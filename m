Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 356234FB37E
	for <lists+stable@lfdr.de>; Mon, 11 Apr 2022 08:13:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239843AbiDKGP3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Apr 2022 02:15:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237415AbiDKGP1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Apr 2022 02:15:27 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA88238DBF;
        Sun, 10 Apr 2022 23:13:14 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 981CF1F38C;
        Mon, 11 Apr 2022 06:13:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1649657593; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yfUZzJxXEU4CNcG2QMgZPPMb7vJB0B02X4kYNQ2tSds=;
        b=CYFR8VI5MElTzammG383x/F4K4XBSJslW9U+hzZc10iBQjejHgINkSwv/HvGWDiKKEVYOs
        /uNSJMQBnIbfq6WunQz7tVALWkLslFenWTCHbeItVG+xLWfl4W63+mhjI7gfGlEJ9CN0dd
        YXKgZq5QlR7zsPlnsrQJ1U1DRbc1eA4=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id BC2A913AB5;
        Mon, 11 Apr 2022 06:13:12 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id sKp0IfjGU2LEfwAAMHmgww
        (envelope-from <wqu@suse.com>); Mon, 11 Apr 2022 06:13:12 +0000
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: [PATCH 2/4] btrfs: fix the error handling for submit_extent_page() for btrfs_do_readpage()
Date:   Mon, 11 Apr 2022 14:12:50 +0800
Message-Id: <2ce5b91dba107bba1ff56c9ebbadcd70e6d333e5.1649657016.git.wqu@suse.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1649657016.git.wqu@suse.com>
References: <cover.1649657016.git.wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[BUG]
Test case generic/475 have a very high chance (almost 100%) to hit a fs
hang, where a data page will never be unlocked and hang all later
operations.

[CAUSE]
In btrfs_do_readpage(), if we hit an error from submit_extent_page() we
will try to do the cleanup for our current io range, and exit.

This works fine for PAGE_SIZE == sectorsize cases, but not for subpage.

For subpage btrfs_do_readpage() will lock the full page first, which can
contain several different sectors and extents:

 btrfs_do_readpage()
 |- begin_page_read()
 |  |- btrfs_subpage_start_reader();
 |     Now the page will hage PAGE_SIZE / sectorsize reader pending,
 |     and the page is locked.
 |
 |- end_page_read() for different branches
 |  This function will reduce subpage readers, and when readers
 |  reach 0, it will unlock the page.

But when submit_extent_page() failed, we only cleanup the current
io range, while the remaining io range will never be cleaned up, and the
page remains locked forever.

[FIX]
Update the error handling of submit_extent_page() to cleanup all the
remaining subpage range before exiting the loop.

CC: stable@vger.kernel.org # 5.15+
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/extent_io.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 34073b0ed6ca..8de25ce05606 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -3735,8 +3735,12 @@ int btrfs_do_readpage(struct page *page, struct extent_map **em_cached,
 					 this_bio_flag,
 					 force_bio_submit);
 		if (ret) {
-			unlock_extent(tree, cur, cur + iosize - 1);
-			end_page_read(page, false, cur, iosize);
+			/*
+			 * We have to unlock the remaining range, or the page
+			 * will never be unlocked.
+			 */
+			unlock_extent(tree, cur, end);
+			end_page_read(page, false, cur, end + 1 - cur);
 			goto out;
 		}
 		cur = cur + iosize;
-- 
2.35.1


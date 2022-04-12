Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5666E4FE16E
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 14:58:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239490AbiDLM7K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 08:59:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243212AbiDLM4x (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 08:56:53 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E2D14C40D;
        Tue, 12 Apr 2022 05:30:41 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 1680D1F38D;
        Tue, 12 Apr 2022 12:30:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1649766640; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=c909N8p9UDZ33r4cAGkIE34NqG09qoEJymolpr9qQDo=;
        b=iCk3BcAXAL5K/Ip/ntu4ly/nDOCyeosj7r+5AzzJ3jFt4PWE4OthLdJ0JI5ZYRJeM71Yev
        x7mtQHxDBVAJ8EocQ5bj0RPDkjrg0bui0OO+d9vkeQIQ4dxbi03GNgSUeXBTLp2vi5UpO6
        32DDHMareTkaP/XfD/B23b8tfXpp5bo=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 0A51513A99;
        Tue, 12 Apr 2022 12:30:38 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id UGiBL+5wVWKBewAAMHmgww
        (envelope-from <wqu@suse.com>); Tue, 12 Apr 2022 12:30:38 +0000
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: [PATCH v2 2/3] btrfs: fix the error handling for submit_extent_page() for btrfs_do_readpage()
Date:   Tue, 12 Apr 2022 20:30:14 +0800
Message-Id: <42552ddb69ec873472fc38bf516bcd10ca2e6869.1649766550.git.wqu@suse.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1649766550.git.wqu@suse.com>
References: <cover.1649766550.git.wqu@suse.com>
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

Please note that, now submit_extent_page() can only fail due to
sanity check in alloc_new_bio().

Thus regular IO errors are impossible to trigger the error path.

CC: stable@vger.kernel.org # 5.15+
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/extent_io.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 163aa6dee987..990d8475ba31 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -3774,8 +3774,12 @@ int btrfs_do_readpage(struct page *page, struct extent_map **em_cached,
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


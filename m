Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52FE75408A0
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:03:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345238AbiFGR7s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 13:59:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349222AbiFGR7F (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 13:59:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C53FC11E1F9;
        Tue,  7 Jun 2022 10:41:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DE8966165B;
        Tue,  7 Jun 2022 17:41:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F22EFC36B00;
        Tue,  7 Jun 2022 17:41:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654623698;
        bh=DgBDuwEJ5QFPHk8gKKEOqH7tp5/B8gGolTG5gLrNhrY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AMOMB8l2At2+x+cicuFzjsPJdjyZ7uUVRtxh35kWKYWTlUBIUROKJoKtkNTsYIL2o
         ppRRjIpXGtWYHVWbouPnNq41/BCP8nI1CipzJxpv0luWiBcMeoEMhyaHK79L+ZAX3w
         JR0tIdnCm5vTGT1AEmsgi480rRcuI7ohMfC00GbQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qu Wenruo <wqu@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.15 042/667] btrfs: fix the error handling for submit_extent_page() for btrfs_do_readpage()
Date:   Tue,  7 Jun 2022 18:55:07 +0200
Message-Id: <20220607164936.064400090@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164934.766888869@linuxfoundation.org>
References: <20220607164934.766888869@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qu Wenruo <wqu@suse.com>

commit 10f7f6f879c28f8368d6516ab1ccf3517a1f5d3d upstream.

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
 |     Now the page will have PAGE_SIZE / sectorsize reader pending,
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
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/extent_io.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -3727,8 +3727,12 @@ int btrfs_do_readpage(struct page *page,
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



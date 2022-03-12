Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 489E94D6F6F
	for <lists+stable@lfdr.de>; Sat, 12 Mar 2022 15:08:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229960AbiCLOJw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 12 Mar 2022 09:09:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbiCLOJw (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 12 Mar 2022 09:09:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 228AC2287CA
        for <stable@vger.kernel.org>; Sat, 12 Mar 2022 06:08:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BC5ED60FA6
        for <stable@vger.kernel.org>; Sat, 12 Mar 2022 14:08:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAE0EC340EB;
        Sat, 12 Mar 2022 14:08:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647094126;
        bh=YP2DvZodv3zQPia+H3fiTNQ9ncUxfsSDU17pREEJ7no=;
        h=Subject:To:Cc:From:Date:From;
        b=izTb006w7pGhPos8b8m5Ajmm3YN9rK8Jkuvc9Rv9WHt/GdEH42BUvWuY3QqC7Gw40
         GJnLbr88Qf/mKgJWbOQF8P7tT16jC0/FnfQDmTHUKUD+VxOl+tc7PFObaxPXjT7tLx
         /YxWY7yvCDLIcE16q89aSD6EKJRq+dkaOrAct19U=
Subject: FAILED: patch "[PATCH] afs: Fix potential thrashing in afs writeback" failed to apply to 5.15-stable tree
To:     dhowells@redhat.com, marc.dionne@auristor.com,
        torvalds@linux-foundation.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 12 Mar 2022 15:08:34 +0100
Message-ID: <1647094114223216@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 173ce1ca47c489135b2799f70f550e1319ba36d8 Mon Sep 17 00:00:00 2001
From: David Howells <dhowells@redhat.com>
Date: Fri, 11 Mar 2022 15:58:21 +0000
Subject: [PATCH] afs: Fix potential thrashing in afs writeback

In afs_writepages_region(), if the dirty page we find is undergoing
writeback or write to cache, but the sync_mode is WB_SYNC_NONE, we go
round the loop trying the same page again and again with no pausing or
waiting unless and until another thread manages to clear the writeback
and fscache flags.

Fix this with three measures:

 (1) Advance start to after the page we found.

 (2) Break out of the loop and return if rescheduling is requested.

 (3) Arbitrarily give up after a maximum of 5 skips.

Fixes: 31143d5d515e ("AFS: implement basic file write support")
Reported-by: Marc Dionne <marc.dionne@auristor.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Tested-by: Marc Dionne <marc.dionne@auristor.com>
Acked-by: Marc Dionne <marc.dionne@auristor.com>
Link: https://lore.kernel.org/r/164692725757.2097000.2060513769492301854.stgit@warthog.procyon.org.uk/ # v1
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

diff --git a/fs/afs/write.c b/fs/afs/write.c
index 5e9157d0da29..f447c902318d 100644
--- a/fs/afs/write.c
+++ b/fs/afs/write.c
@@ -703,7 +703,7 @@ static int afs_writepages_region(struct address_space *mapping,
 	struct folio *folio;
 	struct page *head_page;
 	ssize_t ret;
-	int n;
+	int n, skips = 0;
 
 	_enter("%llx,%llx,", start, end);
 
@@ -754,8 +754,15 @@ static int afs_writepages_region(struct address_space *mapping,
 #ifdef CONFIG_AFS_FSCACHE
 				folio_wait_fscache(folio);
 #endif
+			} else {
+				start += folio_size(folio);
 			}
 			folio_put(folio);
+			if (wbc->sync_mode == WB_SYNC_NONE) {
+				if (skips >= 5 || need_resched())
+					break;
+				skips++;
+			}
 			continue;
 		}
 


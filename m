Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF9A76ADEB6
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 13:30:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229789AbjCGMad (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 07:30:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbjCGMac (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 07:30:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBE61746D3
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 04:30:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8982DB817C2
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 12:30:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7B8EC433D2;
        Tue,  7 Mar 2023 12:30:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678192229;
        bh=UM6o1swyFCjNWYcpQ2W/loLjbi7Nml+lqn8rfVc2Jj4=;
        h=Subject:To:Cc:From:Date:From;
        b=cZhmquc8x8DsayplSPmpYVxb4ilcBJE1mOcupGqe/n4Ik4mlwpuJkwqly1EHBE5tR
         E1WCkQnX+ZWTgNAQecv+m6hKSq3FEr9iBJsjgUtgkyvt+Z0J6UUm26i11Hdn8B7wV4
         WxO/zVvmNmQKxiPgGbD+jvR7DZCv34Zj640MEt6Q=
Subject: FAILED: patch "[PATCH] dm flakey: don't corrupt the zero page" failed to apply to 5.4-stable tree
To:     mpatocka@redhat.com, snitzer@kernel.org, sweettea-kernel@dorminy.me
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 07 Mar 2023 13:30:16 +0100
Message-ID: <167819221615494@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-5.4.y
git checkout FETCH_HEAD
git cherry-pick -x f50714b57aecb6b3dc81d578e295f86d9c73f078
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '167819221615494@kroah.com' --subject-prefix 'PATCH 5.4.y' HEAD^..

Possible dependencies:

f50714b57aec ("dm flakey: don't corrupt the zero page")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From f50714b57aecb6b3dc81d578e295f86d9c73f078 Mon Sep 17 00:00:00 2001
From: Mikulas Patocka <mpatocka@redhat.com>
Date: Sun, 22 Jan 2023 14:02:57 -0500
Subject: [PATCH] dm flakey: don't corrupt the zero page

When we need to zero some range on a block device, the function
__blkdev_issue_zero_pages submits a write bio with the bio vector pointing
to the zero page. If we use dm-flakey with corrupt bio writes option, it
will corrupt the content of the zero page which results in crashes of
various userspace programs. Glibc assumes that memory returned by mmap is
zeroed and it uses it for calloc implementation; if the newly mapped
memory is not zeroed, calloc will return non-zeroed memory.

Fix this bug by testing if the page is equal to ZERO_PAGE(0) and
avoiding the corruption in this case.

Cc: stable@vger.kernel.org
Fixes: a00f5276e266 ("dm flakey: Properly corrupt multi-page bios.")
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Reviewed-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>

diff --git a/drivers/md/dm-flakey.c b/drivers/md/dm-flakey.c
index 89fa7a68c6c4..ff9ca5b2a47e 100644
--- a/drivers/md/dm-flakey.c
+++ b/drivers/md/dm-flakey.c
@@ -303,8 +303,11 @@ static void corrupt_bio_data(struct bio *bio, struct flakey_c *fc)
 	 */
 	bio_for_each_segment(bvec, bio, iter) {
 		if (bio_iter_len(bio, iter) > corrupt_bio_byte) {
-			char *segment = (page_address(bio_iter_page(bio, iter))
-					 + bio_iter_offset(bio, iter));
+			char *segment;
+			struct page *page = bio_iter_page(bio, iter);
+			if (unlikely(page == ZERO_PAGE(0)))
+				break;
+			segment = (page_address(page) + bio_iter_offset(bio, iter));
 			segment[corrupt_bio_byte] = fc->corrupt_bio_value;
 			DMDEBUG("Corrupting data bio=%p by writing %u to byte %u "
 				"(rw=%c bi_opf=%u bi_sector=%llu size=%u)\n",


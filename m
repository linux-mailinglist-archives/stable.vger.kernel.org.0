Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80E906ADEBD
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 13:31:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229477AbjCGMbS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 07:31:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229843AbjCGMbR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 07:31:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF784769CF
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 04:31:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4C5896132E
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 12:31:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42645C433EF;
        Tue,  7 Mar 2023 12:31:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678192275;
        bh=Fwv5sRlpCoxCuRqJ8g8ZhWQr06EDI94HhThJe54UFDA=;
        h=Subject:To:Cc:From:Date:From;
        b=b6hjd/bxtOJedqL9gpzrxMXpThw/Eyq1+vGltBHcGVDhwULjbK3QgHjqxz60EdaGE
         1D7X8GmJpUhrOZANE2fF85zf6dkrPtoHM1zA06r838AG59OulCOoY1/OWGu7tU8k0y
         b+rXa65rmr84wqA3Oq3ifBe/cpUj8P1HAsBjNZQU=
Subject: FAILED: patch "[PATCH] dm flakey: fix a bug with 32-bit highmem systems" failed to apply to 5.10-stable tree
To:     mpatocka@redhat.com, snitzer@kernel.org, sweettea-kernel@dorminy.me
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 07 Mar 2023 13:31:02 +0100
Message-ID: <167819226214734@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-5.10.y
git checkout FETCH_HEAD
git cherry-pick -x 8eb29c4fbf9661e6bd4dd86197a37ffe0ecc9d50
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '167819226214734@kroah.com' --subject-prefix 'PATCH 5.10.y' HEAD^..

Possible dependencies:

8eb29c4fbf96 ("dm flakey: fix a bug with 32-bit highmem systems")
f50714b57aec ("dm flakey: don't corrupt the zero page")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 8eb29c4fbf9661e6bd4dd86197a37ffe0ecc9d50 Mon Sep 17 00:00:00 2001
From: Mikulas Patocka <mpatocka@redhat.com>
Date: Sun, 22 Jan 2023 14:03:31 -0500
Subject: [PATCH] dm flakey: fix a bug with 32-bit highmem systems

The function page_address does not work with 32-bit systems with high
memory. Use bvec_kmap_local/kunmap_local instead.

Cc: stable@vger.kernel.org
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Reviewed-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>

diff --git a/drivers/md/dm-flakey.c b/drivers/md/dm-flakey.c
index ff9ca5b2a47e..33608d436cec 100644
--- a/drivers/md/dm-flakey.c
+++ b/drivers/md/dm-flakey.c
@@ -307,8 +307,9 @@ static void corrupt_bio_data(struct bio *bio, struct flakey_c *fc)
 			struct page *page = bio_iter_page(bio, iter);
 			if (unlikely(page == ZERO_PAGE(0)))
 				break;
-			segment = (page_address(page) + bio_iter_offset(bio, iter));
+			segment = bvec_kmap_local(&bvec);
 			segment[corrupt_bio_byte] = fc->corrupt_bio_value;
+			kunmap_local(segment);
 			DMDEBUG("Corrupting data bio=%p by writing %u to byte %u "
 				"(rw=%c bi_opf=%u bi_sector=%llu size=%u)\n",
 				bio, fc->corrupt_bio_value, fc->corrupt_bio_byte,


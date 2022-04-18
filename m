Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B67CB504E4E
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 11:19:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237442AbiDRJWI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 05:22:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237436AbiDRJWH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 05:22:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 943A0114A
        for <stable@vger.kernel.org>; Mon, 18 Apr 2022 02:19:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2C90A61182
        for <stable@vger.kernel.org>; Mon, 18 Apr 2022 09:19:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 176D3C385A1;
        Mon, 18 Apr 2022 09:19:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650273568;
        bh=hQOvy8gV8staA92ISsQNGywjGqwn2tXMFV48i4rhmZg=;
        h=Subject:To:Cc:From:Date:From;
        b=WhMkeqEi3+kZrPypTmPejBQFPEgLhVvhm8QHbEDVDG8DTWS6cPbkrgH74VkPTh/g2
         6wBNL6bpvT+OeD8rtldSGZDg1qX7yXrSHSDShLXs0Y3SsF7EV2ppDfg/ho4fCbIQ/m
         srU6YqJc7qMwvvgwadCve63M2jLZMKqArlX52ZD4=
Subject: FAILED: patch "[PATCH] dm integrity: fix memory corruption when tag_size is less" failed to apply to 4.19-stable tree
To:     mpatocka@redhat.com, snitzer@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 18 Apr 2022 11:19:25 +0200
Message-ID: <1650273565139113@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 08c1af8f1c13bbf210f1760132f4df24d0ed46d6 Mon Sep 17 00:00:00 2001
From: Mikulas Patocka <mpatocka@redhat.com>
Date: Sun, 3 Apr 2022 14:38:22 -0400
Subject: [PATCH] dm integrity: fix memory corruption when tag_size is less
 than digest size

It is possible to set up dm-integrity in such a way that the
"tag_size" parameter is less than the actual digest size. In this
situation, a part of the digest beyond tag_size is ignored.

In this case, dm-integrity would write beyond the end of the
ic->recalc_tags array and corrupt memory. The corruption happened in
integrity_recalc->integrity_sector_checksum->crypto_shash_final.

Fix this corruption by increasing the tags array so that it has enough
padding at the end to accomodate the loop in integrity_recalc() being
able to write a full digest size for the last member of the tags
array.

Cc: stable@vger.kernel.org # v4.19+
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>

diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
index ad2d5faa2ebb..36ae30b73a6e 100644
--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -4399,6 +4399,7 @@ static int dm_integrity_ctr(struct dm_target *ti, unsigned argc, char **argv)
 	}
 
 	if (ic->internal_hash) {
+		size_t recalc_tags_size;
 		ic->recalc_wq = alloc_workqueue("dm-integrity-recalc", WQ_MEM_RECLAIM, 1);
 		if (!ic->recalc_wq ) {
 			ti->error = "Cannot allocate workqueue";
@@ -4412,8 +4413,10 @@ static int dm_integrity_ctr(struct dm_target *ti, unsigned argc, char **argv)
 			r = -ENOMEM;
 			goto bad;
 		}
-		ic->recalc_tags = kvmalloc_array(RECALC_SECTORS >> ic->sb->log2_sectors_per_block,
-						 ic->tag_size, GFP_KERNEL);
+		recalc_tags_size = (RECALC_SECTORS >> ic->sb->log2_sectors_per_block) * ic->tag_size;
+		if (crypto_shash_digestsize(ic->internal_hash) > ic->tag_size)
+			recalc_tags_size += crypto_shash_digestsize(ic->internal_hash) - ic->tag_size;
+		ic->recalc_tags = kvmalloc(recalc_tags_size, GFP_KERNEL);
 		if (!ic->recalc_tags) {
 			ti->error = "Cannot allocate tags for recalculating";
 			r = -ENOMEM;


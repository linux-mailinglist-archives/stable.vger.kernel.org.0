Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 687D153EA21
	for <lists+stable@lfdr.de>; Mon,  6 Jun 2022 19:09:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237251AbiFFMgo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jun 2022 08:36:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237245AbiFFMgo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Jun 2022 08:36:44 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 097868B0A9
        for <stable@vger.kernel.org>; Mon,  6 Jun 2022 05:36:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 3CE87CE1B11
        for <stable@vger.kernel.org>; Mon,  6 Jun 2022 12:36:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC017C34119;
        Mon,  6 Jun 2022 12:36:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654518999;
        bh=3poakP/rYrMrc5hmeNYml/T2qZIa8HNy8g2EdwyWsaQ=;
        h=Subject:To:Cc:From:Date:From;
        b=wJKoq8SoQDK8pYLP/ddkcjW51PERbC2pkuH+CpaGf0lYH9fjeslQCMTHnDeUDSvCW
         //zlAwpGKVnL85F2SJ8uFXzb/tPGkz1mP1kZh5Rjj5/6BVXLXvs6UOHOCLNx/KXFAY
         iP1bDWdBfetPacaKqVSeYrhM1YQ/nrnjjtZMIOQs=
Subject: FAILED: patch "[PATCH] block: fix bio_clone_blkg_association() to associate with" failed to apply to 5.10-stable tree
To:     jack@suse.cz, axboe@kernel.dk, buczek@molgen.mpg.de, hch@lst.de,
        logang@deltatee.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 06 Jun 2022 14:36:24 +0200
Message-ID: <165451898487172@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 22b106e5355d6e7a9c3b5cb5ed4ef22ae585ea94 Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Thu, 2 Jun 2022 10:12:42 +0200
Subject: [PATCH] block: fix bio_clone_blkg_association() to associate with
 proper blkcg_gq

Commit d92c370a16cb ("block: really clone the block cgroup in
bio_clone_blkg_association") changed bio_clone_blkg_association() to
just clone bio->bi_blkg reference from source to destination bio. This
is however wrong if the source and destination bios are against
different block devices because struct blkcg_gq is different for each
bdev-blkcg pair. This will result in IOs being accounted (and throttled
as a result) multiple times against the same device (src bdev) while
throttling of the other device (dst bdev) is ignored. In case of BFQ the
inconsistency can even result in crashes in bfq_bic_update_cgroup().
Fix the problem by looking up correct blkcg_gq for the cloned bio.

Reported-by: Logan Gunthorpe <logang@deltatee.com>
Reported-and-tested-by: Donald Buczek <buczek@molgen.mpg.de>
Fixes: d92c370a16cb ("block: really clone the block cgroup in bio_clone_blkg_association")
CC: stable@vger.kernel.org
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20220602081242.7731-1-jack@suse.cz
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 40161a3f68d0..764e740b0c0f 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -1974,12 +1974,8 @@ EXPORT_SYMBOL_GPL(bio_associate_blkg);
  */
 void bio_clone_blkg_association(struct bio *dst, struct bio *src)
 {
-	if (src->bi_blkg) {
-		if (dst->bi_blkg)
-			blkg_put(dst->bi_blkg);
-		blkg_get(src->bi_blkg);
-		dst->bi_blkg = src->bi_blkg;
-	}
+	if (src->bi_blkg)
+		bio_associate_blkg_from_css(dst, bio_blkcg_css(src));
 }
 EXPORT_SYMBOL_GPL(bio_clone_blkg_association);
 


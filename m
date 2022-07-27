Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C539A582D74
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 18:58:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240871AbiG0Q6L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 12:58:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240812AbiG0Q5f (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 12:57:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EF1E66AF4;
        Wed, 27 Jul 2022 09:36:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CE038B8200C;
        Wed, 27 Jul 2022 16:36:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 244A9C433D6;
        Wed, 27 Jul 2022 16:36:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658939788;
        bh=8ubWmqh3XHqEGO/Zk88/CHKjpD14FPE7JN30pNzglOg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fFay2UW7HkdVVrD3nJFZtr5ZMKIYZCAkNr6o4no5WtWcnSYz0NJq+w84rU3pZ+8VB
         6KxAhVm7CiOf53F36ahG2VRlDSioSBqzjbta2JNB35MXRliXU+VRd4DjYgRUl/Cf6W
         w3+WbEr7EcG7czNIusdy9jdBwsnU8DQZxzizvcg0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John Stultz <john.stultz@linaro.org>,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.10 105/105] block-crypto-fallback: use a bio_set for splitting bios
Date:   Wed, 27 Jul 2022 18:11:31 +0200
Message-Id: <20220727161016.316853329@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161012.056867467@linuxfoundation.org>
References: <20220727161012.056867467@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

commit 5407334c53e9922c1c3fb28801e489d0b74f2c8d upstream.

bio_split with a NULL bs argumen used to fall back to kmalloc the
bio, which does not guarantee forward progress and could to deadlocks.
Now that the overloading of the NULL bs argument to bio_alloc_bioset
has been removed it crashes instead.  Fix all that by using a special
crafted bioset.

Fixes: 3175199ab0ac ("block: split bio_kmalloc from bio_alloc_bioset")
Reported-by: John Stultz <john.stultz@linaro.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Tested-by: John Stultz <john.stultz@linaro.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/blk-crypto-fallback.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/block/blk-crypto-fallback.c
+++ b/block/blk-crypto-fallback.c
@@ -80,6 +80,7 @@ static struct blk_crypto_keyslot {
 static struct blk_keyslot_manager blk_crypto_ksm;
 static struct workqueue_struct *blk_crypto_wq;
 static mempool_t *blk_crypto_bounce_page_pool;
+static struct bio_set crypto_bio_split;
 
 /*
  * This is the key we set when evicting a keyslot. This *should* be the all 0's
@@ -222,7 +223,8 @@ static bool blk_crypto_split_bio_if_need
 	if (num_sectors < bio_sectors(bio)) {
 		struct bio *split_bio;
 
-		split_bio = bio_split(bio, num_sectors, GFP_NOIO, NULL);
+		split_bio = bio_split(bio, num_sectors, GFP_NOIO,
+				      &crypto_bio_split);
 		if (!split_bio) {
 			bio->bi_status = BLK_STS_RESOURCE;
 			return false;
@@ -536,9 +538,13 @@ static int blk_crypto_fallback_init(void
 
 	prandom_bytes(blank_key, BLK_CRYPTO_MAX_KEY_SIZE);
 
-	err = blk_ksm_init(&blk_crypto_ksm, blk_crypto_num_keyslots);
+	err = bioset_init(&crypto_bio_split, 64, 0, 0);
 	if (err)
 		goto out;
+
+	err = blk_ksm_init(&blk_crypto_ksm, blk_crypto_num_keyslots);
+	if (err)
+		goto fail_free_bioset;
 	err = -ENOMEM;
 
 	blk_crypto_ksm.ksm_ll_ops = blk_crypto_ksm_ll_ops;
@@ -589,6 +595,8 @@ fail_free_wq:
 	destroy_workqueue(blk_crypto_wq);
 fail_free_ksm:
 	blk_ksm_destroy(&blk_crypto_ksm);
+fail_free_bioset:
+	bioset_exit(&crypto_bio_split);
 out:
 	return err;
 }



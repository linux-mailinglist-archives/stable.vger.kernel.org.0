Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C36CB53E771
	for <lists+stable@lfdr.de>; Mon,  6 Jun 2022 19:07:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235538AbiFFLlz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jun 2022 07:41:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235523AbiFFLly (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Jun 2022 07:41:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCD512D1F0
        for <stable@vger.kernel.org>; Mon,  6 Jun 2022 04:41:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8128BB8175D
        for <stable@vger.kernel.org>; Mon,  6 Jun 2022 11:41:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B0F3C385A9;
        Mon,  6 Jun 2022 11:41:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654515711;
        bh=KoBdoj5JE1AW1/mklk+MEbUtOjX5YkLq16JnIp7arcQ=;
        h=Subject:To:Cc:From:Date:From;
        b=ouf+MC2CW6J8hlVXM4rEvNpwNiaPILo5cZPtROuzj0SF1O/k69EyDMt+ASqfwsrn1
         J3U6FvfoVukcI0CqDbtd5kDs2ZNclHF11iMvWQ4xmFqxrcFjqIo4gfonsEpu4wzJ7P
         Y5wsiJ4U7QAs0KtFbOBwHvWArPt07iwTE3Bk0+/E=
Subject: WTF: patch "[PATCH] crypto: qat - set to zero DH parameters before free" was seriously submitted to be applied to the 5.18-stable tree?
To:     giovanni.cabiddu@intel.com, adam.guerin@intel.com,
        herbert@gondor.apana.org.au, wojciech.ziemba@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 06 Jun 2022 13:41:48 +0200
Message-ID: <165451570812441@kroah.com>
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

The patch below was submitted to be applied to the 5.18-stable tree.

I fail to see how this patch meets the stable kernel rules as found at
Documentation/process/stable-kernel-rules.rst.

I could be totally wrong, and if so, please respond to 
<stable@vger.kernel.org> and let me know why this patch should be
applied.  Otherwise, it is now dropped from my patch queues, never to be
seen again.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 1731160ff7c7bbb11bb1aacb14dd25e18d522779 Mon Sep 17 00:00:00 2001
From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Date: Mon, 9 May 2022 14:19:27 +0100
Subject: [PATCH] crypto: qat - set to zero DH parameters before free

Set to zero the context buffers containing the DH key before they are
freed.
This is a defense in depth measure that avoids keys to be recovered from
memory in case the system is compromised between the free of the buffer
and when that area of memory (containing keys) gets overwritten.

Cc: stable@vger.kernel.org
Fixes: c9839143ebbf ("crypto: qat - Add DH support")
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Adam Guerin <adam.guerin@intel.com>
Reviewed-by: Wojciech Ziemba <wojciech.ziemba@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/drivers/crypto/qat/qat_common/qat_asym_algs.c b/drivers/crypto/qat/qat_common/qat_asym_algs.c
index b0b78445418b..5633f9df3b6f 100644
--- a/drivers/crypto/qat/qat_common/qat_asym_algs.c
+++ b/drivers/crypto/qat/qat_common/qat_asym_algs.c
@@ -420,14 +420,17 @@ static int qat_dh_set_params(struct qat_dh_ctx *ctx, struct dh *params)
 static void qat_dh_clear_ctx(struct device *dev, struct qat_dh_ctx *ctx)
 {
 	if (ctx->g) {
+		memset(ctx->g, 0, ctx->p_size);
 		dma_free_coherent(dev, ctx->p_size, ctx->g, ctx->dma_g);
 		ctx->g = NULL;
 	}
 	if (ctx->xa) {
+		memset(ctx->xa, 0, ctx->p_size);
 		dma_free_coherent(dev, ctx->p_size, ctx->xa, ctx->dma_xa);
 		ctx->xa = NULL;
 	}
 	if (ctx->p) {
+		memset(ctx->p, 0, ctx->p_size);
 		dma_free_coherent(dev, ctx->p_size, ctx->p, ctx->dma_p);
 		ctx->p = NULL;
 	}


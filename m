Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7EF958312B
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:47:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243060AbiG0Rrd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:47:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243067AbiG0RrE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 13:47:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 718268C8F8;
        Wed, 27 Jul 2022 09:53:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 13CEEB821D7;
        Wed, 27 Jul 2022 16:53:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6631DC433C1;
        Wed, 27 Jul 2022 16:53:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658940834;
        bh=8TAjTG3BVgjt6+mej6insq8utXxrMq0kT2BsFUAqqQA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VIAhOq9vzkWI7u/e4YyxkGNSRZrHtobCvUUwU95DWi2JQLiyP5TXANhwI44J/qyNt
         BHyHm1StdLj+11g6Mii0BWrLeip2+NBYlKVIkMtR56XkvYhvkCGH6kBU7yaD4jc0K9
         c/SG5EGJrg6GD9NdYs3eZYkqQRPTMHMN+xSrFkEk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Adam Guerin <adam.guerin@intel.com>,
        Wojciech Ziemba <wojciech.ziemba@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 140/158] crypto: qat - set to zero DH parameters before free
Date:   Wed, 27 Jul 2022 18:13:24 +0200
Message-Id: <20220727161026.976342511@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161021.428340041@linuxfoundation.org>
References: <20220727161021.428340041@linuxfoundation.org>
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

From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>

[ Upstream commit 1731160ff7c7bbb11bb1aacb14dd25e18d522779 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/qat/qat_common/qat_asym_algs.c | 3 +++
 1 file changed, 3 insertions(+)

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
-- 
2.35.1




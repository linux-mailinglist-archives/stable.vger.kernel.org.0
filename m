Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2AAD51DAC0
	for <lists+stable@lfdr.de>; Fri,  6 May 2022 16:40:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442302AbiEFOnf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 May 2022 10:43:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442324AbiEFOnY (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 May 2022 10:43:24 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 030236AA61;
        Fri,  6 May 2022 07:39:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651847978; x=1683383978;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=QsLQfLxR5EUPwOSoTRZKB6lv00b/kqBdk2OSm6FD6GI=;
  b=bPtrRJW5TZIemQ+GwRSSNw6aSmfhmuyK+HAjFiVPNH40KACklkNA7loD
   lnYvu9sNEPapiwn+i9NcKk/R8+O/hdWMLvnqa1TKJidX/cfl1+iN0rYTW
   nlr+QkK5Cy/j0IIVWK7VBS37wVsKIa7QijypcbUfPTLEaG+o+n9lVN1rY
   /umiVNoacbjLKtxTOq02JtxIA6txbR2ntk7Bqhmeexmaus2AyNK5BnGLu
   x/2EGZ4Z1TO8dDBYusWGU8ZQ/RQ0K1OJ8LUakDvNulpTL1nVXclXH2uQb
   iafp92d+6Q7LOTXjwN4SyNCm0WdCtbITivRZsiRVOOYs78dLd8PfL20lY
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10339"; a="248387489"
X-IronPort-AV: E=Sophos;i="5.91,203,1647327600"; 
   d="scan'208";a="248387489"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2022 07:39:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,203,1647327600"; 
   d="scan'208";a="537914859"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.76])
  by orsmga006.jf.intel.com with ESMTP; 06 May 2022 07:39:20 -0700
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        vdronov@redhat.com, Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        stable@vger.kernel.org, Adam Guerin <adam.guerin@intel.com>,
        Wojciech Ziemba <wojciech.ziemba@intel.com>
Subject: [PATCH v2 07/11] crypto: qat - set to zero DH parameters before free
Date:   Fri,  6 May 2022 15:38:59 +0100
Message-Id: <20220506143903.31776-8-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220506143903.31776-1-giovanni.cabiddu@intel.com>
References: <20220506143903.31776-1-giovanni.cabiddu@intel.com>
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Set to zero the DH context buffers containing the DH key before they are
freed.
This is to make sure keys are not leaked out by a subsequent memory
allocation.

Cc: stable@vger.kernel.org
Fixes: c9839143ebbf ("crypto: qat - Add DH support")
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Adam Guerin <adam.guerin@intel.com>
Reviewed-by: Wojciech Ziemba <wojciech.ziemba@intel.com>
---
 drivers/crypto/qat/qat_common/qat_asym_algs.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/crypto/qat/qat_common/qat_asym_algs.c b/drivers/crypto/qat/qat_common/qat_asym_algs.c
index d75eb77c9fb9..25bbd22085c3 100644
--- a/drivers/crypto/qat/qat_common/qat_asym_algs.c
+++ b/drivers/crypto/qat/qat_common/qat_asym_algs.c
@@ -421,14 +421,17 @@ static int qat_dh_set_params(struct qat_dh_ctx *ctx, struct dh *params)
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


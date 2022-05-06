Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 221F051D363
	for <lists+stable@lfdr.de>; Fri,  6 May 2022 10:24:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1390092AbiEFI1m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 May 2022 04:27:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1389886AbiEFI1b (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 May 2022 04:27:31 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2F9068F8A;
        Fri,  6 May 2022 01:23:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651825429; x=1683361429;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=WsK1MSiWa9RoyrvkdT2qrhlxrJiB7JKhDRRCgnW53uc=;
  b=Y0iYEUmfACtqkD27DejjrYtxu9/vtBI6QhOAbHhCBQ+Nh85NyEH8Egye
   OQUZDt1Q6SkSlvhOj/++Lo22rkeV20tYUz00jNrwVpRYFf6wtHHCLeMgU
   hm1uZUe1U7vay0KXogKnYJbu4oiLHlSjs9NLRDLfqSei4XSYkF2CsgGKE
   IsAwGxbDO1NgBTHBnQLHTuwTEPf3uo9ngSDX44KbWKjW1OhuylJzYFQ+k
   vMQS75SU1tIDLciO3KTk/uuKgPqLN2St1ckHNn2V9yLukHhy2QqqtQ/kP
   4nQjGXpQ1RcTlvfUyoNrAPA46+PV9bUYXLhHecWoyDNGZoPruZcSJFVzI
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10338"; a="328938493"
X-IronPort-AV: E=Sophos;i="5.91,203,1647327600"; 
   d="scan'208";a="328938493"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2022 01:23:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,203,1647327600"; 
   d="scan'208";a="563709002"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.76])
  by orsmga007.jf.intel.com with ESMTP; 06 May 2022 01:23:47 -0700
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        vdronov@redhat.com, Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        stable@vger.kernel.org, Adam Guerin <adam.guerin@intel.com>,
        Wojciech Ziemba <wojciech.ziemba@intel.com>
Subject: [PATCH 07/12] crypto: qat - set to zero DH parameters before free
Date:   Fri,  6 May 2022 09:23:22 +0100
Message-Id: <20220506082327.21605-8-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220506082327.21605-1-giovanni.cabiddu@intel.com>
References: <20220506082327.21605-1-giovanni.cabiddu@intel.com>
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Set to zero the DH context buffers containing the DH key before they are
freed.

Cc: stable@vger.kernel.org
Fixes: c9839143ebbf ("crypto: qat - Add DH support")
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Adam Guerin <adam.guerin@intel.com>
Reviewed-by: Wojciech Ziemba <wojciech.ziemba@intel.com>
---
 drivers/crypto/qat/qat_common/qat_asym_algs.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/crypto/qat/qat_common/qat_asym_algs.c b/drivers/crypto/qat/qat_common/qat_asym_algs.c
index d75eb77c9fb9..2fec89b8a188 100644
--- a/drivers/crypto/qat/qat_common/qat_asym_algs.c
+++ b/drivers/crypto/qat/qat_common/qat_asym_algs.c
@@ -421,14 +421,17 @@ static int qat_dh_set_params(struct qat_dh_ctx *ctx, struct dh *params)
 static void qat_dh_clear_ctx(struct device *dev, struct qat_dh_ctx *ctx)
 {
 	if (ctx->g) {
+		memzero_explicit(ctx->g, ctx->p_size);
 		dma_free_coherent(dev, ctx->p_size, ctx->g, ctx->dma_g);
 		ctx->g = NULL;
 	}
 	if (ctx->xa) {
+		memzero_explicit(ctx->xa, ctx->p_size);
 		dma_free_coherent(dev, ctx->p_size, ctx->xa, ctx->dma_xa);
 		ctx->xa = NULL;
 	}
 	if (ctx->p) {
+		memzero_explicit(ctx->p, ctx->p_size);
 		dma_free_coherent(dev, ctx->p_size, ctx->p, ctx->dma_p);
 		ctx->p = NULL;
 	}
-- 
2.35.1


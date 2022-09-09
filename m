Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F050E5B3584
	for <lists+stable@lfdr.de>; Fri,  9 Sep 2022 12:50:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229623AbiIIKt5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Sep 2022 06:49:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229854AbiIIKtd (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 9 Sep 2022 06:49:33 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62CA79FD6;
        Fri,  9 Sep 2022 03:49:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662720571; x=1694256571;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=A36fWp6cCwtjgR1aJ5V2wRfpxliwx01PsvlRHM9w4nw=;
  b=dTMGEBNDLxBmCY/rEVHsOy7mFDopPGbd5KEMLkE+sbXVz62iYYnIgsob
   H+SkgNcoNpIGlUaeqmKjhn4PJgTVhcN0Fb3IVXNm0UIA5BWXUJkDVYdQ0
   3qCOHQUDNwB0lhGs1vxv0tF5qxh8yrgnqVQ03CUdy+Ev5Faz+tZsrsaJE
   LK5QqmLuCN+xO4X0HThaVJhq5LU5YbU5ve7mCkXLsAnr/Rc7IgmScuzqn
   ZhDNi566cZXhMsDQs2nLoj4BT/ypBsyOJSq3cVz6iOAEQqW2d+q/XYClu
   lnvXjVEFOQlfk6wH3QHxhX3wZYjKdierfo96TjHtNz2xXLPJoRjFVYp4n
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10464"; a="295031007"
X-IronPort-AV: E=Sophos;i="5.93,303,1654585200"; 
   d="scan'208";a="295031007"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2022 03:49:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,303,1654585200"; 
   d="scan'208";a="677115250"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.76])
  by fmsmga008.fm.intel.com with ESMTP; 09 Sep 2022 03:49:28 -0700
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Vlad Dronov <vdronov@redhat.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        stable@vger.kernel.org
Subject: [PATCH 2/3] Revert "crypto: qat - reduce size of mapped region"
Date:   Fri,  9 Sep 2022 11:49:13 +0100
Message-Id: <20220909104914.3351-3-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220909104914.3351-1-giovanni.cabiddu@intel.com>
References: <20220909104914.3351-1-giovanni.cabiddu@intel.com>
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This reverts commit e48767c17718067ba21fb2ef461779ec2506f845.

In an attempt to resolve a set of warnings reported by the static
analyzer Smatch, the reverted commit improperly reduced the sizes of the
DMA mappings used for the input and output parameters for both RSA and
DH creating a mismatch (map size=8 bytes, unmap size=64 bytes).

This issue is reported when CONFIG_DMA_API_DEBUG is selected, when the
crypto self test is run. The function dma_unmap_single() reports a
warning similar to the one below, saying that the `device driver frees
DMA memory with different size`.

    DMA-API: 4xxx 0000:06:00.0: device driver frees DMA memory with different size [device address=0x0000000123206c80] [map size=8 bytes] [unmap size=64 bytes]
    WARNING: CPU: 0 PID: 0 at kernel/dma/debug.c:973 check_unmap+0x3d0/0x8c0\
    ...
    Call Trace:
    <IRQ>
    debug_dma_unmap_page+0x5c/0x60
    qat_dh_cb+0xd7/0x110 [intel_qat]
    qat_alg_asym_callback+0x1a/0x30 [intel_qat]
    adf_response_handler+0xbd/0x1a0 [intel_qat]
    tasklet_action_common.constprop.0+0xcd/0xe0
    __do_softirq+0xf8/0x30c
    __irq_exit_rcu+0xbf/0x140
    common_interrupt+0xb9/0xd0
    </IRQ>
    <TASK>

The original commit was correct.

Cc: <stable@vger.kernel.org>
Reported-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/crypto/qat/qat_common/qat_asym_algs.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/qat_asym_algs.c b/drivers/crypto/qat/qat_common/qat_asym_algs.c
index 095ed2a404d2..85b0f30712e1 100644
--- a/drivers/crypto/qat/qat_common/qat_asym_algs.c
+++ b/drivers/crypto/qat/qat_common/qat_asym_algs.c
@@ -333,13 +333,13 @@ static int qat_dh_compute_value(struct kpp_request *req)
 	qat_req->out.dh.out_tab[1] = 0;
 	/* Mapping in.in.b or in.in_g2.xa is the same */
 	qat_req->phy_in = dma_map_single(dev, &qat_req->in.dh.in.b,
-					 sizeof(qat_req->in.dh.in.b),
+					 sizeof(struct qat_dh_input_params),
 					 DMA_TO_DEVICE);
 	if (unlikely(dma_mapping_error(dev, qat_req->phy_in)))
 		goto unmap_dst;
 
 	qat_req->phy_out = dma_map_single(dev, &qat_req->out.dh.r,
-					  sizeof(qat_req->out.dh.r),
+					  sizeof(struct qat_dh_output_params),
 					  DMA_TO_DEVICE);
 	if (unlikely(dma_mapping_error(dev, qat_req->phy_out)))
 		goto unmap_in_params;
@@ -730,13 +730,13 @@ static int qat_rsa_enc(struct akcipher_request *req)
 	qat_req->in.rsa.in_tab[3] = 0;
 	qat_req->out.rsa.out_tab[1] = 0;
 	qat_req->phy_in = dma_map_single(dev, &qat_req->in.rsa.enc.m,
-					 sizeof(qat_req->in.rsa.enc.m),
+					 sizeof(struct qat_rsa_input_params),
 					 DMA_TO_DEVICE);
 	if (unlikely(dma_mapping_error(dev, qat_req->phy_in)))
 		goto unmap_dst;
 
 	qat_req->phy_out = dma_map_single(dev, &qat_req->out.rsa.enc.c,
-					  sizeof(qat_req->out.rsa.enc.c),
+					  sizeof(struct qat_rsa_output_params),
 					  DMA_TO_DEVICE);
 	if (unlikely(dma_mapping_error(dev, qat_req->phy_out)))
 		goto unmap_in_params;
@@ -876,13 +876,13 @@ static int qat_rsa_dec(struct akcipher_request *req)
 		qat_req->in.rsa.in_tab[3] = 0;
 	qat_req->out.rsa.out_tab[1] = 0;
 	qat_req->phy_in = dma_map_single(dev, &qat_req->in.rsa.dec.c,
-					 sizeof(qat_req->in.rsa.dec.c),
+					 sizeof(struct qat_rsa_input_params),
 					 DMA_TO_DEVICE);
 	if (unlikely(dma_mapping_error(dev, qat_req->phy_in)))
 		goto unmap_dst;
 
 	qat_req->phy_out = dma_map_single(dev, &qat_req->out.rsa.dec.m,
-					  sizeof(qat_req->out.rsa.dec.m),
+					  sizeof(struct qat_rsa_output_params),
 					  DMA_TO_DEVICE);
 	if (unlikely(dma_mapping_error(dev, qat_req->phy_out)))
 		goto unmap_in_params;
-- 
2.37.1


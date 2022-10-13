Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4A1A5FE0C7
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 20:15:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230143AbiJMSPO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Oct 2022 14:15:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232009AbiJMSN5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Oct 2022 14:13:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C0E9814C1;
        Thu, 13 Oct 2022 11:10:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7658361949;
        Thu, 13 Oct 2022 18:00:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E0BFC433D7;
        Thu, 13 Oct 2022 18:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665684020;
        bh=4rWjydFXyLLDqW4rzOLOSOJ8MSOKHrz5swor8EvZv0k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pouIC8brJOISXS9+BiKw5sY0N7rL7qR0n14OlfxUAPYees0LHi2hmtYGWhKCiYToW
         igmXLNECvLboxFwpgZA24DlAy8KYPoijlolP5TGD/Rp6CPc2NhL4Pf94umIXKrewO+
         uX+hZGaEZ129kAfSwfKDTPgM6o/4L5t0k8EgjGrY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH 5.19 17/33] Revert "crypto: qat - reduce size of mapped region"
Date:   Thu, 13 Oct 2022 19:52:49 +0200
Message-Id: <20221013175145.852098967@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221013175145.236739253@linuxfoundation.org>
References: <20221013175145.236739253@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>

commit 9c5f21b198d259bfe1191b1fedf08e2eab15b33b upstream.

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
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/qat/qat_common/qat_asym_algs.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/crypto/qat/qat_common/qat_asym_algs.c
+++ b/drivers/crypto/qat/qat_common/qat_asym_algs.c
@@ -333,13 +333,13 @@ static int qat_dh_compute_value(struct k
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
@@ -730,13 +730,13 @@ static int qat_rsa_enc(struct akcipher_r
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
@@ -876,13 +876,13 @@ static int qat_rsa_dec(struct akcipher_r
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



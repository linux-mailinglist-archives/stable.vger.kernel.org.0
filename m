Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C29F14F37BE
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 16:24:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359493AbiDELTd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:19:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349197AbiDEJt0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:49:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 948A5222B4;
        Tue,  5 Apr 2022 02:42:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 39F32B818F3;
        Tue,  5 Apr 2022 09:42:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CD48C385A1;
        Tue,  5 Apr 2022 09:42:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649151752;
        bh=fcPtDvDT8Ft1Afq4K2jhGPG0nrBzmkGQ6/6ppmfMs/4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2VF7JqAVOcF2OHxDTEg1pyYBTSBg/BGwnOV25NalmZCm9Mcp7+K6bYGQYyabBOqOi
         QGB28JyzDEWXBYZCQKA0wdu1DElOhGL1wW5GEYSweVdna6XXmQokUFYogFDBNblkYv
         5p/1OFS3lAOtmRNchp6fHzdT4nKscmtpw0O5idog=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 528/913] scsi: mpt3sas: Fix incorrect 4GB boundary check
Date:   Tue,  5 Apr 2022 09:26:30 +0200
Message-Id: <20220405070355.678353611@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sreekanth Reddy <sreekanth.reddy@broadcom.com>

[ Upstream commit 208cc9fe6f21112b5cc6cb87065fb8ab66e79316 ]

The driver must perform its 4GB boundary check using the pool's DMA address
instead of using the virtual address.

Link: https://lore.kernel.org/r/20220303140230.13098-1-sreekanth.reddy@broadcom.com
Fixes: d6adc251dd2f ("scsi: mpt3sas: Force PCIe scatterlist allocations to be within same 4 GB region")
Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 25 ++++++++++++-------------
 1 file changed, 12 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 0d37c4aca175..c38e68943205 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -5737,14 +5737,13 @@ _base_release_memory_pools(struct MPT3SAS_ADAPTER *ioc)
  */
 
 static int
-mpt3sas_check_same_4gb_region(long reply_pool_start_address, u32 pool_sz)
+mpt3sas_check_same_4gb_region(dma_addr_t start_address, u32 pool_sz)
 {
-	long reply_pool_end_address;
+	dma_addr_t end_address;
 
-	reply_pool_end_address = reply_pool_start_address + pool_sz;
+	end_address = start_address + pool_sz - 1;
 
-	if (upper_32_bits(reply_pool_start_address) ==
-		upper_32_bits(reply_pool_end_address))
+	if (upper_32_bits(start_address) == upper_32_bits(end_address))
 		return 1;
 	else
 		return 0;
@@ -5805,7 +5804,7 @@ _base_allocate_pcie_sgl_pool(struct MPT3SAS_ADAPTER *ioc, u32 sz)
 		}
 
 		if (!mpt3sas_check_same_4gb_region(
-		    (long)ioc->pcie_sg_lookup[i].pcie_sgl, sz)) {
+		    ioc->pcie_sg_lookup[i].pcie_sgl_dma, sz)) {
 			ioc_err(ioc, "PCIE SGLs are not in same 4G !! pcie sgl (0x%p) dma = (0x%llx)\n",
 			    ioc->pcie_sg_lookup[i].pcie_sgl,
 			    (unsigned long long)
@@ -5860,8 +5859,8 @@ _base_allocate_chain_dma_pool(struct MPT3SAS_ADAPTER *ioc, u32 sz)
 			    GFP_KERNEL, &ctr->chain_buffer_dma);
 			if (!ctr->chain_buffer)
 				return -EAGAIN;
-			if (!mpt3sas_check_same_4gb_region((long)
-			    ctr->chain_buffer, ioc->chain_segment_sz)) {
+			if (!mpt3sas_check_same_4gb_region(
+			    ctr->chain_buffer_dma, ioc->chain_segment_sz)) {
 				ioc_err(ioc,
 				    "Chain buffers are not in same 4G !!! Chain buff (0x%p) dma = (0x%llx)\n",
 				    ctr->chain_buffer,
@@ -5897,7 +5896,7 @@ _base_allocate_sense_dma_pool(struct MPT3SAS_ADAPTER *ioc, u32 sz)
 	    GFP_KERNEL, &ioc->sense_dma);
 	if (!ioc->sense)
 		return -EAGAIN;
-	if (!mpt3sas_check_same_4gb_region((long)ioc->sense, sz)) {
+	if (!mpt3sas_check_same_4gb_region(ioc->sense_dma, sz)) {
 		dinitprintk(ioc, pr_err(
 		    "Bad Sense Pool! sense (0x%p) sense_dma = (0x%llx)\n",
 		    ioc->sense, (unsigned long long) ioc->sense_dma));
@@ -5930,7 +5929,7 @@ _base_allocate_reply_pool(struct MPT3SAS_ADAPTER *ioc, u32 sz)
 	    &ioc->reply_dma);
 	if (!ioc->reply)
 		return -EAGAIN;
-	if (!mpt3sas_check_same_4gb_region((long)ioc->reply_free, sz)) {
+	if (!mpt3sas_check_same_4gb_region(ioc->reply_dma, sz)) {
 		dinitprintk(ioc, pr_err(
 		    "Bad Reply Pool! Reply (0x%p) Reply dma = (0x%llx)\n",
 		    ioc->reply, (unsigned long long) ioc->reply_dma));
@@ -5965,7 +5964,7 @@ _base_allocate_reply_free_dma_pool(struct MPT3SAS_ADAPTER *ioc, u32 sz)
 	    GFP_KERNEL, &ioc->reply_free_dma);
 	if (!ioc->reply_free)
 		return -EAGAIN;
-	if (!mpt3sas_check_same_4gb_region((long)ioc->reply_free, sz)) {
+	if (!mpt3sas_check_same_4gb_region(ioc->reply_free_dma, sz)) {
 		dinitprintk(ioc,
 		    pr_err("Bad Reply Free Pool! Reply Free (0x%p) Reply Free dma = (0x%llx)\n",
 		    ioc->reply_free, (unsigned long long) ioc->reply_free_dma));
@@ -6004,7 +6003,7 @@ _base_allocate_reply_post_free_array(struct MPT3SAS_ADAPTER *ioc,
 	    GFP_KERNEL, &ioc->reply_post_free_array_dma);
 	if (!ioc->reply_post_free_array)
 		return -EAGAIN;
-	if (!mpt3sas_check_same_4gb_region((long)ioc->reply_post_free_array,
+	if (!mpt3sas_check_same_4gb_region(ioc->reply_post_free_array_dma,
 	    reply_post_free_array_sz)) {
 		dinitprintk(ioc, pr_err(
 		    "Bad Reply Free Pool! Reply Free (0x%p) Reply Free dma = (0x%llx)\n",
@@ -6069,7 +6068,7 @@ base_alloc_rdpq_dma_pool(struct MPT3SAS_ADAPTER *ioc, int sz)
 			 * resources and set DMA mask to 32 and allocate.
 			 */
 			if (!mpt3sas_check_same_4gb_region(
-				(long)ioc->reply_post[i].reply_post_free, sz)) {
+				ioc->reply_post[i].reply_post_free_dma, sz)) {
 				dinitprintk(ioc,
 				    ioc_err(ioc, "bad Replypost free pool(0x%p)"
 				    "reply_post_free_dma = (0x%llx)\n",
-- 
2.34.1




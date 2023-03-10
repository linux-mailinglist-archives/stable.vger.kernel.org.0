Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C2696B4A48
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 16:21:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234181AbjCJPVI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 10:21:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234184AbjCJPUt (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 10:20:49 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3702CB465
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 07:11:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 5CAB8CE2947
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 15:10:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35A61C4339B;
        Fri, 10 Mar 2023 15:10:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678461003;
        bh=aSrD5PMG+xQxw2Q4Z880oSwFYj2tx1Chbxn7tDgq8AU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PAA42uoYWFys6PKAUPYON2JTENWd8GltNFKerKC43D6RWlnbe0U5v2tCCo8yL7kAq
         3XqvZh/IVk5f10ljvJ/vFuYV/yAYRgnAWnQcTq0bLodJl+pnb0y1dYQndqSHcvBbp3
         gChSl5JfHU9ZbIT2xBNWUZPNbAQ3kcawsCcbwZ6g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Salvatore Bonaccorso <carnil@debian.org>
Subject: [PATCH 5.10 524/529] scsi: mpt3sas: Dont change DMA mask while reallocating pools
Date:   Fri, 10 Mar 2023 14:41:07 +0100
Message-Id: <20230310133829.097423405@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sreekanth Reddy <sreekanth.reddy@broadcom.com>

commit 9df650963bf6d6c2c3fcd325d8c44ca2b99554fe upstream.

When a pool crosses the 4GB boundary region then before reallocating pools
change the coherent DMA mask to 32 bits and keep the normal DMA mask set to
63/64 bits.

Link: https://lore.kernel.org/r/20220825075457.16422-2-sreekanth.reddy@broadcom.com
Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Salvatore Bonaccorso <carnil@debian.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c |   21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -2822,19 +2822,26 @@ static int
 _base_config_dma_addressing(struct MPT3SAS_ADAPTER *ioc, struct pci_dev *pdev)
 {
 	struct sysinfo s;
+	u64 coherent_dma_mask, dma_mask;
 
-	if (ioc->is_mcpu_endpoint ||
-	    sizeof(dma_addr_t) == 4 || ioc->use_32bit_dma ||
-	    dma_get_required_mask(&pdev->dev) <= 32)
+	if (ioc->is_mcpu_endpoint || sizeof(dma_addr_t) == 4 ||
+	    dma_get_required_mask(&pdev->dev) <= 32) {
 		ioc->dma_mask = 32;
+		coherent_dma_mask = dma_mask = DMA_BIT_MASK(32);
 	/* Set 63 bit DMA mask for all SAS3 and SAS35 controllers */
-	else if (ioc->hba_mpi_version_belonged > MPI2_VERSION)
+	} else if (ioc->hba_mpi_version_belonged > MPI2_VERSION) {
 		ioc->dma_mask = 63;
-	else
+		coherent_dma_mask = dma_mask = DMA_BIT_MASK(63);
+	} else {
 		ioc->dma_mask = 64;
+		coherent_dma_mask = dma_mask = DMA_BIT_MASK(64);
+	}
 
-	if (dma_set_mask(&pdev->dev, DMA_BIT_MASK(ioc->dma_mask)) ||
-	    dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(ioc->dma_mask)))
+	if (ioc->use_32bit_dma)
+		coherent_dma_mask = DMA_BIT_MASK(32);
+
+	if (dma_set_mask(&pdev->dev, dma_mask) ||
+	    dma_set_coherent_mask(&pdev->dev, coherent_dma_mask))
 		return -ENODEV;
 
 	if (ioc->dma_mask > 32) {



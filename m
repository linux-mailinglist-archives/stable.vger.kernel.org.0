Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA2FE6B4B15
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 16:30:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234379AbjCJPa0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 10:30:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233082AbjCJPaG (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 10:30:06 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 317451184C2
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 07:18:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 82ED8B822F2
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 15:17:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8DB2C4339C;
        Fri, 10 Mar 2023 15:17:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678461451;
        bh=Mc3pjDmNp2g+BPcYk2DbXqbglROYEEIhDgSOsJn+dQk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GaaCxL9L4kFTNYY6GM7Z2w/Sm5RsBmrU9SSWK3hDCiCrabLLGdCreD2jt3kqEhwnJ
         YUU5wm58tmvhxz+tyALJl1bn9ypetdojFzUrrh8R8DCgAPtqUxADi3GkIN/kQSJKih
         VTSHCxImDiE+IN30lPIZZXpRGcLQdw1lLmd9Amzc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Salvatore Bonaccorso <carnil@debian.org>
Subject: [PATCH 5.15 132/136] scsi: mpt3sas: Dont change DMA mask while reallocating pools
Date:   Fri, 10 Mar 2023 14:44:14 +0100
Message-Id: <20230310133711.220674508@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133706.811226272@linuxfoundation.org>
References: <20230310133706.811226272@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
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
@@ -2990,19 +2990,26 @@ static int
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



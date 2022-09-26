Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D33C5EA585
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 14:06:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239051AbiIZMGb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 08:06:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239528AbiIZMEZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 08:04:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EE2DBB5;
        Mon, 26 Sep 2022 03:54:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AA77C60B6A;
        Mon, 26 Sep 2022 10:48:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7291C433D6;
        Mon, 26 Sep 2022 10:48:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664189286;
        bh=4c+/ITZT6UkmkH+5mODA/xzxisTVTWlBXItVtDn7Gtw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JXfFfcasicZocpN1inUDMoZyV9xr0tzQ4gXCQneHsSHIBbOMjJIsf1LDrjNxNa5ja
         CwEh4E4auP07YaoxPU41WJGe3UcYUeCooT8XNVO7NAvgL4wtmnEmwBDPr81LPTf3Q5
         GK19ygbtyB6u6UPvQ8JpcamlW7TwMnbOTpgMGkec=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 104/207] scsi: mpt3sas: Fix return value check of dma_get_required_mask()
Date:   Mon, 26 Sep 2022 12:11:33 +0200
Message-Id: <20220926100811.254873896@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100806.522017616@linuxfoundation.org>
References: <20220926100806.522017616@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sreekanth Reddy <sreekanth.reddy@broadcom.com>

[ Upstream commit e0e0747de0ea3dd87cdbb0393311e17471a9baf1 ]

Fix the incorrect return value check of dma_get_required_mask().  Due to
this incorrect check, the driver was always setting the DMA mask to 63 bit.

Link: https://lore.kernel.org/r/20220913120538.18759-2-sreekanth.reddy@broadcom.com
Fixes: ba27c5cf286d ("scsi: mpt3sas: Don't change the DMA coherent mask after allocations")
Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 9a1ae52bb621..a6d3471a6105 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -2993,7 +2993,7 @@ _base_config_dma_addressing(struct MPT3SAS_ADAPTER *ioc, struct pci_dev *pdev)
 
 	if (ioc->is_mcpu_endpoint ||
 	    sizeof(dma_addr_t) == 4 || ioc->use_32bit_dma ||
-	    dma_get_required_mask(&pdev->dev) <= 32)
+	    dma_get_required_mask(&pdev->dev) <= DMA_BIT_MASK(32))
 		ioc->dma_mask = 32;
 	/* Set 63 bit DMA mask for all SAS3 and SAS35 controllers */
 	else if (ioc->hba_mpi_version_belonged > MPI2_VERSION)
-- 
2.35.1




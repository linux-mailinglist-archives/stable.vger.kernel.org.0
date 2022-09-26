Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7107A5EA1F7
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 13:00:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236935AbiIZLAM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 07:00:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237272AbiIZK7O (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 06:59:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 498CE5C965;
        Mon, 26 Sep 2022 03:30:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 11BBAB80921;
        Mon, 26 Sep 2022 10:30:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4776AC433D7;
        Mon, 26 Sep 2022 10:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664188214;
        bh=b5ug6492769tmpi3/aDreioFX6K/kXA2CQBR07psTOA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Mahp1dSEzjZVv+50us10Uk10fI98yjQ0vZrIdSTsB45M2UoSAffW49ylE8BoNXqLb
         tOrGDDxClXG+ylgQs8wEItUfkIF3/DRs2SNF5fffx+JOviZs78tWlAdzd3YCggBimX
         5tVFpfzqtg0kkaPk7P2fMbCoLhaIlyRZH3llavYM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 077/141] scsi: mpt3sas: Fix return value check of dma_get_required_mask()
Date:   Mon, 26 Sep 2022 12:11:43 +0200
Message-Id: <20220926100757.236635449@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100754.639112000@linuxfoundation.org>
References: <20220926100754.639112000@linuxfoundation.org>
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
index 18f85c963944..c1b76cda60db 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -2825,7 +2825,7 @@ _base_config_dma_addressing(struct MPT3SAS_ADAPTER *ioc, struct pci_dev *pdev)
 
 	if (ioc->is_mcpu_endpoint ||
 	    sizeof(dma_addr_t) == 4 || ioc->use_32bit_dma ||
-	    dma_get_required_mask(&pdev->dev) <= 32)
+	    dma_get_required_mask(&pdev->dev) <= DMA_BIT_MASK(32))
 		ioc->dma_mask = 32;
 	/* Set 63 bit DMA mask for all SAS3 and SAS35 controllers */
 	else if (ioc->hba_mpi_version_belonged > MPI2_VERSION)
-- 
2.35.1




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A03CF4F3145
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:40:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242750AbiDEJiF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:38:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237947AbiDEJE2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:04:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEE0E13F3F;
        Tue,  5 Apr 2022 01:55:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9EFF5B81C84;
        Tue,  5 Apr 2022 08:55:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1209CC385A1;
        Tue,  5 Apr 2022 08:55:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649148949;
        bh=NSm4cXzaYVKISJmzrhEGmW7kbB0t373onYfKAu8jDTU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0Uzp4a7/k0vHr5O35x8laPFa5lGffvFR1/MJSubY1Nc++ksoeQLjcwEtBFW/9cg2X
         8dkjlwXcOTTtThX11nYsbOuRTOxLXDwrnn9DfPvodkhAjMsJ5CAgrra//JqaYYzxX+
         D3zXQGK7E/kkQ0QLClPlKZ8ui79tsdN5EufX0ORI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jack Wang <jinpu.wang@ionos.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0538/1017] scsi: pm8001: Fix NCQ NON DATA command completion handling
Date:   Tue,  5 Apr 2022 09:24:11 +0200
Message-Id: <20220405070410.259833134@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
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

From: Damien Le Moal <damien.lemoal@opensource.wdc.com>

[ Upstream commit 1d6736c3e162061dc811c76e605f35ef3234bffa ]

NCQ NON DATA is an NCQ command with the DMA_NONE DMA direction and so a
register-device-to-host-FIS response is expected for it.

However, for an IO_SUCCESS case, mpi_sata_completion() expects a
set-device-bits-FIS for any ata task with an use_ncq field true, which
includes NCQ NON DATA commands.

Fix this to correctly treat NCQ NON DATA commands as non-data by also
testing for the DMA_NONE DMA direction.

Link: https://lore.kernel.org/r/20220220031810.738362-16-damien.lemoal@opensource.wdc.com
Fixes: dbf9bfe61571 ("[SCSI] pm8001: add SAS/SATA HBA driver")
Reviewed-by: Jack Wang <jinpu.wang@ionos.com>
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/pm8001/pm8001_hwi.c | 3 ++-
 drivers/scsi/pm8001/pm80xx_hwi.c | 3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
index 183c72547229..97c08afd2dcf 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -2421,7 +2421,8 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 				len = sizeof(struct pio_setup_fis);
 				pm8001_dbg(pm8001_ha, IO,
 					   "PIO read len = %d\n", len);
-			} else if (t->ata_task.use_ncq) {
+			} else if (t->ata_task.use_ncq &&
+				   t->data_dir != DMA_NONE) {
 				len = sizeof(struct set_dev_bits_fis);
 				pm8001_dbg(pm8001_ha, IO, "FPDMA len = %d\n",
 					   len);
diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
index 8eef2c51e432..414cd4b67c90 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -2518,7 +2518,8 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha,
 				len = sizeof(struct pio_setup_fis);
 				pm8001_dbg(pm8001_ha, IO,
 					   "PIO read len = %d\n", len);
-			} else if (t->ata_task.use_ncq) {
+			} else if (t->ata_task.use_ncq &&
+				   t->data_dir != DMA_NONE) {
 				len = sizeof(struct set_dev_bits_fis);
 				pm8001_dbg(pm8001_ha, IO, "FPDMA len = %d\n",
 					   len);
-- 
2.34.1




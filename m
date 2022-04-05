Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B68334F3BFD
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 17:23:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382245AbiDEMDs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 08:03:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358093AbiDEK16 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:27:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29E6966637;
        Tue,  5 Apr 2022 03:15:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E04B1B81C88;
        Tue,  5 Apr 2022 10:15:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C403C385A1;
        Tue,  5 Apr 2022 10:15:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649153706;
        bh=V6mRjgw4eCttZbMrLpti/zonBqSKnTpnRtsdslAQDiM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uRLngL+OM1ZXrHzqC2LsheU4B2x5zYX25KjuV5o0ed1mjN8kwafQKzaYkVUaS1i14
         crlseu3xYL3OH5ABxCQyozdyGMBxk0zT4rtEtuiOaK/lqVL6uhXuq7Mk8D8MUkI6DZ
         03HXKSZDWmCdZcU5bAYX7Rd+o3OqenQJ91bzHPaU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jack Wang <jinpu.wang@ionos.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 317/599] scsi: pm8001: Fix NCQ NON DATA command completion handling
Date:   Tue,  5 Apr 2022 09:30:11 +0200
Message-Id: <20220405070308.266014081@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070258.802373272@linuxfoundation.org>
References: <20220405070258.802373272@linuxfoundation.org>
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
index 7b5ab0ff9bbd..a9f317a4be70 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -2365,7 +2365,8 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
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
index 7c02db9ba7f8..4427b4c232da 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -2465,7 +2465,8 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
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




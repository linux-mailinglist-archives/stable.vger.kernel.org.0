Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CEE74F37E3
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 16:26:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359630AbiDELUY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:20:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349087AbiDEJtG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:49:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D1BFA995A;
        Tue,  5 Apr 2022 02:40:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4C749B81C14;
        Tue,  5 Apr 2022 09:40:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BF46C385A2;
        Tue,  5 Apr 2022 09:40:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649151629;
        bh=VcKJ1b7hlR38oeDFWrv/Bduu0TTbaFFTrfTsQgagKYE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zV4AgYfoSL1ppVq97sswIi6sFgXUBD3anT6iLXVyetmnddkFYm1EXiOL8TLzkYrOa
         eV5517oCDIelfXxtmlAwnvWWMNFhIGvwN0WOf2Swa0NiA8+5KECcmLU9btPNKKG/o3
         e/0sKu3aNhtSpyzf/cAHXVdQZvE0Z0t1wBps8xno=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jack Wang <jinpu.wang@ionos.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 483/913] scsi: pm8001: Fix le32 values handling in pm80xx_set_sas_protocol_timer_config()
Date:   Tue,  5 Apr 2022 09:25:45 +0200
Message-Id: <20220405070354.333407463@linuxfoundation.org>
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

From: Damien Le Moal <damien.lemoal@opensource.wdc.com>

[ Upstream commit ca374f5d92b8ae778f6a37dd3e7ed809bbf7a953 ]

All fields of the SASProtocolTimerConfig structure have the __le32 type.
As such, use cpu_to_le32() to initialize them. This change suppresses many
sparse warnings:

warning: incorrect type in assignment (different base types)
   expected restricted __le32 [addressable] [usertype] pageCode
   got int

Note that the check to limit the value of the STP_IDLE_TMO field is removed
as this field is initialized using the fixed (and small) value defined by
the STP_IDLE_TIME macro.

The pm8001_dbg() calls printing the values of the SASProtocolTimerConfig
structure fileds are changed to use le32_to_cpu() to present the values in
human readable form.

Link: https://lore.kernel.org/r/20220220031810.738362-9-damien.lemoal@opensource.wdc.com
Fixes: a6cb3d012b98 ("[SCSI] pm80xx: thermal, sas controller config and error handling update")
Reviewed-by: Jack Wang <jinpu.wang@ionos.com>
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/pm8001/pm80xx_hwi.c | 52 +++++++++++++++-----------------
 1 file changed, 25 insertions(+), 27 deletions(-)

diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
index ed6b5e7c2136..69789aa73fd1 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -1246,43 +1246,41 @@ pm80xx_set_sas_protocol_timer_config(struct pm8001_hba_info *pm8001_ha)
 	circularQ = &pm8001_ha->inbnd_q_tbl[0];
 	payload.tag = cpu_to_le32(tag);
 
-	SASConfigPage.pageCode        =  SAS_PROTOCOL_TIMER_CONFIG_PAGE;
-	SASConfigPage.MST_MSI         =  3 << 15;
-	SASConfigPage.STP_SSP_MCT_TMO =  (STP_MCT_TMO << 16) | SSP_MCT_TMO;
-	SASConfigPage.STP_FRM_TMO     = (SAS_MAX_OPEN_TIME << 24) |
-				(SMP_MAX_CONN_TIMER << 16) | STP_FRM_TIMER;
-	SASConfigPage.STP_IDLE_TMO    =  STP_IDLE_TIME;
-
-	if (SASConfigPage.STP_IDLE_TMO > 0x3FFFFFF)
-		SASConfigPage.STP_IDLE_TMO = 0x3FFFFFF;
-
-
-	SASConfigPage.OPNRJT_RTRY_INTVL =         (SAS_MFD << 16) |
-						SAS_OPNRJT_RTRY_INTVL;
-	SASConfigPage.Data_Cmd_OPNRJT_RTRY_TMO =  (SAS_DOPNRJT_RTRY_TMO << 16)
-						| SAS_COPNRJT_RTRY_TMO;
-	SASConfigPage.Data_Cmd_OPNRJT_RTRY_THR =  (SAS_DOPNRJT_RTRY_THR << 16)
-						| SAS_COPNRJT_RTRY_THR;
-	SASConfigPage.MAX_AIP =  SAS_MAX_AIP;
+	SASConfigPage.pageCode = cpu_to_le32(SAS_PROTOCOL_TIMER_CONFIG_PAGE);
+	SASConfigPage.MST_MSI = cpu_to_le32(3 << 15);
+	SASConfigPage.STP_SSP_MCT_TMO =
+		cpu_to_le32((STP_MCT_TMO << 16) | SSP_MCT_TMO);
+	SASConfigPage.STP_FRM_TMO =
+		cpu_to_le32((SAS_MAX_OPEN_TIME << 24) |
+			    (SMP_MAX_CONN_TIMER << 16) | STP_FRM_TIMER);
+	SASConfigPage.STP_IDLE_TMO = cpu_to_le32(STP_IDLE_TIME);
+
+	SASConfigPage.OPNRJT_RTRY_INTVL =
+		cpu_to_le32((SAS_MFD << 16) | SAS_OPNRJT_RTRY_INTVL);
+	SASConfigPage.Data_Cmd_OPNRJT_RTRY_TMO =
+		cpu_to_le32((SAS_DOPNRJT_RTRY_TMO << 16) | SAS_COPNRJT_RTRY_TMO);
+	SASConfigPage.Data_Cmd_OPNRJT_RTRY_THR =
+		cpu_to_le32((SAS_DOPNRJT_RTRY_THR << 16) | SAS_COPNRJT_RTRY_THR);
+	SASConfigPage.MAX_AIP = cpu_to_le32(SAS_MAX_AIP);
 
 	pm8001_dbg(pm8001_ha, INIT, "SASConfigPage.pageCode 0x%08x\n",
-		   SASConfigPage.pageCode);
+		   le32_to_cpu(SASConfigPage.pageCode));
 	pm8001_dbg(pm8001_ha, INIT, "SASConfigPage.MST_MSI  0x%08x\n",
-		   SASConfigPage.MST_MSI);
+		   le32_to_cpu(SASConfigPage.MST_MSI));
 	pm8001_dbg(pm8001_ha, INIT, "SASConfigPage.STP_SSP_MCT_TMO  0x%08x\n",
-		   SASConfigPage.STP_SSP_MCT_TMO);
+		   le32_to_cpu(SASConfigPage.STP_SSP_MCT_TMO));
 	pm8001_dbg(pm8001_ha, INIT, "SASConfigPage.STP_FRM_TMO  0x%08x\n",
-		   SASConfigPage.STP_FRM_TMO);
+		   le32_to_cpu(SASConfigPage.STP_FRM_TMO));
 	pm8001_dbg(pm8001_ha, INIT, "SASConfigPage.STP_IDLE_TMO  0x%08x\n",
-		   SASConfigPage.STP_IDLE_TMO);
+		   le32_to_cpu(SASConfigPage.STP_IDLE_TMO));
 	pm8001_dbg(pm8001_ha, INIT, "SASConfigPage.OPNRJT_RTRY_INTVL  0x%08x\n",
-		   SASConfigPage.OPNRJT_RTRY_INTVL);
+		   le32_to_cpu(SASConfigPage.OPNRJT_RTRY_INTVL));
 	pm8001_dbg(pm8001_ha, INIT, "SASConfigPage.Data_Cmd_OPNRJT_RTRY_TMO  0x%08x\n",
-		   SASConfigPage.Data_Cmd_OPNRJT_RTRY_TMO);
+		   le32_to_cpu(SASConfigPage.Data_Cmd_OPNRJT_RTRY_TMO));
 	pm8001_dbg(pm8001_ha, INIT, "SASConfigPage.Data_Cmd_OPNRJT_RTRY_THR  0x%08x\n",
-		   SASConfigPage.Data_Cmd_OPNRJT_RTRY_THR);
+		   le32_to_cpu(SASConfigPage.Data_Cmd_OPNRJT_RTRY_THR));
 	pm8001_dbg(pm8001_ha, INIT, "SASConfigPage.MAX_AIP  0x%08x\n",
-		   SASConfigPage.MAX_AIP);
+		   le32_to_cpu(SASConfigPage.MAX_AIP));
 
 	memcpy(&payload.cfg_pg, &SASConfigPage,
 			 sizeof(SASProtocolTimerConfig_t));
-- 
2.34.1




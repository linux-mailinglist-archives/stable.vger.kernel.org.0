Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F8CB4F28E9
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 10:22:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240132AbiDEIXo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:23:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237211AbiDEIRr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:17:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F6CDB1A8F;
        Tue,  5 Apr 2022 01:05:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 895BD617F1;
        Tue,  5 Apr 2022 08:05:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 963D5C385A0;
        Tue,  5 Apr 2022 08:05:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649145941;
        bh=WkIyOKDRULZo2toajZTCmWISGvM2NhUcVLUv4cnrbRs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UXteJkyXzhgqOBIDVMqFCl0V2+1vFY47sr3YaB1GgKHNg4dyy0IGuUf+1gZ6fd4qv
         yTslozz4h74sipzChhGfXiUm/Zj5fS2PAbfBf9qjSqiK7KzGekVejUreQFNheGo97o
         81uY49DqqPQIUxtfP58sdsa7+9gCS0iwIBOgnVvI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jack Wang <jinpu.wang@ionos.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0584/1126] scsi: pm8001: Fix command initialization in pm8001_chip_ssp_tm_req()
Date:   Tue,  5 Apr 2022 09:22:11 +0200
Message-Id: <20220405070424.774771988@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
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

[ Upstream commit cd2268a180117aa8ebb23e090ba204324b2d0e93 ]

The ds_ads_m field of struct ssp_ini_tm_start_req has the type __le32.
Assigning a value to it should thus use cpu_to_le32(). This fixes the
sparse warning:

warning: incorrect type in assignment (different base types)
   expected restricted __le32 [addressable] [assigned] [usertype] ds_ads_m
   got int

Link: https://lore.kernel.org/r/20220220031810.738362-7-damien.lemoal@opensource.wdc.com
Fixes: dbf9bfe61571 ("[SCSI] pm8001: add SAS/SATA HBA driver")
Reviewed-by: Jack Wang <jinpu.wang@ionos.com>
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/pm8001/pm8001_hwi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
index d978f7226206..43c2ab90f711 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -4626,7 +4626,7 @@ int pm8001_chip_ssp_tm_req(struct pm8001_hba_info *pm8001_ha,
 	memcpy(sspTMCmd.lun, task->ssp_task.LUN, 8);
 	sspTMCmd.tag = cpu_to_le32(ccb->ccb_tag);
 	if (pm8001_ha->chip_id != chip_8001)
-		sspTMCmd.ds_ads_m = 0x08;
+		sspTMCmd.ds_ads_m = cpu_to_le32(0x08);
 	circularQ = &pm8001_ha->inbnd_q_tbl[0];
 	ret = pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &sspTMCmd,
 			sizeof(sspTMCmd), 0);
-- 
2.34.1




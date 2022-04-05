Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 724C74F37E1
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 16:26:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359620AbiDELUR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:20:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349089AbiDEJtG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:49:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3373EA995C;
        Tue,  5 Apr 2022 02:40:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E3699B81B14;
        Tue,  5 Apr 2022 09:40:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58B88C385A1;
        Tue,  5 Apr 2022 09:40:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649151631;
        bh=OThjdhWAJy2ZdOmn8E572dDHuYeVeeYjsuJEwal4jL0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tmeNBzhO6aF12MDe7De6DhnG1c+FPS2Rg/jz+s7aZdJ9asZtjnwLkFpZ4btNV+sz+
         IttXkVNMPqrPrOGM+03u4iAB88/WLtPSwpZ6IJBzjb3N+nua21W9lutLg/3f50y3F9
         NvU9kLFjuYOLFXxIqi++hzwpu9pgwqFiTDlERCK8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jack Wang <jinpu.wang@ionos.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 484/913] scsi: pm8001: Fix payload initialization in pm80xx_encrypt_update()
Date:   Tue,  5 Apr 2022 09:25:46 +0200
Message-Id: <20220405070354.363687172@linuxfoundation.org>
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

[ Upstream commit f8b12dfb476dad38ce755aaf5e2df46f06f1822e ]

All fields of the kek_mgmt_req structure have the type __le32. So make sure
to use cpu_to_le32() to initialize them. This suppresses the sparse
warning:

warning: incorrect type in assignment (different base types)
   expected restricted __le32 [addressable] [assigned] [usertype] new_curidx_ksop
   got int

Link: https://lore.kernel.org/r/20220220031810.738362-10-damien.lemoal@opensource.wdc.com
Fixes: f5860992db55 ("[SCSI] pm80xx: Added SPCv/ve specific hardware functionalities and relevant changes in common files")
Reviewed-by: Jack Wang <jinpu.wang@ionos.com>
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/pm8001/pm80xx_hwi.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
index 69789aa73fd1..e606a9b1c3af 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -1406,12 +1406,13 @@ static int pm80xx_encrypt_update(struct pm8001_hba_info *pm8001_ha)
 	/* Currently only one key is used. New KEK index is 1.
 	 * Current KEK index is 1. Store KEK to NVRAM is 1.
 	 */
-	payload.new_curidx_ksop = ((1 << 24) | (1 << 16) | (1 << 8) |
-					KEK_MGMT_SUBOP_KEYCARDUPDATE);
+	payload.new_curidx_ksop =
+		cpu_to_le32(((1 << 24) | (1 << 16) | (1 << 8) |
+			     KEK_MGMT_SUBOP_KEYCARDUPDATE));
 
 	pm8001_dbg(pm8001_ha, DEV,
 		   "Saving Encryption info to flash. payload 0x%x\n",
-		   payload.new_curidx_ksop);
+		   le32_to_cpu(payload.new_curidx_ksop));
 
 	rc = pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &payload,
 			sizeof(payload), 0);
-- 
2.34.1




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E6DA500F8A
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 15:31:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244266AbiDNNdR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 09:33:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244521AbiDNN1g (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:27:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1EA5A0BD5;
        Thu, 14 Apr 2022 06:20:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3D2A4618F8;
        Thu, 14 Apr 2022 13:20:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D467C385A9;
        Thu, 14 Apr 2022 13:20:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649942424;
        bh=i4IVF2b3uFlJ29VJ5FhjGZ5Tzc030PhifJs3cdijxs0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V6vBmkC9awEMLeQbCML1w8NdCUGJMtWTxA78/+TZ4tYP6B0UGc4zsYfhYpkwrtxEq
         LMI+NsJhhVVS8ClgHrtepCE1eK6RzYs/wigjoTOrs6R5JlRMjupuzcUfMxAssMYiKx
         O1hyGPntHQ+mF9kesl69wDGklZ+L1UD4QVtPid9c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John Garry <john.garry@huawei.com>,
        Jack Wang <jinpu.wang@ionos.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 131/338] scsi: pm8001: Fix payload initialization in pm80xx_set_thermal_config()
Date:   Thu, 14 Apr 2022 15:10:34 +0200
Message-Id: <20220414110842.628926456@linuxfoundation.org>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220414110838.883074566@linuxfoundation.org>
References: <20220414110838.883074566@linuxfoundation.org>
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

[ Upstream commit bb225b12dbcc82d53d637d10b8d70b64494f8c16 ]

The fields of the set_ctrl_cfg_req structure have the __le32 type, so use
cpu_to_le32() to assign them. This removes the sparse warnings:

warning: incorrect type in assignment (different base types)
    expected restricted __le32
    got unsigned int

Link: https://lore.kernel.org/r/20220220031810.738362-8-damien.lemoal@opensource.wdc.com
Fixes: 842784e0d15b ("pm80xx: Update For Thermal Page Code")
Fixes: f5860992db55 ("[SCSI] pm80xx: Added SPCv/ve specific hardware functionalities and relevant changes in common files")
Reviewed-by: John Garry <john.garry@huawei.com>
Reviewed-by: Jack Wang <jinpu.wang@ionos.com>
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/pm8001/pm80xx_hwi.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
index c73a365da1d8..2e743dc6b13a 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -881,9 +881,11 @@ pm80xx_set_thermal_config(struct pm8001_hba_info *pm8001_ha)
 	else
 		page_code = THERMAL_PAGE_CODE_8H;
 
-	payload.cfg_pg[0] = (THERMAL_LOG_ENABLE << 9) |
-				(THERMAL_ENABLE << 8) | page_code;
-	payload.cfg_pg[1] = (LTEMPHIL << 24) | (RTEMPHIL << 8);
+	payload.cfg_pg[0] =
+		cpu_to_le32((THERMAL_LOG_ENABLE << 9) |
+			    (THERMAL_ENABLE << 8) | page_code);
+	payload.cfg_pg[1] =
+		cpu_to_le32((LTEMPHIL << 24) | (RTEMPHIL << 8));
 
 	rc = pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &payload, 0);
 	if (rc)
-- 
2.34.1




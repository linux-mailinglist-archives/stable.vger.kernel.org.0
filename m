Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B1D740636C
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 02:46:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230039AbhIJArp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 20:47:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:49276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232038AbhIJAX5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 20:23:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E71DF611BD;
        Fri, 10 Sep 2021 00:22:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631233367;
        bh=t7/ELGK6D0FuWkNv8+hF9qKpaWyFbFxslKiIqkF7WFw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qBbcnvIhzJEZDE5moFF8hWFe6MB3qhL8YNBTMR8Ox8UzgSdFXdEAKvRCsvk2tKaJc
         IlMt7LL5KQlVTFVqP8wuFktF0Rv2lb85ylmrwk/8dTk5JRwpu2eGoC8tgwHwzM7gdl
         cLQN0rsOtF8hZZ/Zcv4054OM3nUJT2jMXOW8p5LRcAmIPd+a8AR7VrH0deXEs3kbJj
         12Pcf4DIbscI4xyBuXd3kGPzwNFTLOmSCAznz1MBx+uOEVYWfEuQKpB3lgfFRTaZ7P
         S8SioLnYNpq4MP08KrIkyOHHG9c50Np2UfQdcF3Dyynm2staEVJIZbvv2/awGU1D+5
         5YN32JksRPu1w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Quinn Tran <qutran@marvell.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Nilesh Javali <njavali@marvell.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 10/25] scsi: qla2xxx: Fix NPIV create erroneous error
Date:   Thu,  9 Sep 2021 20:22:18 -0400
Message-Id: <20210910002234.176125-10-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210910002234.176125-1-sashal@kernel.org>
References: <20210910002234.176125-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

[ Upstream commit a57214443f0f85639a0d9bbb8bd658d82dbf0927 ]

When user creates multiple NPIVs, the switch capabilities field is checked
before a vport is allowed to be created. This field is being toggled if a
switch scan is in progress. This creates erroneous reject of vport create.

Link: https://lore.kernel.org/r/20210810043720.1137-10-njavali@marvell.com
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_init.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 2ebf4e4e0234..cadd67adec20 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -4244,11 +4244,11 @@ qla2x00_configure_hba(scsi_qla_host_t *vha)
 	/* initialize */
 	ha->min_external_loopid = SNS_FIRST_LOOP_ID;
 	ha->operating_mode = LOOP;
-	ha->switch_cap = 0;
 
 	switch (topo) {
 	case 0:
 		ql_dbg(ql_dbg_disc, vha, 0x200b, "HBA in NL topology.\n");
+		ha->switch_cap = 0;
 		ha->current_topology = ISP_CFG_NL;
 		strcpy(connect_type, "(Loop)");
 		break;
@@ -4262,6 +4262,7 @@ qla2x00_configure_hba(scsi_qla_host_t *vha)
 
 	case 2:
 		ql_dbg(ql_dbg_disc, vha, 0x200d, "HBA in N P2P topology.\n");
+		ha->switch_cap = 0;
 		ha->operating_mode = P2P;
 		ha->current_topology = ISP_CFG_N;
 		strcpy(connect_type, "(N_Port-to-N_Port)");
@@ -4278,6 +4279,7 @@ qla2x00_configure_hba(scsi_qla_host_t *vha)
 	default:
 		ql_dbg(ql_dbg_disc, vha, 0x200f,
 		    "HBA in unknown topology %x, using NL.\n", topo);
+		ha->switch_cap = 0;
 		ha->current_topology = ISP_CFG_NL;
 		strcpy(connect_type, "(Loop)");
 		break;
-- 
2.30.2


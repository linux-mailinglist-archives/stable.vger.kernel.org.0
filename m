Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FAF340639B
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 02:50:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240923AbhIJAsH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 20:48:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:49660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234831AbhIJAYa (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 20:24:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1B55E610A3;
        Fri, 10 Sep 2021 00:23:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631233400;
        bh=LNAbMN8XEXrCvYuRLaNDKTnY/9TwojNZNS7IbteKA54=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EESWHuWk4Hp9dKUOqt3W+ZSEU44bLSnx6PLR9LZONoENvEqDmVN9zJUqfoQJSG1SV
         FnmvdHubzL97RetfCFpSgkZw6HAZj5JbKABeWDwV+WPrmSyBWozZBJKAh0e4tabOCH
         SJUDDjPNWzpqXpcwtiIP8H/nPC/zch3/eDXEu6/CNc4/WJ/PooqVXMj0mL8VyCCyjo
         7uE3HV3Avy0DcTjjQaLydw5v2AfsSjB6p/zuiJpBOFtX2s+maBnzWESv7Nyc4R6LME
         SQ6+0Jptlb3b0K8SJfAORXwHmhSQpiRh39Ldc7q7KikqrTlwIPSowoYSxXXTu6VmxH
         0AFTgmuc+pWIQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Quinn Tran <qutran@marvell.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Nilesh Javali <njavali@marvell.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 07/19] scsi: qla2xxx: Fix NPIV create erroneous error
Date:   Thu,  9 Sep 2021 20:22:57 -0400
Message-Id: <20210910002309.176412-7-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210910002309.176412-1-sashal@kernel.org>
References: <20210910002309.176412-1-sashal@kernel.org>
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
index a66f7cec797c..e4bd889a9f72 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -3744,11 +3744,11 @@ qla2x00_configure_hba(scsi_qla_host_t *vha)
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
@@ -3762,6 +3762,7 @@ qla2x00_configure_hba(scsi_qla_host_t *vha)
 
 	case 2:
 		ql_dbg(ql_dbg_disc, vha, 0x200d, "HBA in N P2P topology.\n");
+		ha->switch_cap = 0;
 		ha->operating_mode = P2P;
 		ha->current_topology = ISP_CFG_N;
 		strcpy(connect_type, "(N_Port-to-N_Port)");
@@ -3778,6 +3779,7 @@ qla2x00_configure_hba(scsi_qla_host_t *vha)
 	default:
 		ql_dbg(ql_dbg_disc, vha, 0x200f,
 		    "HBA in unknown topology %x, using NL.\n", topo);
+		ha->switch_cap = 0;
 		ha->current_topology = ISP_CFG_NL;
 		strcpy(connect_type, "(Loop)");
 		break;
-- 
2.30.2


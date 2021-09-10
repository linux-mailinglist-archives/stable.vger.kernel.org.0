Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85D984063B1
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 02:50:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232563AbhIJAsa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 20:48:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:49986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234872AbhIJAY5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 20:24:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3874C610A3;
        Fri, 10 Sep 2021 00:23:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631233427;
        bh=koUlsSVLEmNPMjvawleObiSL+L6M9LpiRi93P3MUWzE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZtxUoR082m2qg79xJyR4RY7kfXPn3X8Mu2uZJjRpBqmp8sfQYVRU9xg9ysSI9+hOk
         BoMXBDv5+LlHNGwp8IjSSb0J8X/Jt6Qwq0er/i2zn5sBixUJjShUx85znRbr8nrfQl
         ONICDZne9uTuD/so21xkemDlW2XXZ/uts9egXkFvVCs1WVz+VF46+WWAnSjSPVrCDk
         JYBbcIEtz+rsxsK7RbvyW0jmyXxfGh5j+VYJS1fsX/xeOk0wCFRVyblYYXKGmH/V9T
         wvel3WebYXErbHrsJPSO6SZp47u9MK0EoHyYObAaxEs7Mn4Aq6VbgxDGBQ6w0E28//
         rwPVaLKv+g+eA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Quinn Tran <qutran@marvell.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Nilesh Javali <njavali@marvell.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 06/17] scsi: qla2xxx: Fix NPIV create erroneous error
Date:   Thu,  9 Sep 2021 20:23:27 -0400
Message-Id: <20210910002338.176677-6-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210910002338.176677-1-sashal@kernel.org>
References: <20210910002338.176677-1-sashal@kernel.org>
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
index 2e3a70a6b300..46e6cdddad6b 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -2507,11 +2507,11 @@ qla2x00_configure_hba(scsi_qla_host_t *vha)
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
@@ -2525,6 +2525,7 @@ qla2x00_configure_hba(scsi_qla_host_t *vha)
 
 	case 2:
 		ql_dbg(ql_dbg_disc, vha, 0x200d, "HBA in N P2P topology.\n");
+		ha->switch_cap = 0;
 		ha->operating_mode = P2P;
 		ha->current_topology = ISP_CFG_N;
 		strcpy(connect_type, "(N_Port-to-N_Port)");
@@ -2541,6 +2542,7 @@ qla2x00_configure_hba(scsi_qla_host_t *vha)
 	default:
 		ql_dbg(ql_dbg_disc, vha, 0x200f,
 		    "HBA in unknown topology %x, using NL.\n", topo);
+		ha->switch_cap = 0;
 		ha->current_topology = ISP_CFG_NL;
 		strcpy(connect_type, "(Loop)");
 		break;
-- 
2.30.2


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77767F49BC
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 13:06:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389325AbfKHLlT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 06:41:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:54572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732718AbfKHLlS (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 06:41:18 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 69EC322473;
        Fri,  8 Nov 2019 11:41:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573213278;
        bh=BsYITncQjbDdzgjbZ7L3lXwyTDl12qrWP9tYAragwzg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rFYAvhRgntCDCwJ64gEI4rtGeINnZbIHXjxvsajh3EhbECgT1y2dzUh4jMXpQ4gEn
         XgqmJUBnoLB4RAHLqxmowh6yUSnIrz45U55fMKGgod8FgEVkvesrt8BlSpepPKBtuE
         Fx2ZrqawqduLbcUPLhLLdZRbvsduoyII+qPt/NaQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Quinn Tran <quinn.tran@cavium.com>,
        Himanshu Madhani <himanshu.madhani@cavium.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 139/205] scsi: qla2xxx: Defer chip reset until target mode is enabled
Date:   Fri,  8 Nov 2019 06:36:46 -0500
Message-Id: <20191108113752.12502-139-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108113752.12502-1-sashal@kernel.org>
References: <20191108113752.12502-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Quinn Tran <quinn.tran@cavium.com>

[ Upstream commit 93eca6135183f7a71e36acd47655a085ed11bcdc ]

For target mode, any chip reset triggered before target mode is enabled will
be held off until user is ready to enable.  This prevents the chip from
starting or running before it is intended.

Signed-off-by: Quinn Tran <quinn.tran@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_os.c | 28 +++++++++++++++++++++-------
 1 file changed, 21 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 60b6019a2fcae..bfbdec61b3c6e 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -6051,12 +6051,27 @@ qla2x00_do_dpc(void *data)
 		if (test_and_clear_bit
 		    (ISP_ABORT_NEEDED, &base_vha->dpc_flags) &&
 		    !test_bit(UNLOADING, &base_vha->dpc_flags)) {
+			bool do_reset = true;
+
+			switch (ql2x_ini_mode) {
+			case QLA2XXX_INI_MODE_ENABLED:
+				break;
+			case QLA2XXX_INI_MODE_DISABLED:
+				if (!qla_tgt_mode_enabled(base_vha))
+					do_reset = false;
+				break;
+			case QLA2XXX_INI_MODE_DUAL:
+				if (!qla_dual_mode_enabled(base_vha))
+					do_reset = false;
+				break;
+			default:
+				break;
+			}
 
-			ql_dbg(ql_dbg_dpc, base_vha, 0x4007,
-			    "ISP abort scheduled.\n");
-			if (!(test_and_set_bit(ABORT_ISP_ACTIVE,
+			if (do_reset && !(test_and_set_bit(ABORT_ISP_ACTIVE,
 			    &base_vha->dpc_flags))) {
-
+				ql_dbg(ql_dbg_dpc, base_vha, 0x4007,
+				    "ISP abort scheduled.\n");
 				if (ha->isp_ops->abort_isp(base_vha)) {
 					/* failed. retry later */
 					set_bit(ISP_ABORT_NEEDED,
@@ -6064,10 +6079,9 @@ qla2x00_do_dpc(void *data)
 				}
 				clear_bit(ABORT_ISP_ACTIVE,
 						&base_vha->dpc_flags);
+				ql_dbg(ql_dbg_dpc, base_vha, 0x4008,
+				    "ISP abort end.\n");
 			}
-
-			ql_dbg(ql_dbg_dpc, base_vha, 0x4008,
-			    "ISP abort end.\n");
 		}
 
 		if (test_and_clear_bit(FCPORT_UPDATE_NEEDED,
-- 
2.20.1


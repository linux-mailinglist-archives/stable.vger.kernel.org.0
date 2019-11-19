Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3736E10186C
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 07:08:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729210AbfKSFbK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:31:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:50058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729204AbfKSFbJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:31:09 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 90F0121783;
        Tue, 19 Nov 2019 05:31:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574141469;
        bh=B3Bt96iKRJBUIJiPv6nnlkBt+SfcTWmHGv9a1VBmFjw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cLKewZm75qBeSj4hXnVShlgImOPbub3ITv4V7awDflgzV7NYWqLgh8EDGu0bxczQY
         hV2aUuQ4hwkG4QFv6jXleEpenheqkMERcL+ZZ7b8oDE77yhtYIvO8sDgX6iSZDowPZ
         J9oVxziC8KKBlNcqSxkmG8NfpCigWDipi5mLjnGo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Quinn Tran <quinn.tran@cavium.com>,
        Himanshu Madhani <himanshu.madhani@cavium.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 170/422] scsi: qla2xxx: Defer chip reset until target mode is enabled
Date:   Tue, 19 Nov 2019 06:16:07 +0100
Message-Id: <20191119051409.435750100@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051400.261610025@linuxfoundation.org>
References: <20191119051400.261610025@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 18ee614fe07f5..d978ea1344625 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -6059,12 +6059,27 @@ qla2x00_do_dpc(void *data)
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
@@ -6072,10 +6087,9 @@ qla2x00_do_dpc(void *data)
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




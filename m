Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E602B101874
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 07:08:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729270AbfKSFba (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:31:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:50578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728834AbfKSFb3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:31:29 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CC888222A2;
        Tue, 19 Nov 2019 05:31:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574141489;
        bh=NGdbHR2Y6ZJaJpbPKyIQqicj7ZPnG+k3WHelTDg6trs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A/Y4hvmEWG22lb6zrmUBfnX8LSp+2KWpndtJ8qtaL+2PADaRjfy58YzSI4/hPDlRQ
         rGlZkFDCMG2ggQDzT7DaUjLptqf37WZUE8UEEF1GrqxogTIGwYao8hva8mdtyFSMY4
         TGR8IzS/yUoti1itxiB53wkO2ICDNuw8l5cZWeeM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Quinn Tran <quinn.tran@cavium.com>,
        Himanshu Madhani <himanshu.madhani@cavium.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 177/422] scsi: qla2xxx: Fix duplicate switchs Nport ID entries
Date:   Tue, 19 Nov 2019 06:16:14 +0100
Message-Id: <20191119051409.909548306@linuxfoundation.org>
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

[ Upstream commit f3a03ee1102a44ccbd2c5de80a6e862ba23e9b55 ]

Current code relies on switch to provide a unique combination of WWPN +
NPORTID to tract an FC port.  This patch tries to detect a case where switch
data base can get corrupted where multiple WWPNs can have the same Nport ID.
The 1st Nport ID on the list will be kept while the duplicate Nport ID will be
discarded.

Signed-off-by: Quinn Tran <quinn.tran@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_gs.c | 24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index d611cf722244c..b8d3403c3c85a 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -3902,9 +3902,10 @@ void qla24xx_async_gnnft_done(scsi_qla_host_t *vha, srb_t *sp)
 	fc_port_t *fcport;
 	u32 i, rc;
 	bool found;
-	struct fab_scan_rp *rp;
+	struct fab_scan_rp *rp, *trp;
 	unsigned long flags;
 	u8 recheck = 0;
+	u16 dup = 0, dup_cnt = 0;
 
 	ql_dbg(ql_dbg_disc, vha, 0xffff,
 	    "%s enter\n", __func__);
@@ -3935,6 +3936,7 @@ void qla24xx_async_gnnft_done(scsi_qla_host_t *vha, srb_t *sp)
 
 	for (i = 0; i < vha->hw->max_fibre_devices; i++) {
 		u64 wwn;
+		int k;
 
 		rp = &vha->scan.l[i];
 		found = false;
@@ -3943,6 +3945,20 @@ void qla24xx_async_gnnft_done(scsi_qla_host_t *vha, srb_t *sp)
 		if (wwn == 0)
 			continue;
 
+		/* Remove duplicate NPORT ID entries from switch data base */
+		for (k = i + 1; k < vha->hw->max_fibre_devices; k++) {
+			trp = &vha->scan.l[k];
+			if (rp->id.b24 == trp->id.b24) {
+				dup = 1;
+				dup_cnt++;
+				ql_dbg(ql_dbg_disc + ql_dbg_verbose,
+				    vha, 0xffff,
+				    "Detected duplicate NPORT ID from switch data base: ID %06x WWN %8phN WWN %8phN\n",
+				    rp->id.b24, rp->port_name, trp->port_name);
+				memset(trp, 0, sizeof(*trp));
+			}
+		}
+
 		if (!memcmp(rp->port_name, vha->port_name, WWN_SIZE))
 			continue;
 
@@ -3982,6 +3998,12 @@ void qla24xx_async_gnnft_done(scsi_qla_host_t *vha, srb_t *sp)
 		}
 	}
 
+	if (dup) {
+		ql_log(ql_log_warn, vha, 0xffff,
+		    "Detected %d duplicate NPORT ID(s) from switch data base\n",
+		    dup_cnt);
+	}
+
 	/*
 	 * Logout all previous fabric dev marked lost, except FCP2 devices.
 	 */
-- 
2.20.1




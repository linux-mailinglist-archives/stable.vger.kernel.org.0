Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BBD51AC3F4
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 15:52:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408811AbgDPNwB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 09:52:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:38252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2408804AbgDPNv7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:51:59 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DD6A42078B;
        Thu, 16 Apr 2020 13:51:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587045119;
        bh=oK6sP62fE4Cer2WwbYd0Xghp/X4kMCZ2SKG/puDV+5E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f/7Hsa4A4/mT1xJJRkxG2YvIp5mzAm2w+B7Y2qkl2KFGg5hE0WlGvhqg6wzsQbtT+
         MtTLgD/FkiDYSD5427a9853G/9gIv7fbW25yGAgplhj1cmS/7qUzG852QoD2sYEc1n
         GKcVfgMX3rvwwzq4qpnA7KsPjD5XO9LVcmyy2w6c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dick Kennedy <dick.kennedy@broadcom.com>,
        James Smart <jsmart2021@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 224/232] scsi: lpfc: Fix configuration of BB credit recovery in service parameters
Date:   Thu, 16 Apr 2020 15:25:18 +0200
Message-Id: <20200416131343.537318853@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131316.640996080@linuxfoundation.org>
References: <20200416131316.640996080@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Smart <jsmart2021@gmail.com>

[ Upstream commit 6bfb1620829825c01e1dcdd63b6a7700352babd9 ]

The driver today is reading service parameters from the firmware and then
overwriting the firmware-provided values with values of its own.  There are
some switch features that require preliminary FLOGI's that are
switch-specific and done prior to the actual fabric FLOGI for traffic.  The
fw will perform those FLOGIs and will revise the service parameters for the
features configured. As the driver later overwrites those values with its
own values, it misconfigures things like BBSCN use by doing so.

Correct by eliminating the driver-overwrite of firmware values. The driver
correctly re-reads the service parameters after each link up to obtain the
latest values from firmware.

Link: https://lore.kernel.org/r/20191105005708.7399-3-jsmart2021@gmail.com
Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_hbadisc.c | 13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index 39ca541935342..3f7df471106e9 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -1139,7 +1139,6 @@ void
 lpfc_mbx_cmpl_local_config_link(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 {
 	struct lpfc_vport *vport = pmb->vport;
-	uint8_t bbscn = 0;
 
 	if (pmb->u.mb.mbxStatus)
 		goto out;
@@ -1166,17 +1165,11 @@ lpfc_mbx_cmpl_local_config_link(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 	/* Start discovery by sending a FLOGI. port_state is identically
 	 * LPFC_FLOGI while waiting for FLOGI cmpl
 	 */
-	if (vport->port_state != LPFC_FLOGI) {
-		if (phba->bbcredit_support && phba->cfg_enable_bbcr) {
-			bbscn = bf_get(lpfc_bbscn_def,
-				       &phba->sli4_hba.bbscn_params);
-			vport->fc_sparam.cmn.bbRcvSizeMsb &= 0xf;
-			vport->fc_sparam.cmn.bbRcvSizeMsb |= (bbscn << 4);
-		}
+	if (vport->port_state != LPFC_FLOGI)
 		lpfc_initial_flogi(vport);
-	} else if (vport->fc_flag & FC_PT2PT) {
+	else if (vport->fc_flag & FC_PT2PT)
 		lpfc_disc_start(vport);
-	}
+
 	return;
 
 out:
-- 
2.20.1




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DAB83C2F99
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 04:30:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233685AbhGJCbw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 22:31:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:48820 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233992AbhGJCaN (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 22:30:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4F19961400;
        Sat, 10 Jul 2021 02:27:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625884046;
        bh=JjjOp3Q0+dxmNz+7tdPWsL7mLftjFhH1hll/TdcqR7I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t6nvSalI2gdQfXfitSBSuF53nTVhTGBa7l+dhGes+2+0cJpVytxt9JyV/YCH4gC9z
         ox5uQNGcbAGMeOGBJxcpFq3uC8D/82gaWujQDeMTS1r0m1hbABGDrRpJnfbsmwRp9r
         ypQMEr0WUEbuzF94A1B/iN9QezWm0c9ymNvNlHGyPVTlPQ99qn+3djyWV2VJzMQ9y3
         HhCPk8WNLxZK4xhSFXLIyAjlQKvKEB9Ur493A6FBeTBlpSHVCyhvAd7h8oF7lmEXcS
         Hc+lbMa+vNwT7htocpn6EjnyNjz66M8yr3NmW1USuT37Qt8NpkyfyM3jfkpn1JfG9T
         B44eSmgYg8QzA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 13/63] scsi: lpfc: Fix "Unexpected timeout" error in direct attach topology
Date:   Fri,  9 Jul 2021 22:26:19 -0400
Message-Id: <20210710022709.3170675-13-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710022709.3170675-1-sashal@kernel.org>
References: <20210710022709.3170675-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Smart <jsmart2021@gmail.com>

[ Upstream commit e30d55137edef47434c40d7570276a0846fe922c ]

An 'unexpected timeout' message may be seen in a point-2-point topology.
The message occurs when a PLOGI is received before the driver is notified
of FLOGI completion. The FLOGI completion failure causes discovery to be
triggered for a second time. The discovery timer is restarted but no new
discovery activity is initiated, thus the timeout message eventually
appears.

In point-2-point, when discovery has progressed before the FLOGI completion
is processed, it is not a failure. Add code to FLOGI completion to detect
that discovery has progressed and exit the FLOGI handling (noop'ing it).

Link: https://lore.kernel.org/r/20210514195559.119853-4-jsmart2021@gmail.com
Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_els.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 4e994a693e3f..2040affa0887 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -1179,6 +1179,15 @@ lpfc_cmpl_els_flogi(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 			phba->fcf.fcf_redisc_attempted = 0; /* reset */
 			goto out;
 		}
+	} else if (vport->port_state > LPFC_FLOGI &&
+		   vport->fc_flag & FC_PT2PT) {
+		/*
+		 * In a p2p topology, it is possible that discovery has
+		 * already progressed, and this completion can be ignored.
+		 * Recheck the indicated topology.
+		 */
+		if (!sp->cmn.fPort)
+			goto out;
 	}
 
 flogifail:
-- 
2.30.2


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 743193CE1D6
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:12:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346427AbhGSP2B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:28:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:40236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348351AbhGSPYo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:24:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2D87A61002;
        Mon, 19 Jul 2021 16:04:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626710674;
        bh=6gLBLds0S10D4p4mmUylYxbFyoDdzCqDmWrhw+Ptj4M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EYIIN2OCLHQ0tsJaBlByhF6dBuKbWo4a6tf159o7A0yE/sZUkCVVw8fkDgFpgzHFV
         b1Y17VlwGZhJ8LSHSCmRVzi/A4rGWHzbRPaZ9fHVDUS/33Q/XRrmsmS8xq/aG82dGc
         ZO9PRv1zUOUVVJxC+7YQeRNDWuB0FVdKrnIIFqDg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Justin Tee <justin.tee@broadcom.com>,
        James Smart <jsmart2021@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 067/351] scsi: lpfc: Fix "Unexpected timeout" error in direct attach topology
Date:   Mon, 19 Jul 2021 16:50:13 +0200
Message-Id: <20210719144946.733194931@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144944.537151528@linuxfoundation.org>
References: <20210719144944.537151528@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index c3ca2ccf9f82..933927f738c7 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -1175,6 +1175,15 @@ stop_rr_fcf_flogi:
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




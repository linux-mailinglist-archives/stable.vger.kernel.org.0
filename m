Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C9CD3CD8D6
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:06:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243485AbhGSOZq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:25:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:56152 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243529AbhGSOYH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:24:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B41376113E;
        Mon, 19 Jul 2021 15:03:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626707021;
        bh=lHj2IO52YggI9UnxK56BuU6XOf0zl8aTC+JB6UiJKy4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2Rb4FbPa5bvgGRXnV8imZEf++AFHj+nWrpe4S1yjOa/xYBuw9c0IbYQYAJGhTRtBR
         YNHNwqAHz4aTVAgClqHJnfSn1MwHaCfEfAkok9ZjFcWXQAtHJotzglb9H3bhCYI7kb
         I63xaP/hEK0wE7NuXuKeV5NlAwJFRqadU/zMrz3s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Justin Tee <justin.tee@broadcom.com>,
        James Smart <jsmart2021@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 146/188] scsi: lpfc: Fix "Unexpected timeout" error in direct attach topology
Date:   Mon, 19 Jul 2021 16:52:10 +0200
Message-Id: <20210719144941.262866644@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144913.076563739@linuxfoundation.org>
References: <20210719144913.076563739@linuxfoundation.org>
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
index 5be938b47f48..b66b1ed6d2af 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -1142,6 +1142,15 @@ stop_rr_fcf_flogi:
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




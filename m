Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E79A84062D4
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 02:45:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242164AbhIJAqZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 20:46:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:48044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234030AbhIJAWX (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 20:22:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 67E7D610E9;
        Fri, 10 Sep 2021 00:21:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631233273;
        bh=H6Dk/3c6UUBrHjCCr5gXVhqlQjn8gXFzMQXWpfbSB50=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i3k4uNda++LB8kkBMBdNgIzngwsZzi67ecRguy6sFtLORMt+BSToKyxsLpFXNvEYt
         szmetVfIHz7r5ZlKpHPU1sa7VexrqwEgPrew63fWFgtlHLFfsWQuvP513p4q1FzioF
         tHytn4iDLeXH6cC2dmN4v+H9RSCBTe2F5jo/9cwEk3UJeu4VLtklIjyaIjbbBgcuBR
         MaE7ITp6YAFVpUWQwAJvZvn5e6XS6WQtZbdY/8Ru5Zt15PV2uBAL9rLpdxFvgBDgsE
         teXSuF+4/j3fTyK7KgG7dxAwrMkc8hedfppfmPHVy4azICvOYqH9MZJT9DZPQQLwI6
         Me+uZi34mkEaQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Quinn Tran <qutran@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 32/53] scsi: qla2xxx: Fix NVMe | FCP personality change
Date:   Thu,  9 Sep 2021 20:20:07 -0400
Message-Id: <20210910002028.175174-32-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210910002028.175174-1-sashal@kernel.org>
References: <20210910002028.175174-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

[ Upstream commit f6e327fc09e48271c103efb3b69fc4ccda3f408b ]

Currently driver saves the personality type (FCP|NVMe) at the start of
first discovery of the remote device. If the remote device personality do
change over time, then qla driver needs to present that to user to decide.

Link: https://lore.kernel.org/r/20210817051315.2477-8-njavali@marvell.com
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_gs.c   | 1 +
 drivers/scsi/qla2xxx/qla_init.c | 5 +++--
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index e28c4b7ec55f..eddf3335e4e3 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -3494,6 +3494,7 @@ void qla24xx_async_gnnft_done(scsi_qla_host_t *vha, srb_t *sp)
 				continue;
 			fcport->scan_state = QLA_FCPORT_FOUND;
 			fcport->last_rscn_gen = fcport->rscn_gen;
+			fcport->fc4_type = rp->fc4type;
 			found = true;
 			/*
 			 * If device was not a fabric device before.
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index d3526a247841..1a81f3b721b6 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -1533,11 +1533,12 @@ int qla24xx_fcport_handle_login(struct scsi_qla_host *vha, fc_port_t *fcport)
 	u16 sec;
 
 	ql_dbg(ql_dbg_disc, vha, 0x20d8,
-	    "%s %8phC DS %d LS %d P %d fl %x confl %p rscn %d|%d login %d lid %d scan %d\n",
+	    "%s %8phC DS %d LS %d P %d fl %x confl %p rscn %d|%d login %d lid %d scan %d fc4type %x\n",
 	    __func__, fcport->port_name, fcport->disc_state,
 	    fcport->fw_login_state, fcport->login_pause, fcport->flags,
 	    fcport->conflict, fcport->last_rscn_gen, fcport->rscn_gen,
-	    fcport->login_gen, fcport->loop_id, fcport->scan_state);
+	    fcport->login_gen, fcport->loop_id, fcport->scan_state,
+	    fcport->fc4_type);
 
 	if (fcport->scan_state != QLA_FCPORT_FOUND)
 		return 0;
-- 
2.30.2


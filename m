Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F11E913339E
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 22:20:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727135AbgAGVE0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 16:04:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:48666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728691AbgAGVE0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jan 2020 16:04:26 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6B26924676;
        Tue,  7 Jan 2020 21:04:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578431065;
        bh=2fEuL8DFvNY9pTqPEb9r5kTK2censwIs22wtuyMPziw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qVUICVKMGWXgHT8yHQ5EF13qwh7vzgeay2OeFVZhRorMe0ovdOPbWHD6OUrrOz5IC
         oElC6CoS172udfYqs2D30cWn5RbAElhna0Ra9DREt3o8dHKW8fZVBII2aQexidmdwC
         PPkCVLXoEfevTAdcC1n1y6fuC5PZUJEOekzrQx5g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Quinn Tran <qutran@marvell.com>,
        Himanshu Madhani <hmadhani@marvell.com>,
        Hannes Reinecke <hare@suse.de>,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 020/115] scsi: qla2xxx: Ignore PORT UPDATE after N2N PLOGI
Date:   Tue,  7 Jan 2020 21:53:50 +0100
Message-Id: <20200107205254.170962810@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200107205240.283674026@linuxfoundation.org>
References: <20200107205240.283674026@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roman Bolshakov <r.bolshakov@yadro.com>

[ Upstream commit af22f0c7b052c5c203207f1e5ebd6aa65f87c538 ]

PORT UPDATE asynchronous event is generated on the host that issues PLOGI
ELS (in the case of higher WWPN). In that case, the event shouldn't be
handled as it sets unwanted DPC flags (i.e. LOOP_RESYNC_NEEDED) that
trigger link flap.

Ignore the event if the host has higher WWPN, but handle otherwise.

Cc: Quinn Tran <qutran@marvell.com>
Link: https://lore.kernel.org/r/20191125165702.1013-13-r.bolshakov@yadro.com
Acked-by: Himanshu Madhani <hmadhani@marvell.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Tested-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Roman Bolshakov <r.bolshakov@yadro.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_mbx.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index b01f69dd4b28..abef3b29fa10 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -3871,6 +3871,7 @@ qla24xx_report_id_acquisition(scsi_qla_host_t *vha,
 					vha->d_id.b24 = 0;
 					vha->d_id.b.al_pa = 1;
 					ha->flags.n2n_bigger = 1;
+					ha->flags.n2n_ae = 0;
 
 					id.b.al_pa = 2;
 					ql_dbg(ql_dbg_async, vha, 0x5075,
@@ -3881,6 +3882,7 @@ qla24xx_report_id_acquisition(scsi_qla_host_t *vha,
 					    "Format 1: Remote login - Waiting for WWPN %8phC.\n",
 					    rptid_entry->u.f1.port_name);
 					ha->flags.n2n_bigger = 0;
+					ha->flags.n2n_ae = 1;
 				}
 				qla24xx_post_newsess_work(vha, &id,
 				    rptid_entry->u.f1.port_name,
@@ -3892,7 +3894,6 @@ qla24xx_report_id_acquisition(scsi_qla_host_t *vha,
 			/* if our portname is higher then initiate N2N login */
 
 			set_bit(N2N_LOGIN_NEEDED, &vha->dpc_flags);
-			ha->flags.n2n_ae = 1;
 			return;
 			break;
 		case TOPO_FL:
-- 
2.20.1




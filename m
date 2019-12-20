Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3CE34127D9C
	for <lists+stable@lfdr.de>; Fri, 20 Dec 2019 15:38:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728027AbfLTOfB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Dec 2019 09:35:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:39328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728329AbfLTOfB (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Dec 2019 09:35:01 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9AE9224680;
        Fri, 20 Dec 2019 14:34:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576852500;
        bh=poCgc+XuigasFh8jiFvh/hpav7KlF6IhwdhTZXEK/00=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qxTtwdmRBaHjzTwfbVfQf//aNHk/ZFVRomjqc0nLECU7JJd0wcJJDH+X2PpYsTYMe
         a0SP1j6Nafo+rwplxhJKiJdBJfRQPL8EwS+T80RtdT1zDUzm3gFBonzN+ThZ5bATPz
         XQPf/FcSsS84uU3tuQNX7DFygyeSGnc34cvgak8s=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Roman Bolshakov <r.bolshakov@yadro.com>,
        Quinn Tran <qutran@marvell.com>,
        Himanshu Madhani <hmadhani@marvell.com>,
        Hannes Reinecke <hare@suse.de>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 20/34] scsi: qla2xxx: Ignore PORT UPDATE after N2N PLOGI
Date:   Fri, 20 Dec 2019 09:34:19 -0500
Message-Id: <20191220143433.9922-20-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191220143433.9922-1-sashal@kernel.org>
References: <20191220143433.9922-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index b01f69dd4b283..abef3b29fa101 100644
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


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32461127E8E
	for <lists+stable@lfdr.de>; Fri, 20 Dec 2019 15:48:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727847AbfLTOrv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Dec 2019 09:47:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:46218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727842AbfLTOru (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Dec 2019 09:47:50 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CC9592468D;
        Fri, 20 Dec 2019 14:47:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576853269;
        bh=5YOfVVCCWhxRkjzJbFr8fCriRbIcuAGsnCrtuszjOmY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HI6AjHAAaUrcofDkJ2rSNB+g+pPW6hsz58+cmH/6qD6t9h+xjSLcsCoF517ENsuD+
         O6+UfwM1nzQgwFKD3t286OP+wT5uXN0/AaiPuVph3FPMmMjdQWXZrxgPOCE/csUX6S
         ocy95XnmqGM51bTniIQQzjyDFKUgdA2cCpwtKrnQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Roman Bolshakov <r.bolshakov@yadro.com>,
        Quinn Tran <qutran@marvell.com>,
        Himanshu Madhani <hmadhani@marvel.com>,
        Hannes Reinecke <hare@suse.de>,
        Himanshu Madhani <hmadhani@marvell.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 04/11] scsi: qla2xxx: Don't call qlt_async_event twice
Date:   Fri, 20 Dec 2019 09:47:36 -0500
Message-Id: <20191220144744.10565-4-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191220144744.10565-1-sashal@kernel.org>
References: <20191220144744.10565-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roman Bolshakov <r.bolshakov@yadro.com>

[ Upstream commit 2c2f4bed9b6299e6430a65a29b5d27b8763fdf25 ]

MBA_PORT_UPDATE generates duplicate log lines in target mode because
qlt_async_event is called twice. Drop the calls within the case as the
function will be called right after the switch statement.

Cc: Quinn Tran <qutran@marvell.com>
Link: https://lore.kernel.org/r/20191125165702.1013-8-r.bolshakov@yadro.com
Acked-by: Himanshu Madhani <hmadhani@marvel.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Tested-by: Hannes Reinecke <hare@suse.de>
Acked-by: Himanshu Madhani <hmadhani@marvell.com>
Signed-off-by: Roman Bolshakov <r.bolshakov@yadro.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_isr.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 440d79e6aea5d..dc7cef6ff8292 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -966,8 +966,6 @@ qla2x00_async_event(scsi_qla_host_t *vha, struct rsp_que *rsp, uint16_t *mb)
 			ql_dbg(ql_dbg_async, vha, 0x5011,
 			    "Asynchronous PORT UPDATE ignored %04x/%04x/%04x.\n",
 			    mb[1], mb[2], mb[3]);
-
-			qlt_async_event(mb[0], vha, mb);
 			break;
 		}
 
@@ -988,8 +986,6 @@ qla2x00_async_event(scsi_qla_host_t *vha, struct rsp_que *rsp, uint16_t *mb)
 		set_bit(LOOP_RESYNC_NEEDED, &vha->dpc_flags);
 		set_bit(LOCAL_LOOP_UPDATE, &vha->dpc_flags);
 		set_bit(VP_CONFIG_OK, &vha->vp_flags);
-
-		qlt_async_event(mb[0], vha, mb);
 		break;
 
 	case MBA_RSCN_UPDATE:		/* State Change Registration */
-- 
2.20.1


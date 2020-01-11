Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4CA44137D89
	for <lists+stable@lfdr.de>; Sat, 11 Jan 2020 11:00:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728978AbgAKJ6t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 04:58:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:52604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728900AbgAKJ6t (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Jan 2020 04:58:49 -0500
Received: from localhost (unknown [62.119.166.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F22162087F;
        Sat, 11 Jan 2020 09:58:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578736728;
        bh=j5KBUszL58vJfT76uQWLheMxHEphyNG2BcAwIcK686Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tuuf8ST9XbyaMNolsH7YD/aqlY3nNH/MM/0dsw0uFXY0XgS9aFz9VGp3qWMJDwicj
         1DctyafJbDP85Xgmb3tYdBlOLJOtUfyLRK9qCF1Tqk1LYEldrKPFtPUAbBhIis2FFQ
         QMcMHj5eo2Fs64kxC5vFNk1g8UX5hFW96r5LstTQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Quinn Tran <qutran@marvell.com>,
        Himanshu Madhani <hmadhani@marvel.com>,
        Hannes Reinecke <hare@suse.de>,
        Himanshu Madhani <hmadhani@marvell.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 04/91] scsi: qla2xxx: Dont call qlt_async_event twice
Date:   Sat, 11 Jan 2020 10:48:57 +0100
Message-Id: <20200111094845.494490127@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200111094844.748507863@linuxfoundation.org>
References: <20200111094844.748507863@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index f0fcff032f8a..17b1525d492b 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -973,8 +973,6 @@ qla2x00_async_event(scsi_qla_host_t *vha, struct rsp_que *rsp, uint16_t *mb)
 			ql_dbg(ql_dbg_async, vha, 0x5011,
 			    "Asynchronous PORT UPDATE ignored %04x/%04x/%04x.\n",
 			    mb[1], mb[2], mb[3]);
-
-			qlt_async_event(mb[0], vha, mb);
 			break;
 		}
 
@@ -995,8 +993,6 @@ qla2x00_async_event(scsi_qla_host_t *vha, struct rsp_que *rsp, uint16_t *mb)
 		set_bit(LOOP_RESYNC_NEEDED, &vha->dpc_flags);
 		set_bit(LOCAL_LOOP_UPDATE, &vha->dpc_flags);
 		set_bit(VP_CONFIG_OK, &vha->vp_flags);
-
-		qlt_async_event(mb[0], vha, mb);
 		break;
 
 	case MBA_RSCN_UPDATE:		/* State Change Registration */
-- 
2.20.1




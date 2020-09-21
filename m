Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5719272FCE
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 19:00:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728887AbgIUQ74 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 12:59:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:43994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728374AbgIUQky (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:40:54 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DF21B206DC;
        Mon, 21 Sep 2020 16:40:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600706453;
        bh=CxXvDCRFbXogjAHvT1dFieOqdnGaCKypk6nS4evj2Q0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s5pQv5u/pmE8uSEoX7a3dBJODsddBDSOlO9c4tDHOY1fRqnXssi4uDJ0+WjSGTGcA
         oYKlJsFOzkhLlGeV1WQIDcEcByFDSlL1jB3FWmXkodIB7a77jGZhXsrnV1hG8elD9b
         QXZMgg9O+9kFMucZAJm8aeoSYXH/OtzkwDYISRDs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Quinn Tran <quinn.tran@cavium.com>,
        Himanshu Madhani <himanshu.madhani@cavium.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Zhengyuan Liu <liuzhengyuan@kylinos.cn>
Subject: [PATCH 4.19 02/49] scsi: qla2xxx: Update rscn_rcvd field to more meaningful scan_needed
Date:   Mon, 21 Sep 2020 18:27:46 +0200
Message-Id: <20200921162034.770440243@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921162034.660953761@linuxfoundation.org>
References: <20200921162034.660953761@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Quinn Tran <quinn.tran@cavium.com>

commit cb873ba4002095d1e2fc60521bc4d860c7b72b92 upstream.

Rename rscn_rcvd field to scan_needed to be more meaningful.

Signed-off-by: Quinn Tran <quinn.tran@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Zhengyuan Liu <liuzhengyuan@kylinos.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/qla2xxx/qla_def.h  |    2 +-
 drivers/scsi/qla2xxx/qla_gs.c   |   12 ++++++------
 drivers/scsi/qla2xxx/qla_init.c |    2 +-
 3 files changed, 8 insertions(+), 8 deletions(-)

--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -2351,7 +2351,7 @@ typedef struct fc_port {
 	unsigned int login_succ:1;
 	unsigned int query:1;
 	unsigned int id_changed:1;
-	unsigned int rscn_rcvd:1;
+	unsigned int scan_needed:1;
 
 	struct work_struct nvme_del_work;
 	struct completion nvme_del_done;
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -3973,7 +3973,7 @@ void qla24xx_async_gnnft_done(scsi_qla_h
 		list_for_each_entry(fcport, &vha->vp_fcports, list) {
 			if (memcmp(rp->port_name, fcport->port_name, WWN_SIZE))
 				continue;
-			fcport->rscn_rcvd = 0;
+			fcport->scan_needed = 0;
 			fcport->scan_state = QLA_FCPORT_FOUND;
 			found = true;
 			/*
@@ -4009,12 +4009,12 @@ void qla24xx_async_gnnft_done(scsi_qla_h
 	 */
 	list_for_each_entry(fcport, &vha->vp_fcports, list) {
 		if ((fcport->flags & FCF_FABRIC_DEVICE) == 0) {
-			fcport->rscn_rcvd = 0;
+			fcport->scan_needed = 0;
 			continue;
 		}
 
 		if (fcport->scan_state != QLA_FCPORT_FOUND) {
-			fcport->rscn_rcvd = 0;
+			fcport->scan_needed = 0;
 			if ((qla_dual_mode_enabled(vha) ||
 				qla_ini_mode_enabled(vha)) &&
 			    atomic_read(&fcport->state) == FCS_ONLINE) {
@@ -4033,7 +4033,7 @@ void qla24xx_async_gnnft_done(scsi_qla_h
 				}
 			}
 		} else {
-			if (fcport->rscn_rcvd ||
+			if (fcport->scan_needed ||
 			    fcport->disc_state != DSC_LOGIN_COMPLETE) {
 				if (fcport->login_retry == 0) {
 					fcport->login_retry =
@@ -4043,7 +4043,7 @@ void qla24xx_async_gnnft_done(scsi_qla_h
 					    fcport->port_name, fcport->loop_id,
 					    fcport->login_retry);
 				}
-				fcport->rscn_rcvd = 0;
+				fcport->scan_needed = 0;
 				qla24xx_fcport_handle_login(vha, fcport);
 			}
 		}
@@ -4058,7 +4058,7 @@ out:
 
 	if (recheck) {
 		list_for_each_entry(fcport, &vha->vp_fcports, list) {
-			if (fcport->rscn_rcvd) {
+			if (fcport->scan_needed) {
 				set_bit(LOCAL_LOOP_UPDATE, &vha->dpc_flags);
 				set_bit(LOOP_RESYNC_NEEDED, &vha->dpc_flags);
 				break;
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -1573,7 +1573,7 @@ void qla2x00_fcport_event_handler(scsi_q
 			fcport = qla2x00_find_fcport_by_nportid
 				(vha, &ea->id, 1);
 			if (fcport)
-				fcport->rscn_rcvd = 1;
+				fcport->scan_needed = 1;
 
 			spin_lock_irqsave(&vha->work_lock, flags);
 			if (vha->scan.scan_flags == 0) {



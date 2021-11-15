Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C6B04525CF
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:56:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245646AbhKPB7e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:59:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:49936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240449AbhKOSJr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:09:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3FBF7632A1;
        Mon, 15 Nov 2021 17:46:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636998409;
        bh=N9N4XaEv4ROQxq4GK76No+ZvrPAARcZgOHOHnlIv1YI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PE0UOXYj0wYB2b7A60gUqV3F84MWK4P8IB+NdoU9FzdpCo2qgrUhymEUBt/DKtLNk
         9mJY+jTUYX6kx7dC/8S9OMVZ3LnP93lyB0SKNo9cBZQbOyRsvmOnW8y5tvvMiBRmv0
         mvC8FGQNQNVwarxzmgFO+7iXLGdJwhOsTpsXDn44=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Saurav Kashyap <skashyap@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 498/575] scsi: qla2xxx: Changes to support FCP2 Target
Date:   Mon, 15 Nov 2021 18:03:43 +0100
Message-Id: <20211115165400.921038889@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Saurav Kashyap <skashyap@marvell.com>

[ Upstream commit 44c57f205876518b14ab2b4b5d88a181f41260bb ]

Add changes to support FCP2 Target.

Link: https://lore.kernel.org/r/20210810043720.1137-5-njavali@marvell.com
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Saurav Kashyap <skashyap@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_dbg.c  |  3 +--
 drivers/scsi/qla2xxx/qla_init.c |  6 ++++++
 drivers/scsi/qla2xxx/qla_os.c   | 10 ++++++++++
 3 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index 144a893e7335b..3a20bf8ce5ab9 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -12,8 +12,7 @@
  * ----------------------------------------------------------------------
  * | Module Init and Probe        |       0x0199       |                |
  * | Mailbox commands             |       0x1206       | 0x11a5-0x11ff	|
- * | Device Discovery             |       0x2134       | 0x210e-0x2116  |
- * |				  | 		       | 0x211a         |
+ * | Device Discovery             |       0x2134       | 0x210e-0x2115  |
  * |                              |                    | 0x211c-0x2128  |
  * |                              |                    | 0x212c-0x2134  |
  * | Queue Command and IO tracing |       0x3074       | 0x300b         |
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index b7aac3116f2db..e893b42e51a35 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -1710,6 +1710,12 @@ void qla2x00_handle_rscn(scsi_qla_host_t *vha, struct event_arg *ea)
 
 	fcport = qla2x00_find_fcport_by_nportid(vha, &ea->id, 1);
 	if (fcport) {
+		if (fcport->flags & FCF_FCP2_DEVICE) {
+			ql_dbg(ql_dbg_disc, vha, 0x2115,
+			       "Delaying session delete for FCP2 portid=%06x %8phC ",
+			       fcport->d_id.b24, fcport->port_name);
+			return;
+		}
 		fcport->scan_needed = 1;
 		fcport->rscn_gen++;
 	}
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 813abaf1b0872..30ce84468c759 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -3955,6 +3955,16 @@ qla2x00_mark_all_devices_lost(scsi_qla_host_t *vha)
 	    "Mark all dev lost\n");
 
 	list_for_each_entry(fcport, &vha->vp_fcports, list) {
+		if (fcport->loop_id != FC_NO_LOOP_ID &&
+		    (fcport->flags & FCF_FCP2_DEVICE) &&
+		    fcport->port_type == FCT_TARGET &&
+		    !qla2x00_reset_active(vha)) {
+			ql_dbg(ql_dbg_disc, vha, 0x211a,
+			       "Delaying session delete for FCP2 flags 0x%x port_type = 0x%x port_id=%06x %phC",
+			       fcport->flags, fcport->port_type,
+			       fcport->d_id.b24, fcport->port_name);
+			continue;
+		}
 		fcport->scan_state = 0;
 		qlt_schedule_sess_for_deletion(fcport);
 	}
-- 
2.33.0




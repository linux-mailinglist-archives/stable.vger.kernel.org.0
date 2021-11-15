Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 273DE451E39
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:32:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345871AbhKPAf2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:35:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:45394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344685AbhKOTZN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:25:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D8331636AF;
        Mon, 15 Nov 2021 19:02:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637002938;
        bh=ej/MA4MPDd4jxpYyt9snCcgmYX6W8mw1mi8o6yViScw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2qBQX2sk7o69aj575V64igBzBTWpn6pZ0HpBEdoWH0XcNpZIShYwLzVbOe0D1PmwP
         /Brn3KT1sKSL6hdrFMFcSKQV9U9ySnceZHZ8fWqvY9zYp4UaOVb8oHQN/xDgU/t+2G
         qb1xopuaOFNcNWWOdtBh/HfFGWC3RApqy1778PIE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Karunakara Merugu <kmerugu@marvell.com>,
        Quinn Tran <qutran@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 752/917] scsi: qla2xxx: edif: Flush stale events and msgs on session down
Date:   Mon, 15 Nov 2021 18:04:07 +0100
Message-Id: <20211115165454.414476973@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

[ Upstream commit b1af26c245545a289b331c7b71996ecd88321540 ]

On session down, driver will flush all stale messages and doorbell
events. This prevents authentication application from having to process
stale data.

Link: https://lore.kernel.org/r/20211026115412.27691-7-njavali@marvell.com
Fixes: 4de067e5df12 ("scsi: qla2xxx: edif: Add N2N support for EDIF")
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Co-developed-by: Karunakara Merugu <kmerugu@marvell.com>
Signed-off-by: Karunakara Merugu <kmerugu@marvell.com>
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_edif.c   | 96 ++++++++++++++++++++++++++++++-
 drivers/scsi/qla2xxx/qla_gbl.h    |  2 +
 drivers/scsi/qla2xxx/qla_target.c |  1 +
 3 files changed, 98 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_edif.c b/drivers/scsi/qla2xxx/qla_edif.c
index cf62f26ce27d9..3931bae3222b3 100644
--- a/drivers/scsi/qla2xxx/qla_edif.c
+++ b/drivers/scsi/qla2xxx/qla_edif.c
@@ -1593,6 +1593,40 @@ qla_enode_stop(scsi_qla_host_t *vha)
 	spin_unlock_irqrestore(&vha->pur_cinfo.pur_lock, flags);
 }
 
+static void qla_enode_clear(scsi_qla_host_t *vha, port_id_t portid)
+{
+	unsigned    long flags;
+	struct enode    *e, *tmp;
+	struct purexevent   *purex;
+	LIST_HEAD(enode_list);
+
+	if (vha->pur_cinfo.enode_flags != ENODE_ACTIVE) {
+		ql_dbg(ql_dbg_edif, vha, 0x09102,
+		       "%s enode not active\n", __func__);
+		return;
+	}
+	spin_lock_irqsave(&vha->pur_cinfo.pur_lock, flags);
+	list_for_each_entry_safe(e, tmp, &vha->pur_cinfo.head, list) {
+		purex = &e->u.purexinfo;
+		if (purex->pur_info.pur_sid.b24 == portid.b24) {
+			ql_dbg(ql_dbg_edif, vha, 0x911d,
+			    "%s free ELS sid=%06x. xchg %x, nb=%xh\n",
+			    __func__, portid.b24,
+			    purex->pur_info.pur_rx_xchg_address,
+			    purex->pur_info.pur_bytes_rcvd);
+
+			list_del_init(&e->list);
+			list_add_tail(&e->list, &enode_list);
+		}
+	}
+	spin_unlock_irqrestore(&vha->pur_cinfo.pur_lock, flags);
+
+	list_for_each_entry_safe(e, tmp, &enode_list, list) {
+		list_del_init(&e->list);
+		qla_enode_free(vha, e);
+	}
+}
+
 /*
  *  allocate enode struct and populate buffer
  *  returns: enode pointer with buffers
@@ -1792,6 +1826,57 @@ qla_edb_node_free(scsi_qla_host_t *vha, struct edb_node *node)
 	node->ntype = N_UNDEF;
 }
 
+static void qla_edb_clear(scsi_qla_host_t *vha, port_id_t portid)
+{
+	unsigned long flags;
+	struct edb_node *e, *tmp;
+	port_id_t sid;
+	LIST_HEAD(edb_list);
+
+	if (vha->e_dbell.db_flags != EDB_ACTIVE) {
+		/* doorbell list not enabled */
+		ql_dbg(ql_dbg_edif, vha, 0x09102,
+		       "%s doorbell not enabled\n", __func__);
+		return;
+	}
+
+	/* grab lock so list doesn't move */
+	spin_lock_irqsave(&vha->e_dbell.db_lock, flags);
+	list_for_each_entry_safe(e, tmp, &vha->e_dbell.head, list) {
+		switch (e->ntype) {
+		case VND_CMD_AUTH_STATE_NEEDED:
+		case VND_CMD_AUTH_STATE_SESSION_SHUTDOWN:
+			sid = e->u.plogi_did;
+			break;
+		case VND_CMD_AUTH_STATE_ELS_RCVD:
+			sid = e->u.els_sid;
+			break;
+		case VND_CMD_AUTH_STATE_SAUPDATE_COMPL:
+			/* app wants to see this  */
+			continue;
+		default:
+			ql_log(ql_log_warn, vha, 0x09102,
+			       "%s unknown node type: %x\n", __func__, e->ntype);
+			sid.b24 = 0;
+			break;
+		}
+		if (sid.b24 == portid.b24) {
+			ql_dbg(ql_dbg_edif, vha, 0x910f,
+			       "%s free doorbell event : node type = %x %p\n",
+			       __func__, e->ntype, e);
+			list_del_init(&e->list);
+			list_add_tail(&e->list, &edb_list);
+		}
+	}
+	spin_unlock_irqrestore(&vha->e_dbell.db_lock, flags);
+
+	list_for_each_entry_safe(e, tmp, &edb_list, list) {
+		qla_edb_node_free(vha, e);
+		list_del_init(&e->list);
+		kfree(e);
+	}
+}
+
 /* function called when app is stopping */
 
 void
@@ -2378,7 +2463,7 @@ void qla24xx_auth_els(scsi_qla_host_t *vha, void **pkt, struct rsp_que **rsp)
 	ql_dbg(ql_dbg_edif, host, 0x0910c,
 	    "%s COMPLETE purex->pur_info.pur_bytes_rcvd =%xh s:%06x -> d:%06x xchg=%xh\n",
 	    __func__, purex->pur_info.pur_bytes_rcvd, purex->pur_info.pur_sid.b24,
-	    purex->pur_info.pur_did.b24, p->rx_xchg_addr);
+	    purex->pur_info.pur_did.b24, purex->pur_info.pur_rx_xchg_address);
 
 	qla_edb_eventcreate(host, VND_CMD_AUTH_STATE_ELS_RCVD, sid, 0, NULL);
 }
@@ -3401,3 +3486,12 @@ void qla_edif_sess_down(struct scsi_qla_host *vha, struct fc_port *sess)
 		qla2x00_post_aen_work(vha, FCH_EVT_PORT_OFFLINE, sess->d_id.b24);
 	}
 }
+
+void qla_edif_clear_appdata(struct scsi_qla_host *vha, struct fc_port *fcport)
+{
+	if (!(fcport->flags & FCF_FCSP_DEVICE))
+		return;
+
+	qla_edb_clear(vha, fcport->d_id);
+	qla_enode_clear(vha, fcport->d_id);
+}
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index 0a43ce9317db2..2c7e91bffb827 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -142,6 +142,8 @@ void qlt_chk_edif_rx_sa_delete_pending(scsi_qla_host_t *vha, fc_port_t *fcport,
 void qla2x00_release_all_sadb(struct scsi_qla_host *vha, struct fc_port *fcport);
 int qla_edif_process_els(scsi_qla_host_t *vha, struct bsg_job *bsgjob);
 void qla_edif_sess_down(struct scsi_qla_host *vha, struct fc_port *sess);
+void qla_edif_clear_appdata(struct scsi_qla_host *vha,
+			    struct fc_port *fcport);
 const char *sc_to_str(uint16_t cmd);
 
 /*
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 7d8242c120fc7..1aaa4238cb722 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -1003,6 +1003,7 @@ void qlt_free_session_done(struct work_struct *work)
 					"%s bypassing release_all_sadb\n",
 					__func__);
 			}
+			qla_edif_clear_appdata(vha, sess);
 			qla_edif_sess_down(vha, sess);
 		}
 		qla2x00_mark_device_lost(vha, sess, 0);
-- 
2.33.0




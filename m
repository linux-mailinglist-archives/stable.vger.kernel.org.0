Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6F6F1AC852
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 17:07:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392454AbgDPPGw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 11:06:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:38208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2408796AbgDPNv6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:51:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7844A2063A;
        Thu, 16 Apr 2020 13:51:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587045116;
        bh=qzChlNWTWRaIgPiRyh59KMNyEZ1s89OWhDJKTLGaS4w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E4LDLXv/zq0QB6ZxzCCkNfDfhv9VNrpyEGApWQBVmtpc8apV9Bx3lAq7Xep2VsiDN
         FvX9fPY0Boc6EYyS9jwsG7RWUliGtMAGqBEshdsUaKlDv+Sup8o7RASmGfMZEVSRlT
         rfo/yzllUSKjxdeIPfSZjnIiDIKko2Lf8hCdy4Lc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dick Kennedy <dick.kennedy@broadcom.com>,
        James Smart <jsmart2021@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 223/232] scsi: lpfc: Fix Fabric hostname registration if system hostname changes
Date:   Thu, 16 Apr 2020 15:25:17 +0200
Message-Id: <20200416131343.419754731@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131316.640996080@linuxfoundation.org>
References: <20200416131316.640996080@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Smart <jsmart2021@gmail.com>

[ Upstream commit e3ba04c9bad1d1c7f15df43da25e878045150777 ]

There are reports of multiple ports on the same system displaying different
hostnames in fabric FDMI displays.

Currently, the driver registers the hostname at initialization and obtains
the hostname via init_utsname()->nodename queried at the time the FC link
comes up. Unfortunately, if the machine hostname is updated after
initialization, such as via DHCP or admin command, the value registered
initially will be incorrect.

Fix by having the driver save the hostname that was registered with FDMI.
The driver then runs a heartbeat action that will check the hostname.  If
the name changes, reregister the FMDI data.

The hostname is used in RSNN_NN, FDMI RPA and FDMI RHBA.

Link: https://lore.kernel.org/r/20191218235808.31922-5-jsmart2021@gmail.com
Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc.h         |  2 ++
 drivers/scsi/lpfc/lpfc_crtn.h    |  2 +-
 drivers/scsi/lpfc/lpfc_ct.c      | 48 ++++++++++++++++++++++++--------
 drivers/scsi/lpfc/lpfc_hbadisc.c |  5 ++++
 drivers/scsi/lpfc/lpfc_init.c    |  2 +-
 5 files changed, 46 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
index 84b0f0ac26e7e..e492ca2d0b8be 100644
--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -1216,6 +1216,8 @@ struct lpfc_hba {
 #define LPFC_POLL_HB	1		/* slowpath heartbeat */
 #define LPFC_POLL_FASTPATH	0	/* called from fastpath */
 #define LPFC_POLL_SLOWPATH	1	/* called from slowpath */
+
+	char os_host_name[MAXHOSTNAMELEN];
 };
 
 static inline struct Scsi_Host *
diff --git a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.h
index 9e477d766ce98..a03efe9ad2a42 100644
--- a/drivers/scsi/lpfc/lpfc_crtn.h
+++ b/drivers/scsi/lpfc/lpfc_crtn.h
@@ -180,7 +180,7 @@ int lpfc_issue_gidft(struct lpfc_vport *vport);
 int lpfc_get_gidft_type(struct lpfc_vport *vport, struct lpfc_iocbq *iocbq);
 int lpfc_ns_cmd(struct lpfc_vport *, int, uint8_t, uint32_t);
 int lpfc_fdmi_cmd(struct lpfc_vport *, struct lpfc_nodelist *, int, uint32_t);
-void lpfc_fdmi_num_disc_check(struct lpfc_vport *);
+void lpfc_fdmi_change_check(struct lpfc_vport *vport);
 void lpfc_delayed_disc_tmo(struct timer_list *);
 void lpfc_delayed_disc_timeout_handler(struct lpfc_vport *);
 
diff --git a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
index f81d1453eefbd..85f77c1ed23c8 100644
--- a/drivers/scsi/lpfc/lpfc_ct.c
+++ b/drivers/scsi/lpfc/lpfc_ct.c
@@ -1495,7 +1495,7 @@ lpfc_vport_symbolic_node_name(struct lpfc_vport *vport, char *symbol,
 	if (strlcat(symbol, tmp, size) >= size)
 		goto buffer_done;
 
-	scnprintf(tmp, sizeof(tmp), " HN:%s", init_utsname()->nodename);
+	scnprintf(tmp, sizeof(tmp), " HN:%s", vport->phba->os_host_name);
 	if (strlcat(symbol, tmp, size) >= size)
 		goto buffer_done;
 
@@ -1984,14 +1984,16 @@ lpfc_cmpl_ct_disc_fdmi(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 
 
 /**
- * lpfc_fdmi_num_disc_check - Check how many mapped NPorts we are connected to
+ * lpfc_fdmi_change_check - Check for changed FDMI parameters
  * @vport: pointer to a host virtual N_Port data structure.
  *
- * Called from hbeat timeout routine to check if the number of discovered
- * ports has changed. If so, re-register thar port Attribute.
+ * Check how many mapped NPorts we are connected to
+ * Check if our hostname changed
+ * Called from hbeat timeout routine to check if any FDMI parameters
+ * changed. If so, re-register those Attributes.
  */
 void
-lpfc_fdmi_num_disc_check(struct lpfc_vport *vport)
+lpfc_fdmi_change_check(struct lpfc_vport *vport)
 {
 	struct lpfc_hba *phba = vport->phba;
 	struct lpfc_nodelist *ndlp;
@@ -2004,17 +2006,41 @@ lpfc_fdmi_num_disc_check(struct lpfc_vport *vport)
 	if (!(vport->fc_flag & FC_FABRIC))
 		return;
 
+	ndlp = lpfc_findnode_did(vport, FDMI_DID);
+	if (!ndlp || !NLP_CHK_NODE_ACT(ndlp))
+		return;
+
+	/* Check if system hostname changed */
+	if (strcmp(phba->os_host_name, init_utsname()->nodename)) {
+		memset(phba->os_host_name, 0, sizeof(phba->os_host_name));
+		scnprintf(phba->os_host_name, sizeof(phba->os_host_name), "%s",
+			  init_utsname()->nodename);
+		lpfc_ns_cmd(vport, SLI_CTNS_RSNN_NN, 0, 0);
+
+		/* Since this effects multiple HBA and PORT attributes, we need
+		 * de-register and go thru the whole FDMI registration cycle.
+		 * DHBA -> DPRT -> RHBA -> RPA  (physical port)
+		 * DPRT -> RPRT (vports)
+		 */
+		if (vport->port_type == LPFC_PHYSICAL_PORT)
+			lpfc_fdmi_cmd(vport, ndlp, SLI_MGMT_DHBA, 0);
+		else
+			lpfc_fdmi_cmd(vport, ndlp, SLI_MGMT_DPRT, 0);
+
+		/* Since this code path registers all the port attributes
+		 * we can just return without further checking.
+		 */
+		return;
+	}
+
 	if (!(vport->fdmi_port_mask & LPFC_FDMI_PORT_ATTR_num_disc))
 		return;
 
+	/* Check if the number of mapped NPorts changed */
 	cnt = lpfc_find_map_node(vport);
 	if (cnt == vport->fdmi_num_disc)
 		return;
 
-	ndlp = lpfc_findnode_did(vport, FDMI_DID);
-	if (!ndlp || !NLP_CHK_NODE_ACT(ndlp))
-		return;
-
 	if (vport->port_type == LPFC_PHYSICAL_PORT) {
 		lpfc_fdmi_cmd(vport, ndlp, SLI_MGMT_RPA,
 			      LPFC_FDMI_PORT_ATTR_num_disc);
@@ -2602,8 +2628,8 @@ lpfc_fdmi_port_attr_host_name(struct lpfc_vport *vport,
 	ae = (struct lpfc_fdmi_attr_entry *)&ad->AttrValue;
 	memset(ae, 0, 256);
 
-	snprintf(ae->un.AttrString, sizeof(ae->un.AttrString), "%s",
-		 init_utsname()->nodename);
+	scnprintf(ae->un.AttrString, sizeof(ae->un.AttrString), "%s",
+		  vport->phba->os_host_name);
 
 	len = strnlen(ae->un.AttrString, sizeof(ae->un.AttrString));
 	len += (len & 3) ? (4 - (len & 3)) : 4;
diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index ee70d14e7a9dc..39ca541935342 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -28,6 +28,7 @@
 #include <linux/kthread.h>
 #include <linux/interrupt.h>
 #include <linux/lockdep.h>
+#include <linux/utsname.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_device.h>
@@ -3322,6 +3323,10 @@ lpfc_mbx_process_link_up(struct lpfc_hba *phba, struct lpfc_mbx_read_top *la)
 		lpfc_sli4_clear_fcf_rr_bmask(phba);
 	}
 
+	/* Prepare for LINK up registrations */
+	memset(phba->os_host_name, 0, sizeof(phba->os_host_name));
+	scnprintf(phba->os_host_name, sizeof(phba->os_host_name), "%s",
+		  init_utsname()->nodename);
 	return;
 out:
 	lpfc_vport_set_state(vport, FC_VPORT_FAILED);
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 1bf79445c15bf..14d9f41977f1c 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -1370,7 +1370,7 @@ lpfc_hb_timeout_handler(struct lpfc_hba *phba)
 	if (vports != NULL)
 		for (i = 0; i <= phba->max_vports && vports[i] != NULL; i++) {
 			lpfc_rcv_seq_check_edtov(vports[i]);
-			lpfc_fdmi_num_disc_check(vports[i]);
+			lpfc_fdmi_change_check(vports[i]);
 		}
 	lpfc_destroy_vport_work_array(phba, vports);
 
-- 
2.20.1




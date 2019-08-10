Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76EFC88E28
	for <lists+stable@lfdr.de>; Sat, 10 Aug 2019 22:52:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727362AbfHJUwO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Aug 2019 16:52:14 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54128 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726571AbfHJUnw (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Aug 2019 16:43:52 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwYDM-00053p-Pt; Sat, 10 Aug 2019 21:43:48 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwYDK-0003bX-2a; Sat, 10 Aug 2019 21:43:46 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Jens Remus" <jremus@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "Steffen Maier" <maier@linux.ibm.com>,
        "Benjamin Block" <bblock@linux.ibm.com>
Date:   Sat, 10 Aug 2019 21:40:07 +0100
Message-ID: <lsq.1565469607.332619319@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 051/157] scsi: zfcp: fix scsi_eh host reset with
 port_forced ERP for non-NPIV FCP devices
In-Reply-To: <lsq.1565469607.188083258@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.72-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Steffen Maier <maier@linux.ibm.com>

commit 242ec1455151267fe35a0834aa9038e4c4670884 upstream.

Suppose more than one non-NPIV FCP device is active on the same channel.
Send I/O to storage and have some of the pending I/O run into a SCSI
command timeout, e.g. due to bit errors on the fibre. Now the error
situation stops. However, we saw FCP requests continue to timeout in the
channel. The abort will be successful, but the subsequent TUR fails.
Scsi_eh starts. The LUN reset fails. The target reset fails.  The host
reset only did an FCP device recovery. However, for non-NPIV FCP devices,
this does not close and reopen ports on the SAN-side if other non-NPIV FCP
device(s) share the same open ports.

In order to resolve the continuing FCP request timeouts, we need to
explicitly close and reopen ports on the SAN-side.

This was missing since the beginning of zfcp in v2.6.0 history commit
ea127f975424 ("[PATCH] s390 (7/7): zfcp host adapter.").

Note: The FSF requests for forced port reopen could run into FSF request
timeouts due to other reasons. This would trigger an internal FCP device
recovery. Pending forced port reopen recoveries would get dismissed. So
some ports might not get fully reopened during this host reset handler.
However, subsequent I/O would trigger the above described escalation and
eventually all ports would be forced reopen to resolve any continuing FCP
request timeouts due to earlier bit errors.

Signed-off-by: Steffen Maier <maier@linux.ibm.com>
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reviewed-by: Jens Remus <jremus@linux.ibm.com>
Reviewed-by: Benjamin Block <bblock@linux.ibm.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/s390/scsi/zfcp_erp.c  | 14 ++++++++++++++
 drivers/s390/scsi/zfcp_ext.h  |  2 ++
 drivers/s390/scsi/zfcp_scsi.c |  4 ++++
 3 files changed, 20 insertions(+)

--- a/drivers/s390/scsi/zfcp_erp.c
+++ b/drivers/s390/scsi/zfcp_erp.c
@@ -652,6 +652,20 @@ static void zfcp_erp_strategy_memwait(st
 	add_timer(&erp_action->timer);
 }
 
+void zfcp_erp_port_forced_reopen_all(struct zfcp_adapter *adapter,
+				     int clear, char *dbftag)
+{
+	unsigned long flags;
+	struct zfcp_port *port;
+
+	write_lock_irqsave(&adapter->erp_lock, flags);
+	read_lock(&adapter->port_list_lock);
+	list_for_each_entry(port, &adapter->port_list, list)
+		_zfcp_erp_port_forced_reopen(port, clear, dbftag);
+	read_unlock(&adapter->port_list_lock);
+	write_unlock_irqrestore(&adapter->erp_lock, flags);
+}
+
 static void _zfcp_erp_port_reopen_all(struct zfcp_adapter *adapter,
 				      int clear, char *id)
 {
--- a/drivers/s390/scsi/zfcp_ext.h
+++ b/drivers/s390/scsi/zfcp_ext.h
@@ -68,6 +68,8 @@ extern void zfcp_erp_clear_port_status(s
 extern int  zfcp_erp_port_reopen(struct zfcp_port *, int, char *);
 extern void zfcp_erp_port_shutdown(struct zfcp_port *, int, char *);
 extern void zfcp_erp_port_forced_reopen(struct zfcp_port *, int, char *);
+extern void zfcp_erp_port_forced_reopen_all(struct zfcp_adapter *adapter,
+					    int clear, char *dbftag);
 extern void zfcp_erp_set_lun_status(struct scsi_device *, u32);
 extern void zfcp_erp_clear_lun_status(struct scsi_device *, u32);
 extern void zfcp_erp_lun_reopen(struct scsi_device *, int, char *);
--- a/drivers/s390/scsi/zfcp_scsi.c
+++ b/drivers/s390/scsi/zfcp_scsi.c
@@ -347,6 +347,10 @@ static int zfcp_scsi_eh_host_reset_handl
 	struct zfcp_adapter *adapter = zfcp_sdev->port->adapter;
 	int ret = SUCCESS, fc_ret;
 
+	if (!(adapter->connection_features & FSF_FEATURE_NPIV_MODE)) {
+		zfcp_erp_port_forced_reopen_all(adapter, 0, "schrh_p");
+		zfcp_erp_wait(adapter);
+	}
 	zfcp_erp_adapter_reopen(adapter, 0, "schrh_1");
 	zfcp_erp_wait(adapter);
 	fc_ret = fc_block_scsi_eh(scpnt);


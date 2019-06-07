Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD110390FF
	for <lists+stable@lfdr.de>; Fri,  7 Jun 2019 17:57:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730106AbfFGPoH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Jun 2019 11:44:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:55454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729787AbfFGPoG (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 7 Jun 2019 11:44:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 02FB221473;
        Fri,  7 Jun 2019 15:44:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559922245;
        bh=8ykz2MlrKkxdzIV+VRyTQrM0mmEzo471AC/ARqC5kqo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LwDkUOiCQL1/7pavf8B7jlrcztQlix4vU2kv+5azJdPDwqRt91eI8UBkqByacKoWT
         Vib9kjzAtGFOwINYWi3yKjSBpLVNTPDBYGJdTfCguD+vIPSKPRnmbPHv2m3vNQo/f4
         hrZYmNLSX+9sdF26q+0hUxDD+np7x2zy2XEmVvAU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Steffen Maier <maier@linux.ibm.com>,
        Benjamin Block <bblock@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 4.19 19/73] scsi: zfcp: fix to prevent port_remove with pure auto scan LUNs (only sdevs)
Date:   Fri,  7 Jun 2019 17:39:06 +0200
Message-Id: <20190607153851.066543765@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190607153848.669070800@linuxfoundation.org>
References: <20190607153848.669070800@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steffen Maier <maier@linux.ibm.com>

commit ef4021fe5fd77ced0323cede27979d80a56211ca upstream.

When the user tries to remove a zfcp port via sysfs, we only rejected it if
there are zfcp unit children under the port. With purely automatically
scanned LUNs there are no zfcp units but only SCSI devices. In such cases,
the port_remove erroneously continued. We close the port and this
implicitly closes all LUNs under the port. The SCSI devices survive with
their private zfcp_scsi_dev still holding a reference to the "removed"
zfcp_port (still allocated but invisible in sysfs) [zfcp_get_port_by_wwpn
in zfcp_scsi_slave_alloc]. This is not a problem as long as the fc_rport
stays blocked. Once (auto) port scan brings back the removed port, we
unblock its fc_rport again by design.  However, there is no mechanism that
would recover (open) the LUNs under the port (no "ersfs_3" without
zfcp_unit [zfcp_erp_strategy_followup_success]).  Any pending or new I/O to
such LUN leads to repeated:

  Done: NEEDS_RETRY Result: hostbyte=DID_IMM_RETRY driverbyte=DRIVER_OK

See also v4.10 commit 6f2ce1c6af37 ("scsi: zfcp: fix rport unblock race
with LUN recovery"). Even a manual LUN recovery
(echo 0 > /sys/bus/scsi/devices/H:C:T:L/zfcp_failed)
does not help, as the LUN links to the old "removed" port which remains
to lack ZFCP_STATUS_COMMON_RUNNING [zfcp_erp_required_act].
The only workaround is to first ensure that the fc_rport is blocked
(e.g. port_remove again in case it was re-discovered by (auto) port scan),
then delete the SCSI devices, and finally re-discover by (auto) port scan.
The port scan includes an fc_rport unblock, which in turn triggers
a new scan on the scsi target to freshly get new pure auto scan LUNs.

Fix this by rejecting port_remove also if there are SCSI devices
(even without any zfcp_unit) under this port. Re-use mechanics from v3.7
commit d99b601b6338 ("[SCSI] zfcp: restore refcount check on port_remove").
However, we have to give up zfcp_sysfs_port_units_mutex earlier in unit_add
to prevent a deadlock with scsi_host scan taking shost->scan_mutex first
and then zfcp_sysfs_port_units_mutex now in our zfcp_scsi_slave_alloc().

Signed-off-by: Steffen Maier <maier@linux.ibm.com>
Fixes: b62a8d9b45b9 ("[SCSI] zfcp: Use SCSI device data zfcp scsi dev instead of zfcp unit")
Fixes: f8210e34887e ("[SCSI] zfcp: Allow midlayer to scan for LUNs when running in NPIV mode")
Cc: <stable@vger.kernel.org> #2.6.37+
Reviewed-by: Benjamin Block <bblock@linux.ibm.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/s390/scsi/zfcp_ext.h   |    1 
 drivers/s390/scsi/zfcp_scsi.c  |    9 ++++++
 drivers/s390/scsi/zfcp_sysfs.c |   54 ++++++++++++++++++++++++++++++++++++-----
 drivers/s390/scsi/zfcp_unit.c  |    8 +++++-
 4 files changed, 65 insertions(+), 7 deletions(-)

--- a/drivers/s390/scsi/zfcp_ext.h
+++ b/drivers/s390/scsi/zfcp_ext.h
@@ -164,6 +164,7 @@ extern const struct attribute_group *zfc
 extern struct mutex zfcp_sysfs_port_units_mutex;
 extern struct device_attribute *zfcp_sysfs_sdev_attrs[];
 extern struct device_attribute *zfcp_sysfs_shost_attrs[];
+bool zfcp_sysfs_port_is_removing(const struct zfcp_port *const port);
 
 /* zfcp_unit.c */
 extern int zfcp_unit_add(struct zfcp_port *, u64);
--- a/drivers/s390/scsi/zfcp_scsi.c
+++ b/drivers/s390/scsi/zfcp_scsi.c
@@ -125,6 +125,15 @@ static int zfcp_scsi_slave_alloc(struct
 
 	zfcp_sdev->erp_action.port = port;
 
+	mutex_lock(&zfcp_sysfs_port_units_mutex);
+	if (zfcp_sysfs_port_is_removing(port)) {
+		/* port is already gone */
+		mutex_unlock(&zfcp_sysfs_port_units_mutex);
+		put_device(&port->dev); /* undo zfcp_get_port_by_wwpn() */
+		return -ENXIO;
+	}
+	mutex_unlock(&zfcp_sysfs_port_units_mutex);
+
 	unit = zfcp_unit_find(port, zfcp_scsi_dev_lun(sdev));
 	if (unit)
 		put_device(&unit->dev);
--- a/drivers/s390/scsi/zfcp_sysfs.c
+++ b/drivers/s390/scsi/zfcp_sysfs.c
@@ -235,6 +235,53 @@ static ZFCP_DEV_ATTR(adapter, port_resca
 
 DEFINE_MUTEX(zfcp_sysfs_port_units_mutex);
 
+static void zfcp_sysfs_port_set_removing(struct zfcp_port *const port)
+{
+	lockdep_assert_held(&zfcp_sysfs_port_units_mutex);
+	atomic_set(&port->units, -1);
+}
+
+bool zfcp_sysfs_port_is_removing(const struct zfcp_port *const port)
+{
+	lockdep_assert_held(&zfcp_sysfs_port_units_mutex);
+	return atomic_read(&port->units) == -1;
+}
+
+static bool zfcp_sysfs_port_in_use(struct zfcp_port *const port)
+{
+	struct zfcp_adapter *const adapter = port->adapter;
+	unsigned long flags;
+	struct scsi_device *sdev;
+	bool in_use = true;
+
+	mutex_lock(&zfcp_sysfs_port_units_mutex);
+	if (atomic_read(&port->units) > 0)
+		goto unlock_port_units_mutex; /* zfcp_unit(s) under port */
+
+	spin_lock_irqsave(adapter->scsi_host->host_lock, flags);
+	__shost_for_each_device(sdev, adapter->scsi_host) {
+		const struct zfcp_scsi_dev *zsdev = sdev_to_zfcp(sdev);
+
+		if (sdev->sdev_state == SDEV_DEL ||
+		    sdev->sdev_state == SDEV_CANCEL)
+			continue;
+		if (zsdev->port != port)
+			continue;
+		/* alive scsi_device under port of interest */
+		goto unlock_host_lock;
+	}
+
+	/* port is about to be removed, so no more unit_add or slave_alloc */
+	zfcp_sysfs_port_set_removing(port);
+	in_use = false;
+
+unlock_host_lock:
+	spin_unlock_irqrestore(adapter->scsi_host->host_lock, flags);
+unlock_port_units_mutex:
+	mutex_unlock(&zfcp_sysfs_port_units_mutex);
+	return in_use;
+}
+
 static ssize_t zfcp_sysfs_port_remove_store(struct device *dev,
 					    struct device_attribute *attr,
 					    const char *buf, size_t count)
@@ -257,16 +304,11 @@ static ssize_t zfcp_sysfs_port_remove_st
 	else
 		retval = 0;
 
-	mutex_lock(&zfcp_sysfs_port_units_mutex);
-	if (atomic_read(&port->units) > 0) {
+	if (zfcp_sysfs_port_in_use(port)) {
 		retval = -EBUSY;
-		mutex_unlock(&zfcp_sysfs_port_units_mutex);
 		put_device(&port->dev); /* undo zfcp_get_port_by_wwpn() */
 		goto out;
 	}
-	/* port is about to be removed, so no more unit_add */
-	atomic_set(&port->units, -1);
-	mutex_unlock(&zfcp_sysfs_port_units_mutex);
 
 	write_lock_irq(&adapter->port_list_lock);
 	list_del(&port->list);
--- a/drivers/s390/scsi/zfcp_unit.c
+++ b/drivers/s390/scsi/zfcp_unit.c
@@ -124,7 +124,7 @@ int zfcp_unit_add(struct zfcp_port *port
 	int retval = 0;
 
 	mutex_lock(&zfcp_sysfs_port_units_mutex);
-	if (atomic_read(&port->units) == -1) {
+	if (zfcp_sysfs_port_is_removing(port)) {
 		/* port is already gone */
 		retval = -ENODEV;
 		goto out;
@@ -168,8 +168,14 @@ int zfcp_unit_add(struct zfcp_port *port
 	write_lock_irq(&port->unit_list_lock);
 	list_add_tail(&unit->list, &port->unit_list);
 	write_unlock_irq(&port->unit_list_lock);
+	/*
+	 * lock order: shost->scan_mutex before zfcp_sysfs_port_units_mutex
+	 * due to      zfcp_unit_scsi_scan() => zfcp_scsi_slave_alloc()
+	 */
+	mutex_unlock(&zfcp_sysfs_port_units_mutex);
 
 	zfcp_unit_scsi_scan(unit);
+	return retval;
 
 out:
 	mutex_unlock(&zfcp_sysfs_port_units_mutex);



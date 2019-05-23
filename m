Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9EDD027E09
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 15:24:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730759AbfEWNYU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 09:24:20 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:43388 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730369AbfEWNYU (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 May 2019 09:24:20 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4ND33SZ129547
        for <stable@vger.kernel.org>; Thu, 23 May 2019 09:24:19 -0400
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2snu6e3pb3-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Thu, 23 May 2019 09:24:18 -0400
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <stable@vger.kernel.org> from <maier@linux.ibm.com>;
        Thu, 23 May 2019 14:24:16 +0100
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 23 May 2019 14:24:13 +0100
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x4NDOB2G36372480
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 May 2019 13:24:11 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7061C52051;
        Thu, 23 May 2019 13:24:11 +0000 (GMT)
Received: from oc4120165700.ibm.com (unknown [9.152.97.204])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTPS id 2B3B952050;
        Thu, 23 May 2019 13:24:11 +0000 (GMT)
From:   Steffen Maier <maier@linux.ibm.com>
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org,
        Benjamin Block <bblock@linux.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Steffen Maier <maier@linux.ibm.com>, <stable@vger.kernel.org>
Subject: [PATCH 2/2] zfcp: fix to prevent port_remove with pure auto scan LUNs (only sdevs)
Date:   Thu, 23 May 2019 15:23:46 +0200
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1558617826-30129-1-git-send-email-maier@linux.ibm.com>
References: <1558617826-30129-1-git-send-email-maier@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19052313-0012-0000-0000-0000031EB01A
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19052313-0013-0000-0000-000021576978
Message-Id: <1558617826-30129-3-git-send-email-maier@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-23_11:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905230092
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When the user tries to remove a zfcp port via sysfs, we only rejected it
if there are zfcp unit children under the port. With purely automatically
scanned LUNs there are no zfcp units but only SCSI devices. In such cases,
the port_remove erroneously continued. We close the port and this
implicitly closes all LUNs under the port. The SCSI devices survive
with their private zfcp_scsi_dev still holding a reference to the
"removed" zfcp_port (still allocated but invisible in sysfs)
[zfcp_get_port_by_wwpn in zfcp_scsi_slave_alloc]. This
is not a problem as long as the fc_rport stays blocked. Once (auto) port
scan brings back the removed port, we unblock its fc_rport again by design.
However, there is no mechanism that would recover (open) the LUNs under the
port (no "ersfs_3" without zfcp_unit [zfcp_erp_strategy_followup_success]).
Any pending or new I/O to such LUN leads to repeated:
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
---
 drivers/s390/scsi/zfcp_ext.h   |  1 +
 drivers/s390/scsi/zfcp_scsi.c  |  9 ++++++
 drivers/s390/scsi/zfcp_sysfs.c | 54 ++++++++++++++++++++++++++++++----
 drivers/s390/scsi/zfcp_unit.c  |  8 ++++-
 4 files changed, 65 insertions(+), 7 deletions(-)

diff --git a/drivers/s390/scsi/zfcp_ext.h b/drivers/s390/scsi/zfcp_ext.h
index c6acca521ffe..31e8a7240fd7 100644
--- a/drivers/s390/scsi/zfcp_ext.h
+++ b/drivers/s390/scsi/zfcp_ext.h
@@ -167,6 +167,7 @@ extern const struct attribute_group *zfcp_port_attr_groups[];
 extern struct mutex zfcp_sysfs_port_units_mutex;
 extern struct device_attribute *zfcp_sysfs_sdev_attrs[];
 extern struct device_attribute *zfcp_sysfs_shost_attrs[];
+bool zfcp_sysfs_port_is_removing(const struct zfcp_port *const port);
 
 /* zfcp_unit.c */
 extern int zfcp_unit_add(struct zfcp_port *, u64);
diff --git a/drivers/s390/scsi/zfcp_scsi.c b/drivers/s390/scsi/zfcp_scsi.c
index 221d0dfb8493..e9ded2befa0d 100644
--- a/drivers/s390/scsi/zfcp_scsi.c
+++ b/drivers/s390/scsi/zfcp_scsi.c
@@ -129,6 +129,15 @@ static int zfcp_scsi_slave_alloc(struct scsi_device *sdev)
 
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
diff --git a/drivers/s390/scsi/zfcp_sysfs.c b/drivers/s390/scsi/zfcp_sysfs.c
index 2d78732b270b..af197e2b3e69 100644
--- a/drivers/s390/scsi/zfcp_sysfs.c
+++ b/drivers/s390/scsi/zfcp_sysfs.c
@@ -235,6 +235,53 @@ static ZFCP_DEV_ATTR(adapter, port_rescan, S_IWUSR, NULL,
 
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
@@ -257,16 +304,11 @@ static ssize_t zfcp_sysfs_port_remove_store(struct device *dev,
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
diff --git a/drivers/s390/scsi/zfcp_unit.c b/drivers/s390/scsi/zfcp_unit.c
index 1bf0a0984a09..e67bf7388cae 100644
--- a/drivers/s390/scsi/zfcp_unit.c
+++ b/drivers/s390/scsi/zfcp_unit.c
@@ -124,7 +124,7 @@ int zfcp_unit_add(struct zfcp_port *port, u64 fcp_lun)
 	int retval = 0;
 
 	mutex_lock(&zfcp_sysfs_port_units_mutex);
-	if (atomic_read(&port->units) == -1) {
+	if (zfcp_sysfs_port_is_removing(port)) {
 		/* port is already gone */
 		retval = -ENODEV;
 		goto out;
@@ -168,8 +168,14 @@ int zfcp_unit_add(struct zfcp_port *port, u64 fcp_lun)
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
-- 
2.17.1


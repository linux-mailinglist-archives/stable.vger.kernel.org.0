Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D27823D1CA
	for <lists+stable@lfdr.de>; Wed,  5 Aug 2020 22:06:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729485AbgHEUGZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Aug 2020 16:06:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:50308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726933AbgHEQeo (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 Aug 2020 12:34:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 73D7F233EB;
        Wed,  5 Aug 2020 15:53:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596642809;
        bh=HrvJqWxAxGdusoTYSWh08BbdfEKW1Pjx1faih+n9pW4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TpMvmrbxLiRWM3ILp9a4WR9aDcgY+e+l7LNkxHEpjdSaET70g41H/x0yDNcmLfJYb
         1GpEZ8Opct3Zi2b0WKDGbvbMbN5BnAO550Gbovb55cHr/kooeQCCQFhWJAxsuSPO2i
         qbNmpMBWC0xA1iwAah3wBThOvLA4GhPbLlYb6n8o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jason Yan <yanaijie@huawei.com>,
        John Garry <john.garry@huawei.com>,
        Johannes Thumshirn <jthumshirn@suse.de>,
        Ewan Milne <emilne@redhat.com>, Christoph Hellwig <hch@lst.de>,
        Tomas Henzl <thenzl@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Hannes Reinecke <hare@suse.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 1/8] Revert "scsi: libsas: direct call probe and destruct"
Date:   Wed,  5 Aug 2020 17:53:27 +0200
Message-Id: <20200805153507.066432283@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200805153507.005753845@linuxfoundation.org>
References: <20200805153507.005753845@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts commit 3a156abd24346a3188eb7e88cf86386a409e0d02 which is
commit 0558f33c06bb910e2879e355192227a8e8f0219d upstream.

John writes:
	This patch was one of a series from Jason to fix this WARN issue, below:

	https://lore.kernel.org/linux-scsi/8f6e3763-2b04-23e8-f1ec-8ed3c58f55d3@huawei.com/

	I'm doubtful that it should be taken in isolation. Maybe 1 or 2 other
	patches are required.

	The WARN was really annoying, so we could spend a bit of time to test a
	backport of what is strictly required. Let us know.

Cc: Jason Yan <yanaijie@huawei.com>
CC: John Garry <john.garry@huawei.com>
CC: Johannes Thumshirn <jthumshirn@suse.de>
CC: Ewan Milne <emilne@redhat.com>
CC: Christoph Hellwig <hch@lst.de>
CC: Tomas Henzl <thenzl@redhat.com>
CC: Dan Williams <dan.j.williams@intel.com>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/libsas/sas_ata.c      |    1 +
 drivers/scsi/libsas/sas_discover.c |   32 ++++++++++++++------------------
 drivers/scsi/libsas/sas_expander.c |    8 +++++---
 drivers/scsi/libsas/sas_internal.h |    1 -
 drivers/scsi/libsas/sas_port.c     |    3 ---
 include/scsi/libsas.h              |    3 ++-
 include/scsi/scsi_transport_sas.h  |    1 -
 7 files changed, 22 insertions(+), 27 deletions(-)

--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -730,6 +730,7 @@ int sas_discover_sata(struct domain_devi
 	if (res)
 		return res;
 
+	sas_discover_event(dev->port, DISCE_PROBE);
 	return 0;
 }
 
--- a/drivers/scsi/libsas/sas_discover.c
+++ b/drivers/scsi/libsas/sas_discover.c
@@ -221,9 +221,13 @@ void sas_notify_lldd_dev_gone(struct dom
 	}
 }
 
-static void sas_probe_devices(struct asd_sas_port *port)
+static void sas_probe_devices(struct work_struct *work)
 {
 	struct domain_device *dev, *n;
+	struct sas_discovery_event *ev = to_sas_discovery_event(work);
+	struct asd_sas_port *port = ev->port;
+
+	clear_bit(DISCE_PROBE, &port->disc.pending);
 
 	/* devices must be domain members before link recovery and probe */
 	list_for_each_entry(dev, &port->disco_list, disco_list_node) {
@@ -299,6 +303,7 @@ int sas_discover_end_dev(struct domain_d
 	res = sas_notify_lldd_dev_found(dev);
 	if (res)
 		return res;
+	sas_discover_event(dev->port, DISCE_PROBE);
 
 	return 0;
 }
@@ -357,9 +362,13 @@ static void sas_unregister_common_dev(st
 	sas_put_device(dev);
 }
 
-void sas_destruct_devices(struct asd_sas_port *port)
+static void sas_destruct_devices(struct work_struct *work)
 {
 	struct domain_device *dev, *n;
+	struct sas_discovery_event *ev = to_sas_discovery_event(work);
+	struct asd_sas_port *port = ev->port;
+
+	clear_bit(DISCE_DESTRUCT, &port->disc.pending);
 
 	list_for_each_entry_safe(dev, n, &port->destroy_list, disco_list_node) {
 		list_del_init(&dev->disco_list_node);
@@ -370,16 +379,6 @@ void sas_destruct_devices(struct asd_sas
 	}
 }
 
-static void sas_destruct_ports(struct asd_sas_port *port)
-{
-	struct sas_port *sas_port, *p;
-
-	list_for_each_entry_safe(sas_port, p, &port->sas_port_del_list, del_list) {
-		list_del_init(&sas_port->del_list);
-		sas_port_delete(sas_port);
-	}
-}
-
 void sas_unregister_dev(struct asd_sas_port *port, struct domain_device *dev)
 {
 	if (!test_bit(SAS_DEV_DESTROY, &dev->state) &&
@@ -394,6 +393,7 @@ void sas_unregister_dev(struct asd_sas_p
 	if (!test_and_set_bit(SAS_DEV_DESTROY, &dev->state)) {
 		sas_rphy_unlink(dev->rphy);
 		list_move_tail(&dev->disco_list_node, &port->destroy_list);
+		sas_discover_event(dev->port, DISCE_DESTRUCT);
 	}
 }
 
@@ -499,8 +499,6 @@ static void sas_discover_domain(struct w
 		port->port_dev = NULL;
 	}
 
-	sas_probe_devices(port);
-
 	SAS_DPRINTK("DONE DISCOVERY on port %d, pid:%d, result:%d\n", port->id,
 		    task_pid_nr(current), error);
 }
@@ -534,10 +532,6 @@ static void sas_revalidate_domain(struct
 		    port->id, task_pid_nr(current), res);
  out:
 	mutex_unlock(&ha->disco_mutex);
-
-	sas_destruct_devices(port);
-	sas_destruct_ports(port);
-	sas_probe_devices(port);
 }
 
 /* ---------- Events ---------- */
@@ -593,8 +587,10 @@ void sas_init_disc(struct sas_discovery
 	static const work_func_t sas_event_fns[DISC_NUM_EVENTS] = {
 		[DISCE_DISCOVER_DOMAIN] = sas_discover_domain,
 		[DISCE_REVALIDATE_DOMAIN] = sas_revalidate_domain,
+		[DISCE_PROBE] = sas_probe_devices,
 		[DISCE_SUSPEND] = sas_suspend_devices,
 		[DISCE_RESUME] = sas_resume_devices,
+		[DISCE_DESTRUCT] = sas_destruct_devices,
 	};
 
 	disc->pending = 0;
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -1946,8 +1946,7 @@ static void sas_unregister_devs_sas_addr
 		sas_port_delete_phy(phy->port, phy->phy);
 		sas_device_set_phy(found, phy->port);
 		if (phy->port->num_phys == 0)
-			list_add_tail(&phy->port->del_list,
-				&parent->port->sas_port_del_list);
+			sas_port_delete(phy->port);
 		phy->port = NULL;
 	}
 }
@@ -2157,7 +2156,7 @@ int sas_ex_revalidate_domain(struct doma
 	struct domain_device *dev = NULL;
 
 	res = sas_find_bcast_dev(port_dev, &dev);
-	if (res == 0 && dev) {
+	while (res == 0 && dev) {
 		struct expander_device *ex = &dev->ex_dev;
 		int i = 0, phy_id;
 
@@ -2169,6 +2168,9 @@ int sas_ex_revalidate_domain(struct doma
 			res = sas_rediscover(dev, phy_id);
 			i = phy_id + 1;
 		} while (i < ex->num_phys);
+
+		dev = NULL;
+		res = sas_find_bcast_dev(port_dev, &dev);
 	}
 	return res;
 }
--- a/drivers/scsi/libsas/sas_internal.h
+++ b/drivers/scsi/libsas/sas_internal.h
@@ -98,7 +98,6 @@ int sas_try_ata_reset(struct asd_sas_phy
 void sas_hae_reset(struct work_struct *work);
 
 void sas_free_device(struct kref *kref);
-void sas_destruct_devices(struct asd_sas_port *port);
 
 #ifdef CONFIG_SCSI_SAS_HOST_SMP
 extern void sas_smp_host_handler(struct bsg_job *job, struct Scsi_Host *shost);
--- a/drivers/scsi/libsas/sas_port.c
+++ b/drivers/scsi/libsas/sas_port.c
@@ -66,7 +66,6 @@ static void sas_resume_port(struct asd_s
 		rc = sas_notify_lldd_dev_found(dev);
 		if (rc) {
 			sas_unregister_dev(port, dev);
-			sas_destruct_devices(port);
 			continue;
 		}
 
@@ -220,7 +219,6 @@ void sas_deform_port(struct asd_sas_phy
 
 	if (port->num_phys == 1) {
 		sas_unregister_domain_devices(port, gone);
-		sas_destruct_devices(port);
 		sas_port_delete(port->port);
 		port->port = NULL;
 	} else {
@@ -325,7 +323,6 @@ static void sas_init_port(struct asd_sas
 	INIT_LIST_HEAD(&port->dev_list);
 	INIT_LIST_HEAD(&port->disco_list);
 	INIT_LIST_HEAD(&port->destroy_list);
-	INIT_LIST_HEAD(&port->sas_port_del_list);
 	spin_lock_init(&port->phy_list_lock);
 	INIT_LIST_HEAD(&port->phy_list);
 	port->ha = sas_ha;
--- a/include/scsi/libsas.h
+++ b/include/scsi/libsas.h
@@ -87,8 +87,10 @@ enum discover_event {
 	DISCE_DISCOVER_DOMAIN   = 0U,
 	DISCE_REVALIDATE_DOMAIN = 1,
 	DISCE_PORT_GONE         = 2,
+	DISCE_PROBE		= 3,
 	DISCE_SUSPEND		= 4,
 	DISCE_RESUME		= 5,
+	DISCE_DESTRUCT		= 6,
 	DISC_NUM_EVENTS		= 7,
 };
 
@@ -267,7 +269,6 @@ struct asd_sas_port {
 	struct list_head dev_list;
 	struct list_head disco_list;
 	struct list_head destroy_list;
-	struct list_head sas_port_del_list;
 	enum   sas_linkrate linkrate;
 
 	struct sas_work work;
--- a/include/scsi/scsi_transport_sas.h
+++ b/include/scsi/scsi_transport_sas.h
@@ -156,7 +156,6 @@ struct sas_port {
 
 	struct mutex		phy_list_mutex;
 	struct list_head	phy_list;
-	struct list_head	del_list; /* libsas only */
 };
 
 #define dev_to_sas_port(d) \



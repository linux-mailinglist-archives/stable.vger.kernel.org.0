Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84DC4329003
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:02:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236462AbhCAUBc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:01:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:58656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241913AbhCATuN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:50:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 30DF7650E1;
        Mon,  1 Mar 2021 17:51:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621112;
        bh=C8c5zcSUPzdQrUJFV1wFm4nxawsrGHzoZUZnI4maXos=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jQwI+oh1yJ/tJApL1LMFnOyOUdjAK8utOKtpP7vjFCKLDf/wZYdth+d/kpiH4+3Cq
         iesP5OxNrANzpV5fHeFO5msHySNvkFQAVlT92k7Av0szDLoGPUcP6LKPdatJxgug7h
         8vH6fwJn34gX+4QKtiB04W8cLYK81R8x3A08bMF8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jason Yan <yanaijie@huawei.com>,
        John Garry <john.garry@huawei.com>,
        "Ahmed S. Darwish" <a.darwish@linutronix.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 368/775] scsi: libsas: Introduce a _gfp() variant of event notifiers
Date:   Mon,  1 Mar 2021 17:08:56 +0100
Message-Id: <20210301161219.792278345@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ahmed S. Darwish <a.darwish@linutronix.de>

[ Upstream commit c2d0f1a65ab9fbabebb463bf36f50ea8f4633386 ]

sas_alloc_event() uses in_interrupt() to decide which allocation should be
used.

The usage of in_interrupt() in drivers is phased out and Linus clearly
requested that code which changes behaviour depending on context should
either be separated or the context be conveyed in an argument passed by the
caller, which usually knows the context.

The in_interrupt() check is also only partially correct, because it fails
to choose the correct code path when just preemption or interrupts are
disabled. For example, as in the following call chain:

  mvsas/mv_sas.c: mvs_work_queue() [process context]
  spin_lock_irqsave(mvs_info::lock, )
    -> libsas/sas_event.c: sas_notify_phy_event()
      -> sas_alloc_event()
        -> in_interrupt() = false
          -> invalid GFP_KERNEL allocation
    -> libsas/sas_event.c: sas_notify_port_event()
      -> sas_alloc_event()
        -> in_interrupt() = false
          -> invalid GFP_KERNEL allocation

Introduce sas_alloc_event_gfp(), sas_notify_port_event_gfp(), and
sas_notify_phy_event_gfp(), which all behave like the non _gfp() variants
but use a caller-passed GFP mask for allocations.

For bisectability, all callers will be modified first to pass GFP context,
then the non _gfp() libsas API variants will be modified to take a gfp_t by
default.

Link: https://lore.kernel.org/r/20210118100955.1761652-4-a.darwish@linutronix.de
Fixes: 1c393b970e0f ("scsi: libsas: Use dynamic alloced work to avoid sas event lost")
Cc: Jason Yan <yanaijie@huawei.com>
Reviewed-by: John Garry <john.garry@huawei.com>
Signed-off-by: Ahmed S. Darwish <a.darwish@linutronix.de>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/scsi/libsas.rst      |  2 +
 drivers/scsi/libsas/sas_event.c    | 65 ++++++++++++++++++++++++------
 drivers/scsi/libsas/sas_init.c     | 21 +++++++---
 drivers/scsi/libsas/sas_internal.h |  4 ++
 include/scsi/libsas.h              |  4 ++
 5 files changed, 79 insertions(+), 17 deletions(-)

diff --git a/Documentation/scsi/libsas.rst b/Documentation/scsi/libsas.rst
index 210df1aba1409..de422253b0ab7 100644
--- a/Documentation/scsi/libsas.rst
+++ b/Documentation/scsi/libsas.rst
@@ -192,6 +192,8 @@ The event interface::
 	void (*notify_ha_event)(struct sas_ha_struct *, enum ha_event);
 	void sas_notify_port_event(struct sas_phy *, enum port_event);
 	void sas_notify_phy_event(struct sas_phy *, enum phy_event);
+	void sas_notify_port_event_gfp(struct sas_phy *, enum port_event, gfp_t);
+	void sas_notify_phy_event_gfp(struct sas_phy *, enum phy_event, gfp_t);
 
 The port notification::
 
diff --git a/drivers/scsi/libsas/sas_event.c b/drivers/scsi/libsas/sas_event.c
index 112a1b76f63b1..ba266a17250ae 100644
--- a/drivers/scsi/libsas/sas_event.c
+++ b/drivers/scsi/libsas/sas_event.c
@@ -131,18 +131,15 @@ static void sas_phy_event_worker(struct work_struct *work)
 	sas_free_event(ev);
 }
 
-int sas_notify_port_event(struct asd_sas_phy *phy, enum port_event event)
+static int __sas_notify_port_event(struct asd_sas_phy *phy,
+				   enum port_event event,
+				   struct asd_sas_event *ev)
 {
-	struct asd_sas_event *ev;
 	struct sas_ha_struct *ha = phy->ha;
 	int ret;
 
 	BUG_ON(event >= PORT_NUM_EVENTS);
 
-	ev = sas_alloc_event(phy);
-	if (!ev)
-		return -ENOMEM;
-
 	INIT_SAS_EVENT(ev, sas_port_event_worker, phy, event);
 
 	ret = sas_queue_event(event, &ev->work, ha);
@@ -151,20 +148,41 @@ int sas_notify_port_event(struct asd_sas_phy *phy, enum port_event event)
 
 	return ret;
 }
-EXPORT_SYMBOL_GPL(sas_notify_port_event);
 
-int sas_notify_phy_event(struct asd_sas_phy *phy, enum phy_event event)
+int sas_notify_port_event_gfp(struct asd_sas_phy *phy, enum port_event event,
+			      gfp_t gfp_flags)
 {
 	struct asd_sas_event *ev;
-	struct sas_ha_struct *ha = phy->ha;
-	int ret;
 
-	BUG_ON(event >= PHY_NUM_EVENTS);
+	ev = sas_alloc_event_gfp(phy, gfp_flags);
+	if (!ev)
+		return -ENOMEM;
+
+	return __sas_notify_port_event(phy, event, ev);
+}
+EXPORT_SYMBOL_GPL(sas_notify_port_event_gfp);
+
+int sas_notify_port_event(struct asd_sas_phy *phy, enum port_event event)
+{
+	struct asd_sas_event *ev;
 
 	ev = sas_alloc_event(phy);
 	if (!ev)
 		return -ENOMEM;
 
+	return __sas_notify_port_event(phy, event, ev);
+}
+EXPORT_SYMBOL_GPL(sas_notify_port_event);
+
+static inline int __sas_notify_phy_event(struct asd_sas_phy *phy,
+					 enum phy_event event,
+					 struct asd_sas_event *ev)
+{
+	struct sas_ha_struct *ha = phy->ha;
+	int ret;
+
+	BUG_ON(event >= PHY_NUM_EVENTS);
+
 	INIT_SAS_EVENT(ev, sas_phy_event_worker, phy, event);
 
 	ret = sas_queue_event(event, &ev->work, ha);
@@ -173,5 +191,28 @@ int sas_notify_phy_event(struct asd_sas_phy *phy, enum phy_event event)
 
 	return ret;
 }
-EXPORT_SYMBOL_GPL(sas_notify_phy_event);
 
+int sas_notify_phy_event_gfp(struct asd_sas_phy *phy, enum phy_event event,
+			     gfp_t gfp_flags)
+{
+	struct asd_sas_event *ev;
+
+	ev = sas_alloc_event_gfp(phy, gfp_flags);
+	if (!ev)
+		return -ENOMEM;
+
+	return __sas_notify_phy_event(phy, event, ev);
+}
+EXPORT_SYMBOL_GPL(sas_notify_phy_event_gfp);
+
+int sas_notify_phy_event(struct asd_sas_phy *phy, enum phy_event event)
+{
+	struct asd_sas_event *ev;
+
+	ev = sas_alloc_event(phy);
+	if (!ev)
+		return -ENOMEM;
+
+	return __sas_notify_phy_event(phy, event, ev);
+}
+EXPORT_SYMBOL_GPL(sas_notify_phy_event);
diff --git a/drivers/scsi/libsas/sas_init.c b/drivers/scsi/libsas/sas_init.c
index 6dc2505d36af7..f8ae1f0f17d36 100644
--- a/drivers/scsi/libsas/sas_init.c
+++ b/drivers/scsi/libsas/sas_init.c
@@ -584,16 +584,15 @@ sas_domain_attach_transport(struct sas_domain_function_template *dft)
 }
 EXPORT_SYMBOL_GPL(sas_domain_attach_transport);
 
-
-struct asd_sas_event *sas_alloc_event(struct asd_sas_phy *phy)
+static struct asd_sas_event *__sas_alloc_event(struct asd_sas_phy *phy,
+					       gfp_t gfp_flags)
 {
 	struct asd_sas_event *event;
-	gfp_t flags = in_interrupt() ? GFP_ATOMIC : GFP_KERNEL;
 	struct sas_ha_struct *sas_ha = phy->ha;
 	struct sas_internal *i =
 		to_sas_internal(sas_ha->core.shost->transportt);
 
-	event = kmem_cache_zalloc(sas_event_cache, flags);
+	event = kmem_cache_zalloc(sas_event_cache, gfp_flags);
 	if (!event)
 		return NULL;
 
@@ -604,7 +603,8 @@ struct asd_sas_event *sas_alloc_event(struct asd_sas_phy *phy)
 			if (cmpxchg(&phy->in_shutdown, 0, 1) == 0) {
 				pr_notice("The phy%d bursting events, shut it down.\n",
 					  phy->id);
-				sas_notify_phy_event(phy, PHYE_SHUTDOWN);
+				sas_notify_phy_event_gfp(phy, PHYE_SHUTDOWN,
+							 gfp_flags);
 			}
 		} else {
 			/* Do not support PHY control, stop allocating events */
@@ -618,6 +618,17 @@ struct asd_sas_event *sas_alloc_event(struct asd_sas_phy *phy)
 	return event;
 }
 
+struct asd_sas_event *sas_alloc_event(struct asd_sas_phy *phy)
+{
+	return __sas_alloc_event(phy, in_interrupt() ? GFP_ATOMIC : GFP_KERNEL);
+}
+
+struct asd_sas_event *sas_alloc_event_gfp(struct asd_sas_phy *phy,
+					  gfp_t gfp_flags)
+{
+	return __sas_alloc_event(phy, gfp_flags);
+}
+
 void sas_free_event(struct asd_sas_event *event)
 {
 	struct asd_sas_phy *phy = event->phy;
diff --git a/drivers/scsi/libsas/sas_internal.h b/drivers/scsi/libsas/sas_internal.h
index 53ea32ed17a75..52e09c3e2b50d 100644
--- a/drivers/scsi/libsas/sas_internal.h
+++ b/drivers/scsi/libsas/sas_internal.h
@@ -49,6 +49,8 @@ int  sas_register_phys(struct sas_ha_struct *sas_ha);
 void sas_unregister_phys(struct sas_ha_struct *sas_ha);
 
 struct asd_sas_event *sas_alloc_event(struct asd_sas_phy *phy);
+struct asd_sas_event *sas_alloc_event_gfp(struct asd_sas_phy *phy,
+					  gfp_t gfp_flags);
 void sas_free_event(struct asd_sas_event *event);
 
 int  sas_register_ports(struct sas_ha_struct *sas_ha);
@@ -77,6 +79,8 @@ int sas_smp_phy_control(struct domain_device *dev, int phy_id,
 int sas_smp_get_phy_events(struct sas_phy *phy);
 
 int sas_notify_phy_event(struct asd_sas_phy *phy, enum phy_event event);
+int sas_notify_phy_event_gfp(struct asd_sas_phy *phy, enum phy_event event,
+			     gfp_t flags);
 void sas_device_set_phy(struct domain_device *dev, struct sas_port *port);
 struct domain_device *sas_find_dev_by_rphy(struct sas_rphy *rphy);
 struct domain_device *sas_ex_to_ata(struct domain_device *ex_dev, int phy_id);
diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
index 3387149502e9a..e6a43163ab5b7 100644
--- a/include/scsi/libsas.h
+++ b/include/scsi/libsas.h
@@ -704,5 +704,9 @@ int sas_request_addr(struct Scsi_Host *shost, u8 *addr);
 
 int sas_notify_port_event(struct asd_sas_phy *phy, enum port_event event);
 int sas_notify_phy_event(struct asd_sas_phy *phy, enum phy_event event);
+int sas_notify_port_event_gfp(struct asd_sas_phy *phy, enum port_event event,
+			      gfp_t gfp_flags);
+int sas_notify_phy_event_gfp(struct asd_sas_phy *phy, enum phy_event event,
+			     gfp_t gfp_flags);
 
 #endif /* _SASLIB_H_ */
-- 
2.27.0




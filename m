Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BD0C2EA970
	for <lists+stable@lfdr.de>; Tue,  5 Jan 2021 12:05:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728910AbhAELDX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jan 2021 06:03:23 -0500
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:55036 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728949AbhAELDW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jan 2021 06:03:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1609844602; x=1641380602;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=O61ZE/PJc6nheyfqzICN+CeRDKKbfl9Sk7tiU21kq88=;
  b=l1mao2wX2a8eguugSg/I5jyauGx+A3bI7UP5eJAoRXQSHA8W8vAzvNVy
   O0WFTKLzTL4uLDi6LkQLsTIQFvjjMJmxhBzKpv1ZYXA0WIsCe7Fpxp8p0
   t2o7IbQK6xO86rveZf0GCiENPOYhVoyo7A041S0O/Bo2h1R42mNjHsrc7
   M=;
X-IronPort-AV: E=Sophos;i="5.78,476,1599523200"; 
   d="scan'208";a="76884273"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-2b-a7fdc47a.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-6001.iad6.amazon.com with ESMTP; 05 Jan 2021 11:02:34 +0000
Received: from EX13D31EUA001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2b-a7fdc47a.us-west-2.amazon.com (Postfix) with ESMTPS id 57D65C06C1;
        Tue,  5 Jan 2021 11:02:33 +0000 (UTC)
Received: from u3f2cd687b01c55.ant.amazon.com (10.43.162.94) by
 EX13D31EUA001.ant.amazon.com (10.43.165.15) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 5 Jan 2021 11:02:12 +0000
From:   SeongJae Park <sjpark@amazon.com>
To:     <stable@vger.kernel.org>
CC:     SeongJae Park <sjpark@amazon.de>, <doebel@amazon.de>,
        <aams@amazon.de>, <mku@amazon.de>, <jgross@suse.com>,
        <julien@xen.org>, <wipawel@amazon.de>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/5] xen/xenbus: Add 'will_handle' callback support in xenbus_watch_path()
Date:   Tue, 5 Jan 2021 12:01:39 +0100
Message-ID: <20210105110142.1810-3-sjpark@amazon.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210105110142.1810-1-sjpark@amazon.com>
References: <20210105110142.1810-1-sjpark@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.162.94]
X-ClientProxiedBy: EX13D45UWA001.ant.amazon.com (10.43.160.91) To
 EX13D31EUA001.ant.amazon.com (10.43.165.15)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: SeongJae Park <sjpark@amazon.de>

Some code does not directly make 'xenbus_watch' object and call
'register_xenbus_watch()' but use 'xenbus_watch_path()' instead.  This
commit adds support of 'will_handle' callback in the
'xenbus_watch_path()' and it's wrapper, 'xenbus_watch_pathfmt()'.

This is part of XSA-349

This is upstream commit 2e85d32b1c865bec703ce0c962221a5e955c52c2

Cc: stable@vger.kernel.org
Signed-off-by: SeongJae Park <sjpark@amazon.de>
Reported-by: Michael Kurth <mku@amazon.de>
Reported-by: Pawel Wieczorkiewicz <wipawel@amazon.de>
Reviewed-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
---
 drivers/block/xen-blkback/xenbus.c | 3 ++-
 drivers/net/xen-netback/xenbus.c   | 2 +-
 drivers/xen/xen-pciback/xenbus.c   | 2 +-
 drivers/xen/xenbus/xenbus_client.c | 9 +++++++--
 drivers/xen/xenbus/xenbus_probe.c  | 2 +-
 include/xen/xenbus.h               | 6 +++++-
 6 files changed, 17 insertions(+), 7 deletions(-)

diff --git a/drivers/block/xen-blkback/xenbus.c b/drivers/block/xen-blkback/xenbus.c
index 9a4ac6fd262a..27c9d7a5b4de 100644
--- a/drivers/block/xen-blkback/xenbus.c
+++ b/drivers/block/xen-blkback/xenbus.c
@@ -646,7 +646,8 @@ static int xen_blkbk_probe(struct xenbus_device *dev,
 	/* setup back pointer */
 	be->blkif->be = be;
 
-	err = xenbus_watch_pathfmt(dev, &be->backend_watch, backend_changed,
+	err = xenbus_watch_pathfmt(dev, &be->backend_watch, NULL,
+				   backend_changed,
 				   "%s/%s", dev->nodename, "physical-device");
 	if (err)
 		goto fail;
diff --git a/drivers/net/xen-netback/xenbus.c b/drivers/net/xen-netback/xenbus.c
index 5cb9dbf62816..78788402edd8 100644
--- a/drivers/net/xen-netback/xenbus.c
+++ b/drivers/net/xen-netback/xenbus.c
@@ -1040,7 +1040,7 @@ static void connect(struct backend_info *be)
 	xenvif_carrier_on(be->vif);
 
 	unregister_hotplug_status_watch(be);
-	err = xenbus_watch_pathfmt(dev, &be->hotplug_status_watch,
+	err = xenbus_watch_pathfmt(dev, &be->hotplug_status_watch, NULL,
 				   hotplug_status_changed,
 				   "%s/%s", dev->nodename, "hotplug-status");
 	if (!err)
diff --git a/drivers/xen/xen-pciback/xenbus.c b/drivers/xen/xen-pciback/xenbus.c
index f33eb40cb414..36ec99cff507 100644
--- a/drivers/xen/xen-pciback/xenbus.c
+++ b/drivers/xen/xen-pciback/xenbus.c
@@ -689,7 +689,7 @@ static int xen_pcibk_xenbus_probe(struct xenbus_device *dev,
 
 	/* watch the backend node for backend configuration information */
 	err = xenbus_watch_path(dev, dev->nodename, &pdev->be_watch,
-				xen_pcibk_be_watch);
+				NULL, xen_pcibk_be_watch);
 	if (err)
 		goto out;
 
diff --git a/drivers/xen/xenbus/xenbus_client.c b/drivers/xen/xenbus/xenbus_client.c
index d02d25f784c9..8bbd887ca422 100644
--- a/drivers/xen/xenbus/xenbus_client.c
+++ b/drivers/xen/xenbus/xenbus_client.c
@@ -114,19 +114,22 @@ EXPORT_SYMBOL_GPL(xenbus_strstate);
  */
 int xenbus_watch_path(struct xenbus_device *dev, const char *path,
 		      struct xenbus_watch *watch,
+		      bool (*will_handle)(struct xenbus_watch *,
+					  const char **, unsigned int),
 		      void (*callback)(struct xenbus_watch *,
 				       const char **, unsigned int))
 {
 	int err;
 
 	watch->node = path;
-	watch->will_handle = NULL;
+	watch->will_handle = will_handle;
 	watch->callback = callback;
 
 	err = register_xenbus_watch(watch);
 
 	if (err) {
 		watch->node = NULL;
+		watch->will_handle = NULL;
 		watch->callback = NULL;
 		xenbus_dev_fatal(dev, err, "adding watch on %s", path);
 	}
@@ -153,6 +156,8 @@ EXPORT_SYMBOL_GPL(xenbus_watch_path);
  */
 int xenbus_watch_pathfmt(struct xenbus_device *dev,
 			 struct xenbus_watch *watch,
+			 bool (*will_handle)(struct xenbus_watch *,
+					     const char **, unsigned int),
 			 void (*callback)(struct xenbus_watch *,
 					const char **, unsigned int),
 			 const char *pathfmt, ...)
@@ -169,7 +174,7 @@ int xenbus_watch_pathfmt(struct xenbus_device *dev,
 		xenbus_dev_fatal(dev, -ENOMEM, "allocating path for watch");
 		return -ENOMEM;
 	}
-	err = xenbus_watch_path(dev, path, watch, callback);
+	err = xenbus_watch_path(dev, path, watch, will_handle, callback);
 
 	if (err)
 		kfree(path);
diff --git a/drivers/xen/xenbus/xenbus_probe.c b/drivers/xen/xenbus/xenbus_probe.c
index c2d447687e33..c560c1b8489a 100644
--- a/drivers/xen/xenbus/xenbus_probe.c
+++ b/drivers/xen/xenbus/xenbus_probe.c
@@ -137,7 +137,7 @@ static int watch_otherend(struct xenbus_device *dev)
 		container_of(dev->dev.bus, struct xen_bus_type, bus);
 
 	return xenbus_watch_pathfmt(dev, &dev->otherend_watch,
-				    bus->otherend_changed,
+				    NULL, bus->otherend_changed,
 				    "%s/%s", dev->otherend, "state");
 }
 
diff --git a/include/xen/xenbus.h b/include/xen/xenbus.h
index 11697aa023b5..1772507dc2c9 100644
--- a/include/xen/xenbus.h
+++ b/include/xen/xenbus.h
@@ -201,10 +201,14 @@ void xenbus_suspend_cancel(void);
 
 int xenbus_watch_path(struct xenbus_device *dev, const char *path,
 		      struct xenbus_watch *watch,
+		      bool (*will_handle)(struct xenbus_watch *,
+					  const char **, unsigned int),
 		      void (*callback)(struct xenbus_watch *,
 				       const char **, unsigned int));
-__printf(4, 5)
+__printf(5, 6)
 int xenbus_watch_pathfmt(struct xenbus_device *dev, struct xenbus_watch *watch,
+			 bool (*will_handle)(struct xenbus_watch *,
+					     const char **, unsigned int),
 			 void (*callback)(struct xenbus_watch *,
 					  const char **, unsigned int),
 			 const char *pathfmt, ...);
-- 
2.17.1


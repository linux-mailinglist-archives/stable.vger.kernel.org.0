Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAE9E2E4292
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:25:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436488AbgL1PYg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 10:24:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:60342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2407902AbgL1N7L (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:59:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B5A7F205CB;
        Mon, 28 Dec 2020 13:58:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609163935;
        bh=Onhd4CKiwI1ET6b9/v345pCurlZoNKRRJNBGGAMCTyI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=taX5dQFZZyw04+u934d4d1Gzc/JFF6kSwDxg5Oz6IwD3fChXYUWkNIYDAuuPCxODS
         oI1duGzTyQw3VefRYtb3aX2NGFsCCzdgT3+i6ec8Wp3/Fs2NHBVnviYUhuMzXmZVVB
         m/ntzD8Nw2LCyM3Y0AsBr/6lrBfi0AKKqOPs9rok=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, SeongJae Park <sjpark@amazon.de>,
        Michael Kurth <mku@amazon.de>,
        Pawel Wieczorkiewicz <wipawel@amazon.de>,
        Juergen Gross <jgross@suse.com>
Subject: [PATCH 5.4 444/453] xen/xenbus: Add will_handle callback support in xenbus_watch_path()
Date:   Mon, 28 Dec 2020 13:51:20 +0100
Message-Id: <20201228124958.585176574@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: SeongJae Park <sjpark@amazon.de>

commit 2e85d32b1c865bec703ce0c962221a5e955c52c2 upstream.

Some code does not directly make 'xenbus_watch' object and call
'register_xenbus_watch()' but use 'xenbus_watch_path()' instead.  This
commit adds support of 'will_handle' callback in the
'xenbus_watch_path()' and it's wrapper, 'xenbus_watch_pathfmt()'.

This is part of XSA-349

Cc: stable@vger.kernel.org
Signed-off-by: SeongJae Park <sjpark@amazon.de>
Reported-by: Michael Kurth <mku@amazon.de>
Reported-by: Pawel Wieczorkiewicz <wipawel@amazon.de>
Reviewed-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/block/xen-blkback/xenbus.c |    3 ++-
 drivers/net/xen-netback/xenbus.c   |    2 +-
 drivers/xen/xen-pciback/xenbus.c   |    2 +-
 drivers/xen/xenbus/xenbus_client.c |    9 +++++++--
 drivers/xen/xenbus/xenbus_probe.c  |    2 +-
 include/xen/xenbus.h               |    6 +++++-
 6 files changed, 17 insertions(+), 7 deletions(-)

--- a/drivers/block/xen-blkback/xenbus.c
+++ b/drivers/block/xen-blkback/xenbus.c
@@ -644,7 +644,8 @@ static int xen_blkbk_probe(struct xenbus
 	/* setup back pointer */
 	be->blkif->be = be;
 
-	err = xenbus_watch_pathfmt(dev, &be->backend_watch, backend_changed,
+	err = xenbus_watch_pathfmt(dev, &be->backend_watch, NULL,
+				   backend_changed,
 				   "%s/%s", dev->nodename, "physical-device");
 	if (err)
 		goto fail;
--- a/drivers/net/xen-netback/xenbus.c
+++ b/drivers/net/xen-netback/xenbus.c
@@ -979,7 +979,7 @@ static void connect(struct backend_info
 	xenvif_carrier_on(be->vif);
 
 	unregister_hotplug_status_watch(be);
-	err = xenbus_watch_pathfmt(dev, &be->hotplug_status_watch,
+	err = xenbus_watch_pathfmt(dev, &be->hotplug_status_watch, NULL,
 				   hotplug_status_changed,
 				   "%s/%s", dev->nodename, "hotplug-status");
 	if (!err)
--- a/drivers/xen/xen-pciback/xenbus.c
+++ b/drivers/xen/xen-pciback/xenbus.c
@@ -688,7 +688,7 @@ static int xen_pcibk_xenbus_probe(struct
 
 	/* watch the backend node for backend configuration information */
 	err = xenbus_watch_path(dev, dev->nodename, &pdev->be_watch,
-				xen_pcibk_be_watch);
+				NULL, xen_pcibk_be_watch);
 	if (err)
 		goto out;
 
--- a/drivers/xen/xenbus/xenbus_client.c
+++ b/drivers/xen/xenbus/xenbus_client.c
@@ -114,19 +114,22 @@ EXPORT_SYMBOL_GPL(xenbus_strstate);
  */
 int xenbus_watch_path(struct xenbus_device *dev, const char *path,
 		      struct xenbus_watch *watch,
+		      bool (*will_handle)(struct xenbus_watch *,
+					  const char *, const char *),
 		      void (*callback)(struct xenbus_watch *,
 				       const char *, const char *))
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
+					const char *, const char *),
 			 void (*callback)(struct xenbus_watch *,
 					  const char *, const char *),
 			 const char *pathfmt, ...)
@@ -169,7 +174,7 @@ int xenbus_watch_pathfmt(struct xenbus_d
 		xenbus_dev_fatal(dev, -ENOMEM, "allocating path for watch");
 		return -ENOMEM;
 	}
-	err = xenbus_watch_path(dev, path, watch, callback);
+	err = xenbus_watch_path(dev, path, watch, will_handle, callback);
 
 	if (err)
 		kfree(path);
--- a/drivers/xen/xenbus/xenbus_probe.c
+++ b/drivers/xen/xenbus/xenbus_probe.c
@@ -136,7 +136,7 @@ static int watch_otherend(struct xenbus_
 		container_of(dev->dev.bus, struct xen_bus_type, bus);
 
 	return xenbus_watch_pathfmt(dev, &dev->otherend_watch,
-				    bus->otherend_changed,
+				    NULL, bus->otherend_changed,
 				    "%s/%s", dev->otherend, "state");
 }
 
--- a/include/xen/xenbus.h
+++ b/include/xen/xenbus.h
@@ -199,10 +199,14 @@ void xenbus_probe(struct work_struct *);
 
 int xenbus_watch_path(struct xenbus_device *dev, const char *path,
 		      struct xenbus_watch *watch,
+		      bool (*will_handle)(struct xenbus_watch *,
+					  const char *, const char *),
 		      void (*callback)(struct xenbus_watch *,
 				       const char *, const char *));
-__printf(4, 5)
+__printf(5, 6)
 int xenbus_watch_pathfmt(struct xenbus_device *dev, struct xenbus_watch *watch,
+			 bool (*will_handle)(struct xenbus_watch *,
+					     const char *, const char *),
 			 void (*callback)(struct xenbus_watch *,
 					  const char *, const char *),
 			 const char *pathfmt, ...);



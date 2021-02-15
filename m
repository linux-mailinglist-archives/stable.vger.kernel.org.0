Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37AE631BC86
	for <lists+stable@lfdr.de>; Mon, 15 Feb 2021 16:31:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231182AbhBOPax (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Feb 2021 10:30:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:45434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230295AbhBOP3r (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Feb 2021 10:29:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B3D4864E40;
        Mon, 15 Feb 2021 15:28:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613402904;
        bh=SFH41UuPb7XtnofRcWtjtIekGzKQlQOefDC+q8pl4SI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pkju7FKgK9iH5JAthlqpmNktgjLou6KbWClTIhjVQowL+LHs8Ha3Y6OIck91Kyzcn
         TQ1BBCHgdYcTw8sUYtc7jG6XCZ/mdfmuamotZSp95y80O2SHzUwdsyLQv4RwykNlQY
         L7F7IzPUrSz6zv95+H5Ua27dvGf5fuWyvxWeiCao=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ian Jackson <iwj@xenproject.org>,
        Julien Grall <jgrall@amazon.com>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Juergen Gross <jgross@suse.com>
Subject: [PATCH 5.4 05/60] arm/xen: Dont probe xenbus as part of an early initcall
Date:   Mon, 15 Feb 2021 16:26:53 +0100
Message-Id: <20210215152715.564530615@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210215152715.401453874@linuxfoundation.org>
References: <20210215152715.401453874@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Julien Grall <jgrall@amazon.com>

commit c4295ab0b485b8bc50d2264bcae2acd06f25caaf upstream.

After Commit 3499ba8198cad ("xen: Fix event channel callback via
INTX/GSI"), xenbus_probe() will be called too early on Arm. This will
recent to a guest hang during boot.

If the hang wasn't there, we would have ended up to call
xenbus_probe() twice (the second time is in xenbus_probe_initcall()).

We don't need to initialize xenbus_probe() early for Arm guest.
Therefore, the call in xen_guest_init() is now removed.

After this change, there is no more external caller for xenbus_probe().
So the function is turned to a static one. Interestingly there were two
prototypes for it.

Cc: stable@vger.kernel.org
Fixes: 3499ba8198cad ("xen: Fix event channel callback via INTX/GSI")
Reported-by: Ian Jackson <iwj@xenproject.org>
Signed-off-by: Julien Grall <jgrall@amazon.com>
Reviewed-by: David Woodhouse <dwmw@amazon.co.uk>
Reviewed-by: Stefano Stabellini <sstabellini@kernel.org>
Link: https://lore.kernel.org/r/20210210170654.5377-1-julien@xen.org
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/xen/enlighten.c          |    2 --
 drivers/xen/xenbus/xenbus.h       |    1 -
 drivers/xen/xenbus/xenbus_probe.c |    2 +-
 include/xen/xenbus.h              |    2 --
 4 files changed, 1 insertion(+), 6 deletions(-)

--- a/arch/arm/xen/enlighten.c
+++ b/arch/arm/xen/enlighten.c
@@ -370,8 +370,6 @@ static int __init xen_guest_init(void)
 		return -ENOMEM;
 	}
 	gnttab_init();
-	if (!xen_initial_domain())
-		xenbus_probe();
 
 	/*
 	 * Making sure board specific code will not set up ops for
--- a/drivers/xen/xenbus/xenbus.h
+++ b/drivers/xen/xenbus/xenbus.h
@@ -115,7 +115,6 @@ int xenbus_probe_node(struct xen_bus_typ
 		      const char *type,
 		      const char *nodename);
 int xenbus_probe_devices(struct xen_bus_type *bus);
-void xenbus_probe(void);
 
 void xenbus_dev_changed(const char *node, struct xen_bus_type *bus);
 
--- a/drivers/xen/xenbus/xenbus_probe.c
+++ b/drivers/xen/xenbus/xenbus_probe.c
@@ -683,7 +683,7 @@ void unregister_xenstore_notifier(struct
 }
 EXPORT_SYMBOL_GPL(unregister_xenstore_notifier);
 
-void xenbus_probe(void)
+static void xenbus_probe(void)
 {
 	xenstored_ready = 1;
 
--- a/include/xen/xenbus.h
+++ b/include/xen/xenbus.h
@@ -187,8 +187,6 @@ void xs_suspend_cancel(void);
 
 struct work_struct;
 
-void xenbus_probe(void);
-
 #define XENBUS_IS_ERR_READ(str) ({			\
 	if (!IS_ERR(str) && strlen(str) == 0) {		\
 		kfree(str);				\



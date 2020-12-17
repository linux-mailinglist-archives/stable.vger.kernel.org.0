Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA7DA2DD4E5
	for <lists+stable@lfdr.de>; Thu, 17 Dec 2020 17:08:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729655AbgLQQFf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Dec 2020 11:05:35 -0500
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:53505 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729150AbgLQQFd (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Dec 2020 11:05:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1608221133; x=1639757133;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=uZGMd6GnIXxRytXL5PNWtDItQ2kBxHZ1DXyfaFYsHpU=;
  b=lwgI25UK4XN5H5AQQUc8VWEdhqgYSUDyyrXO1awp4WlJp4jqtzYszkJx
   FvefHRfuB4v31C9ILoGmQY81S2Eo7YPAjHm6jNH2nMGTLKLYciOtOdCj7
   tMrcsd81XamMMeYzoJMaC/AJVg51PvZW0UQbrU1WGIzpCSTfFAhsMMTWj
   E=;
X-IronPort-AV: E=Sophos;i="5.78,428,1599523200"; 
   d="scan'208";a="96902845"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2c-c6afef2e.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP; 17 Dec 2020 16:04:44 +0000
Received: from EX13D31EUA004.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2c-c6afef2e.us-west-2.amazon.com (Postfix) with ESMTPS id 2A060A2272;
        Thu, 17 Dec 2020 16:04:43 +0000 (UTC)
Received: from u3f2cd687b01c55.ant.amazon.com (10.43.162.146) by
 EX13D31EUA004.ant.amazon.com (10.43.165.161) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 17 Dec 2020 16:04:38 +0000
From:   SeongJae Park <sjpark@amazon.com>
To:     <stable@vger.kernel.org>
CC:     SeongJae Park <sjpark@amazon.de>, <doebel@amazon.de>,
        <aams@amazon.de>, <mku@amazon.de>, <jgross@suse.com>,
        <julien@xen.org>, <wipawel@amazon.de>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v3 3/5] xen/xenbus/xen_bus_type: Support will_handle watch callback
Date:   Thu, 17 Dec 2020 17:04:00 +0100
Message-ID: <20201217160402.26303-4-sjpark@amazon.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201217160402.26303-1-sjpark@amazon.com>
References: <20201217160402.26303-1-sjpark@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.162.146]
X-ClientProxiedBy: EX13D14UWC001.ant.amazon.com (10.43.162.5) To
 EX13D31EUA004.ant.amazon.com (10.43.165.161)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: SeongJae Park <sjpark@amazon.de>

This commit adds support of the 'will_handle' watch callback for
'xen_bus_type' users.

This is part of XSA-349

This is upstream commit be987200fbaceaef340872841d4f7af2c5ee8dc3

Cc: stable@vger.kernel.org
Signed-off-by: SeongJae Park <sjpark@amazon.de>
Reported-by: Michael Kurth <mku@amazon.de>
Reported-by: Pawel Wieczorkiewicz <wipawel@amazon.de>
Reviewed-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
---
 drivers/xen/xenbus/xenbus_probe.c | 3 ++-
 drivers/xen/xenbus/xenbus_probe.h | 2 ++
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/xen/xenbus/xenbus_probe.c b/drivers/xen/xenbus/xenbus_probe.c
index c560c1b8489a..ba7590d75985 100644
--- a/drivers/xen/xenbus/xenbus_probe.c
+++ b/drivers/xen/xenbus/xenbus_probe.c
@@ -137,7 +137,8 @@ static int watch_otherend(struct xenbus_device *dev)
 		container_of(dev->dev.bus, struct xen_bus_type, bus);
 
 	return xenbus_watch_pathfmt(dev, &dev->otherend_watch,
-				    NULL, bus->otherend_changed,
+				    bus->otherend_will_handle,
+				    bus->otherend_changed,
 				    "%s/%s", dev->otherend, "state");
 }
 
diff --git a/drivers/xen/xenbus/xenbus_probe.h b/drivers/xen/xenbus/xenbus_probe.h
index c9ec7ca1f7ab..2c394c6ba605 100644
--- a/drivers/xen/xenbus/xenbus_probe.h
+++ b/drivers/xen/xenbus/xenbus_probe.h
@@ -42,6 +42,8 @@ struct xen_bus_type {
 	int (*get_bus_id)(char bus_id[XEN_BUS_ID_SIZE], const char *nodename);
 	int (*probe)(struct xen_bus_type *bus, const char *type,
 		     const char *dir);
+	bool (*otherend_will_handle)(struct xenbus_watch *watch,
+				     const char **vec, unsigned int len);
 	void (*otherend_changed)(struct xenbus_watch *watch, const char **vec,
 				 unsigned int len);
 	struct bus_type bus;
-- 
2.17.1


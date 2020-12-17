Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 806282DCD88
	for <lists+stable@lfdr.de>; Thu, 17 Dec 2020 09:20:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727392AbgLQITD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Dec 2020 03:19:03 -0500
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:27582 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725468AbgLQITD (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Dec 2020 03:19:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1608193143; x=1639729143;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=DoAP4nxNHrpmrhNE8HfHGjd+2WyKdw2CcSZGZ+R3/9E=;
  b=fXYmHSb/tOeG1aBaVeq+jWwt0vNK3/+rnCVow+JIczOhOD01tDu+Q4kn
   tdXMUGlJCOXBGYOth7kv9XiMRvGhSYJdQaByxBO10AB1gxB0eO59jXPAX
   l/n7KYukG5g+ZoepmvP/DxVSbTY3WkdiOAw5XQXkZJo/hf4/bIDY1UrgA
   M=;
X-IronPort-AV: E=Sophos;i="5.78,426,1599523200"; 
   d="scan'208";a="73261961"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1a-715bee71.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-6001.iad6.amazon.com with ESMTP; 17 Dec 2020 08:18:15 +0000
Received: from EX13D31EUA004.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-1a-715bee71.us-east-1.amazon.com (Postfix) with ESMTPS id 973EFA07AE;
        Thu, 17 Dec 2020 08:18:14 +0000 (UTC)
Received: from u3f2cd687b01c55.ant.amazon.com (10.43.162.144) by
 EX13D31EUA004.ant.amazon.com (10.43.165.161) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 17 Dec 2020 08:18:09 +0000
From:   SeongJae Park <sjpark@amazon.com>
To:     <stable@vger.kernel.org>
CC:     SeongJae Park <sjpark@amazon.de>, <doebel@amazon.de>,
        <aams@amazon.de>, <mku@amazon.de>, <jgross@suse.com>,
        <julien@xen.org>, <wipawel@amazon.de>,
        <linux-kernel@vger.kernel.org>, Author Redacted <security@xen.org>
Subject: [PATCH 3/5] xen/xenbus/xen_bus_type: Support will_handle watch callback
Date:   Thu, 17 Dec 2020 09:17:25 +0100
Message-ID: <20201217081727.8253-4-sjpark@amazon.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201217081727.8253-1-sjpark@amazon.com>
References: <20201217081727.8253-1-sjpark@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.162.144]
X-ClientProxiedBy: EX13D30UWC002.ant.amazon.com (10.43.162.235) To
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
Signed-off-by: Author Redacted <security@xen.org>
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


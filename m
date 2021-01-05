Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1493D2EA974
	for <lists+stable@lfdr.de>; Tue,  5 Jan 2021 12:05:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729320AbhAELDh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jan 2021 06:03:37 -0500
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:14777 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729102AbhAELDg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jan 2021 06:03:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1609844617; x=1641380617;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=rDSWw9DpTymjT0DU6I+lktIy3laoqLV0oAeVdRm7WEc=;
  b=aS0Nfci6CxzDgWr6Pw1SUfjzUnBA7Yme8+0l2pUO9nrJ9vkj2ZnQBjnk
   1F28dr0Um9N0X1AngoXDyFAx4C7MP5I/MSTCd+lGnf+PVglzOcssUUAnF
   5s21YkUs/u9u2OBojqjcYOlrAgBWGq+MDJjE41EG7MjS1JWRNjbmOwwvJ
   A=;
X-IronPort-AV: E=Sophos;i="5.78,476,1599523200"; 
   d="scan'208";a="101273380"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2a-1c1b5cdd.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP; 05 Jan 2021 11:03:06 +0000
Received: from EX13D31EUA001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2a-1c1b5cdd.us-west-2.amazon.com (Postfix) with ESMTPS id 84D31A1E99;
        Tue,  5 Jan 2021 11:03:05 +0000 (UTC)
Received: from u3f2cd687b01c55.ant.amazon.com (10.43.162.125) by
 EX13D31EUA001.ant.amazon.com (10.43.165.15) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 5 Jan 2021 11:03:00 +0000
From:   SeongJae Park <sjpark@amazon.com>
To:     <stable@vger.kernel.org>
CC:     SeongJae Park <sjpark@amazon.de>, <doebel@amazon.de>,
        <aams@amazon.de>, <mku@amazon.de>, <jgross@suse.com>,
        <julien@xen.org>, <wipawel@amazon.de>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 5/5] xenbus/xenbus_backend: Disallow pending watch messages
Date:   Tue, 5 Jan 2021 12:02:45 +0100
Message-ID: <20210105110245.1969-1-sjpark@amazon.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210105110142.1810-1-sjpark@amazon.com>
References: <20210105110142.1810-1-sjpark@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.162.125]
X-ClientProxiedBy: EX13D29UWA001.ant.amazon.com (10.43.160.187) To
 EX13D31EUA001.ant.amazon.com (10.43.165.15)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: SeongJae Park <sjpark@amazon.de>

'xenbus_backend' watches 'state' of devices, which is writable by
guests.  Hence, if guests intensively updates it, dom0 will have lots of
pending events that exhausting memory of dom0.  In other words, guests
can trigger dom0 memory pressure.  This is known as XSA-349.  However,
the watch callback of it, 'frontend_changed()', reads only 'state', so
doesn't need to have the pending events.

To avoid the problem, this commit disallows pending watch messages for
'xenbus_backend' using the 'will_handle()' watch callback.

This is part of XSA-349

This is upstream commit 9996bd494794a2fe393e97e7a982388c6249aa76

Cc: stable@vger.kernel.org
Signed-off-by: SeongJae Park <sjpark@amazon.de>
Reported-by: Michael Kurth <mku@amazon.de>
Reported-by: Pawel Wieczorkiewicz <wipawel@amazon.de>
Reviewed-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
---
 drivers/xen/xenbus/xenbus_probe_backend.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/xen/xenbus/xenbus_probe_backend.c b/drivers/xen/xenbus/xenbus_probe_backend.c
index 04f7f85a5edf..597c0b038454 100644
--- a/drivers/xen/xenbus/xenbus_probe_backend.c
+++ b/drivers/xen/xenbus/xenbus_probe_backend.c
@@ -181,6 +181,12 @@ static int xenbus_probe_backend(struct xen_bus_type *bus, const char *type,
 	return err;
 }
 
+static bool frontend_will_handle(struct xenbus_watch *watch,
+				 const char **vec, unsigned int len)
+{
+	return watch->nr_pending == 0;
+}
+
 static void frontend_changed(struct xenbus_watch *watch,
 			    const char **vec, unsigned int len)
 {
@@ -192,6 +198,7 @@ static struct xen_bus_type xenbus_backend = {
 	.levels = 3,		/* backend/type/<frontend>/<id> */
 	.get_bus_id = backend_bus_id,
 	.probe = xenbus_probe_backend,
+	.otherend_will_handle = frontend_will_handle,
 	.otherend_changed = frontend_changed,
 	.bus = {
 		.name		= "xen-backend",
-- 
2.17.1


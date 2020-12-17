Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D833B2DD4F0
	for <lists+stable@lfdr.de>; Thu, 17 Dec 2020 17:08:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729986AbgLQQF5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Dec 2020 11:05:57 -0500
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:3877 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729967AbgLQQFz (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Dec 2020 11:05:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1608221156; x=1639757156;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=rDSWw9DpTymjT0DU6I+lktIy3laoqLV0oAeVdRm7WEc=;
  b=iLyee2Fr9JVk3Pc5Vpbl7oHEGXq+5xcrS4LLDnGB7+zoeBl5+ftUWNGP
   GoMiVCuA1Oe8ljkYUFJ4tdaaHK3nRzQ26M2MKXf19QZUvE6Sb6QZ38kdN
   0FJCcOsPWjcLxDga1Iy/ImKS4geO7emcr8sT2xrjV5ncIUHLSUJR687ge
   s=;
X-IronPort-AV: E=Sophos;i="5.78,428,1599523200"; 
   d="scan'208";a="73353501"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-2a-6e2fc477.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-6001.iad6.amazon.com with ESMTP; 17 Dec 2020 16:05:28 +0000
Received: from EX13D31EUA004.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2a-6e2fc477.us-west-2.amazon.com (Postfix) with ESMTPS id AC9C4A06A8;
        Thu, 17 Dec 2020 16:05:25 +0000 (UTC)
Received: from u3f2cd687b01c55.ant.amazon.com (10.43.161.68) by
 EX13D31EUA004.ant.amazon.com (10.43.165.161) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 17 Dec 2020 16:05:20 +0000
From:   SeongJae Park <sjpark@amazon.com>
To:     <stable@vger.kernel.org>
CC:     SeongJae Park <sjpark@amazon.de>, <doebel@amazon.de>,
        <aams@amazon.de>, <mku@amazon.de>, <jgross@suse.com>,
        <julien@xen.org>, <wipawel@amazon.de>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v3 5/5] xenbus/xenbus_backend: Disallow pending watch messages
Date:   Thu, 17 Dec 2020 17:05:03 +0100
Message-ID: <20201217160503.26563-1-sjpark@amazon.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201217160402.26303-1-sjpark@amazon.com>
References: <20201217160402.26303-1-sjpark@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.161.68]
X-ClientProxiedBy: EX13D23UWC002.ant.amazon.com (10.43.162.22) To
 EX13D31EUA004.ant.amazon.com (10.43.165.161)
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


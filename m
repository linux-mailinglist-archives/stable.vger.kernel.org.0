Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 877CA3783B8
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 12:47:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231296AbhEJKrL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 06:47:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:59672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233009AbhEJKo5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:44:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B01DF6143B;
        Mon, 10 May 2021 10:34:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620642870;
        bh=v5XGusImn6QmKPp8HJBTBjOXUorUWO8M4g+OdsIfnys=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xW3dt6+Hts9r6t13T76Sl070s9Xb7adLWRP1YBYCjd0qRT8YXJ4p/by+zCUPo7z3n
         X7n7rpMy0LHMYDCFsyhec3apDiRA05uA+lPWKBmGruwCZlT9T1OM9rceURAeuSYiRL
         qb4OvyfUKjIZUM76zRv5s6MyNO9bu8rRoSEeCWf0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 051/299] bus: ti-sysc: Probe for l4_wkup and l4_cfg interconnect devices first
Date:   Mon, 10 May 2021 12:17:28 +0200
Message-Id: <20210510102006.564978575@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102004.821838356@linuxfoundation.org>
References: <20210510102004.821838356@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tony Lindgren <tony@atomide.com>

[ Upstream commit 4700a00755fb5a4bb5109128297d6fd2d1272ee6 ]

We want to probe l4_wkup and l4_cfg interconnect devices first to avoid
issues with missing resources. Otherwise we attempt to probe l4_per
devices first causing pointless deferred probe and also annoyingh
renumbering of the MMC devices for example.

Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bus/ti-sysc.c | 49 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 49 insertions(+)

diff --git a/drivers/bus/ti-sysc.c b/drivers/bus/ti-sysc.c
index 16e389dce111..9afbe4992a1d 100644
--- a/drivers/bus/ti-sysc.c
+++ b/drivers/bus/ti-sysc.c
@@ -635,6 +635,51 @@ static int sysc_parse_and_check_child_range(struct sysc *ddata)
 	return 0;
 }
 
+/* Interconnect instances to probe before l4_per instances */
+static struct resource early_bus_ranges[] = {
+	/* am3/4 l4_wkup */
+	{ .start = 0x44c00000, .end = 0x44c00000 + 0x300000, },
+	/* omap4/5 and dra7 l4_cfg */
+	{ .start = 0x4a000000, .end = 0x4a000000 + 0x300000, },
+	/* omap4 l4_wkup */
+	{ .start = 0x4a300000, .end = 0x4a300000 + 0x30000,  },
+	/* omap5 and dra7 l4_wkup without dra7 dcan segment */
+	{ .start = 0x4ae00000, .end = 0x4ae00000 + 0x30000,  },
+};
+
+static atomic_t sysc_defer = ATOMIC_INIT(10);
+
+/**
+ * sysc_defer_non_critical - defer non_critical interconnect probing
+ * @ddata: device driver data
+ *
+ * We want to probe l4_cfg and l4_wkup interconnect instances before any
+ * l4_per instances as l4_per instances depend on resources on l4_cfg and
+ * l4_wkup interconnects.
+ */
+static int sysc_defer_non_critical(struct sysc *ddata)
+{
+	struct resource *res;
+	int i;
+
+	if (!atomic_read(&sysc_defer))
+		return 0;
+
+	for (i = 0; i < ARRAY_SIZE(early_bus_ranges); i++) {
+		res = &early_bus_ranges[i];
+		if (ddata->module_pa >= res->start &&
+		    ddata->module_pa <= res->end) {
+			atomic_set(&sysc_defer, 0);
+
+			return 0;
+		}
+	}
+
+	atomic_dec_if_positive(&sysc_defer);
+
+	return -EPROBE_DEFER;
+}
+
 static struct device_node *stdout_path;
 
 static void sysc_init_stdout_path(struct sysc *ddata)
@@ -859,6 +904,10 @@ static int sysc_map_and_check_registers(struct sysc *ddata)
 	if (error)
 		return error;
 
+	error = sysc_defer_non_critical(ddata);
+	if (error)
+		return error;
+
 	sysc_check_children(ddata);
 
 	error = sysc_parse_registers(ddata);
-- 
2.30.2




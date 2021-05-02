Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86F91370BC9
	for <lists+stable@lfdr.de>; Sun,  2 May 2021 16:03:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232342AbhEBOEd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 2 May 2021 10:04:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:49132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231964AbhEBOEa (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 2 May 2021 10:04:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 54B176102A;
        Sun,  2 May 2021 14:03:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619964199;
        bh=9rBdmnqcNBYq4mulLLtVltQzh9zTOIB56p2i5oS17/I=;
        h=From:To:Cc:Subject:Date:From;
        b=XVIXdqBVxIn8B0y0By1BryoBOwQl5GVper6y4RZlbtzKJaP3jcT758JRiyWANV892
         JzC6AnV82f+qsWHoRXu2uIFkkgkWQgOWJdqopw9xRzRTCenPa3z/IBAYPUl41jqQ8X
         XE9pd5+nJkak+BOo8z0bonBZbkuW0cbzgCRNXkQkYu86Wz8AQfBEjSTiNzjXRrNq/J
         0EYld+vrxlT/kwCU5tBi21Mu6GKgC7BIKZj//ms41YPF4XipfJ3LeREV4hzvt0E+Lp
         PBcBfgLvEcKDtPM4zjsuIxCJb+uY/XUeMbu/JYMGpKIPIRyx7JEwvf/P7bhdRjFVh/
         lZNh4pgxi8j2w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tony Lindgren <tony@atomide.com>, Sasha Levin <sashal@kernel.org>,
        linux-omap@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 01/79] bus: ti-sysc: Probe for l4_wkup and l4_cfg interconnect devices first
Date:   Sun,  2 May 2021 10:01:58 -0400
Message-Id: <20210502140316.2718705-1-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 3d74f237f005..9e535336689f 100644
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
@@ -863,6 +908,10 @@ static int sysc_map_and_check_registers(struct sysc *ddata)
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


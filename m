Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9B8A3C48DF
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:31:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235642AbhGLGlO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:41:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:35158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237155AbhGLGiY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:38:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5E0D661004;
        Mon, 12 Jul 2021 06:34:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626071670;
        bh=sFlGSuKcTC7RPMt0MiOEKxjw8fGmpLxEHQqCcT2gRJA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KDJX7RO+wse3bDPzVvOsB071xPcx9VDxllqvIZrzH62JgPPS8bNbbjb3iYMUNkDCN
         OjUssMXtYsWyUPVAz/Ra7yb8wqDWAMV/07/pupbqutVCYU1NmBq61mfUXg01lh/OvI
         g2/0DjOOMThlZdXiWo0epp7RQJBSwc/YyvUVVG4w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Prike Liang <Prike.Liang@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Mario Limonciello <mario.limonciello@amd.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 170/593] ACPI: processor idle: Fix up C-state latency if not ordered
Date:   Mon, 12 Jul 2021 08:05:30 +0200
Message-Id: <20210712060901.745351087@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060843.180606720@linuxfoundation.org>
References: <20210712060843.180606720@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit 65ea8f2c6e230bdf71fed0137cf9e9d1b307db32 ]

Generally, the C-state latency is provided by the _CST method or
FADT, but some OEM platforms using AMD Picasso, Renoir, Van Gogh,
and Cezanne set the C2 latency greater than C3's which causes the
C2 state to be skipped.

That will block the core entering PC6, which prevents S0ix working
properly on Linux systems.

In other operating systems, the latency values are not validated and
this does not cause problems by skipping states.

To avoid this issue on Linux, detect when latencies are not an
arithmetic progression and sort them.

Link: https://gitlab.freedesktop.org/agd5f/linux/-/commit/026d186e4592c1ee9c1cb44295912d0294508725
Link: https://gitlab.freedesktop.org/drm/amd/-/issues/1230#note_712174
Suggested-by: Prike Liang <Prike.Liang@amd.com>
Suggested-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
[ rjw: Subject and changelog edits ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/processor_idle.c | 40 +++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
index fb161a21d0ae..8377c3ed10ff 100644
--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -16,6 +16,7 @@
 #include <linux/acpi.h>
 #include <linux/dmi.h>
 #include <linux/sched.h>       /* need_resched() */
+#include <linux/sort.h>
 #include <linux/tick.h>
 #include <linux/cpuidle.h>
 #include <linux/cpu.h>
@@ -389,10 +390,37 @@ static void acpi_processor_power_verify_c3(struct acpi_processor *pr,
 	return;
 }
 
+static int acpi_cst_latency_cmp(const void *a, const void *b)
+{
+	const struct acpi_processor_cx *x = a, *y = b;
+
+	if (!(x->valid && y->valid))
+		return 0;
+	if (x->latency > y->latency)
+		return 1;
+	if (x->latency < y->latency)
+		return -1;
+	return 0;
+}
+static void acpi_cst_latency_swap(void *a, void *b, int n)
+{
+	struct acpi_processor_cx *x = a, *y = b;
+	u32 tmp;
+
+	if (!(x->valid && y->valid))
+		return;
+	tmp = x->latency;
+	x->latency = y->latency;
+	y->latency = tmp;
+}
+
 static int acpi_processor_power_verify(struct acpi_processor *pr)
 {
 	unsigned int i;
 	unsigned int working = 0;
+	unsigned int last_latency = 0;
+	unsigned int last_type = 0;
+	bool buggy_latency = false;
 
 	pr->power.timer_broadcast_on_state = INT_MAX;
 
@@ -416,12 +444,24 @@ static int acpi_processor_power_verify(struct acpi_processor *pr)
 		}
 		if (!cx->valid)
 			continue;
+		if (cx->type >= last_type && cx->latency < last_latency)
+			buggy_latency = true;
+		last_latency = cx->latency;
+		last_type = cx->type;
 
 		lapic_timer_check_state(i, pr, cx);
 		tsc_check_state(cx->type);
 		working++;
 	}
 
+	if (buggy_latency) {
+		pr_notice("FW issue: working around C-state latencies out of order\n");
+		sort(&pr->power.states[1], max_cstate,
+		     sizeof(struct acpi_processor_cx),
+		     acpi_cst_latency_cmp,
+		     acpi_cst_latency_swap);
+	}
+
 	lapic_timer_propagate_broadcast(pr);
 
 	return (working);
-- 
2.30.2




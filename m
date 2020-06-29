Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F46D20E65C
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 00:09:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727866AbgF2Vqu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 17:46:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:56908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726743AbgF2Sfp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 14:35:45 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4D5F824695;
        Mon, 29 Jun 2020 15:19:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593443990;
        bh=bnLnIf/d+NGHn7mvXEL2xulT0w4PmpuJ11tRjWmHk3s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WA+TfD/0D7Vso5RmC7ZgFtuNRxuNfMThY9DKgeNyVXVQO6M8wqcHWNz9FgEqHrg6t
         GyGg+gAp4JTMsGU3wOrhg0HQ6NavYD9YDsZzwMnIDInwJt+UpAssSC1xK8KUhxUSxB
         e4VSaDsel8jfl5k+Q2JaLksWSATS+p0oVdLFW1t8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tony Lindgren <tony@atomide.com>, Faiz Abbas <faiz_abbas@ti.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 094/265] bus: ti-sysc: Use optional clocks on for enable and wait for softreset bit
Date:   Mon, 29 Jun 2020 11:15:27 -0400
Message-Id: <20200629151818.2493727-95-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629151818.2493727-1-sashal@kernel.org>
References: <20200629151818.2493727-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.7.7-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.7.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.7.7-rc1
X-KernelTest-Deadline: 2020-07-01T15:14+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tony Lindgren <tony@atomide.com>

[ Upstream commit d46f9fbec71997420e4fb83c04d9affdf423f879 ]

Some modules reset automatically when idled, and when re-enabled, we must
wait for the automatic OCP softreset to complete. And if optional clocks
are configured, we need to keep the clocks on while waiting for the reset
to complete.

Let's fix the issue by moving the OCP softreset code to a separate
function sysc_wait_softreset(), and call it also from sysc_enable_module()
with the optional clocks enabled.

This is based on what we're already doing for legacy platform data booting
in _enable_sysc().

Fixes: 7324a7a0d5e2 ("bus: ti-sysc: Implement display subsystem reset quirk")
Reported-by: Faiz Abbas <faiz_abbas@ti.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bus/ti-sysc.c | 80 ++++++++++++++++++++++++++++++++-----------
 1 file changed, 60 insertions(+), 20 deletions(-)

diff --git a/drivers/bus/ti-sysc.c b/drivers/bus/ti-sysc.c
index 369c97c3e0c0b..a3a2c269e9ad7 100644
--- a/drivers/bus/ti-sysc.c
+++ b/drivers/bus/ti-sysc.c
@@ -221,6 +221,35 @@ static u32 sysc_read_sysstatus(struct sysc *ddata)
 	return sysc_read(ddata, offset);
 }
 
+/* Poll on reset status */
+static int sysc_wait_softreset(struct sysc *ddata)
+{
+	u32 sysc_mask, syss_done, rstval;
+	int syss_offset, error = 0;
+
+	syss_offset = ddata->offsets[SYSC_SYSSTATUS];
+	sysc_mask = BIT(ddata->cap->regbits->srst_shift);
+
+	if (ddata->cfg.quirks & SYSS_QUIRK_RESETDONE_INVERTED)
+		syss_done = 0;
+	else
+		syss_done = ddata->cfg.syss_mask;
+
+	if (syss_offset >= 0) {
+		error = readx_poll_timeout(sysc_read_sysstatus, ddata, rstval,
+					   (rstval & ddata->cfg.syss_mask) ==
+					   syss_done,
+					   100, MAX_MODULE_SOFTRESET_WAIT);
+
+	} else if (ddata->cfg.quirks & SYSC_QUIRK_RESET_STATUS) {
+		error = readx_poll_timeout(sysc_read_sysconfig, ddata, rstval,
+					   !(rstval & sysc_mask),
+					   100, MAX_MODULE_SOFTRESET_WAIT);
+	}
+
+	return error;
+}
+
 static int sysc_add_named_clock_from_child(struct sysc *ddata,
 					   const char *name,
 					   const char *optfck_name)
@@ -925,8 +954,34 @@ static int sysc_enable_module(struct device *dev)
 	struct sysc *ddata;
 	const struct sysc_regbits *regbits;
 	u32 reg, idlemodes, best_mode;
+	int error;
 
 	ddata = dev_get_drvdata(dev);
+
+	/*
+	 * Some modules like DSS reset automatically on idle. Enable optional
+	 * reset clocks and wait for OCP softreset to complete.
+	 */
+	if (ddata->cfg.quirks & SYSC_QUIRK_OPT_CLKS_IN_RESET) {
+		error = sysc_enable_opt_clocks(ddata);
+		if (error) {
+			dev_err(ddata->dev,
+				"Optional clocks failed for enable: %i\n",
+				error);
+			return error;
+		}
+	}
+	error = sysc_wait_softreset(ddata);
+	if (error)
+		dev_warn(ddata->dev, "OCP softreset timed out\n");
+	if (ddata->cfg.quirks & SYSC_QUIRK_OPT_CLKS_IN_RESET)
+		sysc_disable_opt_clocks(ddata);
+
+	/*
+	 * Some subsystem private interconnects, like DSS top level module,
+	 * need only the automatic OCP softreset handling with no sysconfig
+	 * register bits to configure.
+	 */
 	if (ddata->offsets[SYSC_SYSCONFIG] == -ENODEV)
 		return 0;
 
@@ -1828,11 +1883,10 @@ static int sysc_legacy_init(struct sysc *ddata)
  */
 static int sysc_reset(struct sysc *ddata)
 {
-	int sysc_offset, syss_offset, sysc_val, rstval, error = 0;
-	u32 sysc_mask, syss_done;
+	int sysc_offset, sysc_val, error;
+	u32 sysc_mask;
 
 	sysc_offset = ddata->offsets[SYSC_SYSCONFIG];
-	syss_offset = ddata->offsets[SYSC_SYSSTATUS];
 
 	if (ddata->legacy_mode ||
 	    ddata->cap->regbits->srst_shift < 0 ||
@@ -1841,11 +1895,6 @@ static int sysc_reset(struct sysc *ddata)
 
 	sysc_mask = BIT(ddata->cap->regbits->srst_shift);
 
-	if (ddata->cfg.quirks & SYSS_QUIRK_RESETDONE_INVERTED)
-		syss_done = 0;
-	else
-		syss_done = ddata->cfg.syss_mask;
-
 	if (ddata->pre_reset_quirk)
 		ddata->pre_reset_quirk(ddata);
 
@@ -1862,18 +1911,9 @@ static int sysc_reset(struct sysc *ddata)
 	if (ddata->post_reset_quirk)
 		ddata->post_reset_quirk(ddata);
 
-	/* Poll on reset status */
-	if (syss_offset >= 0) {
-		error = readx_poll_timeout(sysc_read_sysstatus, ddata, rstval,
-					   (rstval & ddata->cfg.syss_mask) ==
-					   syss_done,
-					   100, MAX_MODULE_SOFTRESET_WAIT);
-
-	} else if (ddata->cfg.quirks & SYSC_QUIRK_RESET_STATUS) {
-		error = readx_poll_timeout(sysc_read_sysconfig, ddata, rstval,
-					   !(rstval & sysc_mask),
-					   100, MAX_MODULE_SOFTRESET_WAIT);
-	}
+	error = sysc_wait_softreset(ddata);
+	if (error)
+		dev_warn(ddata->dev, "OCP softreset timed out\n");
 
 	if (ddata->reset_done_quirk)
 		ddata->reset_done_quirk(ddata);
-- 
2.25.1


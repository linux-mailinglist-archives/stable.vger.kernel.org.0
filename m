Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB92D2269A0
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:30:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732787AbgGTQ1u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:27:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:60386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732251AbgGTP7f (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 11:59:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5925622CBB;
        Mon, 20 Jul 2020 15:59:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595260774;
        bh=0FZeMFH7gDbfkGfeeYppuC4EMRgBINcNU5H0gQHaCSk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U93apk+D2MD5JUi+lzcsq897lzTHjDvEvX9QXmtvIXivJ3m73R6JhjJCUbj82dSew
         HirljRE5wO2PmbmA7/dkg5YIvKCVwMtI9bPxlQdzzAnX7eQd4HXESV4g/Go7+rlsri
         yAFLvoYN0xiaM57MGlCtyOHQlPPRqQ/FdSfzip+w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Faiz Abbas <faiz_abbas@ti.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 091/215] bus: ti-sysc: Use optional clocks on for enable and wait for softreset bit
Date:   Mon, 20 Jul 2020 17:36:13 +0200
Message-Id: <20200720152824.536061809@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152820.122442056@linuxfoundation.org>
References: <20200720152820.122442056@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index d0b75e7d5e50f..bb3e3310865bd 100644
--- a/drivers/bus/ti-sysc.c
+++ b/drivers/bus/ti-sysc.c
@@ -186,6 +186,35 @@ static u32 sysc_read_sysstatus(struct sysc *ddata)
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
@@ -892,8 +921,34 @@ static int sysc_enable_module(struct device *dev)
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
 
@@ -1691,11 +1746,10 @@ static int sysc_rstctrl_reset_deassert(struct sysc *ddata, bool reset)
  */
 static int sysc_reset(struct sysc *ddata)
 {
-	int sysc_offset, syss_offset, sysc_val, rstval, error = 0;
-	u32 sysc_mask, syss_done;
+	int sysc_offset, sysc_val, error;
+	u32 sysc_mask;
 
 	sysc_offset = ddata->offsets[SYSC_SYSCONFIG];
-	syss_offset = ddata->offsets[SYSC_SYSSTATUS];
 
 	if (ddata->legacy_mode || sysc_offset < 0 ||
 	    ddata->cap->regbits->srst_shift < 0 ||
@@ -1704,11 +1758,6 @@ static int sysc_reset(struct sysc *ddata)
 
 	sysc_mask = BIT(ddata->cap->regbits->srst_shift);
 
-	if (ddata->cfg.quirks & SYSS_QUIRK_RESETDONE_INVERTED)
-		syss_done = 0;
-	else
-		syss_done = ddata->cfg.syss_mask;
-
 	if (ddata->pre_reset_quirk)
 		ddata->pre_reset_quirk(ddata);
 
@@ -1723,18 +1772,9 @@ static int sysc_reset(struct sysc *ddata)
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




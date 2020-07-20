Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8194C2269DE
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:31:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732084AbgGTP6u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 11:58:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:59112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726381AbgGTP6s (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 11:58:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C505522CAF;
        Mon, 20 Jul 2020 15:58:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595260727;
        bh=oiWuWvuvG1G8SrLD9jFwj9JkIdSab9u8/D5wCadZwoQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H2UVYIVKTck5EjZNPXP1Autm8Tqs03cJn1PxmFyrsZDglbMQrrISQPuLeRZbAXTsi
         WkzkvVGZAZyWQnpdXhOw76mfS4Mfk1nCl1C6PmTpKgvHIFMDhqzzYt54uHMTL/BP1f
         oRbhp4n7gUK4xHexNcBqVuRbmceG0odgR6TVfui4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 074/215] bus: ti-sysc: Rename clk related quirks to pre_reset and post_reset quirks
Date:   Mon, 20 Jul 2020 17:35:56 +0200
Message-Id: <20200720152823.735136196@linuxfoundation.org>
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

[ Upstream commit e64c021fd92467e34b9d970a651bcaa8f326f3f2 ]

The clk_disable_quirk and clk_enable_quirk should really be called
pre_reset_quirk and post_reset_quirk to avoid confusion like we had
with hdq1w reset.

Let's also rename the related functions so the code is easier to follow.
Note that we also have reset_done_quirk that is needed in some cases
after checking the separate register for reset done bit.

Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bus/ti-sysc.c | 32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/bus/ti-sysc.c b/drivers/bus/ti-sysc.c
index 553c0e2796217..c7f408d758396 100644
--- a/drivers/bus/ti-sysc.c
+++ b/drivers/bus/ti-sysc.c
@@ -70,8 +70,8 @@ static const char * const clock_names[SYSC_MAX_CLOCKS] = {
  * @child_needs_resume: runtime resume needed for child on resume from suspend
  * @disable_on_idle: status flag used for disabling modules with resets
  * @idle_work: work structure used to perform delayed idle on a module
- * @clk_enable_quirk: module specific clock enable quirk
- * @clk_disable_quirk: module specific clock disable quirk
+ * @pre_reset_quirk: module specific pre-reset quirk
+ * @post_reset_quirk: module specific post-reset quirk
  * @reset_done_quirk: module specific reset done quirk
  * @module_enable_quirk: module specific enable quirk
  * @module_disable_quirk: module specific disable quirk
@@ -97,8 +97,8 @@ struct sysc {
 	unsigned int needs_resume:1;
 	unsigned int child_needs_resume:1;
 	struct delayed_work idle_work;
-	void (*clk_enable_quirk)(struct sysc *sysc);
-	void (*clk_disable_quirk)(struct sysc *sysc);
+	void (*pre_reset_quirk)(struct sysc *sysc);
+	void (*post_reset_quirk)(struct sysc *sysc);
 	void (*reset_done_quirk)(struct sysc *sysc);
 	void (*module_enable_quirk)(struct sysc *sysc);
 	void (*module_disable_quirk)(struct sysc *sysc);
@@ -1433,7 +1433,7 @@ static void sysc_module_enable_quirk_aess(struct sysc *ddata)
 	sysc_write(ddata, offset, 1);
 }
 
-/* I2C needs extra enable bit toggling for reset */
+/* I2C needs to be disabled for reset */
 static void sysc_clk_quirk_i2c(struct sysc *ddata, bool enable)
 {
 	int offset;
@@ -1454,14 +1454,14 @@ static void sysc_clk_quirk_i2c(struct sysc *ddata, bool enable)
 	sysc_write(ddata, offset, val);
 }
 
-static void sysc_clk_enable_quirk_i2c(struct sysc *ddata)
+static void sysc_pre_reset_quirk_i2c(struct sysc *ddata)
 {
-	sysc_clk_quirk_i2c(ddata, true);
+	sysc_clk_quirk_i2c(ddata, false);
 }
 
-static void sysc_clk_disable_quirk_i2c(struct sysc *ddata)
+static void sysc_post_reset_quirk_i2c(struct sysc *ddata)
 {
-	sysc_clk_quirk_i2c(ddata, false);
+	sysc_clk_quirk_i2c(ddata, true);
 }
 
 /* 36xx SGX needs a quirk for to bypass OCP IPG interrupt logic */
@@ -1503,14 +1503,14 @@ static void sysc_init_module_quirks(struct sysc *ddata)
 		return;
 
 	if (ddata->cfg.quirks & SYSC_MODULE_QUIRK_HDQ1W) {
-		ddata->clk_disable_quirk = sysc_pre_reset_quirk_hdq1w;
+		ddata->pre_reset_quirk = sysc_pre_reset_quirk_hdq1w;
 
 		return;
 	}
 
 	if (ddata->cfg.quirks & SYSC_MODULE_QUIRK_I2C) {
-		ddata->clk_enable_quirk = sysc_clk_enable_quirk_i2c;
-		ddata->clk_disable_quirk = sysc_clk_disable_quirk_i2c;
+		ddata->pre_reset_quirk = sysc_pre_reset_quirk_i2c;
+		ddata->post_reset_quirk = sysc_post_reset_quirk_i2c;
 
 		return;
 	}
@@ -1629,8 +1629,8 @@ static int sysc_reset(struct sysc *ddata)
 	else
 		syss_done = ddata->cfg.syss_mask;
 
-	if (ddata->clk_disable_quirk)
-		ddata->clk_disable_quirk(ddata);
+	if (ddata->pre_reset_quirk)
+		ddata->pre_reset_quirk(ddata);
 
 	sysc_val = sysc_read_sysconfig(ddata);
 	sysc_val |= sysc_mask;
@@ -1640,8 +1640,8 @@ static int sysc_reset(struct sysc *ddata)
 		usleep_range(ddata->cfg.srst_udelay,
 			     ddata->cfg.srst_udelay * 2);
 
-	if (ddata->clk_enable_quirk)
-		ddata->clk_enable_quirk(ddata);
+	if (ddata->post_reset_quirk)
+		ddata->post_reset_quirk(ddata);
 
 	/* Poll on reset status */
 	if (syss_offset >= 0) {
-- 
2.25.1




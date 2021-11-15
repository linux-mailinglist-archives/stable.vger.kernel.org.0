Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EF5D450E7C
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:13:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237991AbhKOSPm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 13:15:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:50068 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240230AbhKOSH1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:07:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BD8FF63395;
        Mon, 15 Nov 2021 17:43:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636998220;
        bh=qoNE+hBPLqpzXpTP8y5G1K88Rtigbn+X1ssvycPlcpE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xto+v7M4vQ7V567VRL9xOSGnAJ0AlJ6ANvOu/gKrSPTzv9/rNnXkF9KIoVRmQNKN5
         dLUjzuVS4sb5NNFdM0AjUhruisZ32koVM17lr9cmeYijruz+B8/bOsY2UVLlDQlNUU
         y1S4QJExVXYV2+Vg9b7iuloq/Hx7CN5eDffiMSis=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 399/575] bus: ti-sysc: Fix timekeeping_suspended warning on resume
Date:   Mon, 15 Nov 2021 18:02:04 +0100
Message-Id: <20211115165357.569947261@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tony Lindgren <tony@atomide.com>

[ Upstream commit b3e9431854e8f305385d5de225441c0477b936cb ]

On resume we can get a warning at kernel/time/timekeeping.c:824 for
timekeeping_suspended.

Let's fix this by adding separate functions for sysc_poll_reset_sysstatus()
and sysc_poll_reset_sysconfig() and have the new functions handle also
timekeeping_suspended.

If iopoll at some point supports timekeeping_suspended, we can just drop
the custom handling from these functions.

Fixes: d46f9fbec719 ("bus: ti-sysc: Use optional clocks on for enable and wait for softreset bit")
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bus/ti-sysc.c | 65 +++++++++++++++++++++++++++++++++++--------
 1 file changed, 53 insertions(+), 12 deletions(-)

diff --git a/drivers/bus/ti-sysc.c b/drivers/bus/ti-sysc.c
index 02341fd66e8d2..2ff437e5c7051 100644
--- a/drivers/bus/ti-sysc.c
+++ b/drivers/bus/ti-sysc.c
@@ -17,6 +17,7 @@
 #include <linux/of_platform.h>
 #include <linux/slab.h>
 #include <linux/sys_soc.h>
+#include <linux/timekeeping.h>
 #include <linux/iopoll.h>
 
 #include <linux/platform_data/ti-sysc.h>
@@ -223,37 +224,77 @@ static u32 sysc_read_sysstatus(struct sysc *ddata)
 	return sysc_read(ddata, offset);
 }
 
-/* Poll on reset status */
-static int sysc_wait_softreset(struct sysc *ddata)
+static int sysc_poll_reset_sysstatus(struct sysc *ddata)
 {
-	u32 sysc_mask, syss_done, rstval;
-	int syss_offset, error = 0;
-
-	if (ddata->cap->regbits->srst_shift < 0)
-		return 0;
-
-	syss_offset = ddata->offsets[SYSC_SYSSTATUS];
-	sysc_mask = BIT(ddata->cap->regbits->srst_shift);
+	int error, retries;
+	u32 syss_done, rstval;
 
 	if (ddata->cfg.quirks & SYSS_QUIRK_RESETDONE_INVERTED)
 		syss_done = 0;
 	else
 		syss_done = ddata->cfg.syss_mask;
 
-	if (syss_offset >= 0) {
+	if (likely(!timekeeping_suspended)) {
 		error = readx_poll_timeout_atomic(sysc_read_sysstatus, ddata,
 				rstval, (rstval & ddata->cfg.syss_mask) ==
 				syss_done, 100, MAX_MODULE_SOFTRESET_WAIT);
+	} else {
+		retries = MAX_MODULE_SOFTRESET_WAIT;
+		while (retries--) {
+			rstval = sysc_read_sysstatus(ddata);
+			if ((rstval & ddata->cfg.syss_mask) == syss_done)
+				return 0;
+			udelay(2); /* Account for udelay flakeyness */
+		}
+		error = -ETIMEDOUT;
+	}
 
-	} else if (ddata->cfg.quirks & SYSC_QUIRK_RESET_STATUS) {
+	return error;
+}
+
+static int sysc_poll_reset_sysconfig(struct sysc *ddata)
+{
+	int error, retries;
+	u32 sysc_mask, rstval;
+
+	sysc_mask = BIT(ddata->cap->regbits->srst_shift);
+
+	if (likely(!timekeeping_suspended)) {
 		error = readx_poll_timeout_atomic(sysc_read_sysconfig, ddata,
 				rstval, !(rstval & sysc_mask),
 				100, MAX_MODULE_SOFTRESET_WAIT);
+	} else {
+		retries = MAX_MODULE_SOFTRESET_WAIT;
+		while (retries--) {
+			rstval = sysc_read_sysconfig(ddata);
+			if (!(rstval & sysc_mask))
+				return 0;
+			udelay(2); /* Account for udelay flakeyness */
+		}
+		error = -ETIMEDOUT;
 	}
 
 	return error;
 }
 
+/* Poll on reset status */
+static int sysc_wait_softreset(struct sysc *ddata)
+{
+	int syss_offset, error = 0;
+
+	if (ddata->cap->regbits->srst_shift < 0)
+		return 0;
+
+	syss_offset = ddata->offsets[SYSC_SYSSTATUS];
+
+	if (syss_offset >= 0)
+		error = sysc_poll_reset_sysstatus(ddata);
+	else if (ddata->cfg.quirks & SYSC_QUIRK_RESET_STATUS)
+		error = sysc_poll_reset_sysconfig(ddata);
+
+	return error;
+}
+
 static int sysc_add_named_clock_from_child(struct sysc *ddata,
 					   const char *name,
 					   const char *optfck_name)
-- 
2.33.0




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8CFF45119A
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 20:08:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239647AbhKOTLX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 14:11:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:39112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244025AbhKOTIZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:08:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 363AA63402;
        Mon, 15 Nov 2021 18:17:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637000278;
        bh=968QfDD1pURssI5vp7c5C92KofDfJ4bAUDofdb6tsAY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ossZEH635yzLv4AfqME6mFfYB5I3fVOpiKjGBIl1bnOM7DsoOaY7L5NRCKa3VnO0R
         mRQmCYdRlQM/yZTwcTdwknYcHnsVVJResD6d372xUc2qnuJxfFUAXIVszbx5y8/Y4N
         rzNwlbpSBu0RbD8kLgvfO115SnVxIFDfwgghhg+U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 569/849] bus: ti-sysc: Fix timekeeping_suspended warning on resume
Date:   Mon, 15 Nov 2021 18:00:52 +0100
Message-Id: <20211115165439.495201728@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
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
index 418ada474a85d..dd149cffe5e5b 100644
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




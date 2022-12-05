Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7FA6643287
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 20:27:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232676AbiLET05 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 14:26:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234027AbiLET0b (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 14:26:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2219323EA3
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 11:23:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B52F8B81181
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 19:23:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1CCEC433C1;
        Mon,  5 Dec 2022 19:23:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670268183;
        bh=0Oq0sLNv5fg5zID8fzgXDuKoYH42VXWl57atoUKT0Tg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NLCNhAwqMsMO0lVvE5aa+OeZp57wZvO+TWoAEcCbSISwqLuVczcpskI9BX8DL3twn
         GJq8SVknbcTpH/wZpr0+ytSQ/uamkE1kekD0CPMDNZB4+FabZKxD9H5uE+TUc0g/VY
         RyU3kE6MUurLARjP1Pf2XtxWUcyCXi9DysEUDGEo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Johan Hovold <johan+linaro@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Taniya Das <quic_tdas@quicinc.com>,
        Satya Priya <quic_c_skakit@quicinc.com>,
        Douglas Anderson <dianders@chromium.org>,
        Matthias Kaehlcke <mka@chromium.org>,
        Stephen Boyd <swboyd@chromium.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 011/124] clk: qcom: gdsc: Remove direct runtime PM calls
Date:   Mon,  5 Dec 2022 20:08:37 +0100
Message-Id: <20221205190808.763141986@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190808.422385173@linuxfoundation.org>
References: <20221205190808.422385173@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stephen Boyd <swboyd@chromium.org>

[ Upstream commit 4cc47e8add635408e063c98b52d56b7ceacf0b70 ]

We shouldn't be calling runtime PM APIs from within the genpd
enable/disable path for a couple reasons.

First, this causes an AA lockdep splat[1] because genpd can call into
genpd code again while holding the genpd lock.

WARNING: possible recursive locking detected
5.19.0-rc2-lockdep+ #7 Not tainted
--------------------------------------------
kworker/2:1/49 is trying to acquire lock:
ffffffeea0370788 (&genpd->mlock){+.+.}-{3:3}, at: genpd_lock_mtx+0x24/0x30

but task is already holding lock:
ffffffeea03710a8 (&genpd->mlock){+.+.}-{3:3}, at: genpd_lock_mtx+0x24/0x30

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(&genpd->mlock);
  lock(&genpd->mlock);

 *** DEADLOCK ***

 May be due to missing lock nesting notation

3 locks held by kworker/2:1/49:
 #0: 74ffff80811a5748 ((wq_completion)pm){+.+.}-{0:0}, at: process_one_work+0x320/0x5fc
 #1: ffffffc008537cf8 ((work_completion)(&genpd->power_off_work)){+.+.}-{0:0}, at: process_one_work+0x354/0x5fc
 #2: ffffffeea03710a8 (&genpd->mlock){+.+.}-{3:3}, at: genpd_lock_mtx+0x24/0x30

stack backtrace:
CPU: 2 PID: 49 Comm: kworker/2:1 Not tainted 5.19.0-rc2-lockdep+ #7
Hardware name: Google Lazor (rev3 - 8) with KB Backlight (DT)
Workqueue: pm genpd_power_off_work_fn
Call trace:
 dump_backtrace+0x1a0/0x200
 show_stack+0x24/0x30
 dump_stack_lvl+0x7c/0xa0
 dump_stack+0x18/0x44
 __lock_acquire+0xb38/0x3634
 lock_acquire+0x180/0x2d4
 __mutex_lock_common+0x118/0xe30
 mutex_lock_nested+0x70/0x7c
 genpd_lock_mtx+0x24/0x30
 genpd_runtime_suspend+0x2f0/0x414
 __rpm_callback+0xdc/0x1b8
 rpm_callback+0x4c/0xcc
 rpm_suspend+0x21c/0x5f0
 rpm_idle+0x17c/0x1e0
 __pm_runtime_idle+0x78/0xcc
 gdsc_disable+0x24c/0x26c
 _genpd_power_off+0xd4/0x1c4
 genpd_power_off+0x2d8/0x41c
 genpd_power_off_work_fn+0x60/0x94
 process_one_work+0x398/0x5fc
 worker_thread+0x42c/0x6c4
 kthread+0x194/0x1b4
 ret_from_fork+0x10/0x20

Second, this confuses runtime PM on CoachZ for the camera devices by
causing the camera clock controller's runtime PM usage_count to go
negative after resuming from suspend. This is because runtime PM is
being used on the clock controller while runtime PM is disabled for the
device.

The reason for the negative count is because a GDSC is represented as a
genpd and each genpd that is attached to a device is resumed during the
noirq phase of system wide suspend/resume (see the noirq suspend ops
assignment in pm_genpd_init() for more details). The camera GDSCs are
attached to camera devices with the 'power-domains' property in DT.
Every device has runtime PM disabled in the late system suspend phase
via __device_suspend_late(). Runtime PM is not usable until runtime PM
is enabled in device_resume_early(). The noirq phases run after the
'late' and before the 'early' phase of suspend/resume. When the genpds
are resumed in genpd_resume_noirq(), we call down into gdsc_enable()
that calls pm_runtime_resume_and_get() and that returns -EACCES to
indicate failure to resume because runtime PM is disabled for all
devices.

Upon closer inspection, calling runtime PM APIs like this in the GDSC
driver doesn't make sense. It was intended to make sure the GDSC for the
clock controller providing other GDSCs was enabled, specifically the
MMCX GDSC for the display clk controller on SM8250 (sm8250-dispcc), so
that GDSC register accesses succeeded. That will already happen because
we make the 'dev->pm_domain' a parent domain of each GDSC we register in
gdsc_register() via pm_genpd_add_subdomain(). When any of these GDSCs
are accessed, we'll enable the parent domain (in this specific case
MMCX).

We also remove any getting of runtime PM during registration, because
when a genpd is registered it increments the count on the parent if the
genpd itself is already enabled.

Cc: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Cc: Johan Hovold <johan+linaro@kernel.org>
Cc: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Taniya Das <quic_tdas@quicinc.com>
Cc: Satya Priya <quic_c_skakit@quicinc.com>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Tested-by: Douglas Anderson <dianders@chromium.org>
Cc: Matthias Kaehlcke <mka@chromium.org>
Reported-by: Stephen Boyd <swboyd@chromium.org>
Link: https://lore.kernel.org/r/CAE-0n52xbZeJ66RaKwggeRB57fUAwjvxGxfFMKOKJMKVyFTe+w@mail.gmail.com [1]
Fixes: 1b771839de05 ("clk: qcom: gdsc: enable optional power domain support")
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
Link: https://lore.kernel.org/r/20221103183030.3594899-1-swboyd@chromium.org
Tested-by: Johan Hovold <johan+linaro@kernel.org>
Reviewed-by: Johan Hovold <johan+linaro@kernel.org>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gdsc.c | 61 ++++-------------------------------------
 drivers/clk/qcom/gdsc.h |  2 --
 2 files changed, 6 insertions(+), 57 deletions(-)

diff --git a/drivers/clk/qcom/gdsc.c b/drivers/clk/qcom/gdsc.c
index 4b66ce0f1940..39b35058ad47 100644
--- a/drivers/clk/qcom/gdsc.c
+++ b/drivers/clk/qcom/gdsc.c
@@ -11,7 +11,6 @@
 #include <linux/kernel.h>
 #include <linux/ktime.h>
 #include <linux/pm_domain.h>
-#include <linux/pm_runtime.h>
 #include <linux/regmap.h>
 #include <linux/regulator/consumer.h>
 #include <linux/reset-controller.h>
@@ -56,22 +55,6 @@ enum gdsc_status {
 	GDSC_ON
 };
 
-static int gdsc_pm_runtime_get(struct gdsc *sc)
-{
-	if (!sc->dev)
-		return 0;
-
-	return pm_runtime_resume_and_get(sc->dev);
-}
-
-static int gdsc_pm_runtime_put(struct gdsc *sc)
-{
-	if (!sc->dev)
-		return 0;
-
-	return pm_runtime_put_sync(sc->dev);
-}
-
 /* Returns 1 if GDSC status is status, 0 if not, and < 0 on error */
 static int gdsc_check_status(struct gdsc *sc, enum gdsc_status status)
 {
@@ -271,8 +254,9 @@ static void gdsc_retain_ff_on(struct gdsc *sc)
 	regmap_update_bits(sc->regmap, sc->gdscr, mask, mask);
 }
 
-static int _gdsc_enable(struct gdsc *sc)
+static int gdsc_enable(struct generic_pm_domain *domain)
 {
+	struct gdsc *sc = domain_to_gdsc(domain);
 	int ret;
 
 	if (sc->pwrsts == PWRSTS_ON)
@@ -328,22 +312,11 @@ static int _gdsc_enable(struct gdsc *sc)
 	return 0;
 }
 
-static int gdsc_enable(struct generic_pm_domain *domain)
+static int gdsc_disable(struct generic_pm_domain *domain)
 {
 	struct gdsc *sc = domain_to_gdsc(domain);
 	int ret;
 
-	ret = gdsc_pm_runtime_get(sc);
-	if (ret)
-		return ret;
-
-	return _gdsc_enable(sc);
-}
-
-static int _gdsc_disable(struct gdsc *sc)
-{
-	int ret;
-
 	if (sc->pwrsts == PWRSTS_ON)
 		return gdsc_assert_reset(sc);
 
@@ -378,18 +351,6 @@ static int _gdsc_disable(struct gdsc *sc)
 	return 0;
 }
 
-static int gdsc_disable(struct generic_pm_domain *domain)
-{
-	struct gdsc *sc = domain_to_gdsc(domain);
-	int ret;
-
-	ret = _gdsc_disable(sc);
-
-	gdsc_pm_runtime_put(sc);
-
-	return ret;
-}
-
 static int gdsc_init(struct gdsc *sc)
 {
 	u32 mask, val;
@@ -437,11 +398,6 @@ static int gdsc_init(struct gdsc *sc)
 				return ret;
 		}
 
-		/* ...and the power-domain */
-		ret = gdsc_pm_runtime_get(sc);
-		if (ret)
-			goto err_disable_supply;
-
 		/*
 		 * Votable GDSCs can be ON due to Vote from other masters.
 		 * If a Votable GDSC is ON, make sure we have a Vote.
@@ -449,14 +405,14 @@ static int gdsc_init(struct gdsc *sc)
 		if (sc->flags & VOTABLE) {
 			ret = gdsc_update_collapse_bit(sc, false);
 			if (ret)
-				goto err_put_rpm;
+				goto err_disable_supply;
 		}
 
 		/* Turn on HW trigger mode if supported */
 		if (sc->flags & HW_CTRL) {
 			ret = gdsc_hwctrl(sc, true);
 			if (ret < 0)
-				goto err_put_rpm;
+				goto err_disable_supply;
 		}
 
 		/*
@@ -486,13 +442,10 @@ static int gdsc_init(struct gdsc *sc)
 
 	ret = pm_genpd_init(&sc->pd, NULL, !on);
 	if (ret)
-		goto err_put_rpm;
+		goto err_disable_supply;
 
 	return 0;
 
-err_put_rpm:
-	if (on)
-		gdsc_pm_runtime_put(sc);
 err_disable_supply:
 	if (on && sc->rsupply)
 		regulator_disable(sc->rsupply);
@@ -531,8 +484,6 @@ int gdsc_register(struct gdsc_desc *desc,
 	for (i = 0; i < num; i++) {
 		if (!scs[i])
 			continue;
-		if (pm_runtime_enabled(dev))
-			scs[i]->dev = dev;
 		scs[i]->regmap = regmap;
 		scs[i]->rcdev = rcdev;
 		ret = gdsc_init(scs[i]);
diff --git a/drivers/clk/qcom/gdsc.h b/drivers/clk/qcom/gdsc.h
index 5de48c9439b2..8d569232bbd6 100644
--- a/drivers/clk/qcom/gdsc.h
+++ b/drivers/clk/qcom/gdsc.h
@@ -30,7 +30,6 @@ struct reset_controller_dev;
  * @resets: ids of resets associated with this gdsc
  * @reset_count: number of @resets
  * @rcdev: reset controller
- * @dev: the device holding the GDSC, used for pm_runtime calls
  */
 struct gdsc {
 	struct generic_pm_domain	pd;
@@ -69,7 +68,6 @@ struct gdsc {
 
 	const char 			*supply;
 	struct regulator		*rsupply;
-	struct device			*dev;
 };
 
 struct gdsc_desc {
-- 
2.35.1




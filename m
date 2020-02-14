Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10FAD15F10B
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 19:00:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387951AbgBNP4m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 10:56:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:38670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387941AbgBNP4m (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 10:56:42 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E6423222C4;
        Fri, 14 Feb 2020 15:56:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581695801;
        bh=BahF8te1RYAssLJXqN29Xd37PKdX5pcjbSGFsiGGhgk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F6yf8KD0+Ci0e3Atv8SaXMXK5Axbe0xA4h3d3Fy23llOwniAMP3+SsuIg8PNOJF7c
         KLHkLqncpKScfpyLue4zB/e6fa3BRtwEyd7Yti/qplfStwnuYC+TKwBAUUSJpU7QHk
         pv5NjvioEJUfWz012OanKP1BKkV2i/p6HNG1nNUI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Stephen Boyd <swboyd@chromium.org>,
        Thierry Reding <treding@nvidia.com>,
        Brian Masney <masneyb@onstation.org>,
        Lina Iyer <ilina@codeaurora.org>,
        Marc Zyngier <maz@kernel.org>,
        Maulik Shah <mkshah@codeaurora.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-gpio@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 361/542] gpiolib: Set lockdep class for hierarchical irq domains
Date:   Fri, 14 Feb 2020 10:45:53 -0500
Message-Id: <20200214154854.6746-361-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214154854.6746-1-sashal@kernel.org>
References: <20200214154854.6746-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stephen Boyd <swboyd@chromium.org>

[ Upstream commit c34f6dc8c9e6bbe9fba1d53acd6d9a3889599da3 ]

I see the following lockdep splat in the qcom pinctrl driver when
attempting to suspend the device.

 ============================================
 WARNING: possible recursive locking detected
 5.4.2 #2 Tainted: G S
 --------------------------------------------
 cat/6536 is trying to acquire lock:
 ffffff814787ccc0 (&irq_desc_lock_class){-.-.}, at: __irq_get_desc_lock+0x64/0x94

 but task is already holding lock:
 ffffff81436740c0 (&irq_desc_lock_class){-.-.}, at: __irq_get_desc_lock+0x64/0x94

 other info that might help us debug this:
  Possible unsafe locking scenario:

        CPU0
        ----
   lock(&irq_desc_lock_class);
   lock(&irq_desc_lock_class);

  *** DEADLOCK ***

  May be due to missing lock nesting notation

 7 locks held by cat/6536:
  #0: ffffff8140e0c420 (sb_writers#7){.+.+}, at: vfs_write+0xc8/0x19c
  #1: ffffff8121eec480 (&of->mutex){+.+.}, at: kernfs_fop_write+0x128/0x1f4
  #2: ffffff8147cad668 (kn->count#263){.+.+}, at: kernfs_fop_write+0x130/0x1f4
  #3: ffffffd011446000 (system_transition_mutex){+.+.}, at: pm_suspend+0x108/0x354
  #4: ffffff814302b970 (&dev->mutex){....}, at: __device_suspend+0x16c/0x420
  #5: ffffff81436740c0 (&irq_desc_lock_class){-.-.}, at: __irq_get_desc_lock+0x64/0x94
  #6: ffffff81479b8c10 (&pctrl->lock){....}, at: msm_gpio_irq_set_wake+0x48/0x7c

 stack backtrace:
 CPU: 4 PID: 6536 Comm: cat Tainted: G S                5.4.2 #2
 Call trace:
  dump_backtrace+0x0/0x174
  show_stack+0x20/0x2c
  dump_stack+0xdc/0x144
  __lock_acquire+0x52c/0x2268
  lock_acquire+0x1dc/0x220
  _raw_spin_lock_irqsave+0x64/0x80
  __irq_get_desc_lock+0x64/0x94
  irq_set_irq_wake+0x40/0x144
  msm_gpio_irq_set_wake+0x5c/0x7c
  set_irq_wake_real+0x40/0x5c
  irq_set_irq_wake+0x70/0x144
  cros_ec_rtc_suspend+0x38/0x4c
  platform_pm_suspend+0x34/0x60
  dpm_run_callback+0x64/0xcc
  __device_suspend+0x314/0x420
  dpm_suspend+0xf8/0x298
  dpm_suspend_start+0x84/0xb4
  suspend_devices_and_enter+0xbc/0x628
  pm_suspend+0x214/0x354
  state_store+0xb0/0x108
  kobj_attr_store+0x14/0x24
  sysfs_kf_write+0x4c/0x64
  kernfs_fop_write+0x158/0x1f4
  __vfs_write+0x54/0x18c
  vfs_write+0xdc/0x19c
  ksys_write+0x7c/0xe4
  __arm64_sys_write+0x20/0x2c
  el0_svc_common+0xa8/0x160
  el0_svc_compat_handler+0x2c/0x38
  el0_svc_compat+0x8/0x10

This is because the msm_gpio_irq_set_wake() function calls
irq_set_irq_wake() as a backup in case the irq comes in during the path
to idle. Given that we're calling irqchip functions from within an
irqchip we need to set the lockdep class to be different for this child
controller vs. the default one that the parent irqchip gets.

This used to be done before this driver was converted to hierarchical
irq domains in commit e35a6ae0eb3a ("pinctrl/msm: Setup GPIO chip in
hierarchy") via the gpiochip_irq_map() function. With hierarchical irq
domains this function has been replaced by
gpiochip_hierarchy_irq_domain_alloc(). Therefore, set the lockdep class
like was done previously in the irq domain path so we can avoid this
lockdep warning.

Fixes: fdd61a013a24 ("gpio: Add support for hierarchical IRQ domains")
Cc: Thierry Reding <treding@nvidia.com>
Cc: Brian Masney <masneyb@onstation.org>
Cc: Lina Iyer <ilina@codeaurora.org>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Maulik Shah <mkshah@codeaurora.org>
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
Link: https://lore.kernel.org/r/20200114231103.85641-1-swboyd@chromium.org
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpiolib.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 78a16e42f222e..0bfb4f9083993 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -2053,6 +2053,7 @@ static int gpiochip_hierarchy_irq_domain_alloc(struct irq_domain *d,
 				     parent_type);
 	chip_info(gc, "alloc_irqs_parent for %d parent hwirq %d\n",
 		  irq, parent_hwirq);
+	irq_set_lockdep_class(irq, gc->irq.lock_key, gc->irq.request_key);
 	ret = irq_domain_alloc_irqs_parent(d, irq, 1, &parent_fwspec);
 	if (ret)
 		chip_err(gc,
-- 
2.20.1


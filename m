Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F7F616315E
	for <lists+stable@lfdr.de>; Tue, 18 Feb 2020 21:01:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727668AbgBRT7v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Feb 2020 14:59:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:38722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728483AbgBRT7u (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 18 Feb 2020 14:59:50 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EB1072464E;
        Tue, 18 Feb 2020 19:59:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582055989;
        bh=KDjerKczOZHWwPnuBGNxgXOG0D9QiJQCmyfpxvInpYo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tOtbGxPjdKhJeRJh5hreSYAfyyVGSpXTYcffSic8TIGxPoJjrqJeVEslpUoKfl9/b
         W8TnXGLwUjLTpVaRvHNMKmwuyQNB0GoLdvzhZpfrvyGa6zJkk+8LXItK0tgKpCNJuA
         owOVZaW3/Xtukmd+wPRb4Pl47mmXByT4/tiyBiq4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Douglas Anderson <dianders@chromium.org>,
        Brian Masney <masneyb@onstation.org>,
        Lina Iyer <ilina@codeaurora.org>,
        Maulik Shah <mkshah@codeaurora.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Stephen Boyd <swboyd@chromium.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 5.4 51/66] spmi: pmic-arb: Set lockdep class for hierarchical irq domains
Date:   Tue, 18 Feb 2020 20:55:18 +0100
Message-Id: <20200218190432.763926947@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200218190428.035153861@linuxfoundation.org>
References: <20200218190428.035153861@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stephen Boyd <swboyd@chromium.org>

commit 2d5a2f913b658a7ae984773a63318ed4daadf4af upstream.

I see the following lockdep splat in the qcom pinctrl driver when
attempting to suspend the device.

 WARNING: possible recursive locking detected
 5.4.11 #3 Tainted: G        W
 --------------------------------------------
 cat/3074 is trying to acquire lock:
 ffffff81f49804c0 (&irq_desc_lock_class){-.-.}, at: __irq_get_desc_lock+0x64/0x94

 but task is already holding lock:
 ffffff81f1cc10c0 (&irq_desc_lock_class){-.-.}, at: __irq_get_desc_lock+0x64/0x94

 other info that might help us debug this:
  Possible unsafe locking scenario:

        CPU0
        ----
   lock(&irq_desc_lock_class);
   lock(&irq_desc_lock_class);

  *** DEADLOCK ***

  May be due to missing lock nesting notation

 6 locks held by cat/3074:
  #0: ffffff81f01d9420 (sb_writers#7){.+.+}, at: vfs_write+0xd0/0x1a4
  #1: ffffff81bd7d2080 (&of->mutex){+.+.}, at: kernfs_fop_write+0x12c/0x1fc
  #2: ffffff81f4c322f0 (kn->count#337){.+.+}, at: kernfs_fop_write+0x134/0x1fc
  #3: ffffffe411a41d60 (system_transition_mutex){+.+.}, at: pm_suspend+0x108/0x348
  #4: ffffff81f1c5e970 (&dev->mutex){....}, at: __device_suspend+0x168/0x41c
  #5: ffffff81f1cc10c0 (&irq_desc_lock_class){-.-.}, at: __irq_get_desc_lock+0x64/0x94

 stack backtrace:
 CPU: 5 PID: 3074 Comm: cat Tainted: G        W         5.4.11 #3
 Hardware name: Google Cheza (rev3+) (DT)
 Call trace:
  dump_backtrace+0x0/0x174
  show_stack+0x20/0x2c
  dump_stack+0xc8/0x124
  __lock_acquire+0x460/0x2388
  lock_acquire+0x1cc/0x210
  _raw_spin_lock_irqsave+0x64/0x80
  __irq_get_desc_lock+0x64/0x94
  irq_set_irq_wake+0x40/0x144
  qpnpint_irq_set_wake+0x28/0x34
  set_irq_wake_real+0x40/0x5c
  irq_set_irq_wake+0x70/0x144
  pm8941_pwrkey_suspend+0x34/0x44
  platform_pm_suspend+0x34/0x60
  dpm_run_callback+0x64/0xcc
  __device_suspend+0x310/0x41c
  dpm_suspend+0xf8/0x298
  dpm_suspend_start+0x84/0xb4
  suspend_devices_and_enter+0xbc/0x620
  pm_suspend+0x210/0x348
  state_store+0xb0/0x108
  kobj_attr_store+0x14/0x24
  sysfs_kf_write+0x4c/0x64
  kernfs_fop_write+0x15c/0x1fc
  __vfs_write+0x54/0x18c
  vfs_write+0xe4/0x1a4
  ksys_write+0x7c/0xe4
  __arm64_sys_write+0x20/0x2c
  el0_svc_common+0xa8/0x160
  el0_svc_handler+0x7c/0x98
  el0_svc+0x8/0xc

Set a lockdep class when we map the irq so that irq_set_wake() doesn't
warn about a lockdep bug that doesn't exist.

Fixes: 12a9eeaebba3 ("spmi: pmic-arb: convert to v2 irq interfaces to support hierarchical IRQ chips")
Cc: Douglas Anderson <dianders@chromium.org>
Cc: Brian Masney <masneyb@onstation.org>
Cc: Lina Iyer <ilina@codeaurora.org>
Cc: Maulik Shah <mkshah@codeaurora.org>
Cc: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
Link: https://lore.kernel.org/r/20200121183748.68662-1-swboyd@chromium.org
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/spmi/spmi-pmic-arb.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/spmi/spmi-pmic-arb.c
+++ b/drivers/spmi/spmi-pmic-arb.c
@@ -731,6 +731,7 @@ static int qpnpint_irq_domain_translate(
 	return 0;
 }
 
+static struct lock_class_key qpnpint_irq_lock_class, qpnpint_irq_request_class;
 
 static void qpnpint_irq_domain_map(struct spmi_pmic_arb *pmic_arb,
 				   struct irq_domain *domain, unsigned int virq,
@@ -746,6 +747,9 @@ static void qpnpint_irq_domain_map(struc
 	else
 		handler = handle_level_irq;
 
+
+	irq_set_lockdep_class(virq, &qpnpint_irq_lock_class,
+			      &qpnpint_irq_request_class);
 	irq_domain_set_info(domain, virq, hwirq, &pmic_arb_irqchip, pmic_arb,
 			    handler, NULL, NULL);
 }



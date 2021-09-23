Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EE9F41549A
	for <lists+stable@lfdr.de>; Thu, 23 Sep 2021 02:26:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238612AbhIWA1j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Sep 2021 20:27:39 -0400
Received: from mo-csw1115.securemx.jp ([210.130.202.157]:59352 "EHLO
        mo-csw.securemx.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234042AbhIWA1i (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Sep 2021 20:27:38 -0400
Received: by mo-csw.securemx.jp (mx-mo-csw1115) id 18N0PpUW002175; Thu, 23 Sep 2021 09:25:51 +0900
X-Iguazu-Qid: 2wHHK91O7mjF8JETEe
X-Iguazu-QSIG: v=2; s=0; t=1632356751; q=2wHHK91O7mjF8JETEe; m=iRswzK/Nl7gBakB/oOZjnsstwolVtQjNNyEDFghsLX0=
Received: from imx12-a.toshiba.co.jp (imx12-a.toshiba.co.jp [61.202.160.135])
        by relay.securemx.jp (mx-mr1113) id 18N0PnPo019498
        (version=TLSv1.2 cipher=AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 23 Sep 2021 09:25:50 +0900
Received: from enc02.toshiba.co.jp (enc02.toshiba.co.jp [61.202.160.51])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by imx12-a.toshiba.co.jp (Postfix) with ESMTPS id B171F1000ED;
        Thu, 23 Sep 2021 09:25:33 +0900 (JST)
Received: from hop101.toshiba.co.jp ([133.199.85.107])
        by enc02.toshiba.co.jp  with ESMTP id 18N0PX6u023220;
        Thu, 23 Sep 2021 09:25:33 +0900
From:   Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
To:     stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, sashal@kernel.org,
        Tony Lindgren <tony@atomide.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Subject: [PATCH for 4.4 and 4.9] PM / wakeirq: Fix unbalanced IRQ enable for wakeirq
Date:   Thu, 23 Sep 2021 09:25:22 +0900
X-TSB-HOP: ON
Message-Id: <20210923002522.29648-1-nobuhiro1.iwamatsu@toshiba.co.jp>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tony Lindgren <tony@atomide.com>

commit 69728051f5bf15efaf6edfbcfe1b5a49a2437918 upstream

If a device is runtime PM suspended when we enter suspend and has
a dedicated wake IRQ, we can get the following warning:

WARNING: CPU: 0 PID: 108 at kernel/irq/manage.c:526 enable_irq+0x40/0x94
[  102.087860] Unbalanced enable for IRQ 147
...
(enable_irq) from [<c06117a8>] (dev_pm_arm_wake_irq+0x4c/0x60)
(dev_pm_arm_wake_irq) from [<c0618360>]
 (device_wakeup_arm_wake_irqs+0x58/0x9c)
(device_wakeup_arm_wake_irqs) from [<c0615948>]
(dpm_suspend_noirq+0x10/0x48)
(dpm_suspend_noirq) from [<c01ac7ac>]
(suspend_devices_and_enter+0x30c/0xf14)
(suspend_devices_and_enter) from [<c01adf20>]
(enter_state+0xad4/0xbd8)
(enter_state) from [<c01ad3ec>] (pm_suspend+0x38/0x98)
(pm_suspend) from [<c01ab3e8>] (state_store+0x68/0xc8)

This is because the dedicated wake IRQ for the device may have been
already enabled earlier by dev_pm_enable_wake_irq_check().  Fix the
issue by checking for runtime PM suspended status.

This issue can be easily reproduced by setting serial console log level
to zero, letting the serial console idle, and suspend the system from
an ssh terminal.  On resume, dmesg will have the warning above.

The reason why I have not run into this issue earlier has been that I
typically run my PM test cases from on a serial console instead over ssh.

Fixes: c84345597558 (PM / wakeirq: Enable dedicated wakeirq for suspend)
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Nobuhiro Iwamatsu (CIP) <nobuhiro1.iwamatsu@toshiba.co.jp>
---
 drivers/base/power/wakeirq.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/base/power/wakeirq.c b/drivers/base/power/wakeirq.c
index ee63ccaea8d57a..8c05e7a5e777b5 100644
--- a/drivers/base/power/wakeirq.c
+++ b/drivers/base/power/wakeirq.c
@@ -320,7 +320,8 @@ void dev_pm_arm_wake_irq(struct wake_irq *wirq)
 		return;
 
 	if (device_may_wakeup(wirq->dev)) {
-		if (wirq->status & WAKE_IRQ_DEDICATED_ALLOCATED)
+		if (wirq->status & WAKE_IRQ_DEDICATED_ALLOCATED &&
+		    !pm_runtime_status_suspended(wirq->dev))
 			enable_irq(wirq->irq);
 
 		enable_irq_wake(wirq->irq);
@@ -342,7 +343,8 @@ void dev_pm_disarm_wake_irq(struct wake_irq *wirq)
 	if (device_may_wakeup(wirq->dev)) {
 		disable_irq_wake(wirq->irq);
 
-		if (wirq->status & WAKE_IRQ_DEDICATED_ALLOCATED)
+		if (wirq->status & WAKE_IRQ_DEDICATED_ALLOCATED &&
+		    !pm_runtime_status_suspended(wirq->dev))
 			disable_irq_nosync(wirq->irq);
 	}
 }
-- 
2.33.0



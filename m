Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6420F41725A
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 14:48:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344059AbhIXMro (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 08:47:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:42730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343984AbhIXMqz (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Sep 2021 08:46:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 438F96124B;
        Fri, 24 Sep 2021 12:45:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632487522;
        bh=VG+frtPWR7Hugbx58zvTwHatZg/pksRVcznDr+TupUc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U4sR+070Qzs4lze3TX+jptruSkPS6moEed3OZKlssDq7fxEnAN3zxXcUC9Uom9LjF
         RS+2iW4ypNtgV6r9wJHr7+MzdmNGFnCCOH+D8Sq7l/BQfwVnyu0jVYOslQR4gUe9vs
         ZL4Ak7wANv3rPkmiOFdX+I0XyQHhWr/OihXEXqoA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tony Lindgren <tony@atomide.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        "Nobuhiro Iwamatsu (CIP)" <nobuhiro1.iwamatsu@toshiba.co.jp>
Subject: [PATCH 4.9 02/26] PM / wakeirq: Fix unbalanced IRQ enable for wakeirq
Date:   Fri, 24 Sep 2021 14:43:50 +0200
Message-Id: <20210924124328.421778398@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210924124328.336953942@linuxfoundation.org>
References: <20210924124328.336953942@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tony Lindgren <tony@atomide.com>

commit 69728051f5bf15efaf6edfbcfe1b5a49a2437918 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/power/wakeirq.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/base/power/wakeirq.c
+++ b/drivers/base/power/wakeirq.c
@@ -320,7 +320,8 @@ void dev_pm_arm_wake_irq(struct wake_irq
 		return;
 
 	if (device_may_wakeup(wirq->dev)) {
-		if (wirq->status & WAKE_IRQ_DEDICATED_ALLOCATED)
+		if (wirq->status & WAKE_IRQ_DEDICATED_ALLOCATED &&
+		    !pm_runtime_status_suspended(wirq->dev))
 			enable_irq(wirq->irq);
 
 		enable_irq_wake(wirq->irq);
@@ -342,7 +343,8 @@ void dev_pm_disarm_wake_irq(struct wake_
 	if (device_may_wakeup(wirq->dev)) {
 		disable_irq_wake(wirq->irq);
 
-		if (wirq->status & WAKE_IRQ_DEDICATED_ALLOCATED)
+		if (wirq->status & WAKE_IRQ_DEDICATED_ALLOCATED &&
+		    !pm_runtime_status_suspended(wirq->dev))
 			disable_irq_nosync(wirq->irq);
 	}
 }



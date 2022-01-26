Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBC2749C9ED
	for <lists+stable@lfdr.de>; Wed, 26 Jan 2022 13:43:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241443AbiAZMnY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jan 2022 07:43:24 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:58366 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234178AbiAZMnW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Jan 2022 07:43:22 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1FB87B81CD5
        for <stable@vger.kernel.org>; Wed, 26 Jan 2022 12:43:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AB5CC340E6;
        Wed, 26 Jan 2022 12:43:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643200999;
        bh=uYljL53p37oDAXJUSBAwQO8Fx45TbNChjIWnMJ2/fho=;
        h=Subject:To:From:Date:From;
        b=i4C7eXNtUW0ablx3U6tyrq9xnBpOEk0npGQs3YXocBrqPVe5lRW07Qr4nj71Wrh4u
         vve2Vv/ry1SHIjOOuKRGdHbNpvvKhwNK7APaiazn+cuJDx/oH7HQroQigBsJNbupcA
         Gcg8w6Pzni1C1aQ7xjjANB7eE3lbMpGQwpLfk6j0=
Subject: patch "usb: xhci-plat: fix crash when suspend if remote wake enable" added to usb-linus
To:     Frank.Li@nxp.com, abel.vesa@nxp.com, gregkh@linuxfoundation.org,
        peter.chen@kernel.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 26 Jan 2022 13:43:07 +0100
Message-ID: <164320098710840@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: xhci-plat: fix crash when suspend if remote wake enable

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 9df478463d9feb90dae24f183383961cf123a0ec Mon Sep 17 00:00:00 2001
From: Frank Li <Frank.Li@nxp.com>
Date: Mon, 10 Jan 2022 11:27:38 -0600
Subject: usb: xhci-plat: fix crash when suspend if remote wake enable

Crashed at i.mx8qm platform when suspend if enable remote wakeup

Internal error: synchronous external abort: 96000210 [#1] PREEMPT SMP
Modules linked in:
CPU: 2 PID: 244 Comm: kworker/u12:6 Not tainted 5.15.5-dirty #12
Hardware name: Freescale i.MX8QM MEK (DT)
Workqueue: events_unbound async_run_entry_fn
pstate: 600000c5 (nZCv daIF -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : xhci_disable_hub_port_wake.isra.62+0x60/0xf8
lr : xhci_disable_hub_port_wake.isra.62+0x34/0xf8
sp : ffff80001394bbf0
x29: ffff80001394bbf0 x28: 0000000000000000 x27: ffff00081193b578
x26: ffff00081193b570 x25: 0000000000000000 x24: 0000000000000000
x23: ffff00081193a29c x22: 0000000000020001 x21: 0000000000000001
x20: 0000000000000000 x19: ffff800014e90490 x18: 0000000000000000
x17: 0000000000000000 x16: 0000000000000000 x15: 0000000000000000
x14: 0000000000000000 x13: 0000000000000002 x12: 0000000000000000
x11: 0000000000000000 x10: 0000000000000960 x9 : ffff80001394baa0
x8 : ffff0008145d1780 x7 : ffff0008f95b8e80 x6 : 000000001853b453
x5 : 0000000000000496 x4 : 0000000000000000 x3 : ffff00081193a29c
x2 : 0000000000000001 x1 : 0000000000000000 x0 : ffff000814591620
Call trace:
 xhci_disable_hub_port_wake.isra.62+0x60/0xf8
 xhci_suspend+0x58/0x510
 xhci_plat_suspend+0x50/0x78
 platform_pm_suspend+0x2c/0x78
 dpm_run_callback.isra.25+0x50/0xe8
 __device_suspend+0x108/0x3c0

The basic flow:
	1. run time suspend call xhci_suspend, xhci parent devices gate the clock.
        2. echo mem >/sys/power/state, system _device_suspend call xhci_suspend
        3. xhci_suspend call xhci_disable_hub_port_wake, which access register,
	   but clock already gated by run time suspend.

This problem was hidden by power domain driver, which call run time resume before it.

But the below commit remove it and make this issue happen.
	commit c1df456d0f06e ("PM: domains: Don't runtime resume devices at genpd_prepare()")

This patch call run time resume before suspend to make sure clock is on
before access register.

Reviewed-by: Peter Chen <peter.chen@kernel.org>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Testeb-by: Abel Vesa <abel.vesa@nxp.com>
Link: https://lore.kernel.org/r/20220110172738.31686-1-Frank.Li@nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-plat.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/usb/host/xhci-plat.c b/drivers/usb/host/xhci-plat.c
index c1edcc9b13ce..dc570ce4e831 100644
--- a/drivers/usb/host/xhci-plat.c
+++ b/drivers/usb/host/xhci-plat.c
@@ -437,6 +437,9 @@ static int __maybe_unused xhci_plat_suspend(struct device *dev)
 	struct xhci_hcd	*xhci = hcd_to_xhci(hcd);
 	int ret;
 
+	if (pm_runtime_suspended(dev))
+		pm_runtime_resume(dev);
+
 	ret = xhci_priv_suspend_quirk(hcd);
 	if (ret)
 		return ret;
-- 
2.35.0



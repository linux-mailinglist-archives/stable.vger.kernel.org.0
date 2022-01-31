Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9ED874A44EF
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:35:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358926AbiAaLfJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:35:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379032AbiAaL3o (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:29:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E852BC061783;
        Mon, 31 Jan 2022 03:19:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 87F6C61257;
        Mon, 31 Jan 2022 11:19:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69760C340E8;
        Mon, 31 Jan 2022 11:18:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643627940;
        bh=YP3uc33jwRUfDk9XScnitxmKQ9R/hWEnLuZ4nu+AswA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XNXNhDwspRyqwa/hhixWOECiczQnsPh0TNsIso/nH6zdCgayojasnmmSRLzsfUrkW
         u6IHoElt+DbGQtqk4prVn3GZI6gOZJdvktIdAWkzyKMrdSQ6m9U4EN7UNm8SEyoUO4
         ftY+2rD9YzJ/3W+rugmokQgfBgYfph64jDwR+w8E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Chen <peter.chen@kernel.org>,
        Frank Li <Frank.Li@nxp.com>, Abel Vesa <abel.vesa@nxp.com>
Subject: [PATCH 5.16 074/200] usb: xhci-plat: fix crash when suspend if remote wake enable
Date:   Mon, 31 Jan 2022 11:55:37 +0100
Message-Id: <20220131105236.075903042@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105233.561926043@linuxfoundation.org>
References: <20220131105233.561926043@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Frank Li <Frank.Li@nxp.com>

commit 9df478463d9feb90dae24f183383961cf123a0ec upstream.

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
 drivers/usb/host/xhci-plat.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/usb/host/xhci-plat.c
+++ b/drivers/usb/host/xhci-plat.c
@@ -437,6 +437,9 @@ static int __maybe_unused xhci_plat_susp
 	struct xhci_hcd	*xhci = hcd_to_xhci(hcd);
 	int ret;
 
+	if (pm_runtime_suspended(dev))
+		pm_runtime_resume(dev);
+
 	ret = xhci_priv_suspend_quirk(hcd);
 	if (ret)
 		return ret;



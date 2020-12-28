Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8C3B2E3833
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:07:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729955AbgL1NG6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:06:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:34088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730902AbgL1NGR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:06:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 452622242A;
        Mon, 28 Dec 2020 13:05:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609160736;
        bh=XZu/RfXgrQUn15ODtgxjJO1SY6eMoKONJ8bSIgYEhkg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wY7fVwST8Ribx6oWkGxbpU77mQe+Bwr9BovjHZn2qqDZPdL9CZfp7mXckd74Xux7B
         v/gg6DR3Jl3R67zjTDuFbFOAbqu37D98lk863TXPooQMYhk9KQh+JACTv0qFzqflwG
         p+w7CJ04k3yuw86ue/m4bMR2l8BmgSeSjgfSv6fI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 123/175] watchdog: qcom: Avoid context switch in restart handler
Date:   Mon, 28 Dec 2020 13:49:36 +0100
Message-Id: <20201228124859.217268858@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124853.216621466@linuxfoundation.org>
References: <20201228124853.216621466@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

[ Upstream commit 7948fab26bcc468aa2a76462f441291b5fb0d5c7 ]

The use of msleep() in the restart handler will cause scheduler to
induce a context switch which is not desirable. This generates below
warning on SDX55 when WDT is the only available restart source:

[   39.800188] reboot: Restarting system
[   39.804115] ------------[ cut here ]------------
[   39.807855] WARNING: CPU: 0 PID: 678 at kernel/rcu/tree_plugin.h:297 rcu_note_context_switch+0x190/0x764
[   39.812538] Modules linked in:
[   39.821954] CPU: 0 PID: 678 Comm: reboot Not tainted 5.10.0-rc1-00063-g33a9990d1d66-dirty #47
[   39.824854] Hardware name: Generic DT based system
[   39.833470] [<c0310fbc>] (unwind_backtrace) from [<c030c544>] (show_stack+0x10/0x14)
[   39.838154] [<c030c544>] (show_stack) from [<c0c218f0>] (dump_stack+0x8c/0xa0)
[   39.846049] [<c0c218f0>] (dump_stack) from [<c0322f80>] (__warn+0xd8/0xf0)
[   39.853058] [<c0322f80>] (__warn) from [<c0c1dc08>] (warn_slowpath_fmt+0x64/0xc8)
[   39.859925] [<c0c1dc08>] (warn_slowpath_fmt) from [<c038b6f4>] (rcu_note_context_switch+0x190/0x764)
[   39.867503] [<c038b6f4>] (rcu_note_context_switch) from [<c0c2aa3c>] (__schedule+0x84/0x640)
[   39.876685] [<c0c2aa3c>] (__schedule) from [<c0c2b050>] (schedule+0x58/0x10c)
[   39.885095] [<c0c2b050>] (schedule) from [<c0c2eed0>] (schedule_timeout+0x1e8/0x3d4)
[   39.892135] [<c0c2eed0>] (schedule_timeout) from [<c039ad40>] (msleep+0x2c/0x38)
[   39.899947] [<c039ad40>] (msleep) from [<c0a59d0c>] (qcom_wdt_restart+0xc4/0xcc)
[   39.907319] [<c0a59d0c>] (qcom_wdt_restart) from [<c0a58290>] (watchdog_restart_notifier+0x18/0x28)
[   39.914715] [<c0a58290>] (watchdog_restart_notifier) from [<c03468e0>] (atomic_notifier_call_chain+0x60/0x84)
[   39.923487] [<c03468e0>] (atomic_notifier_call_chain) from [<c030ae64>] (machine_restart+0x78/0x7c)
[   39.933551] [<c030ae64>] (machine_restart) from [<c0348048>] (__do_sys_reboot+0xdc/0x1e0)
[   39.942397] [<c0348048>] (__do_sys_reboot) from [<c0300060>] (ret_fast_syscall+0x0/0x54)
[   39.950721] Exception stack(0xc3e0bfa8 to 0xc3e0bff0)
[   39.958855] bfa0:                   0001221c bed2fe24 fee1dead 28121969 01234567 00000000
[   39.963832] bfc0: 0001221c bed2fe24 00000003 00000058 000225e0 00000000 00000000 00000000
[   39.971985] bfe0: b6e62560 bed2fc84 00010fd8 b6e62580
[   39.980124] ---[ end trace 3f578288bad866e4 ]---

Hence, replace msleep() with mdelay() to fix this issue.

Fixes: 05e487d905ab ("watchdog: qcom: register a restart notifier")
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/r/20201207060005.21293-1-manivannan.sadhasivam@linaro.org
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Wim Van Sebroeck <wim@linux-watchdog.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/watchdog/qcom-wdt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/watchdog/qcom-wdt.c b/drivers/watchdog/qcom-wdt.c
index 4f47b5e909566..8b88824a88dc2 100644
--- a/drivers/watchdog/qcom-wdt.c
+++ b/drivers/watchdog/qcom-wdt.c
@@ -121,7 +121,7 @@ static int qcom_wdt_restart(struct watchdog_device *wdd, unsigned long action,
 	 */
 	wmb();
 
-	msleep(150);
+	mdelay(150);
 	return 0;
 }
 
-- 
2.27.0




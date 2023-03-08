Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFBDB6B0A0D
	for <lists+stable@lfdr.de>; Wed,  8 Mar 2023 14:54:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231910AbjCHNyd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Mar 2023 08:54:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231717AbjCHNxl (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Mar 2023 08:53:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8FB797FDB;
        Wed,  8 Mar 2023 05:53:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BCC2A61846;
        Wed,  8 Mar 2023 13:53:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E77DC433A4;
        Wed,  8 Mar 2023 13:53:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678283595;
        bh=cMc+h0EdzLDs1AgWG9sov4h4C2Yo60GqELjLDqqHhHg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i4PvweL9GMAjMZaUE3xB0IDBpvd7K47lcHdsFIcWzO3l8lfJcw6c2XWdjMkxbE6bc
         zZd4OsFnipNk+UqoMFnP8UZGRNVU8QYNduOSCurX473EsdIKmnQnq9IOG7cP7WYB6O
         BS0arZ+3CvHAvNfCpVViSjVUuB8aRx1/5PGkEwibp67aA0BqYNmZ0rzBRYhm1qsaNE
         hWbQ7aVEJdOHXhcXUB2EAtVgqL89NSTxMBNwKcudjyIDsDcvhFp/l9oOXJnr0u23K/
         +Cwc952FxxBFMmP+Mp+vgXMNk+99JXJywWpwruAQ1+Kj6+it2AL4utAtSBjldGqxly
         Nzra5H2x8fS2Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Li Jun <jun.li@nxp.com>, Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 3/3] media: rc: gpio-ir-recv: add remove function
Date:   Wed,  8 Mar 2023 08:53:06 -0500
Message-Id: <20230308135309.2927462-3-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230308135309.2927462-1-sashal@kernel.org>
References: <20230308135309.2927462-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Li Jun <jun.li@nxp.com>

[ Upstream commit 30040818b338b8ebc956ce0ebd198f8d593586a6 ]

In case runtime PM is enabled, do runtime PM clean up to remove
cpu latency qos request, otherwise driver removal may have below
kernel dump:

[   19.463299] Unable to handle kernel NULL pointer dereference at
virtual address 0000000000000048
[   19.472161] Mem abort info:
[   19.474985]   ESR = 0x0000000096000004
[   19.478754]   EC = 0x25: DABT (current EL), IL = 32 bits
[   19.484081]   SET = 0, FnV = 0
[   19.487149]   EA = 0, S1PTW = 0
[   19.490361]   FSC = 0x04: level 0 translation fault
[   19.495256] Data abort info:
[   19.498149]   ISV = 0, ISS = 0x00000004
[   19.501997]   CM = 0, WnR = 0
[   19.504977] user pgtable: 4k pages, 48-bit VAs, pgdp=0000000049f81000
[   19.511432] [0000000000000048] pgd=0000000000000000,
p4d=0000000000000000
[   19.518245] Internal error: Oops: 0000000096000004 [#1] PREEMPT SMP
[   19.524520] Modules linked in: gpio_ir_recv(+) rc_core [last
unloaded: rc_core]
[   19.531845] CPU: 0 PID: 445 Comm: insmod Not tainted
6.2.0-rc1-00028-g2c397a46d47c #72
[   19.531854] Hardware name: FSL i.MX8MM EVK board (DT)
[   19.531859] pstate: 80000005 (Nzcv daif -PAN -UAO -TCO -DIT -SSBS
BTYPE=--)
[   19.551777] pc : cpu_latency_qos_remove_request+0x20/0x110
[   19.557277] lr : gpio_ir_recv_runtime_suspend+0x18/0x30
[gpio_ir_recv]
[   19.557294] sp : ffff800008ce3740
[   19.557297] x29: ffff800008ce3740 x28: 0000000000000000 x27:
ffff800008ce3d50
[   19.574270] x26: ffffc7e3e9cea100 x25: 00000000000f4240 x24:
ffffc7e3f9ef0e30
[   19.574284] x23: 0000000000000000 x22: ffff0061803820f4 x21:
0000000000000008
[   19.574296] x20: ffffc7e3fa75df30 x19: 0000000000000020 x18:
ffffffffffffffff
[   19.588570] x17: 0000000000000000 x16: ffffc7e3f9efab70 x15:
ffffffffffffffff
[   19.595712] x14: ffff800008ce37b8 x13: ffff800008ce37aa x12:
0000000000000001
[   19.602853] x11: 0000000000000001 x10: ffffcbe3ec0dff87 x9 :
0000000000000008
[   19.609991] x8 : 0101010101010101 x7 : 0000000000000000 x6 :
000000000f0bfe9f
[   19.624261] x5 : 00ffffffffffffff x4 : 0025ab8e00000000 x3 :
ffff006180382010
[   19.631405] x2 : ffffc7e3e9ce8030 x1 : ffffc7e3fc3eb810 x0 :
0000000000000020
[   19.638548] Call trace:
[   19.640995]  cpu_latency_qos_remove_request+0x20/0x110
[   19.646142]  gpio_ir_recv_runtime_suspend+0x18/0x30 [gpio_ir_recv]
[   19.652339]  pm_generic_runtime_suspend+0x2c/0x44
[   19.657055]  __rpm_callback+0x48/0x1dc
[   19.660807]  rpm_callback+0x6c/0x80
[   19.664301]  rpm_suspend+0x10c/0x640
[   19.667880]  rpm_idle+0x250/0x2d0
[   19.671198]  update_autosuspend+0x38/0xe0
[   19.675213]  pm_runtime_set_autosuspend_delay+0x40/0x60
[   19.680442]  gpio_ir_recv_probe+0x1b4/0x21c [gpio_ir_recv]
[   19.685941]  platform_probe+0x68/0xc0
[   19.689610]  really_probe+0xc0/0x3dc
[   19.693189]  __driver_probe_device+0x7c/0x190
[   19.697550]  driver_probe_device+0x3c/0x110
[   19.701739]  __driver_attach+0xf4/0x200
[   19.705578]  bus_for_each_dev+0x70/0xd0
[   19.709417]  driver_attach+0x24/0x30
[   19.712998]  bus_add_driver+0x17c/0x240
[   19.716834]  driver_register+0x78/0x130
[   19.720676]  __platform_driver_register+0x28/0x34
[   19.725386]  gpio_ir_recv_driver_init+0x20/0x1000 [gpio_ir_recv]
[   19.731404]  do_one_initcall+0x44/0x2ac
[   19.735243]  do_init_module+0x48/0x1d0
[   19.739003]  load_module+0x19fc/0x2034
[   19.742759]  __do_sys_finit_module+0xac/0x12c
[   19.747124]  __arm64_sys_finit_module+0x20/0x30
[   19.751664]  invoke_syscall+0x48/0x114
[   19.755420]  el0_svc_common.constprop.0+0xcc/0xec
[   19.760132]  do_el0_svc+0x38/0xb0
[   19.763456]  el0_svc+0x2c/0x84
[   19.766516]  el0t_64_sync_handler+0xf4/0x120
[   19.770789]  el0t_64_sync+0x190/0x194
[   19.774460] Code: 910003fd a90153f3 aa0003f3 91204021 (f9401400)
[   19.780556] ---[ end trace 0000000000000000 ]---

Signed-off-by: Li Jun <jun.li@nxp.com>
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/rc/gpio-ir-recv.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/media/rc/gpio-ir-recv.c b/drivers/media/rc/gpio-ir-recv.c
index 22e524b69806a..a56c844d7f816 100644
--- a/drivers/media/rc/gpio-ir-recv.c
+++ b/drivers/media/rc/gpio-ir-recv.c
@@ -130,6 +130,23 @@ static int gpio_ir_recv_probe(struct platform_device *pdev)
 				"gpio-ir-recv-irq", gpio_dev);
 }
 
+static int gpio_ir_recv_remove(struct platform_device *pdev)
+{
+	struct gpio_rc_dev *gpio_dev = platform_get_drvdata(pdev);
+	struct device *pmdev = gpio_dev->pmdev;
+
+	if (pmdev) {
+		pm_runtime_get_sync(pmdev);
+		cpu_latency_qos_remove_request(&gpio_dev->qos);
+
+		pm_runtime_disable(pmdev);
+		pm_runtime_put_noidle(pmdev);
+		pm_runtime_set_suspended(pmdev);
+	}
+
+	return 0;
+}
+
 #ifdef CONFIG_PM
 static int gpio_ir_recv_suspend(struct device *dev)
 {
@@ -189,6 +206,7 @@ MODULE_DEVICE_TABLE(of, gpio_ir_recv_of_match);
 
 static struct platform_driver gpio_ir_recv_driver = {
 	.probe  = gpio_ir_recv_probe,
+	.remove = gpio_ir_recv_remove,
 	.driver = {
 		.name   = KBUILD_MODNAME,
 		.of_match_table = of_match_ptr(gpio_ir_recv_of_match),
-- 
2.39.2


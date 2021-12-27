Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE22247FF6A
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 16:38:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238367AbhL0PhU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 10:37:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238715AbhL0Pge (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 10:36:34 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2F43C0698D3;
        Mon, 27 Dec 2021 07:36:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 5F06FCE10D4;
        Mon, 27 Dec 2021 15:36:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2554FC36AE7;
        Mon, 27 Dec 2021 15:36:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640619387;
        bh=Fn9MZBSKH5bSRzUX3XSviK7mU398oD038jbCnt69ygc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dis5A545Itoro6DYoKcIhHs4MKrQ6mtXL5NLFaN5Dk13YqMWhUopIMTwBIwbQadoU
         jy67IDaZRdKREM4dfSaKiCDIysjAohUKTtdwDqN1AixlPt8PEerSHaWwYSGBwRf9FS
         o1RljoBWGW7CEsNC3vGGtpwZdhz33aGuSFPatfK4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wu Bo <wubo40@huawei.com>,
        Corey Minyard <cminyard@mvista.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 11/47] ipmi: Fix UAF when uninstall ipmi_si and ipmi_msghandler module
Date:   Mon, 27 Dec 2021 16:30:47 +0100
Message-Id: <20211227151321.178297410@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227151320.801714429@linuxfoundation.org>
References: <20211227151320.801714429@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wu Bo <wubo40@huawei.com>

[ Upstream commit ffb76a86f8096a8206be03b14adda6092e18e275 ]

Hi,

When testing install and uninstall of ipmi_si.ko and ipmi_msghandler.ko,
the system crashed.

The log as follows:
[  141.087026] BUG: unable to handle kernel paging request at ffffffffc09b3a5a
[  141.087241] PGD 8fe4c0d067 P4D 8fe4c0d067 PUD 8fe4c0f067 PMD 103ad89067 PTE 0
[  141.087464] Oops: 0010 [#1] SMP NOPTI
[  141.087580] CPU: 67 PID: 668 Comm: kworker/67:1 Kdump: loaded Not tainted 4.18.0.x86_64 #47
[  141.088009] Workqueue: events 0xffffffffc09b3a40
[  141.088009] RIP: 0010:0xffffffffc09b3a5a
[  141.088009] Code: Bad RIP value.
[  141.088009] RSP: 0018:ffffb9094e2c3e88 EFLAGS: 00010246
[  141.088009] RAX: 0000000000000000 RBX: ffff9abfdb1f04a0 RCX: 0000000000000000
[  141.088009] RDX: 0000000000000000 RSI: 0000000000000246 RDI: 0000000000000246
[  141.088009] RBP: 0000000000000000 R08: ffff9abfffee3cb8 R09: 00000000000002e1
[  141.088009] R10: ffffb9094cb73d90 R11: 00000000000f4240 R12: ffff9abfffee8700
[  141.088009] R13: 0000000000000000 R14: ffff9abfdb1f04a0 R15: ffff9abfdb1f04a8
[  141.088009] FS:  0000000000000000(0000) GS:ffff9abfffec0000(0000) knlGS:0000000000000000
[  141.088009] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  141.088009] CR2: ffffffffc09b3a30 CR3: 0000008fe4c0a001 CR4: 00000000007606e0
[  141.088009] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  141.088009] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[  141.088009] PKRU: 55555554
[  141.088009] Call Trace:
[  141.088009]  ? process_one_work+0x195/0x390
[  141.088009]  ? worker_thread+0x30/0x390
[  141.088009]  ? process_one_work+0x390/0x390
[  141.088009]  ? kthread+0x10d/0x130
[  141.088009]  ? kthread_flush_work_fn+0x10/0x10
[  141.088009]  ? ret_from_fork+0x35/0x40] BUG: unable to handle kernel paging request at ffffffffc0b28a5a
[  200.223240] PGD 97fe00d067 P4D 97fe00d067 PUD 97fe00f067 PMD a580cbf067 PTE 0
[  200.223464] Oops: 0010 [#1] SMP NOPTI
[  200.223579] CPU: 63 PID: 664 Comm: kworker/63:1 Kdump: loaded Not tainted 4.18.0.x86_64 #46
[  200.224008] Workqueue: events 0xffffffffc0b28a40
[  200.224008] RIP: 0010:0xffffffffc0b28a5a
[  200.224008] Code: Bad RIP value.
[  200.224008] RSP: 0018:ffffbf3c8e2a3e88 EFLAGS: 00010246
[  200.224008] RAX: 0000000000000000 RBX: ffffa0799ad6bca0 RCX: 0000000000000000
[  200.224008] RDX: 0000000000000000 RSI: 0000000000000246 RDI: 0000000000000246
[  200.224008] RBP: 0000000000000000 R08: ffff9fe43fde3cb8 R09: 00000000000000d5
[  200.224008] R10: ffffbf3c8cb53d90 R11: 00000000000f4240 R12: ffff9fe43fde8700
[  200.224008] R13: 0000000000000000 R14: ffffa0799ad6bca0 R15: ffffa0799ad6bca8
[  200.224008] FS:  0000000000000000(0000) GS:ffff9fe43fdc0000(0000) knlGS:0000000000000000
[  200.224008] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  200.224008] CR2: ffffffffc0b28a30 CR3: 00000097fe00a002 CR4: 00000000007606e0
[  200.224008] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  200.224008] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[  200.224008] PKRU: 55555554
[  200.224008] Call Trace:
[  200.224008]  ? process_one_work+0x195/0x390
[  200.224008]  ? worker_thread+0x30/0x390
[  200.224008]  ? process_one_work+0x390/0x390
[  200.224008]  ? kthread+0x10d/0x130
[  200.224008]  ? kthread_flush_work_fn+0x10/0x10
[  200.224008]  ? ret_from_fork+0x35/0x40
[  200.224008] kernel fault(0x1) notification starting on CPU 63
[  200.224008] kernel fault(0x1) notification finished on CPU 63
[  200.224008] CR2: ffffffffc0b28a5a
[  200.224008] ---[ end trace c82a412d93f57412 ]---

The reason is as follows:
T1: rmmod ipmi_si.
    ->ipmi_unregister_smi()
        -> ipmi_bmc_unregister()
            -> __ipmi_bmc_unregister()
                -> kref_put(&bmc->usecount, cleanup_bmc_device);
                    -> schedule_work(&bmc->remove_work);

T2: rmmod ipmi_msghandler.
    ipmi_msghander module uninstalled, and the module space
    will be freed.

T3: bmc->remove_work doing cleanup the bmc resource.
    -> cleanup_bmc_work()
        -> platform_device_unregister(&bmc->pdev);
            -> platform_device_del(pdev);
                -> device_del(&pdev->dev);
                    -> kobject_uevent(&dev->kobj, KOBJ_REMOVE);
                        -> kobject_uevent_env()
                            -> dev_uevent()
                                -> if (dev->type && dev->type->name)

   'dev->type'(bmc_device_type) pointer space has freed when uninstall
    ipmi_msghander module, 'dev->type->name' cause the system crash.

drivers/char/ipmi/ipmi_msghandler.c:
2820 static const struct device_type bmc_device_type = {
2821         .groups         = bmc_dev_attr_groups,
2822 };

Steps to reproduce:
Add a time delay in cleanup_bmc_work() function,
and uninstall ipmi_si and ipmi_msghandler module.

2910 static void cleanup_bmc_work(struct work_struct *work)
2911 {
2912         struct bmc_device *bmc = container_of(work, struct bmc_device,
2913                                               remove_work);
2914         int id = bmc->pdev.id; /* Unregister overwrites id */
2915
2916         msleep(3000);   <---
2917         platform_device_unregister(&bmc->pdev);
2918         ida_simple_remove(&ipmi_bmc_ida, id);
2919 }

Use 'remove_work_wq' instead of 'system_wq' to solve this issues.

Fixes: b2cfd8ab4add ("ipmi: Rework device id and guid handling to catch changing BMCs")
Signed-off-by: Wu Bo <wubo40@huawei.com>
Message-Id: <1640070034-56671-1-git-send-email-wubo40@huawei.com>
Signed-off-by: Corey Minyard <cminyard@mvista.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/ipmi/ipmi_msghandler.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/ipmi/ipmi_msghandler.c b/drivers/char/ipmi/ipmi_msghandler.c
index 8a93d5a494fff..435e9459a859f 100644
--- a/drivers/char/ipmi/ipmi_msghandler.c
+++ b/drivers/char/ipmi/ipmi_msghandler.c
@@ -2938,7 +2938,7 @@ cleanup_bmc_device(struct kref *ref)
 	 * with removing the device attributes while reading a device
 	 * attribute.
 	 */
-	schedule_work(&bmc->remove_work);
+	queue_work(remove_work_wq, &bmc->remove_work);
 }
 
 /*
-- 
2.34.1




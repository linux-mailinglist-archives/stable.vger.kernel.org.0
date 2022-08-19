Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB56359A1B3
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 18:35:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351711AbiHSQSV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 12:18:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352596AbiHSQRP (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 12:17:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71D1E116EED;
        Fri, 19 Aug 2022 09:00:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 32BDBB827F8;
        Fri, 19 Aug 2022 16:00:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 912A7C433D6;
        Fri, 19 Aug 2022 16:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660924820;
        bh=ChWf+LtxRb24AG++lacK+sYcVfg3nX7V4e/awgBbszs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fXnITut83ZNogiYMjunl+7RuOCzuVjVGeQMm7OsiP+0ruEuZFjeyt9jIhVV50cL1/
         T7pQJIBysbHZUx2O2W5bXqRqr3J8t1p/KM0QPg1OdGH5k1w4ZIEKA7Ul7/JwQ83MLm
         li0S6bUaFDNf9dflPaRgOZDdnHfJZsgAski0Nkb4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhang Wensheng <zhangwensheng5@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 293/545] driver core: fix potential deadlock in __driver_attach
Date:   Fri, 19 Aug 2022 17:41:03 +0200
Message-Id: <20220819153842.447940623@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Wensheng <zhangwensheng5@huawei.com>

[ Upstream commit 70fe758352cafdee72a7b13bf9db065f9613ced8 ]

In __driver_attach function, There are also AA deadlock problem,
like the commit b232b02bf3c2 ("driver core: fix deadlock in
__device_attach").

stack like commit b232b02bf3c2 ("driver core: fix deadlock in
__device_attach").
list below:
    In __driver_attach function, The lock holding logic is as follows:
    ...
    __driver_attach
    if (driver_allows_async_probing(drv))
      device_lock(dev)      // get lock dev
        async_schedule_dev(__driver_attach_async_helper, dev); // func
          async_schedule_node
            async_schedule_node_domain(func)
              entry = kzalloc(sizeof(struct async_entry), GFP_ATOMIC);
              /* when fail or work limit, sync to execute func, but
                 __driver_attach_async_helper will get lock dev as
                 will, which will lead to A-A deadlock.  */
              if (!entry || atomic_read(&entry_count) > MAX_WORK) {
                func;
              else
                queue_work_node(node, system_unbound_wq, &entry->work)
      device_unlock(dev)

    As above show, when it is allowed to do async probes, because of
    out of memory or work limit, async work is not be allowed, to do
    sync execute instead. it will lead to A-A deadlock because of
    __driver_attach_async_helper getting lock dev.

Reproduce:
and it can be reproduce by make the condition
(if (!entry || atomic_read(&entry_count) > MAX_WORK)) untenable, like
below:

[  370.785650] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables
this message.
[  370.787154] task:swapper/0       state:D stack:    0 pid:    1 ppid:
0 flags:0x00004000
[  370.788865] Call Trace:
[  370.789374]  <TASK>
[  370.789841]  __schedule+0x482/0x1050
[  370.790613]  schedule+0x92/0x1a0
[  370.791290]  schedule_preempt_disabled+0x2c/0x50
[  370.792256]  __mutex_lock.isra.0+0x757/0xec0
[  370.793158]  __mutex_lock_slowpath+0x1f/0x30
[  370.794079]  mutex_lock+0x50/0x60
[  370.794795]  __device_driver_lock+0x2f/0x70
[  370.795677]  ? driver_probe_device+0xd0/0xd0
[  370.796576]  __driver_attach_async_helper+0x1d/0xd0
[  370.797318]  ? driver_probe_device+0xd0/0xd0
[  370.797957]  async_schedule_node_domain+0xa5/0xc0
[  370.798652]  async_schedule_node+0x19/0x30
[  370.799243]  __driver_attach+0x246/0x290
[  370.799828]  ? driver_allows_async_probing+0xa0/0xa0
[  370.800548]  bus_for_each_dev+0x9d/0x130
[  370.801132]  driver_attach+0x22/0x30
[  370.801666]  bus_add_driver+0x290/0x340
[  370.802246]  driver_register+0x88/0x140
[  370.802817]  ? virtio_scsi_init+0x116/0x116
[  370.803425]  scsi_register_driver+0x1a/0x30
[  370.804057]  init_sd+0x184/0x226
[  370.804533]  do_one_initcall+0x71/0x3a0
[  370.805107]  kernel_init_freeable+0x39a/0x43a
[  370.805759]  ? rest_init+0x150/0x150
[  370.806283]  kernel_init+0x26/0x230
[  370.806799]  ret_from_fork+0x1f/0x30

To fix the deadlock, move the async_schedule_dev outside device_lock,
as we can see, in async_schedule_node_domain, the parameter of
queue_work_node is system_unbound_wq, so it can accept concurrent
operations. which will also not change the code logic, and will
not lead to deadlock.

Fixes: ef0ff68351be ("driver core: Probe devices asynchronously instead of the driver")
Signed-off-by: Zhang Wensheng <zhangwensheng5@huawei.com>
Link: https://lore.kernel.org/r/20220622074327.497102-1-zhangwensheng5@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/dd.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index f9d9f1ad9215..b5441741274b 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -1056,6 +1056,7 @@ static void __driver_attach_async_helper(void *_dev, async_cookie_t cookie)
 static int __driver_attach(struct device *dev, void *data)
 {
 	struct device_driver *drv = data;
+	bool async = false;
 	int ret;
 
 	/*
@@ -1093,9 +1094,11 @@ static int __driver_attach(struct device *dev, void *data)
 		if (!dev->driver) {
 			get_device(dev);
 			dev->p->async_driver = drv;
-			async_schedule_dev(__driver_attach_async_helper, dev);
+			async = true;
 		}
 		device_unlock(dev);
+		if (async)
+			async_schedule_dev(__driver_attach_async_helper, dev);
 		return 0;
 	}
 
-- 
2.35.1




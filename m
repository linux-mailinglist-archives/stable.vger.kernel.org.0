Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03E574F29D7
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 12:50:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238114AbiDEJEj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:04:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243670AbiDEIuz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:50:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 858F9DCB;
        Tue,  5 Apr 2022 01:39:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 43EA861532;
        Tue,  5 Apr 2022 08:38:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 542F6C385A0;
        Tue,  5 Apr 2022 08:38:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649147919;
        bh=lyl/QYeOAOaVkyrba6LwCYjzbpaPtg3ddCAsSWp4+5E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QFOV3GbLMAzdtni8Tyorq6DnHs4iUWoZdZuQ3P2VFAcHUzBocVV1VjljRbqHCoIRC
         Qmmc9ZkbQ/QyO3i2kZrua8UkaDm0CvxfyAhkl8BqSiG8Y6HVRVrF3Jz6tAYNBfL2Yk
         x+U2vVKdVjlxEya3c254hrRwkRJTMhlwUpWgiC0k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shawn Guo <shawn.guo@linaro.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.16 0170/1017] PM: domains: Fix sleep-in-atomic bug caused by genpd_debug_remove()
Date:   Tue,  5 Apr 2022 09:18:03 +0200
Message-Id: <20220405070359.272949027@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Shawn Guo <shawn.guo@linaro.org>

commit f6bfe8b5b2c2a5ac8bd2fc7bca3706e6c3fc26d8 upstream.

When a genpd with GENPD_FLAG_IRQ_SAFE gets removed, the following
sleep-in-atomic bug will be seen, as genpd_debug_remove() will be called
with a spinlock being held.

[    0.029183] BUG: sleeping function called from invalid context at kernel/locking/rwsem.c:1460
[    0.029204] in_atomic(): 1, irqs_disabled(): 128, non_block: 0, pid: 1, name: swapper/0
[    0.029219] preempt_count: 1, expected: 0
[    0.029230] CPU: 1 PID: 1 Comm: swapper/0 Not tainted 5.17.0-rc4+ #489
[    0.029245] Hardware name: Thundercomm TurboX CM2290 (DT)
[    0.029256] Call trace:
[    0.029265]  dump_backtrace.part.0+0xbc/0xd0
[    0.029285]  show_stack+0x3c/0xa0
[    0.029298]  dump_stack_lvl+0x7c/0xa0
[    0.029311]  dump_stack+0x18/0x34
[    0.029323]  __might_resched+0x10c/0x13c
[    0.029338]  __might_sleep+0x4c/0x80
[    0.029351]  down_read+0x24/0xd0
[    0.029363]  lookup_one_len_unlocked+0x9c/0xcc
[    0.029379]  lookup_positive_unlocked+0x10/0x50
[    0.029392]  debugfs_lookup+0x68/0xac
[    0.029406]  genpd_remove.part.0+0x12c/0x1b4
[    0.029419]  of_genpd_remove_last+0xa8/0xd4
[    0.029434]  psci_cpuidle_domain_probe+0x174/0x53c
[    0.029449]  platform_probe+0x68/0xe0
[    0.029462]  really_probe+0x190/0x430
[    0.029473]  __driver_probe_device+0x90/0x18c
[    0.029485]  driver_probe_device+0x40/0xe0
[    0.029497]  __driver_attach+0xf4/0x1d0
[    0.029508]  bus_for_each_dev+0x70/0xd0
[    0.029523]  driver_attach+0x24/0x30
[    0.029534]  bus_add_driver+0x164/0x22c
[    0.029545]  driver_register+0x78/0x130
[    0.029556]  __platform_driver_register+0x28/0x34
[    0.029569]  psci_idle_init_domains+0x1c/0x28
[    0.029583]  do_one_initcall+0x50/0x1b0
[    0.029595]  kernel_init_freeable+0x214/0x280
[    0.029609]  kernel_init+0x2c/0x13c
[    0.029622]  ret_from_fork+0x10/0x20

It doesn't seem necessary to call genpd_debug_remove() with the lock, so
move it out from locking to fix the problem.

Fixes: 718072ceb211 ("PM: domains: create debugfs nodes when adding power domains")
Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
Reviewed-by: Ulf Hansson <ulf.hansson@linaro.org>
Cc: 5.11+ <stable@vger.kernel.org> # 5.11+
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/power/domain.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/base/power/domain.c
+++ b/drivers/base/power/domain.c
@@ -2058,9 +2058,9 @@ static int genpd_remove(struct generic_p
 		kfree(link);
 	}
 
-	genpd_debug_remove(genpd);
 	list_del(&genpd->gpd_list_node);
 	genpd_unlock(genpd);
+	genpd_debug_remove(genpd);
 	cancel_work_sync(&genpd->power_off_work);
 	if (genpd_is_cpu_domain(genpd))
 		free_cpumask_var(genpd->cpus);



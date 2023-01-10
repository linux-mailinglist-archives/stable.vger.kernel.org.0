Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 949DB664A27
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:31:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239105AbjAJSay (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:30:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239379AbjAJSaF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:30:05 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 340D29B2A2
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 10:24:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DD0D1B81903
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 18:24:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25D15C433D2;
        Tue, 10 Jan 2023 18:24:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673375086;
        bh=EBogUQbgjWYPXNqBrDD/AJAymDMmJv5AkUyIztTrVVU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zXmTDVv+/W4V7opCkIbCuFXjKtOA5Qjtf7ipwbZF+Hr4oKKwy/NUBJ0ITJoIc3Qyf
         1YqYAvPGnpAqSy9ge6qdcORXhn38gvakROl4ajiADxa/GQNLWUgrrIEmmUJPPU5M42
         87cYONT33vnPPj2jhsJqBy0Dnp51sHsWgrRxuogk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yongqiang Liu <liuyongqiang13@huawei.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.15 074/290] cpufreq: Init completion before kobject_init_and_add()
Date:   Tue, 10 Jan 2023 19:02:46 +0100
Message-Id: <20230110180034.190624597@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180031.620810905@linuxfoundation.org>
References: <20230110180031.620810905@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yongqiang Liu <liuyongqiang13@huawei.com>

commit 5c51054896bcce1d33d39fead2af73fec24f40b6 upstream.

In cpufreq_policy_alloc(), it will call uninitialed completion in
cpufreq_sysfs_release() when kobject_init_and_add() fails. And
that will cause a crash such as the following page fault in complete:

BUG: unable to handle page fault for address: fffffffffffffff8
[..]
RIP: 0010:complete+0x98/0x1f0
[..]
Call Trace:
 kobject_put+0x1be/0x4c0
 cpufreq_online.cold+0xee/0x1fd
 cpufreq_add_dev+0x183/0x1e0
 subsys_interface_register+0x3f5/0x4e0
 cpufreq_register_driver+0x3b7/0x670
 acpi_cpufreq_init+0x56c/0x1000 [acpi_cpufreq]
 do_one_initcall+0x13d/0x780
 do_init_module+0x1c3/0x630
 load_module+0x6e67/0x73b0
 __do_sys_finit_module+0x181/0x240
 do_syscall_64+0x35/0x80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

Fixes: 4ebe36c94aed ("cpufreq: Fix kobject memleak")
Signed-off-by: Yongqiang Liu <liuyongqiang13@huawei.com>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
Cc: 5.2+ <stable@vger.kernel.org> # 5.2+
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cpufreq/cpufreq.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -1212,6 +1212,7 @@ static struct cpufreq_policy *cpufreq_po
 	if (!zalloc_cpumask_var(&policy->real_cpus, GFP_KERNEL))
 		goto err_free_rcpumask;
 
+	init_completion(&policy->kobj_unregister);
 	ret = kobject_init_and_add(&policy->kobj, &ktype_cpufreq,
 				   cpufreq_global_kobject, "policy%u", cpu);
 	if (ret) {
@@ -1250,7 +1251,6 @@ static struct cpufreq_policy *cpufreq_po
 	init_rwsem(&policy->rwsem);
 	spin_lock_init(&policy->transition_lock);
 	init_waitqueue_head(&policy->transition_wait);
-	init_completion(&policy->kobj_unregister);
 	INIT_WORK(&policy->update, handle_update);
 
 	policy->cpu = cpu;



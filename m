Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8F8064340A
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 20:42:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234931AbiLETlw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 14:41:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234492AbiLETlT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 14:41:19 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D2F6D5A
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 11:38:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 88F5DCE131B
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 19:38:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 789E6C433D7;
        Mon,  5 Dec 2022 19:38:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670269130;
        bh=uOjaAgiCgqNlN9hYuR9I4LI1Zx3/S/moZUug4sWsxKE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0topRgeVwOn86kLwbLy4wWg1E2l1FMaSPBtPBpW/Gm2zG5JtrCfe0wdAVIjCH8Pxb
         QSi5YOfA4hhyihuJUOKNemEzFt5j2eNzxpSoGduugU0nupqze10V8YH99fZdRtj9yU
         LtVL0mPIJTWjY40hwgZsTtCiunRaUnzuuyLZE8Ig=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 015/153] regulator: core: fix UAF in destroy_regulator()
Date:   Mon,  5 Dec 2022 20:08:59 +0100
Message-Id: <20221205190809.188282376@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190808.733996403@linuxfoundation.org>
References: <20221205190808.733996403@linuxfoundation.org>
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

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 1f386d6894d0f1b7de8ef640c41622ddd698e7ab ]

I got a UAF report as following:

==================================================================
BUG: KASAN: use-after-free in __lock_acquire+0x935/0x2060
Read of size 8 at addr ffff88810e838220 by task python3/268
Call Trace:
 <TASK>
 dump_stack_lvl+0x67/0x83
 print_report+0x178/0x4b0
 kasan_report+0x90/0x190
 __lock_acquire+0x935/0x2060
 lock_acquire+0x156/0x400
 _raw_spin_lock+0x2a/0x40
 lockref_get+0x11/0x30
 simple_recursive_removal+0x41/0x440
 debugfs_remove.part.12+0x32/0x50
 debugfs_remove+0x29/0x30
 _regulator_put.cold.54+0x3e/0x27f
 regulator_put+0x1f/0x30
 release_nodes+0x6a/0xa0
 devres_release_all+0xf8/0x150

Allocated by task 37:
 kasan_save_stack+0x1c/0x40
 kasan_set_track+0x21/0x30
 __kasan_slab_alloc+0x5d/0x70
 slab_post_alloc_hook+0x62/0x510
 kmem_cache_alloc_lru+0x222/0x5a0
 __d_alloc+0x31/0x440
 d_alloc+0x30/0xf0
 d_alloc_parallel+0xc4/0xd20
 __lookup_slow+0x15e/0x2f0
 lookup_one_len+0x13a/0x150
 start_creating+0xea/0x190
 debugfs_create_dir+0x1e/0x210
 create_regulator+0x254/0x4e0
 _regulator_get+0x2a1/0x467
 _devm_regulator_get+0x5a/0xb0
 regulator_virtual_probe+0xb9/0x1a0

Freed by task 30:
 kasan_save_stack+0x1c/0x40
 kasan_set_track+0x21/0x30
 kasan_save_free_info+0x2a/0x50
 __kasan_slab_free+0x102/0x190
 kmem_cache_free+0xf6/0x600
 rcu_core+0x54c/0x12b0
 __do_softirq+0xf2/0x5e3

Last potentially related work creation:
 kasan_save_stack+0x1c/0x40
 __kasan_record_aux_stack+0x98/0xb0
 call_rcu+0x42/0x700
 dentry_free+0x6c/0xd0
 __dentry_kill+0x23b/0x2d0
 dput.part.31+0x431/0x780
 simple_recursive_removal+0xa9/0x440
 debugfs_remove.part.12+0x32/0x50
 debugfs_remove+0x29/0x30
 regulator_unregister+0xe3/0x230
 release_nodes+0x6a/0xa0

==================================================================

Here is how happened:

processor A					processor B
regulator_register()
  rdev_init_debugfs()
    rdev->debugfs = debugfs_create_dir()
						devm_regulator_get()
						  rdev = regulator_dev_lookup()
						  create_regulator(rdev)
						    // using rdev->debugfs as parent
						    debugfs_create_dir(rdev->debugfs)

mfd_remove_devices_fn()
  release_nodes()
    regulator_unregister()
      // free rdev->debugfs
      debugfs_remove_recursive(rdev->debugfs)
						release_nodes()
						  destroy_regulator()
						    debugfs_remove_recursive() <- causes UAF

In devm_regulator_get(), after getting rdev, the refcount
is get, so fix this by moving debugfs_remove_recursive()
to regulator_dev_release(), then it can be proctected by
the refcount, the 'rdev->debugfs' can not be freed until
the refcount is 0.

Fixes: 5de705194e98 ("regulator: Add basic per consumer debugfs")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://lore.kernel.org/r/20221116033706.3595812-1-yangyingliang@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 173798c0fbcd..7d15312d6792 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -4802,6 +4802,7 @@ static void regulator_dev_release(struct device *dev)
 {
 	struct regulator_dev *rdev = dev_get_drvdata(dev);
 
+	debugfs_remove_recursive(rdev->debugfs);
 	kfree(rdev->constraints);
 	of_node_put(rdev->dev.of_node);
 	kfree(rdev);
@@ -5306,7 +5307,6 @@ void regulator_unregister(struct regulator_dev *rdev)
 
 	mutex_lock(&regulator_list_mutex);
 
-	debugfs_remove_recursive(rdev->debugfs);
 	WARN_ON(rdev->open_count);
 	regulator_remove_coupling(rdev);
 	unset_regulator_supplies(rdev);
-- 
2.35.1




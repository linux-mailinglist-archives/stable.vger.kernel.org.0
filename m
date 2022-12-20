Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6963A65181F
	for <lists+stable@lfdr.de>; Tue, 20 Dec 2022 02:25:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233040AbiLTBZW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Dec 2022 20:25:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232586AbiLTBXP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Dec 2022 20:23:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02FA99FE5;
        Mon, 19 Dec 2022 17:22:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B7EA2B80F9B;
        Tue, 20 Dec 2022 01:21:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE798C43396;
        Tue, 20 Dec 2022 01:21:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671499317;
        bh=zC6lvUdZEtVn13IPbikSY5Yln/XTvATTCPY+B0G6TfE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FrwY67esAW154ivptAcfE7QSk1g5K+mP9BU2Q7+VlZgnYuoy/noITSPaNWXTaRhCF
         miNpMZI7Ru+0r/fr6nFa/zlk4igrIGWHLLXESZfi9zoOshADOuZsGZed5HPNIvXG4z
         zmaFYvDUQx7N3u4OnicKyRpnxSsX0WWc8F3BhIN3NEJCpY2D2LlO9fVyZrHzqi4K6w
         3goCMp6iTgeRqhym594WPnnvBD4dxeR41c5Pmm8IJxkIX9Cw1VpV5C6Ed6BBlLIP40
         ppGAqh1kZMUvrpwpcIQ6CCOaHL0+PoWBduIRW8vFVjGnG+EZ7hxNIunBZONj+areOt
         9/9gqgql6X38Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zhang Xiaoxu <zhangxiaoxu5@huawei.com>,
        Mike Marshall <hubcap@omnibond.com>,
        Sasha Levin <sashal@kernel.org>, devel@lists.orangefs.org
Subject: [PATCH AUTOSEL 6.0 15/16] orangefs: Fix kmemleak in orangefs_sysfs_init()
Date:   Mon, 19 Dec 2022 20:21:25 -0500
Message-Id: <20221220012127.1222311-15-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221220012127.1222311-1-sashal@kernel.org>
References: <20221220012127.1222311-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>

[ Upstream commit 1f2c0e8a587bcafad85019a2d80f158d8d41a868 ]

When insert and remove the orangefs module, there are kobjects memory
leaked as below:

unreferenced object 0xffff88810f95af00 (size 64):
  comm "insmod", pid 783, jiffies 4294813439 (age 65.512s)
  hex dump (first 32 bytes):
    a0 83 af 01 81 88 ff ff 08 af 95 0f 81 88 ff ff  ................
    08 af 95 0f 81 88 ff ff 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<0000000031ab7788>] kmalloc_trace+0x27/0xa0
    [<000000005a6e4dfe>] orangefs_sysfs_init+0x42/0x3a0
    [<00000000722645ca>] 0xffffffffa02780fe
    [<000000004232d9f7>] do_one_initcall+0x87/0x2a0
    [<0000000054f22384>] do_init_module+0xdf/0x320
    [<000000003263bdea>] load_module+0x2f98/0x3330
    [<0000000052cd4153>] __do_sys_finit_module+0x113/0x1b0
    [<00000000250ae02b>] do_syscall_64+0x35/0x80
    [<00000000f11c03c7>] entry_SYSCALL_64_after_hwframe+0x46/0xb0

unreferenced object 0xffff88810f95ae80 (size 64):
  comm "insmod", pid 783, jiffies 4294813439 (age 65.512s)
  hex dump (first 32 bytes):
    c8 90 0f 02 81 88 ff ff 88 ae 95 0f 81 88 ff ff  ................
    88 ae 95 0f 81 88 ff ff 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<0000000031ab7788>] kmalloc_trace+0x27/0xa0
    [<000000001a4841fa>] orangefs_sysfs_init+0xc7/0x3a0
    [<00000000722645ca>] 0xffffffffa02780fe
    [<000000004232d9f7>] do_one_initcall+0x87/0x2a0
    [<0000000054f22384>] do_init_module+0xdf/0x320
    [<000000003263bdea>] load_module+0x2f98/0x3330
    [<0000000052cd4153>] __do_sys_finit_module+0x113/0x1b0
    [<00000000250ae02b>] do_syscall_64+0x35/0x80
    [<00000000f11c03c7>] entry_SYSCALL_64_after_hwframe+0x46/0xb0

unreferenced object 0xffff88810f95ae00 (size 64):
  comm "insmod", pid 783, jiffies 4294813440 (age 65.511s)
  hex dump (first 32 bytes):
    60 87 a1 00 81 88 ff ff 08 ae 95 0f 81 88 ff ff  `...............
    08 ae 95 0f 81 88 ff ff 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<0000000031ab7788>] kmalloc_trace+0x27/0xa0
    [<000000005915e797>] orangefs_sysfs_init+0x12b/0x3a0
    [<00000000722645ca>] 0xffffffffa02780fe
    [<000000004232d9f7>] do_one_initcall+0x87/0x2a0
    [<0000000054f22384>] do_init_module+0xdf/0x320
    [<000000003263bdea>] load_module+0x2f98/0x3330
    [<0000000052cd4153>] __do_sys_finit_module+0x113/0x1b0
    [<00000000250ae02b>] do_syscall_64+0x35/0x80
    [<00000000f11c03c7>] entry_SYSCALL_64_after_hwframe+0x46/0xb0

unreferenced object 0xffff88810f95ad80 (size 64):
  comm "insmod", pid 783, jiffies 4294813440 (age 65.511s)
  hex dump (first 32 bytes):
    78 90 0f 02 81 88 ff ff 88 ad 95 0f 81 88 ff ff  x...............
    88 ad 95 0f 81 88 ff ff 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<0000000031ab7788>] kmalloc_trace+0x27/0xa0
    [<000000007a14eb35>] orangefs_sysfs_init+0x1ac/0x3a0
    [<00000000722645ca>] 0xffffffffa02780fe
    [<000000004232d9f7>] do_one_initcall+0x87/0x2a0
    [<0000000054f22384>] do_init_module+0xdf/0x320
    [<000000003263bdea>] load_module+0x2f98/0x3330
    [<0000000052cd4153>] __do_sys_finit_module+0x113/0x1b0
    [<00000000250ae02b>] do_syscall_64+0x35/0x80
    [<00000000f11c03c7>] entry_SYSCALL_64_after_hwframe+0x46/0xb0

unreferenced object 0xffff88810f95ac00 (size 64):
  comm "insmod", pid 783, jiffies 4294813440 (age 65.531s)
  hex dump (first 32 bytes):
    e0 ff 67 02 81 88 ff ff 08 ac 95 0f 81 88 ff ff  ..g.............
    08 ac 95 0f 81 88 ff ff 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<0000000031ab7788>] kmalloc_trace+0x27/0xa0
    [<000000001f38adcb>] orangefs_sysfs_init+0x291/0x3a0
    [<00000000722645ca>] 0xffffffffa02780fe
    [<000000004232d9f7>] do_one_initcall+0x87/0x2a0
    [<0000000054f22384>] do_init_module+0xdf/0x320
    [<000000003263bdea>] load_module+0x2f98/0x3330
    [<0000000052cd4153>] __do_sys_finit_module+0x113/0x1b0
    [<00000000250ae02b>] do_syscall_64+0x35/0x80
    [<00000000f11c03c7>] entry_SYSCALL_64_after_hwframe+0x46/0xb0

unreferenced object 0xffff88810f95ab80 (size 64):
  comm "insmod", pid 783, jiffies 4294813441 (age 65.530s)
  hex dump (first 32 bytes):
    50 bf 2f 02 81 88 ff ff 88 ab 95 0f 81 88 ff ff  P./.............
    88 ab 95 0f 81 88 ff ff 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<0000000031ab7788>] kmalloc_trace+0x27/0xa0
    [<000000009cc7d95b>] orangefs_sysfs_init+0x2f5/0x3a0
    [<00000000722645ca>] 0xffffffffa02780fe
    [<000000004232d9f7>] do_one_initcall+0x87/0x2a0
    [<0000000054f22384>] do_init_module+0xdf/0x320
    [<000000003263bdea>] load_module+0x2f98/0x3330
    [<0000000052cd4153>] __do_sys_finit_module+0x113/0x1b0
    [<00000000250ae02b>] do_syscall_64+0x35/0x80
    [<00000000f11c03c7>] entry_SYSCALL_64_after_hwframe+0x46/0xb0

Should add release function for each kobject_type to free the memory.

Signed-off-by: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
Signed-off-by: Mike Marshall <hubcap@omnibond.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/orangefs/orangefs-sysfs.c | 71 ++++++++++++++++++++++++++++++++----
 1 file changed, 63 insertions(+), 8 deletions(-)

diff --git a/fs/orangefs/orangefs-sysfs.c b/fs/orangefs/orangefs-sysfs.c
index de80b62553bb..be4ba03a01a0 100644
--- a/fs/orangefs/orangefs-sysfs.c
+++ b/fs/orangefs/orangefs-sysfs.c
@@ -896,9 +896,18 @@ static struct attribute *orangefs_default_attrs[] = {
 };
 ATTRIBUTE_GROUPS(orangefs_default);
 
+static struct kobject *orangefs_obj;
+
+static void orangefs_obj_release(struct kobject *kobj)
+{
+	kfree(orangefs_obj);
+	orangefs_obj = NULL;
+}
+
 static struct kobj_type orangefs_ktype = {
 	.sysfs_ops = &orangefs_sysfs_ops,
 	.default_groups = orangefs_default_groups,
+	.release = orangefs_obj_release,
 };
 
 static struct orangefs_attribute acache_hard_limit_attribute =
@@ -934,9 +943,18 @@ static struct attribute *acache_orangefs_default_attrs[] = {
 };
 ATTRIBUTE_GROUPS(acache_orangefs_default);
 
+static struct kobject *acache_orangefs_obj;
+
+static void acache_orangefs_obj_release(struct kobject *kobj)
+{
+	kfree(acache_orangefs_obj);
+	acache_orangefs_obj = NULL;
+}
+
 static struct kobj_type acache_orangefs_ktype = {
 	.sysfs_ops = &orangefs_sysfs_ops,
 	.default_groups = acache_orangefs_default_groups,
+	.release = acache_orangefs_obj_release,
 };
 
 static struct orangefs_attribute capcache_hard_limit_attribute =
@@ -972,9 +990,18 @@ static struct attribute *capcache_orangefs_default_attrs[] = {
 };
 ATTRIBUTE_GROUPS(capcache_orangefs_default);
 
+static struct kobject *capcache_orangefs_obj;
+
+static void capcache_orangefs_obj_release(struct kobject *kobj)
+{
+	kfree(capcache_orangefs_obj);
+	capcache_orangefs_obj = NULL;
+}
+
 static struct kobj_type capcache_orangefs_ktype = {
 	.sysfs_ops = &orangefs_sysfs_ops,
 	.default_groups = capcache_orangefs_default_groups,
+	.release = capcache_orangefs_obj_release,
 };
 
 static struct orangefs_attribute ccache_hard_limit_attribute =
@@ -1010,9 +1037,18 @@ static struct attribute *ccache_orangefs_default_attrs[] = {
 };
 ATTRIBUTE_GROUPS(ccache_orangefs_default);
 
+static struct kobject *ccache_orangefs_obj;
+
+static void ccache_orangefs_obj_release(struct kobject *kobj)
+{
+	kfree(ccache_orangefs_obj);
+	ccache_orangefs_obj = NULL;
+}
+
 static struct kobj_type ccache_orangefs_ktype = {
 	.sysfs_ops = &orangefs_sysfs_ops,
 	.default_groups = ccache_orangefs_default_groups,
+	.release = ccache_orangefs_obj_release,
 };
 
 static struct orangefs_attribute ncache_hard_limit_attribute =
@@ -1048,9 +1084,18 @@ static struct attribute *ncache_orangefs_default_attrs[] = {
 };
 ATTRIBUTE_GROUPS(ncache_orangefs_default);
 
+static struct kobject *ncache_orangefs_obj;
+
+static void ncache_orangefs_obj_release(struct kobject *kobj)
+{
+	kfree(ncache_orangefs_obj);
+	ncache_orangefs_obj = NULL;
+}
+
 static struct kobj_type ncache_orangefs_ktype = {
 	.sysfs_ops = &orangefs_sysfs_ops,
 	.default_groups = ncache_orangefs_default_groups,
+	.release = ncache_orangefs_obj_release,
 };
 
 static struct orangefs_attribute pc_acache_attribute =
@@ -1079,9 +1124,18 @@ static struct attribute *pc_orangefs_default_attrs[] = {
 };
 ATTRIBUTE_GROUPS(pc_orangefs_default);
 
+static struct kobject *pc_orangefs_obj;
+
+static void pc_orangefs_obj_release(struct kobject *kobj)
+{
+	kfree(pc_orangefs_obj);
+	pc_orangefs_obj = NULL;
+}
+
 static struct kobj_type pc_orangefs_ktype = {
 	.sysfs_ops = &orangefs_sysfs_ops,
 	.default_groups = pc_orangefs_default_groups,
+	.release = pc_orangefs_obj_release,
 };
 
 static struct orangefs_attribute stats_reads_attribute =
@@ -1103,19 +1157,20 @@ static struct attribute *stats_orangefs_default_attrs[] = {
 };
 ATTRIBUTE_GROUPS(stats_orangefs_default);
 
+static struct kobject *stats_orangefs_obj;
+
+static void stats_orangefs_obj_release(struct kobject *kobj)
+{
+	kfree(stats_orangefs_obj);
+	stats_orangefs_obj = NULL;
+}
+
 static struct kobj_type stats_orangefs_ktype = {
 	.sysfs_ops = &orangefs_sysfs_ops,
 	.default_groups = stats_orangefs_default_groups,
+	.release = stats_orangefs_obj_release,
 };
 
-static struct kobject *orangefs_obj;
-static struct kobject *acache_orangefs_obj;
-static struct kobject *capcache_orangefs_obj;
-static struct kobject *ccache_orangefs_obj;
-static struct kobject *ncache_orangefs_obj;
-static struct kobject *pc_orangefs_obj;
-static struct kobject *stats_orangefs_obj;
-
 int orangefs_sysfs_init(void)
 {
 	int rc = -EINVAL;
-- 
2.35.1


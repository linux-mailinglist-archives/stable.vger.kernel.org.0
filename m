Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7AC253899C
	for <lists+stable@lfdr.de>; Tue, 31 May 2022 03:30:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238311AbiEaBao (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 May 2022 21:30:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231684AbiEaBao (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 21:30:44 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46DE962A2F;
        Mon, 30 May 2022 18:30:42 -0700 (PDT)
Received: from dggpemm500024.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4LBvlp3Nx5zQkQD;
        Tue, 31 May 2022 09:27:34 +0800 (CST)
Received: from dggpemm500013.china.huawei.com (7.185.36.172) by
 dggpemm500024.china.huawei.com (7.185.36.203) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 31 May 2022 09:30:39 +0800
Received: from ubuntu1804.huawei.com (10.67.175.36) by
 dggpemm500013.china.huawei.com (7.185.36.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 31 May 2022 09:30:39 +0800
From:   Chen Zhongjin <chenzhongjin@huawei.com>
To:     <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
CC:     <ebiederm@xmission.com>, <akpm@linux-foundation.org>,
        <paskripkin@gmail.com>, <chenzhongjin@huawei.com>
Subject: [PATCH] profiling: fix shift too large makes kernel panic
Date:   Tue, 31 May 2022 09:28:54 +0800
Message-ID: <20220531012854.229439-1-chenzhongjin@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.175.36]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpemm500013.china.huawei.com (7.185.36.172)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

"2d186afd04d6: profiling: fix shift-out-of-bounds bugs" limits shift
value by [0, BITS_PER_LONG -1], which means [0, 63].

However, syzbot found that the max shift value should be the bit number
of (_etext - _stext). If shift be out of this, the "buffer_bytes" will
be zero and cause kzalloc(0). Then kernel goes panic for derefrence
returned pointer 16.

It can be easily reproduced by pass a large number like 60 to enable
profiling and then run readprofile.

LOGS:
 BUG: kernel NULL pointer dereference, address: 0000000000000010
 #PF: supervisor write access in kernel mode
 #PF: error_code(0x0002) - not-present page
 PGD 6148067 P4D 6148067 PUD 6142067 PMD 0
 PREEMPT SMP
 CPU: 4 PID: 184 Comm: readprofile Not tainted 5.18.0+ #162
 Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.15.0-0-g2dd4b9b3f840-prebuilt.qemu.org 04/01/2014
 RIP: 0010:read_profile+0x104/0x220
 RSP: 0018:ffffc900006fbe80 EFLAGS: 00000202
 RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
 RDX: ffff888006150000 RSI: 0000000000000001 RDI: ffffffff82aba4a0
 RBP: 000000000188bb60 R08: 0000000000000010 R09: ffff888006151000
 R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff82aba4a0
 R13: 0000000000000000 R14: ffffc900006fbf08 R15: 0000000000020c30
 FS:  000000000188a8c0(0000) GS:ffff88803ed00000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 0000000000000010 CR3: 0000000006144000 CR4: 00000000000006e0
 Call Trace:
  <TASK>
  proc_reg_read+0x56/0x70
  vfs_read+0x9a/0x1b0
  ksys_read+0xa1/0xe0
  ? fpregs_assert_state_consistent+0x1e/0x40
  do_syscall_64+0x3a/0x80
  entry_SYSCALL_64_after_hwframe+0x46/0xb0
 RIP: 0033:0x4d4b4e
 RSP: 002b:00007ffebb668d58 EFLAGS: 00000246 ORIG_RAX: 0000000000000000
 RAX: ffffffffffffffda RBX: 000000000188a8a0 RCX: 00000000004d4b4e
 RDX: 0000000000000400 RSI: 000000000188bb60 RDI: 0000000000000003
 RBP: 0000000000000003 R08: 000000000000006e R09: 0000000000000000
 R10: 0000000000000041 R11: 0000000000000246 R12: 000000000188bb60
 R13: 0000000000000400 R14: 0000000000000000 R15: 000000000188bb60
  </TASK>
 Modules linked in:
 CR2: 0000000000000010
Killed
 ---[ end trace 0000000000000000 ]---

Check prof_len in profile_init() to prevent it be zero.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Chen Zhongjin <chenzhongjin@huawei.com>
---
 kernel/profile.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/kernel/profile.c b/kernel/profile.c
index 37640a0bd8a3..ae82ddfc6a68 100644
--- a/kernel/profile.c
+++ b/kernel/profile.c
@@ -109,6 +109,13 @@ int __ref profile_init(void)
 
 	/* only text is profiled */
 	prof_len = (_etext - _stext) >> prof_shift;
+
+	if (!prof_len) {
+		pr_warn("profiling shift: %u too large\n", prof_shift);
+		prof_on = 0;
+		return -EINVAL;
+	}
+
 	buffer_bytes = prof_len*sizeof(atomic_t);
 
 	if (!alloc_cpumask_var(&prof_cpu_mask, GFP_KERNEL))
-- 
2.17.1


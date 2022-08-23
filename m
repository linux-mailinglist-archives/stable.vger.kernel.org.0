Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0B9859E2EE
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:43:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354550AbiHWKm5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 06:42:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355389AbiHWKij (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 06:38:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1744E85F90;
        Tue, 23 Aug 2022 02:07:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6A4CDB81C53;
        Tue, 23 Aug 2022 09:07:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1702C433C1;
        Tue, 23 Aug 2022 09:07:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661245666;
        bh=/+eRUPMPZDWrhSIl0FMK0dBhrrqdcIZx5ZENoVmu4KY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cfLIWVZEOw1aJriTYtZ+dztSynhTQVzVIlvUmLz4z+ojMVG+5deJUbW5GgQ68BKKg
         jxkaksB8rXvMtecszrDP41Op3KREeICmeTcGqPdJkbqiMV+pkT42L0jvnpNjCo4P1t
         vLd8uLP/08m2lH2ZmAOxP9iGCKc7e1YItDfVnim4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chen Zhongjin <chenzhongjin@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 151/287] profiling: fix shift too large makes kernel panic
Date:   Tue, 23 Aug 2022 10:25:20 +0200
Message-Id: <20220823080105.688319242@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080100.268827165@linuxfoundation.org>
References: <20220823080100.268827165@linuxfoundation.org>
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

From: Chen Zhongjin <chenzhongjin@huawei.com>

[ Upstream commit 0fe6ee8f123a4dfb529a5aff07536bb481f34043 ]

2d186afd04d6 ("profiling: fix shift-out-of-bounds bugs") limits shift
value by [0, BITS_PER_LONG -1], which means [0, 63].

However, syzbot found that the max shift value should be the bit number of
(_etext - _stext).  If shift is outside of this, the "buffer_bytes" will
be zero and will cause kzalloc(0).  Then the kernel panics due to
dereferencing the returned pointer 16.

This can be easily reproduced by passing a large number like 60 to enable
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

Link: https://lkml.kernel.org/r/20220531012854.229439-1-chenzhongjin@huawei.com
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Chen Zhongjin <chenzhongjin@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/profile.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/kernel/profile.c b/kernel/profile.c
index efa58f63dc1b..7fc621404230 100644
--- a/kernel/profile.c
+++ b/kernel/profile.c
@@ -108,6 +108,13 @@ int __ref profile_init(void)
 
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
2.35.1




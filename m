Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00BBC3FDC31
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 15:18:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344211AbhIAMrm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 08:47:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:49836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345102AbhIAMp4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 08:45:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 836C86102A;
        Wed,  1 Sep 2021 12:39:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630499965;
        bh=I+mVwJT+jzQOnIbc6Otb6j4VwvX5i2IlPXsOd3tfmmo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PzFeo+G2WQ38IOEr3EkZXVKQdB+k0WFRHQzNWQYNcAgGRgsjdJOf0Ppa1XNPQ4oNX
         iACAC7StoYw7ZCgFBiTcMV94TXK/FOSdQx++/9axmgU+iGErqjd7ODWcKybvgjbmmS
         AoM2phyTmTm2ZQ6h+YiTQMrgS+scnt4n0x691uQU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+01985d7909f9468f013c@syzkaller.appspotmail.com,
        Alexey Gladkov <legion@kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 051/113] ucounts: Increase ucounts reference counter before the security hook
Date:   Wed,  1 Sep 2021 14:28:06 +0200
Message-Id: <20210901122303.683547755@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210901122301.984263453@linuxfoundation.org>
References: <20210901122301.984263453@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexey Gladkov <legion@kernel.org>

[ Upstream commit bbb6d0f3e1feb43d663af089c7dedb23be6a04fb ]

We need to increment the ucounts reference counter befor security_prepare_creds()
because this function may fail and abort_creds() will try to decrement
this reference.

[   96.465056][ T8641] FAULT_INJECTION: forcing a failure.
[   96.465056][ T8641] name fail_page_alloc, interval 1, probability 0, space 0, times 0
[   96.478453][ T8641] CPU: 1 PID: 8641 Comm: syz-executor668 Not tainted 5.14.0-rc6-syzkaller #0
[   96.487215][ T8641] Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
[   96.497254][ T8641] Call Trace:
[   96.500517][ T8641]  dump_stack_lvl+0x1d3/0x29f
[   96.505758][ T8641]  ? show_regs_print_info+0x12/0x12
[   96.510944][ T8641]  ? log_buf_vmcoreinfo_setup+0x498/0x498
[   96.516652][ T8641]  should_fail+0x384/0x4b0
[   96.521141][ T8641]  prepare_alloc_pages+0x1d1/0x5a0
[   96.526236][ T8641]  __alloc_pages+0x14d/0x5f0
[   96.530808][ T8641]  ? __rmqueue_pcplist+0x2030/0x2030
[   96.536073][ T8641]  ? lockdep_hardirqs_on_prepare+0x3e2/0x750
[   96.542056][ T8641]  ? alloc_pages+0x3f3/0x500
[   96.546635][ T8641]  allocate_slab+0xf1/0x540
[   96.551120][ T8641]  ___slab_alloc+0x1cf/0x350
[   96.555689][ T8641]  ? kzalloc+0x1d/0x30
[   96.559740][ T8641]  __kmalloc+0x2e7/0x390
[   96.563980][ T8641]  ? kzalloc+0x1d/0x30
[   96.568029][ T8641]  kzalloc+0x1d/0x30
[   96.571903][ T8641]  security_prepare_creds+0x46/0x220
[   96.577174][ T8641]  prepare_creds+0x411/0x640
[   96.581747][ T8641]  __sys_setfsuid+0xe2/0x3a0
[   96.586333][ T8641]  do_syscall_64+0x3d/0xb0
[   96.590739][ T8641]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[   96.596611][ T8641] RIP: 0033:0x445a69
[   96.600483][ T8641] Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 11 15 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
[   96.620152][ T8641] RSP: 002b:00007f1054173318 EFLAGS: 00000246 ORIG_RAX: 000000000000007a
[   96.628543][ T8641] RAX: ffffffffffffffda RBX: 00000000004ca4c8 RCX: 0000000000445a69
[   96.636600][ T8641] RDX: 0000000000000010 RSI: 00007f10541732f0 RDI: 0000000000000000
[   96.644550][ T8641] RBP: 00000000004ca4c0 R08: 0000000000000001 R09: 0000000000000000
[   96.652500][ T8641] R10: 0000000000000000 R11: 0000000000000246 R12: 00000000004ca4cc
[   96.660631][ T8641] R13: 00007fffffe0b62f R14: 00007f1054173400 R15: 0000000000022000

Fixes: 905ae01c4ae2 ("Add a reference to ucounts for each cred")
Reported-by: syzbot+01985d7909f9468f013c@syzkaller.appspotmail.com
Signed-off-by: Alexey Gladkov <legion@kernel.org>
Link: https://lkml.kernel.org/r/97433b1742c3331f02ad92de5a4f07d673c90613.1629735352.git.legion@kernel.org
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/cred.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/kernel/cred.c b/kernel/cred.c
index 9c2759166bd8..0f84958d1db9 100644
--- a/kernel/cred.c
+++ b/kernel/cred.c
@@ -286,13 +286,13 @@ struct cred *prepare_creds(void)
 	new->security = NULL;
 #endif
 
-	if (security_prepare_creds(new, old, GFP_KERNEL_ACCOUNT) < 0)
-		goto error;
-
 	new->ucounts = get_ucounts(new->ucounts);
 	if (!new->ucounts)
 		goto error;
 
+	if (security_prepare_creds(new, old, GFP_KERNEL_ACCOUNT) < 0)
+		goto error;
+
 	validate_creds(new);
 	return new;
 
@@ -753,13 +753,13 @@ struct cred *prepare_kernel_cred(struct task_struct *daemon)
 #ifdef CONFIG_SECURITY
 	new->security = NULL;
 #endif
-	if (security_prepare_creds(new, old, GFP_KERNEL_ACCOUNT) < 0)
-		goto error;
-
 	new->ucounts = get_ucounts(new->ucounts);
 	if (!new->ucounts)
 		goto error;
 
+	if (security_prepare_creds(new, old, GFP_KERNEL_ACCOUNT) < 0)
+		goto error;
+
 	put_cred(old);
 	validate_creds(new);
 	return new;
-- 
2.30.2




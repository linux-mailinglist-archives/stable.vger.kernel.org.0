Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9338C59D911
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 12:05:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243465AbiHWJNB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 05:13:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348525AbiHWJKa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 05:10:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E22D86CF51;
        Tue, 23 Aug 2022 01:30:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2F58E614C5;
        Tue, 23 Aug 2022 08:29:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E016C433D6;
        Tue, 23 Aug 2022 08:29:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661243344;
        bh=+u7StSxrYGzH7Cn/hxGYZHiedHN3GtCGunx154eqRKk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1euO1UfI8W/n4/AJK15B30Ex7MWYhK2VIyZ97x3bDuKgk5SeZTXzVrB4XNsyfvLzv
         OqG4HkOqsPaxU4QPgWn23qN2d3GV6kJxyQzD+B93KHiimkTXMGJSVmMl9wzsz9rmQB
         MBx27R91wu/MoQxlUj9H2fV22mv0kO9dsJPw47oc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Melissa Wen <mwen@igalia.com>,
        =?UTF-8?q?Ma=C3=ADra=20Canal?= <mairacanal@riseup.net>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 248/365] drm/amdgpu: Fix use-after-free on amdgpu_bo_list mutex
Date:   Tue, 23 Aug 2022 10:02:29 +0200
Message-Id: <20220823080128.578248859@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080118.128342613@linuxfoundation.org>
References: <20220823080118.128342613@linuxfoundation.org>
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

From: Maíra Canal <mairacanal@riseup.net>

[ Upstream commit bbca24d0a3c11193bafb9e174f89f52a379006e3 ]

If amdgpu_cs_vm_handling returns r != 0, then it will unlock the
bo_list_mutex inside the function amdgpu_cs_vm_handling and again on
amdgpu_cs_parser_fini. This problem results in the following
use-after-free problem:

[ 220.280990] ------------[ cut here ]------------
[ 220.281000] refcount_t: underflow; use-after-free.
[ 220.281019] WARNING: CPU: 1 PID: 3746 at lib/refcount.c:28 refcount_warn_saturate+0xba/0x110
[ 220.281029] ------------[ cut here ]------------
[ 220.281415] CPU: 1 PID: 3746 Comm: chrome:cs0 Tainted: G W L ------- --- 5.20.0-0.rc0.20220812git7ebfc85e2cd7.10.fc38.x86_64 #1
[ 220.281421] Hardware name: System manufacturer System Product Name/ROG STRIX X570-I GAMING, BIOS 4403 04/27/2022
[ 220.281426] RIP: 0010:refcount_warn_saturate+0xba/0x110
[ 220.281431] Code: 01 01 e8 79 4a 6f 00 0f 0b e9 42 47 a5 00 80 3d de
7e be 01 00 75 85 48 c7 c7 f8 98 8e 98 c6 05 ce 7e be 01 01 e8 56 4a
6f 00 <0f> 0b e9 1f 47 a5 00 80 3d b9 7e be 01 00 0f 85 5e ff ff ff 48
c7
[ 220.281437] RSP: 0018:ffffb4b0d18d7a80 EFLAGS: 00010282
[ 220.281443] RAX: 0000000000000026 RBX: 0000000000000003 RCX: 0000000000000000
[ 220.281448] RDX: 0000000000000001 RSI: ffffffff988d06dc RDI: 00000000ffffffff
[ 220.281452] RBP: 00000000ffffffff R08: 0000000000000000 R09: ffffb4b0d18d7930
[ 220.281457] R10: 0000000000000003 R11: ffffa0672e2fffe8 R12: ffffa058ca360400
[ 220.281461] R13: ffffa05846c50a18 R14: 00000000fffffe00 R15: 0000000000000003
[ 220.281465] FS: 00007f82683e06c0(0000) GS:ffffa066e2e00000(0000) knlGS:0000000000000000
[ 220.281470] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 220.281475] CR2: 00003590005cc000 CR3: 00000001fca46000 CR4: 0000000000350ee0
[ 220.281480] Call Trace:
[ 220.281485] <TASK>
[ 220.281490] amdgpu_cs_ioctl+0x4e2/0x2070 [amdgpu]
[ 220.281806] ? amdgpu_cs_find_mapping+0xe0/0xe0 [amdgpu]
[ 220.282028] drm_ioctl_kernel+0xa4/0x150
[ 220.282043] drm_ioctl+0x21f/0x420
[ 220.282053] ? amdgpu_cs_find_mapping+0xe0/0xe0 [amdgpu]
[ 220.282275] ? lock_release+0x14f/0x460
[ 220.282282] ? _raw_spin_unlock_irqrestore+0x30/0x60
[ 220.282290] ? _raw_spin_unlock_irqrestore+0x30/0x60
[ 220.282297] ? lockdep_hardirqs_on+0x7d/0x100
[ 220.282305] ? _raw_spin_unlock_irqrestore+0x40/0x60
[ 220.282317] amdgpu_drm_ioctl+0x4a/0x80 [amdgpu]
[ 220.282534] __x64_sys_ioctl+0x90/0xd0
[ 220.282545] do_syscall_64+0x5b/0x80
[ 220.282551] ? futex_wake+0x6c/0x150
[ 220.282568] ? lock_is_held_type+0xe8/0x140
[ 220.282580] ? do_syscall_64+0x67/0x80
[ 220.282585] ? lockdep_hardirqs_on+0x7d/0x100
[ 220.282592] ? do_syscall_64+0x67/0x80
[ 220.282597] ? do_syscall_64+0x67/0x80
[ 220.282602] ? lockdep_hardirqs_on+0x7d/0x100
[ 220.282609] entry_SYSCALL_64_after_hwframe+0x63/0xcd
[ 220.282616] RIP: 0033:0x7f8282a4f8bf
[ 220.282639] Code: 00 48 89 44 24 18 31 c0 48 8d 44 24 60 c7 04 24 10
00 00 00 48 89 44 24 08 48 8d 44 24 20 48 89 44 24 10 b8 10 00 00 00
0f 05 <89> c2 3d 00 f0 ff ff 77 18 48 8b 44 24 18 64 48 2b 04 25 28 00
00
[ 220.282644] RSP: 002b:00007f82683df410 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
[ 220.282651] RAX: ffffffffffffffda RBX: 00007f82683df588 RCX: 00007f8282a4f8bf
[ 220.282655] RDX: 00007f82683df4d0 RSI: 00000000c0186444 RDI: 0000000000000018
[ 220.282659] RBP: 00007f82683df4d0 R08: 00007f82683df5e0 R09: 00007f82683df4b0
[ 220.282663] R10: 00001d04000a0600 R11: 0000000000000246 R12: 00000000c0186444
[ 220.282667] R13: 0000000000000018 R14: 00007f82683df588 R15: 0000000000000003
[ 220.282689] </TASK>
[ 220.282693] irq event stamp: 6232311
[ 220.282697] hardirqs last enabled at (6232319): [<ffffffff9718cd7e>] __up_console_sem+0x5e/0x70
[ 220.282704] hardirqs last disabled at (6232326): [<ffffffff9718cd63>] __up_console_sem+0x43/0x70
[ 220.282709] softirqs last enabled at (6232072): [<ffffffff970ff669>] __irq_exit_rcu+0xf9/0x170
[ 220.282716] softirqs last disabled at (6232061): [<ffffffff970ff669>] __irq_exit_rcu+0xf9/0x170
[ 220.282722] ---[ end trace 0000000000000000 ]---

Therefore, remove the mutex_unlock from the amdgpu_cs_vm_handling
function, so that amdgpu_cs_submit and amdgpu_cs_parser_fini can handle
the unlock.

Fixes: 90af0ca047f3 ("drm/amdgpu: Protect the amdgpu_bo_list list with a mutex v2")
Reported-by: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Melissa Wen <mwen@igalia.com>
Signed-off-by: Maíra Canal <mairacanal@riseup.net>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
index d8f1335bc68f..b7bae833c804 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
@@ -837,16 +837,12 @@ static int amdgpu_cs_vm_handling(struct amdgpu_cs_parser *p)
 			continue;
 
 		r = amdgpu_vm_bo_update(adev, bo_va, false);
-		if (r) {
-			mutex_unlock(&p->bo_list->bo_list_mutex);
+		if (r)
 			return r;
-		}
 
 		r = amdgpu_sync_fence(&p->job->sync, bo_va->last_pt_update);
-		if (r) {
-			mutex_unlock(&p->bo_list->bo_list_mutex);
+		if (r)
 			return r;
-		}
 	}
 
 	r = amdgpu_vm_handle_moved(adev, vm);
-- 
2.35.1




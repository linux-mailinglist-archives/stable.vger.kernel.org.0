Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97A68537B68
	for <lists+stable@lfdr.de>; Mon, 30 May 2022 15:24:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236542AbiE3NYl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 May 2022 09:24:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236538AbiE3NYk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 09:24:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72D1671A1A;
        Mon, 30 May 2022 06:24:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EABB9B80DA7;
        Mon, 30 May 2022 13:24:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66562C385B8;
        Mon, 30 May 2022 13:24:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653917074;
        bh=m8OgePpjLaw3vqTYFrtd4bJ7YgU/xYB3M8CWzOMVcdc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bX11V3oMN+/wnYPlL0/UAMWBEEmOveKuwZ82Wee9Mvbuw/IGBTjuL4Z+eUJbvkWOM
         hyhl4xzFyrhnPVAuk0Nx5gKXgE9lk2j3UI78EajiXZtVKCOYSHp9j7DHSlE8Vdr681
         m1rfjeEMBfCVq22gA6uABRrEYpO+9oHVx2gYzt4YSrCir1cPQZE4sI1NorY7mo9yCA
         vYJ9h875kxRYoTrZqUq2LWL4tiqT8apHzrGXb1VurPxT15XTfzbGn4cg3KiKJmUL61
         pIfgYeV5ijGa3S4C6Bp/FpMbiC+EHteTC3ATR46cdNMfm/i/CnMDZNycHif/4zj1s7
         kKuaSfc3Ssziw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Arunpravin <Arunpravin.PaneerSelvam@amd.com>,
        kernel test robot <oliver.sang@intel.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Sasha Levin <sashal@kernel.org>, airlied@linux.ie,
        daniel@ffwll.ch, matthew.auld@intel.com, dan.carpenter@oracle.com,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.18 002/159] drm/selftests: fix a shift-out-of-bounds bug
Date:   Mon, 30 May 2022 09:21:47 -0400
Message-Id: <20220530132425.1929512-2-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220530132425.1929512-1-sashal@kernel.org>
References: <20220530132425.1929512-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arunpravin <Arunpravin.PaneerSelvam@amd.com>

[ Upstream commit fc3785fb56a27304c769af730d079f4337d4dc76 ]

pass the correct size value computed using the max_order.

<log snip>

[ 68.124177][ T1] UBSAN: shift-out-of-bounds in include/linux/log2.h:67:13
[ 68.125333][ T1] shift exponent 4294967295 is too large for 32-bit type 'long
unsigned int'
[ 68.126563][ T1] CPU: 0 PID: 1 Comm: swapper Not tainted
5.17.0-rc2-00311-g39ec47bbfd5d #2
[ 68.127758][ T1] Call Trace:
[ 68.128187][ T1] dump_stack_lvl (lib/dump_stack.c:108)
[ 68.128793][ T1] dump_stack (lib/dump_stack.c:114)
[ 68.129331][ T1] ubsan_epilogue (lib/ubsan.c:152)
[ 68.129958][ T1] __ubsan_handle_shift_out_of_bounds.cold (arch/x86/include/asm/smap.h:85)

[ 68.130791][ T1] ? drm_block_alloc+0x28/0x80
[ 68.131582][ T1] ? rcu_read_lock_sched_held (kernel/rcu/update.c:125)
[ 68.132215][ T1] ? kmem_cache_alloc (include/trace/events/kmem.h:54 mm/slab.c:3501)
[ 68.132878][ T1] ? mark_free+0x2e/0x80
[ 68.133524][ T1] drm_buddy_init.cold (include/linux/log2.h:67
drivers/gpu/drm/drm_buddy.c:131)
[ 68.134145][ T1] ? test_drm_cmdline_init (drivers/gpu/drm/selftests/test-drm_buddy.c:87)

[ 68.134770][ T1] igt_buddy_alloc_limit (drivers/gpu/drm/selftests/test-drm_buddy.c:30)
[ 68.135472][ T1] ? vprintk_default (kernel/printk/printk.c:2257)
[ 68.136057][ T1] ? test_drm_cmdline_init (drivers/gpu/drm/selftests/test-drm_buddy.c:87)

[ 68.136812][ T1] test_drm_buddy_init (drivers/gpu/drm/selftests/drm_selftest.c:77
drivers/gpu/drm/selftests/test-drm_buddy.c:95)
[ 68.137475][ T1] do_one_initcall (init/main.c:1300)
[ 68.138111][ T1] ? parse_args (kernel/params.c:609 kernel/params.c:146
kernel/params.c:188)
[ 68.138717][ T1] do_basic_setup (init/main.c:1372 init/main.c:1389 init/main.c:1408)
[ 68.139366][ T1] kernel_init_freeable (init/main.c:1617)
[ 68.140040][ T1] ? rest_init (init/main.c:1494)
[ 68.140634][ T1] kernel_init (init/main.c:1504)
[ 68.141155][ T1] ret_from_fork (arch/x86/entry/entry_32.S:772)
[ 68.141607][ T1]
================================================================================
[ 68.146730][ T1] ------------[ cut here ]------------
[ 68.147460][ T1] kernel BUG at drivers/gpu/drm/drm_buddy.c:140!
[ 68.148280][ T1] invalid opcode: 0000 [#1]
[ 68.148895][ T1] CPU: 0 PID: 1 Comm: swapper Not tainted
5.17.0-rc2-00311-g39ec47bbfd5d #2
[ 68.149896][ T1] EIP: drm_buddy_init (drivers/gpu/drm/drm_buddy.c:140 (discriminator 1))

For more details: https://lists.01.org/hyperkitty/list/lkp@lists.01.org/thread/FDIF3HCILZNN5UQAZMOR7E3MQSMHHKWU/

Signed-off-by: Arunpravin <Arunpravin.PaneerSelvam@amd.com>
Reported-by: kernel test robot <oliver.sang@intel.com>
Acked-by: Christian König <christian.koenig@amd.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220303201602.2365-1-Arunpravin.PaneerSelvam@amd.com
Signed-off-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/selftests/test-drm_buddy.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/selftests/test-drm_buddy.c b/drivers/gpu/drm/selftests/test-drm_buddy.c
index fa997f89522b..913cbd7eae04 100644
--- a/drivers/gpu/drm/selftests/test-drm_buddy.c
+++ b/drivers/gpu/drm/selftests/test-drm_buddy.c
@@ -902,14 +902,13 @@ static int igt_buddy_alloc_range(void *arg)
 
 static int igt_buddy_alloc_limit(void *arg)
 {
-	u64 end, size = U64_MAX, start = 0;
+	u64 size = U64_MAX, start = 0;
 	struct drm_buddy_block *block;
 	unsigned long flags = 0;
 	LIST_HEAD(allocated);
 	struct drm_buddy mm;
 	int err;
 
-	size = end = round_down(size, 4096);
 	err = drm_buddy_init(&mm, size, PAGE_SIZE);
 	if (err)
 		return err;
@@ -921,7 +920,8 @@ static int igt_buddy_alloc_limit(void *arg)
 		goto out_fini;
 	}
 
-	err = drm_buddy_alloc_blocks(&mm, start, end, size,
+	size = mm.chunk_size << mm.max_order;
+	err = drm_buddy_alloc_blocks(&mm, start, size, size,
 				     PAGE_SIZE, &allocated, flags);
 
 	if (unlikely(err))
-- 
2.35.1


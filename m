Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B662541784
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:03:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378245AbiFGVDk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:03:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350136AbiFGVC3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:02:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4B11110AF0;
        Tue,  7 Jun 2022 11:48:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 10B3161295;
        Tue,  7 Jun 2022 18:48:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A86EC385A2;
        Tue,  7 Jun 2022 18:48:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654627685;
        bh=m8OgePpjLaw3vqTYFrtd4bJ7YgU/xYB3M8CWzOMVcdc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e/oWGqFhgz6Sls5I8jP4TnsSnUYARZxCcVh9vKx0f8v7LDsJhZ+eMhdmwwguqmfVL
         lo5Jnt9GWDyqdVJA/uRaWao9YB80zVoIaFASy30/U76054tMMYtswuuMRDIMUMcnpW
         iz84ZuL7G6OTsLmaxfKK7fYPoCUSf/f0wg41tnOk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Arunpravin <Arunpravin.PaneerSelvam@amd.com>,
        kernel test robot <oliver.sang@intel.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 055/879] drm/selftests: fix a shift-out-of-bounds bug
Date:   Tue,  7 Jun 2022 18:52:53 +0200
Message-Id: <20220607165004.286931280@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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




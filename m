Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D79B5E8A36
	for <lists+stable@lfdr.de>; Sat, 24 Sep 2022 10:39:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233529AbiIXIju (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 24 Sep 2022 04:39:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233616AbiIXIjt (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 24 Sep 2022 04:39:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AE785FB0
        for <stable@vger.kernel.org>; Sat, 24 Sep 2022 01:39:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F321BB80E04
        for <stable@vger.kernel.org>; Sat, 24 Sep 2022 08:39:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55EDFC433C1;
        Sat, 24 Sep 2022 08:39:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664008770;
        bh=1I642gZGU5ZzkWPzTXRf4Yx43051RF8OhLMAc26I4MQ=;
        h=Subject:To:Cc:From:Date:From;
        b=pNs0U41sVRr4oS0+3LpBHpV2ns7kN2a5D+Rx7DD+bG9U3DHwrIttDOdSDMS3jVlhe
         vh+zNPoPji5Jqv12gc337YXwHsd+caSwAfIRB18TXdyQlWNp5PPd5GBgUWVTUipXox
         y8SLYs24rfHwUa6HodlHAeumveCjWWIngdICPDSs=
Subject: FAILED: patch "[PATCH] drm/i915/gem: Really move i915_gem_context.link under ref" failed to apply to 5.15-stable tree
To:     chris@chris-wilson.co.uk, andi.shyti@linux.intel.com,
        janusz.krzysztofik@linux.intel.com, mark.janes@intel.com,
        rodrigo.vivi@intel.com, stable@vger.kernel.org,
        tvrtko.ursulin@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 24 Sep 2022 10:39:28 +0200
Message-ID: <1664008768177251@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

d119888b09bd ("drm/i915/gem: Really move i915_gem_context.link under ref protection")
49bd54b390c2 ("drm/i915: Track all user contexts per client")
43c504607dc3 ("drm/i915: Make GEM contexts track DRM clients")
5f0d4d1463cc ("drm/i915: Explicitly track DRM clients")
bec68cc9ea42 ("drm/i915: Prepare for multiple GTs")
fa732088378f ("drm/i915: Rename INTEL_REGION_LMEM with INTEL_REGION_LMEM_0")
7fe7c2a679dc ("drm/i915: fixup the initial fb base on DGFX")
9b78b5dade2d ("drm/i915: add i915_gem_object_create_region_at()")
b7563ec7d906 ("drm/i915: Report steering details in debugfs")
e1a7ab4fca0c ("drm/i915: Remove the vm open count")
c03d98267033 ("drm/i915: Clarify vma lifetime")
d2cc01e1794b ("drm/i915: apply PM_EARLY for non-GTT mappable objects")
db927686e43f ("Merge drm/drm-next into drm-intel-gt-next")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From d119888b09bd567e07c6b93a07f175df88857e02 Mon Sep 17 00:00:00 2001
From: Chris Wilson <chris@chris-wilson.co.uk>
Date: Fri, 16 Sep 2022 11:24:03 +0200
Subject: [PATCH] drm/i915/gem: Really move i915_gem_context.link under ref
 protection

i915_perf assumes that it can use the i915_gem_context reference to
protect its i915->gem.contexts.list iteration. However, this requires
that we do not remove the context from the list until after we drop the
final reference and release the struct. If, as currently, we remove the
context from the list during context_close(), the link.next pointer may
be poisoned while we are holding the context reference and cause a GPF:

[ 4070.573157] i915 0000:00:02.0: [drm:i915_perf_open_ioctl [i915]] filtering on ctx_id=0x1fffff ctx_id_mask=0x1fffff
[ 4070.574881] general protection fault, probably for non-canonical address 0xdead000000000100: 0000 [#1] PREEMPT SMP
[ 4070.574897] CPU: 1 PID: 284392 Comm: amd_performance Tainted: G            E     5.17.9 #180
[ 4070.574903] Hardware name: Intel Corporation NUC7i5BNK/NUC7i5BNB, BIOS BNKBL357.86A.0052.2017.0918.1346 09/18/2017
[ 4070.574907] RIP: 0010:oa_configure_all_contexts.isra.0+0x222/0x350 [i915]
[ 4070.574982] Code: 08 e8 32 6e 10 e1 4d 8b 6d 50 b8 ff ff ff ff 49 83 ed 50 f0 41 0f c1 04 24 83 f8 01 0f 84 e3 00 00 00 85 c0 0f 8e fa 00 00 00 <49> 8b 45 50 48 8d 70 b0 49 8d 45 50 48 39 44 24 10 0f 85 34 fe ff
[ 4070.574990] RSP: 0018:ffffc90002077b78 EFLAGS: 00010202
[ 4070.574995] RAX: 0000000000000002 RBX: 0000000000000002 RCX: 0000000000000000
[ 4070.575000] RDX: 0000000000000001 RSI: ffffc90002077b20 RDI: ffff88810ddc7c68
[ 4070.575004] RBP: 0000000000000001 R08: ffff888103242648 R09: fffffffffffffffc
[ 4070.575008] R10: ffffffff82c50bc0 R11: 0000000000025c80 R12: ffff888101bf1860
[ 4070.575012] R13: dead0000000000b0 R14: ffffc90002077c04 R15: ffff88810be5cabc
[ 4070.575016] FS:  00007f1ed50c0780(0000) GS:ffff88885ec80000(0000) knlGS:0000000000000000
[ 4070.575021] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 4070.575025] CR2: 00007f1ed5590280 CR3: 000000010ef6f005 CR4: 00000000003706e0
[ 4070.575029] Call Trace:
[ 4070.575033]  <TASK>
[ 4070.575037]  lrc_configure_all_contexts+0x13e/0x150 [i915]
[ 4070.575103]  gen8_enable_metric_set+0x4d/0x90 [i915]
[ 4070.575164]  i915_perf_open_ioctl+0xbc0/0x1500 [i915]
[ 4070.575224]  ? asm_common_interrupt+0x1e/0x40
[ 4070.575232]  ? i915_oa_init_reg_state+0x110/0x110 [i915]
[ 4070.575290]  drm_ioctl_kernel+0x85/0x110
[ 4070.575296]  ? update_load_avg+0x5f/0x5e0
[ 4070.575302]  drm_ioctl+0x1d3/0x370
[ 4070.575307]  ? i915_oa_init_reg_state+0x110/0x110 [i915]
[ 4070.575382]  ? gen8_gt_irq_handler+0x46/0x130 [i915]
[ 4070.575445]  __x64_sys_ioctl+0x3c4/0x8d0
[ 4070.575451]  ? __do_softirq+0xaa/0x1d2
[ 4070.575456]  do_syscall_64+0x35/0x80
[ 4070.575461]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[ 4070.575467] RIP: 0033:0x7f1ed5c10397
[ 4070.575471] Code: 3c 1c e8 1c ff ff ff 85 c0 79 87 49 c7 c4 ff ff ff ff 5b 5d 4c 89 e0 41 5c c3 66 0f 1f 84 00 00 00 00 00 b8 10 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d a9 da 0d 00 f7 d8 64 89 01 48
[ 4070.575478] RSP: 002b:00007ffd65c8d7a8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
[ 4070.575484] RAX: ffffffffffffffda RBX: 0000000000000006 RCX: 00007f1ed5c10397
[ 4070.575488] RDX: 00007ffd65c8d7c0 RSI: 0000000040106476 RDI: 0000000000000006
[ 4070.575492] RBP: 00005620972f9c60 R08: 000000000000000a R09: 0000000000000005
[ 4070.575496] R10: 000000000000000d R11: 0000000000000246 R12: 000000000000000a
[ 4070.575500] R13: 000000000000000d R14: 0000000000000000 R15: 00007ffd65c8d7c0
[ 4070.575505]  </TASK>
[ 4070.575507] Modules linked in: nls_ascii(E) nls_cp437(E) vfat(E) fat(E) i915(E) x86_pkg_temp_thermal(E) intel_powerclamp(E) crct10dif_pclmul(E) crc32_pclmul(E) crc32c_intel(E) aesni_intel(E) crypto_simd(E) intel_gtt(E) cryptd(E) ttm(E) rapl(E) intel_cstate(E) drm_kms_helper(E) cfbfillrect(E) syscopyarea(E) cfbimgblt(E) intel_uncore(E) sysfillrect(E) mei_me(E) sysimgblt(E) i2c_i801(E) fb_sys_fops(E) mei(E) intel_pch_thermal(E) i2c_smbus(E) cfbcopyarea(E) video(E) button(E) efivarfs(E) autofs4(E)
[ 4070.575549] ---[ end trace 0000000000000000 ]---

v3: fix incorrect syntax of spin_lock() replacing spin_lock_irqsave()

v2: irqsave not required in a worker, neither conversion to irq safe
    elsewhere (Tvrtko),
  - perf: it's safe to call gen8_configure_context() even if context has
    been closed, no need to check,
  - drop unrelated cleanup (Andi, Tvrtko)

Reported-by: Mark Janes <mark.janes@intel.com>
Closes: https://gitlab.freedesktop.org/drm/intel/issues/6222
References: a4e7ccdac38e ("drm/i915: Move context management under GEM")
Fixes: f8246cf4d9a9 ("drm/i915/gem: Drop free_work for GEM contexts")
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Reviewed-by: Andi Shyti <andi.shyti@linux.intel.com>
Signed-off-by: Janusz Krzysztofik <janusz.krzysztofik@linux.intel.com>
Cc: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Cc: <stable@vger.kernel.org> # v5.12+
Signed-off-by: Andi Shyti <andi.shyti@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220916092403.201355-3-janusz.krzysztofik@linux.intel.com
(cherry picked from commit ad3aa7c31efa5a09b0dba42e66cfdf77e0db7dc2)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>

diff --git a/drivers/gpu/drm/i915/gem/i915_gem_context.c b/drivers/gpu/drm/i915/gem/i915_gem_context.c
index dabdfe09f5e5..0bcde53c50c6 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_context.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_context.c
@@ -1269,6 +1269,10 @@ static void i915_gem_context_release_work(struct work_struct *work)
 	trace_i915_context_free(ctx);
 	GEM_BUG_ON(!i915_gem_context_is_closed(ctx));
 
+	spin_lock(&ctx->i915->gem.contexts.lock);
+	list_del(&ctx->link);
+	spin_unlock(&ctx->i915->gem.contexts.lock);
+
 	if (ctx->syncobj)
 		drm_syncobj_put(ctx->syncobj);
 
@@ -1521,10 +1525,6 @@ static void context_close(struct i915_gem_context *ctx)
 
 	ctx->file_priv = ERR_PTR(-EBADF);
 
-	spin_lock(&ctx->i915->gem.contexts.lock);
-	list_del(&ctx->link);
-	spin_unlock(&ctx->i915->gem.contexts.lock);
-
 	client = ctx->client;
 	if (client) {
 		spin_lock(&client->ctx_lock);


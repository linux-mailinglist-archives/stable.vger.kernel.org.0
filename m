Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66DC0269CAB
	for <lists+stable@lfdr.de>; Tue, 15 Sep 2020 05:43:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726120AbgIODni (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Sep 2020 23:43:38 -0400
Received: from mga14.intel.com ([192.55.52.115]:17029 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726019AbgIODnh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Sep 2020 23:43:37 -0400
IronPort-SDR: SrTpG7h6dt36Eu3uZzYLJXXsnQHwiphOJwofuaaSIcmKdYz2g1l706CmuE7x/amndhqVh1Rxsw
 UKx4Z+/1ZO/g==
X-IronPort-AV: E=McAfee;i="6000,8403,9744"; a="158479930"
X-IronPort-AV: E=Sophos;i="5.76,428,1592895600"; 
   d="scan'208";a="158479930"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2020 20:43:36 -0700
IronPort-SDR: tbHh1+mQ6HN95vTUK7Ea87D1JDw6r8GgQB9IwOI57BEOgLbPkft3yKO+Jz13vBAYzxFa/4TouK
 cCyPRIZGAb+w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,428,1592895600"; 
   d="scan'208";a="331008010"
Received: from unknown (HELO ndadhani-NUC7i5BNKP.iind.intel.com) ([10.223.165.84])
  by fmsmga004.fm.intel.com with ESMTP; 14 Sep 2020 20:43:33 -0700
From:   "Nikunj A. Dadhania" <nikunj.dadhania@linux.intel.com>
To:     intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        chris@chris-wilson.co.uk,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>
Cc:     nikunj.dadhania@linux.intel.com, tvrtko.ursulin@intel.com,
        stable@vger.kernel.org
Subject: [PATCH v2] drm/i915: Fix the race between the GEM close and debugfs
Date:   Tue, 15 Sep 2020 09:11:18 +0530
Message-Id: <20200915034118.32256-1-nikunj.dadhania@linux.intel.com>
X-Mailer: git-send-email 2.17.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

As we close GEM object and set file_priv to -EBADF which is protected
by ctx->mutex, populating the GEM debugfs info is not protected
and results in the crash shown below.

Make sure to protect the access to file_priv using ctx->mutex to avoid
race.

BUG: unable to handle page fault for address: ffffffffffffffff
RIP: 0010:i915_gem_object_info+0x26b/0x3eb
Code: 89 44 24 48 48 89 44 24 40 48 89 44 24 38 48 89 44 24 30 48 89 44 24 28 48 89 44 24 20 49 8b 46 f0 48 89 44 24 20 49 8b 46 a0 <48> 8b 58 08 b9 0a 00 00 00 48 b8 aa aa aa aa aa aa aa aa 48 8d bc
RSP: 0018:ffffac81c14cfc30 EFLAGS: 00010246
RAX: fffffffffffffff7 RBX: ffff95094429c218 RCX: ffff95096756c740
RDX: 0000000000000000 RSI: ffffffff919b93ee RDI: ffff95094429c218
RBP: ffffac81c14cfd58 R08: ffff9509746fab80 R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000000 R12: ffff9509753f8e80
R13: ffffac81c14cfc98 R14: ffff95094429c268 R15: ffffac81c14cfc88
FS:  00007a1bdcd52900(0000) GS:ffff950977e00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffffffffffffff CR3: 000000026b4e0000 CR4: 0000000000340ef0
Call Trace:
 seq_read+0x162/0x3ca
 full_proxy_read+0x5b/0x8d
 __vfs_read+0x45/0x1b9
 vfs_read+0xc9/0x15e
 ksys_read+0x7e/0xde
 do_syscall_64+0x54/0x7e
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x7a1bdd34cf03

Signed-off-by: Nikunj A. Dadhania <nikunj.dadhania@linux.intel.com>
Reviewed-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Cc: stable@vger.kernel.org
---
 drivers/gpu/drm/i915/i915_debugfs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/i915/i915_debugfs.c b/drivers/gpu/drm/i915/i915_debugfs.c
index 784219962193..ea469168cd44 100644
--- a/drivers/gpu/drm/i915/i915_debugfs.c
+++ b/drivers/gpu/drm/i915/i915_debugfs.c
@@ -326,6 +326,7 @@ static void print_context_stats(struct seq_file *m,
 		}
 		i915_gem_context_unlock_engines(ctx);
 
+		mutex_lock(&ctx->mutex);
 		if (!IS_ERR_OR_NULL(ctx->file_priv)) {
 			struct file_stats stats = {
 				.vm = rcu_access_pointer(ctx->vm),
@@ -346,6 +347,7 @@ static void print_context_stats(struct seq_file *m,
 
 			print_file_stats(m, name, stats);
 		}
+		mutex_unlock(&ctx->mutex);
 
 		spin_lock(&i915->gem.contexts.lock);
 		list_safe_reset_next(ctx, cn, link);
-- 
2.17.1


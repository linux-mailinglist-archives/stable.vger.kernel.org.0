Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BAC320DB91
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 22:15:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732955AbgF2TaY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 15:30:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:40594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732882AbgF2TaV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:30:21 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D1BE925285;
        Mon, 29 Jun 2020 15:36:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593444995;
        bh=cN7Ws5kFubXu9Ze739Ig/VKXejpZSMxSGXVMrzTa6eU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0pgpET9zrMoInm+oUnSKxk1nLF9tKeAKNDdY/Ae5TUQH0PMEWQMoTMQHDEST18ilp
         l6ija1OTbFTfBd6nqBpT9yK2lmIipepRyM3cnOSuQrzaNt2hanq8lzcSoLe2bgwVCS
         +irXn5o05bjVtMIyk7VnOKvHWw7oO+tlEXgt0Exc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dave Martin <Dave.Martin@arm.com>, Will Deacon <will@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 095/131] arm64/sve: Eliminate data races on sve_default_vl
Date:   Mon, 29 Jun 2020 11:34:26 -0400
Message-Id: <20200629153502.2494656-96-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629153502.2494656-1-sashal@kernel.org>
References: <20200629153502.2494656-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.131-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.131-rc1
X-KernelTest-Deadline: 2020-07-01T15:34+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dave Martin <Dave.Martin@arm.com>

[ Upstream commit 1e570f512cbdc5e9e401ba640d9827985c1bea1e ]

sve_default_vl can be modified via the /proc/sys/abi/sve_default_vl
sysctl concurrently with use, and modified concurrently by multiple
threads.

Adding a lock for this seems overkill, and I don't want to think any
more than necessary, so just define wrappers using READ_ONCE()/
WRITE_ONCE().

This will avoid the possibility of torn accesses and repeated loads
and stores.

There's no evidence yet that this is going wrong in practice: this
is just hygiene.  For generic sysctl users, it would be better to
build this kind of thing into the sysctl common code somehow.

Reported-by: Will Deacon <will@kernel.org>
Signed-off-by: Dave Martin <Dave.Martin@arm.com>
Link: https://lore.kernel.org/r/1591808590-20210-3-git-send-email-Dave.Martin@arm.com
[will: move set_sve_default_vl() inside #ifdef to squash allnoconfig warning]
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/fpsimd.c | 25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
index 14fdbaa6ee3ab..af59b42973141 100644
--- a/arch/arm64/kernel/fpsimd.c
+++ b/arch/arm64/kernel/fpsimd.c
@@ -22,6 +22,7 @@
 #include <linux/bug.h>
 #include <linux/cache.h>
 #include <linux/compat.h>
+#include <linux/compiler.h>
 #include <linux/cpu.h>
 #include <linux/cpu_pm.h>
 #include <linux/kernel.h>
@@ -124,10 +125,20 @@ struct fpsimd_last_state_struct {
 static DEFINE_PER_CPU(struct fpsimd_last_state_struct, fpsimd_last_state);
 
 /* Default VL for tasks that don't set it explicitly: */
-static int sve_default_vl = -1;
+static int __sve_default_vl = -1;
+
+static int get_sve_default_vl(void)
+{
+	return READ_ONCE(__sve_default_vl);
+}
 
 #ifdef CONFIG_ARM64_SVE
 
+static void set_sve_default_vl(int val)
+{
+	WRITE_ONCE(__sve_default_vl, val);
+}
+
 /* Maximum supported vector length across all CPUs (initially poisoned) */
 int __ro_after_init sve_max_vl = SVE_VL_MIN;
 /* Set of available vector lengths, as vq_to_bit(vq): */
@@ -311,7 +322,7 @@ static int sve_proc_do_default_vl(struct ctl_table *table, int write,
 				  loff_t *ppos)
 {
 	int ret;
-	int vl = sve_default_vl;
+	int vl = get_sve_default_vl();
 	struct ctl_table tmp_table = {
 		.data = &vl,
 		.maxlen = sizeof(vl),
@@ -328,7 +339,7 @@ static int sve_proc_do_default_vl(struct ctl_table *table, int write,
 	if (!sve_vl_valid(vl))
 		return -EINVAL;
 
-	sve_default_vl = find_supported_vector_length(vl);
+	set_sve_default_vl(find_supported_vector_length(vl));
 	return 0;
 }
 
@@ -772,12 +783,12 @@ void __init sve_setup(void)
 	 * For the default VL, pick the maximum supported value <= 64.
 	 * VL == 64 is guaranteed not to grow the signal frame.
 	 */
-	sve_default_vl = find_supported_vector_length(64);
+	set_sve_default_vl(find_supported_vector_length(64));
 
 	pr_info("SVE: maximum available vector length %u bytes per vector\n",
 		sve_max_vl);
 	pr_info("SVE: default vector length %u bytes per vector\n",
-		sve_default_vl);
+		get_sve_default_vl());
 
 	sve_efi_setup();
 }
@@ -914,13 +925,13 @@ void fpsimd_flush_thread(void)
 		 * vector length configured: no kernel task can become a user
 		 * task without an exec and hence a call to this function.
 		 * By the time the first call to this function is made, all
-		 * early hardware probing is complete, so sve_default_vl
+		 * early hardware probing is complete, so __sve_default_vl
 		 * should be valid.
 		 * If a bug causes this to go wrong, we make some noise and
 		 * try to fudge thread.sve_vl to a safe value here.
 		 */
 		vl = current->thread.sve_vl_onexec ?
-			current->thread.sve_vl_onexec : sve_default_vl;
+			current->thread.sve_vl_onexec : get_sve_default_vl();
 
 		if (WARN_ON(!sve_vl_valid(vl)))
 			vl = SVE_VL_MIN;
-- 
2.25.1


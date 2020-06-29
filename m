Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D378D20E686
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 00:09:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404274AbgF2VsT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 17:48:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:56912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726714AbgF2Sfn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 14:35:43 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A44D824761;
        Mon, 29 Jun 2020 15:21:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593444079;
        bh=sc5f8187uxVzY6pGmrOQEZXwwHoqL0rU2Y3yzc/cin4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FYSsCEl5lqzJOUOgcMYfzzNH3Uy8dzZwn4AG4cK236lK1WzDIMx5+UbKbjinXFOay
         NbsMENdmWKqqxVnQ7AuqstNYDNy2kXP+1+CUfAEX/AW0Y3C8o9slI44aXkTpzFFfNX
         lK+NONWUP13rIzH7qJQ7AwO+n47F2KHAwRAQEP/8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dave Martin <Dave.Martin@arm.com>, Will Deacon <will@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 188/265] arm64/sve: Eliminate data races on sve_default_vl
Date:   Mon, 29 Jun 2020 11:17:01 -0400
Message-Id: <20200629151818.2493727-189-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629151818.2493727-1-sashal@kernel.org>
References: <20200629151818.2493727-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.7.7-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.7.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.7.7-rc1
X-KernelTest-Deadline: 2020-07-01T15:14+00:00
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
index 94289d1269933..4a77263c183b3 100644
--- a/arch/arm64/kernel/fpsimd.c
+++ b/arch/arm64/kernel/fpsimd.c
@@ -12,6 +12,7 @@
 #include <linux/bug.h>
 #include <linux/cache.h>
 #include <linux/compat.h>
+#include <linux/compiler.h>
 #include <linux/cpu.h>
 #include <linux/cpu_pm.h>
 #include <linux/kernel.h>
@@ -119,10 +120,20 @@ struct fpsimd_last_state_struct {
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
 int __ro_after_init sve_max_virtualisable_vl = SVE_VL_MIN;
@@ -345,7 +356,7 @@ static int sve_proc_do_default_vl(struct ctl_table *table, int write,
 				  loff_t *ppos)
 {
 	int ret;
-	int vl = sve_default_vl;
+	int vl = get_sve_default_vl();
 	struct ctl_table tmp_table = {
 		.data = &vl,
 		.maxlen = sizeof(vl),
@@ -362,7 +373,7 @@ static int sve_proc_do_default_vl(struct ctl_table *table, int write,
 	if (!sve_vl_valid(vl))
 		return -EINVAL;
 
-	sve_default_vl = find_supported_vector_length(vl);
+	set_sve_default_vl(find_supported_vector_length(vl));
 	return 0;
 }
 
@@ -869,7 +880,7 @@ void __init sve_setup(void)
 	 * For the default VL, pick the maximum supported value <= 64.
 	 * VL == 64 is guaranteed not to grow the signal frame.
 	 */
-	sve_default_vl = find_supported_vector_length(64);
+	set_sve_default_vl(find_supported_vector_length(64));
 
 	bitmap_andnot(tmp_map, sve_vq_partial_map, sve_vq_map,
 		      SVE_VQ_MAX);
@@ -890,7 +901,7 @@ void __init sve_setup(void)
 	pr_info("SVE: maximum available vector length %u bytes per vector\n",
 		sve_max_vl);
 	pr_info("SVE: default vector length %u bytes per vector\n",
-		sve_default_vl);
+		get_sve_default_vl());
 
 	/* KVM decides whether to support mismatched systems. Just warn here: */
 	if (sve_max_virtualisable_vl < sve_max_vl)
@@ -1030,13 +1041,13 @@ void fpsimd_flush_thread(void)
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


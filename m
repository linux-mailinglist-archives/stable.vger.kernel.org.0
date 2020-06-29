Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0476820DC14
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 22:16:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730490AbgF2UMT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 16:12:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:40606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732876AbgF2TaU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:30:20 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6832A2528E;
        Mon, 29 Jun 2020 15:36:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593445000;
        bh=U/ajtNUXgrI79PR52vEqduc3fXP2kxHpfe7LhEmubNI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GNMiOx9V9Gjm+8VKZIUFEvrCb8xv04TKO3OcCfpQxZiIG1WxDFGBwwuRT7/qqHvvt
         x6cFbrqEUeMObZdFSO1+gwUO531G/oceU+kci3Fc3L0IMSXH4tdKcZhcjAl9wRKfjU
         r79UPtxZIGSFL0d5rBZIUI5Z9RtqHoTUubpKxU5w=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Will Deacon <will@kernel.org>, Dave Martin <Dave.Martin@arm.com>,
        Qian Cai <cai@lca.pw>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 100/131] arm64: sve: Fix build failure when ARM64_SVE=y and SYSCTL=n
Date:   Mon, 29 Jun 2020 11:34:31 -0400
Message-Id: <20200629153502.2494656-101-sashal@kernel.org>
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

From: Will Deacon <will@kernel.org>

[ Upstream commit e575fb9e76c8e33440fb859572a8b7d430f053d6 ]

When I squashed the 'allnoconfig' compiler warning about the
set_sve_default_vl() function being defined but not used in commit
1e570f512cbd ("arm64/sve: Eliminate data races on sve_default_vl"), I
accidentally broke the build for configs where ARM64_SVE is enabled, but
SYSCTL is not.

Fix this by only compiling the SVE sysctl support if both CONFIG_SVE=y
and CONFIG_SYSCTL=y.

Cc: Dave Martin <Dave.Martin@arm.com>
Reported-by: Qian Cai <cai@lca.pw>
Link: https://lore.kernel.org/r/20200616131808.GA1040@lca.pw
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/fpsimd.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
index af59b42973141..177363abbd3e3 100644
--- a/arch/arm64/kernel/fpsimd.c
+++ b/arch/arm64/kernel/fpsimd.c
@@ -315,7 +315,7 @@ static unsigned int find_supported_vector_length(unsigned int vl)
 	return sve_vl_from_vq(bit_to_vq(bit));
 }
 
-#ifdef CONFIG_SYSCTL
+#if defined(CONFIG_ARM64_SVE) && defined(CONFIG_SYSCTL)
 
 static int sve_proc_do_default_vl(struct ctl_table *table, int write,
 				  void __user *buffer, size_t *lenp,
@@ -361,9 +361,9 @@ static int __init sve_sysctl_init(void)
 	return 0;
 }
 
-#else /* ! CONFIG_SYSCTL */
+#else /* ! (CONFIG_ARM64_SVE && CONFIG_SYSCTL) */
 static int __init sve_sysctl_init(void) { return 0; }
-#endif /* ! CONFIG_SYSCTL */
+#endif /* ! (CONFIG_ARM64_SVE && CONFIG_SYSCTL) */
 
 #define ZREG(sve_state, vq, n) ((char *)(sve_state) +		\
 	(SVE_SIG_ZREG_OFFSET(vq, n) - SVE_SIG_REGS_OFFSET))
-- 
2.25.1


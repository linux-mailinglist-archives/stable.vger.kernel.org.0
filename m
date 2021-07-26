Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B001F3D6164
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:13:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231248AbhGZPa7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:30:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:43124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237846AbhGZP3Z (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:29:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 51ED461042;
        Mon, 26 Jul 2021 16:08:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627315734;
        bh=GHr51w815V5K43UucPOUv5I/mia81NkzcNJB3oHSkeo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e2Ej5nAVA+RgbOEl6FvvU+3A5mkX3ARyqh92/m5+tp8RBRhOcIaZPqqLQ2ja866zx
         wzQekTVor3Tf9fKDE0UisJGj6TvyTiiCfFYV540ISLKnmPw4t2qXNT9X54KEQfwget
         xDY2QJ9kQ0YNb8i+bgp/5W2TP64yK/iiud5ZHzFE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>,
        Andrey Konovalov <andreyknvl@gmail.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 046/223] arm64: mte: fix restoration of GCR_EL1 from suspend
Date:   Mon, 26 Jul 2021 17:37:18 +0200
Message-Id: <20210726153847.773328197@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153846.245305071@linuxfoundation.org>
References: <20210726153846.245305071@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Rutland <mark.rutland@arm.com>

[ Upstream commit 59f44069e0527523f27948da7b77599a73dab157 ]

Since commit:

  bad1e1c663e0a72f ("arm64: mte: switch GCR_EL1 in kernel entry and exit")

we saved/restored the user GCR_EL1 value at exception boundaries, and
update_gcr_el1_excl() is no longer used for this. However it is used to
restore the kernel's GCR_EL1 value when returning from a suspend state.
Thus, the comment is misleading (and an ISB is necessary).

When restoring the kernel's GCR value, we need an ISB to ensure this is
used by subsequent instructions. We don't necessarily get an ISB by
other means (e.g. if the kernel is built without support for pointer
authentication). As __cpu_setup() initialised GCR_EL1.Exclude to 0xffff,
until a context synchronization event, allocation tag 0 may be used
rather than the desired set of tags.

This patch drops the misleading comment, adds the missing ISB, and for
clarity folds update_gcr_el1_excl() into its only user.

Fixes: bad1e1c663e0 ("arm64: mte: switch GCR_EL1 in kernel entry and exit")
Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Will Deacon <will@kernel.org>
Link: https://lore.kernel.org/r/20210714143843.56537-2-mark.rutland@arm.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/mte.c | 15 ++-------------
 1 file changed, 2 insertions(+), 13 deletions(-)

diff --git a/arch/arm64/kernel/mte.c b/arch/arm64/kernel/mte.c
index 125a10e413e9..23e9879a6e78 100644
--- a/arch/arm64/kernel/mte.c
+++ b/arch/arm64/kernel/mte.c
@@ -185,18 +185,6 @@ void mte_check_tfsr_el1(void)
 }
 #endif
 
-static void update_gcr_el1_excl(u64 excl)
-{
-
-	/*
-	 * Note that the mask controlled by the user via prctl() is an
-	 * include while GCR_EL1 accepts an exclude mask.
-	 * No need for ISB since this only affects EL0 currently, implicit
-	 * with ERET.
-	 */
-	sysreg_clear_set_s(SYS_GCR_EL1, SYS_GCR_EL1_EXCL_MASK, excl);
-}
-
 static void set_gcr_el1_excl(u64 excl)
 {
 	current->thread.gcr_user_excl = excl;
@@ -257,7 +245,8 @@ void mte_suspend_exit(void)
 	if (!system_supports_mte())
 		return;
 
-	update_gcr_el1_excl(gcr_kernel_excl);
+	sysreg_clear_set_s(SYS_GCR_EL1, SYS_GCR_EL1_EXCL_MASK, gcr_kernel_excl);
+	isb();
 }
 
 long set_mte_ctrl(struct task_struct *task, unsigned long arg)
-- 
2.30.2




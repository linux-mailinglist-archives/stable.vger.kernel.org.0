Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B39A15432F
	for <lists+stable@lfdr.de>; Thu,  6 Feb 2020 12:34:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727390AbgBFLeR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Feb 2020 06:34:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:32820 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727178AbgBFLeQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 6 Feb 2020 06:34:16 -0500
Received: from localhost.localdomain (236.31.169.217.in-addr.arpa [217.169.31.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F1D8F20730;
        Thu,  6 Feb 2020 11:34:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580988856;
        bh=VqdMZT/GZ1M58LxK4ooJm6983xMTXou8aDPxXtT0gCE=;
        h=From:To:Cc:Subject:Date:From;
        b=buCuuH8j2DZnjTAeJIdjkcTv1p2hBay8VkzRDdk2poZHj1/eb8vI/f8jVbT2SWAPF
         +nL8d7fvehjbLIRZTcWMBgAGSoeQNM48xTtbvQXFypHrQO3dZSIGcW8WtycV8HhewO
         Yyecz3RpDihV2ZtGUThRt65a4mCCVRWpGaCcQf5Y=
From:   Will Deacon <will@kernel.org>
To:     linux-arm-kernel@lists.infradead.org
Cc:     mark.rutland@arm.com, kernel-team@android.com,
        Will Deacon <will@kernel.org>, stable@vger.kernel.org,
        Marc Zyngier <maz@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Srinivas Ramana <sramana@codeaurora.org>
Subject: [PATCH] arm64: ssbs: Fix context-switch when SSBS instructions are present
Date:   Thu,  6 Feb 2020 11:34:10 +0000
Message-Id: <20200206113410.18301-1-will@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When all CPUs in the system implement the SSBS instructions, we
advertise this via an HWCAP and allow EL0 to toggle the SSBS field
in PSTATE directly. Consequently, the state of the mitigation is not
accurately tracked by the TIF_SSBD thread flag and the PSTATE value
is authoritative.

Avoid forcing the SSBS field in context-switch on such a system, and
simply rely on the PSTATE register instead.

Cc: <stable@vger.kernel.org>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Srinivas Ramana <sramana@codeaurora.org>
Fixes: cbdf8a189a66 ("arm64: Force SSBS on context switch")
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kernel/process.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm64/kernel/process.c b/arch/arm64/kernel/process.c
index d54586d5b031..45e867f40a7a 100644
--- a/arch/arm64/kernel/process.c
+++ b/arch/arm64/kernel/process.c
@@ -466,6 +466,13 @@ static void ssbs_thread_switch(struct task_struct *next)
 	if (unlikely(next->flags & PF_KTHREAD))
 		return;
 
+	/*
+	 * If all CPUs implement the SSBS instructions, then we just
+	 * need to context-switch the PSTATE field.
+	 */
+	if (cpu_have_feature(cpu_feature(SSBS)))
+		return;
+
 	/* If the mitigation is enabled, then we leave SSBS clear. */
 	if ((arm64_get_ssbd_state() == ARM64_SSBD_FORCE_ENABLE) ||
 	    test_tsk_thread_flag(next, TIF_SSBD))
-- 
2.25.0.341.g760bfbb309-goog


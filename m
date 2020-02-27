Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7ACB172033
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:41:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731532AbgB0Nwh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 08:52:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:52176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731543AbgB0Nwh (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 08:52:37 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0843E2084E;
        Thu, 27 Feb 2020 13:52:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582811556;
        bh=UVGkyyzU1ieiqZUQBxDFmWqE0FN+gNaeD1QrvyaNMNM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZMdLO+jDmSCxSiFSPMosH1b/iMAua47dLOJ/k/T0MIhLfDpXjPK97oPxgrzIRAXyx
         05dretPdo7E/iIsGlVerAYgNFr9UFHb0/iXjHykmqtaOtT9o5C1wRGOhM87bujcQkF
         RjsOvP+SVp4MBgu6UnnqOuQZRj3w+WQ/hw7xCra0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Will Deacon <will@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <maz@kernel.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 013/237] arm64: nofpsimd: Handle TIF_FOREIGN_FPSTATE flag cleanly
Date:   Thu, 27 Feb 2020 14:33:47 +0100
Message-Id: <20200227132256.987937595@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132255.285644406@linuxfoundation.org>
References: <20200227132255.285644406@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Suzuki K Poulose <suzuki.poulose@arm.com>

commit 52f73c383b2418f2d31b798e765ae7d596c35021 upstream

We detect the absence of FP/SIMD after an incapable CPU is brought up,
and by then we have kernel threads running already with TIF_FOREIGN_FPSTATE set
which could be set for early userspace applications (e.g, modprobe triggered
from initramfs) and init. This could cause the applications to loop forever in
do_nofity_resume() as we never clear the TIF flag, once we now know that
we don't support FP.

Fix this by making sure that we clear the TIF_FOREIGN_FPSTATE flag
for tasks which may have them set, as we would have done in the normal
case, but avoiding touching the hardware state (since we don't support any).

Cc: stable@vger.kernel.org # v4.14
Cc: Will Deacon <will@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Reviewed-by: Ard Biesheuvel <ardb@kernel.org>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Acked-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/fpsimd.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
index f4fdf6420ac5c..4cd962f6c4302 100644
--- a/arch/arm64/kernel/fpsimd.c
+++ b/arch/arm64/kernel/fpsimd.c
@@ -206,8 +206,19 @@ void fpsimd_preserve_current_state(void)
  */
 void fpsimd_restore_current_state(void)
 {
-	if (!system_supports_fpsimd())
+	/*
+	 * For the tasks that were created before we detected the absence of
+	 * FP/SIMD, the TIF_FOREIGN_FPSTATE could be set via fpsimd_thread_switch(),
+	 * e.g, init. This could be then inherited by the children processes.
+	 * If we later detect that the system doesn't support FP/SIMD,
+	 * we must clear the flag for  all the tasks to indicate that the
+	 * FPSTATE is clean (as we can't have one) to avoid looping for ever in
+	 * do_notify_resume().
+	 */
+	if (!system_supports_fpsimd()) {
+		clear_thread_flag(TIF_FOREIGN_FPSTATE);
 		return;
+	}
 
 	local_bh_disable();
 
@@ -229,7 +240,7 @@ void fpsimd_restore_current_state(void)
  */
 void fpsimd_update_current_state(struct fpsimd_state *state)
 {
-	if (!system_supports_fpsimd())
+	if (WARN_ON(!system_supports_fpsimd()))
 		return;
 
 	local_bh_disable();
-- 
2.20.1




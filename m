Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE9482FC982
	for <lists+stable@lfdr.de>; Wed, 20 Jan 2021 04:54:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730322AbhATC2h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jan 2021 21:28:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:46598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729850AbhATB1q (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Jan 2021 20:27:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B110623158;
        Wed, 20 Jan 2021 01:26:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611105983;
        bh=YYgKReb4iChjozIJRJvtv/aAfeRqgZZcx5EeBcUYleQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q/NVXEm7WCnNGHaK+1BxCWllrrU8GMrUca9QuKyW9dAycz3J82moqn7brLMNjAXzT
         tJyXjYaRjJgzo3p2bwPViZfhBFTJOFdUptugst2clybqaYY1p8Qm2Q97gNBliucrxg
         /3Q7LaTMdbuzo+3AuagxBHn3vbxhIiMRGbgXy02yNMzyhpVm4MTyoUR48JsRTvj3Iv
         rtSpIGOAYDH5m9Fe0ekPP9LLxBch5UvhrRICLq96uhrjo6BTKId+aofry7AdLE9HUb
         C4FCfPuCSaC2wDFtLNcbkKhrXTFFG7pK4+XRrHFMMJ9lWMM5edq2ua6lU889lhVwNW
         ysHR5psxdhTAw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Damien Le Moal <damien.lemoal@wdc.com>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-riscv@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 16/45] riscv: Enable interrupts during syscalls with M-Mode
Date:   Tue, 19 Jan 2021 20:25:33 -0500
Message-Id: <20210120012602.769683-16-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210120012602.769683-1-sashal@kernel.org>
References: <20210120012602.769683-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Damien Le Moal <damien.lemoal@wdc.com>

[ Upstream commit 643437b996bac9267785e0bd528332e2d5811067 ]

When running is M-Mode (no MMU config), MPIE does not get set. This
results in all syscalls being executed with interrupts disabled as
handle_exception never sets SR_IE as it always sees SR_PIE being
cleared. Fix this by always force enabling interrupts in
handle_syscall when CONFIG_RISCV_M_MODE is enabled.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
Reviewed-by: Palmer Dabbelt <palmerdabbelt@google.com>
Signed-off-by: Palmer Dabbelt <palmerdabbelt@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/entry.S | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/riscv/kernel/entry.S b/arch/riscv/kernel/entry.S
index 524d918f3601b..080eb8d78589d 100644
--- a/arch/riscv/kernel/entry.S
+++ b/arch/riscv/kernel/entry.S
@@ -155,6 +155,15 @@ skip_context_tracking:
 	tail do_trap_unknown
 
 handle_syscall:
+#ifdef CONFIG_RISCV_M_MODE
+	/*
+	 * When running is M-Mode (no MMU config), MPIE does not get set.
+	 * As a result, we need to force enable interrupts here because
+	 * handle_exception did not do set SR_IE as it always sees SR_PIE
+	 * being cleared.
+	 */
+	csrs CSR_STATUS, SR_IE
+#endif
 #if defined(CONFIG_TRACE_IRQFLAGS) || defined(CONFIG_CONTEXT_TRACKING)
 	/* Recover a0 - a7 for system calls */
 	REG_L a0, PT_A0(sp)
-- 
2.27.0


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EFA8B15C65
	for <lists+stable@lfdr.de>; Tue,  7 May 2019 08:03:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727724AbfEGFfJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 May 2019 01:35:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:55198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727718AbfEGFfJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 May 2019 01:35:09 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 65EF7214AE;
        Tue,  7 May 2019 05:35:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557207308;
        bh=jLmyqPYi3A2ppOJa+HCdiRXXIVzEb4yxF0qDFHX80us=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zX/7Z3M2M+fzkPwzDs4MO6vvfraK9eqxwwwdh0JvxkrQxgLFqdrfnvz3g4/3jZR8e
         84XhMFuvtguVgwuMbZUpO/JfNNEDJP/2Z8za7HcccSx0wssKeTf1jplgo3+pZEP/g1
         h4WZlBesgnwggu1+A5zmlRRLmMh4t0Mg/GL6LqNI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Will Deacon <will.deacon@arm.com>,
        dann frazier <dann.frazier@canonical.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.0 77/99] arm64/module: ftrace: deal with place relative nature of PLTs
Date:   Tue,  7 May 2019 01:32:11 -0400
Message-Id: <20190507053235.29900-77-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190507053235.29900-1-sashal@kernel.org>
References: <20190507053235.29900-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ard Biesheuvel <ard.biesheuvel@linaro.org>

[ Upstream commit 4e69ecf4da1ee0b2ac735e1f1bb13935acd5a38d ]

Another bodge for the ftrace PLT code: plt_entries_equal() now takes
the place relative nature of the ADRP/ADD based PLT entries into
account, which means that a struct trampoline instance on the stack
is no longer equal to the same set of opcodes in the module struct,
given that they don't point to the same place in memory anymore.

Work around this by using memcmp() in the ftrace PLT handling code.

Acked-by: Will Deacon <will.deacon@arm.com>
Tested-by: dann frazier <dann.frazier@canonical.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/ftrace.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kernel/ftrace.c b/arch/arm64/kernel/ftrace.c
index 07b298120182..65a51331088e 100644
--- a/arch/arm64/kernel/ftrace.c
+++ b/arch/arm64/kernel/ftrace.c
@@ -103,10 +103,15 @@ int ftrace_make_call(struct dyn_ftrace *rec, unsigned long addr)
 		 * to be revisited if support for multiple ftrace entry points
 		 * is added in the future, but for now, the pr_err() below
 		 * deals with a theoretical issue only.
+		 *
+		 * Note that PLTs are place relative, and plt_entries_equal()
+		 * checks whether they point to the same target. Here, we need
+		 * to check if the actual opcodes are in fact identical,
+		 * regardless of the offset in memory so use memcmp() instead.
 		 */
 		trampoline = get_plt_entry(addr, mod->arch.ftrace_trampoline);
-		if (!plt_entries_equal(mod->arch.ftrace_trampoline,
-				       &trampoline)) {
+		if (memcmp(mod->arch.ftrace_trampoline, &trampoline,
+			   sizeof(trampoline))) {
 			if (plt_entry_is_initialized(mod->arch.ftrace_trampoline)) {
 				pr_err("ftrace: far branches to multiple entry points unsupported inside a single module\n");
 				return -EINVAL;
-- 
2.20.1


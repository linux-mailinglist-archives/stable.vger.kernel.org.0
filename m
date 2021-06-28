Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A7DC3B60E1
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:28:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233717AbhF1ObG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:31:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:36332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234514AbhF1OaB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:30:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2EDBB61CA4;
        Mon, 28 Jun 2021 14:26:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624890385;
        bh=n3LBBJFmOwhXlPnrw2Koqg9ky5QV+yoGEO/vmYx59Ow=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DtMFWSzGBwt+hAbzFv5nLMsjZeWu5AQ4Epv1B6KnaSlxecL8x0IThdB02Hw7AZgou
         tNtr1jIrBL7qrYW8NqEQFEM3r6SDJteGMdUc8qQmw9YCSut78ezv5Ehs9jU+gOcxE1
         AeezI49pH8EzzPS4awudlzHGm/sSx1FLnb6f8/vwbdNz16vpsng4aAbm21NSSRA98y
         b81GIcPh0gZIMy3plG77Q6ODi6kc+YmOgA5C036lT/969BeVQE/yx+2ogAT1/Wz7Xm
         RZ1qr52il6uWrYeoFjdS+8UWPwViYob92nKV5Tfd7neZe7Fqqsc0z7Ix8/IOIgINHy
         t8A44L8oCtHDw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 018/101] x86/xen: Fix noinstr fail in exc_xen_unknown_trap()
Date:   Mon, 28 Jun 2021 10:24:44 -0400
Message-Id: <20210628142607.32218-19-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628142607.32218-1-sashal@kernel.org>
References: <20210628142607.32218-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.47-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.47-rc1
X-KernelTest-Deadline: 2021-06-30T14:25+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit 4c9c26f1e67648f41f28f8c997c5c9467a3dbbe4 ]

Fix:

  vmlinux.o: warning: objtool: exc_xen_unknown_trap()+0x7: call to printk() leaves .noinstr.text section

Fixes: 2e92493637a0 ("x86/xen: avoid warning in Xen pv guest with CONFIG_AMD_MEM_ENCRYPT enabled")
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Link: https://lore.kernel.org/r/20210621120120.606560778@infradead.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/xen/enlighten_pv.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/xen/enlighten_pv.c b/arch/x86/xen/enlighten_pv.c
index 8064df638222..d3cdf467d91f 100644
--- a/arch/x86/xen/enlighten_pv.c
+++ b/arch/x86/xen/enlighten_pv.c
@@ -586,8 +586,10 @@ DEFINE_IDTENTRY_RAW(xenpv_exc_debug)
 DEFINE_IDTENTRY_RAW(exc_xen_unknown_trap)
 {
 	/* This should never happen and there is no way to handle it. */
+	instrumentation_begin();
 	pr_err("Unknown trap in Xen PV mode.");
 	BUG();
+	instrumentation_end();
 }
 
 struct trap_array_entry {
-- 
2.30.2


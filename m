Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F08969633
	for <lists+stable@lfdr.de>; Mon, 15 Jul 2019 17:03:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388525AbfGOOKM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jul 2019 10:10:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:37474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731744AbfGOOKL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Jul 2019 10:10:11 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 91C3920651;
        Mon, 15 Jul 2019 14:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563199811;
        bh=mIXy/baeiCUevcbT8ICaqwiWfI0GcGSI9r1KMsyruEw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pk+tiAq2rHF1mFj2Ia1fl0X+4254vLJUNqcpj4YaYm8SPaVwxgVWVw+eKHp3ANz8X
         nLYcNCKI+n8ytmcHyaJQUCQ3DKSYHEXZn0feGGfHgSnw4EA4xva8a0iQmfB2ub1yFH
         7vUW1vhSzCWim45HNf+3NnkGBcpaL2X3D8IIrREo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Qian Cai <cai@lca.pw>, Borislav Petkov <bp@suse.de>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Pu Wen <puwen@hygon.cn>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>, x86-ml <x86@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.1 112/219] x86/cacheinfo: Fix a -Wtype-limits warning
Date:   Mon, 15 Jul 2019 10:01:53 -0400
Message-Id: <20190715140341.6443-112-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715140341.6443-1-sashal@kernel.org>
References: <20190715140341.6443-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qian Cai <cai@lca.pw>

[ Upstream commit 1b7aebf0487613033aff26420e32fa2076d52846 ]

cpuinfo_x86.x86_model is an unsigned type, so comparing against zero
will generate a compilation warning:

  arch/x86/kernel/cpu/cacheinfo.c: In function 'cacheinfo_amd_init_llc_id':
  arch/x86/kernel/cpu/cacheinfo.c:662:19: warning: comparison is always true \
    due to limited range of data type [-Wtype-limits]

Remove the unnecessary lower bound check.

 [ bp: Massage. ]

Fixes: 68091ee7ac3c ("x86/CPU/AMD: Calculate last level cache ID from number of sharing threads")
Signed-off-by: Qian Cai <cai@lca.pw>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Sean Christopherson <sean.j.christopherson@intel.com>
Cc: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Pu Wen <puwen@hygon.cn>
Cc: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: x86-ml <x86@kernel.org>
Link: https://lkml.kernel.org/r/1560954773-11967-1-git-send-email-cai@lca.pw
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/cacheinfo.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/cacheinfo.c b/arch/x86/kernel/cpu/cacheinfo.c
index 395d46f78582..c7503be92f35 100644
--- a/arch/x86/kernel/cpu/cacheinfo.c
+++ b/arch/x86/kernel/cpu/cacheinfo.c
@@ -658,8 +658,7 @@ void cacheinfo_amd_init_llc_id(struct cpuinfo_x86 *c, int cpu, u8 node_id)
 	if (c->x86 < 0x17) {
 		/* LLC is at the node level. */
 		per_cpu(cpu_llc_id, cpu) = node_id;
-	} else if (c->x86 == 0x17 &&
-		   c->x86_model >= 0 && c->x86_model <= 0x1F) {
+	} else if (c->x86 == 0x17 && c->x86_model <= 0x1F) {
 		/*
 		 * LLC is at the core complex level.
 		 * Core complex ID is ApicId[3] for these processors.
-- 
2.20.1


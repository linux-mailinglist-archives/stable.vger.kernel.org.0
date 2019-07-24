Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36B3C7388E
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 21:30:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388399AbfGXTan (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 15:30:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:50880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388389AbfGXTak (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:30:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7CC8C20659;
        Wed, 24 Jul 2019 19:30:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563996639;
        bh=3MB4bK7EG96b5G7lE/CIVDA98zKHLKKru1XWZkbPHGY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fW9VtnYAC/K/g8O+n48CBhu41pe4CKGVBv/IUVwZ1iVzKnLBDsSebjxGT1W2uI6KK
         IUFsjchgEgp/Tz63/ItdvnFd3wEaA7qBP6ucZKl+xk3gTx/HlN0qmlroSKBwQExLMC
         jUFEuvUj67OSualHKxpM4yx1vab67DYCDFHL/sSc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qian Cai <cai@lca.pw>,
        Borislav Petkov <bp@suse.de>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Pu Wen <puwen@hygon.cn>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>, x86-ml <x86@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 125/413] x86/cacheinfo: Fix a -Wtype-limits warning
Date:   Wed, 24 Jul 2019 21:16:56 +0200
Message-Id: <20190724191744.090186828@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191735.096702571@linuxfoundation.org>
References: <20190724191735.096702571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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




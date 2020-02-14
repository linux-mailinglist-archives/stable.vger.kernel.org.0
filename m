Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C06C015E97D
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 18:08:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388578AbgBNRHI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 12:07:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:44232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403967AbgBNQOh (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:14:37 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 590F2246D2;
        Fri, 14 Feb 2020 16:14:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581696876;
        bh=uaqtr6l3s3vDn9atw6+mtNDLwhEDUDOlpKODIU0dLpw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Mao162NErL4fGFozRCPP1t3bjqxG7aoDEhlkiE/L/GfkG08MlFfXhkkrLi76BFEJy
         Xsu+/vuOGjKIXUtvhQxmhlTPOy1MTZzVlf93EhbtDV0zuVzu7pxP1GEIv9aqDr6GcN
         r7Am1uGUhWjkPoMkgut4VizPQwG15Gc2GIC0rfAI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Shile Zhang <shile.zhang@linux.alibaba.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Andy Lutomirski <luto@amacapital.net>,
        Borislav Petkov <bp@alien8.de>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 132/252] x86/unwind/orc: Fix !CONFIG_MODULES build warning
Date:   Fri, 14 Feb 2020 11:09:47 -0500
Message-Id: <20200214161147.15842-132-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214161147.15842-1-sashal@kernel.org>
References: <20200214161147.15842-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shile Zhang <shile.zhang@linux.alibaba.com>

[ Upstream commit 22a7fa8848c5e881d87ef2f7f3c2ea77b286e6f9 ]

To fix follwowing warning due to ORC sort moved to build time:

  arch/x86/kernel/unwind_orc.c:210:12: warning: ‘orc_sort_cmp’ defined but not used [-Wunused-function]
  arch/x86/kernel/unwind_orc.c:190:13: warning: ‘orc_sort_swap’ defined but not used [-Wunused-function]

Signed-off-by: Shile Zhang <shile.zhang@linux.alibaba.com>
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: https://lkml.kernel.org/r/c9c81536-2afc-c8aa-c5f8-c7618ecd4f54@linux.alibaba.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/unwind_orc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/unwind_orc.c b/arch/x86/kernel/unwind_orc.c
index 89be1be1790c4..a3cb70fbe941a 100644
--- a/arch/x86/kernel/unwind_orc.c
+++ b/arch/x86/kernel/unwind_orc.c
@@ -176,6 +176,8 @@ static struct orc_entry *orc_find(unsigned long ip)
 	return orc_ftrace_find(ip);
 }
 
+#ifdef CONFIG_MODULES
+
 static void orc_sort_swap(void *_a, void *_b, int size)
 {
 	struct orc_entry *orc_a, *orc_b;
@@ -218,7 +220,6 @@ static int orc_sort_cmp(const void *_a, const void *_b)
 	return orc_a->sp_reg == ORC_REG_UNDEFINED && !orc_a->end ? -1 : 1;
 }
 
-#ifdef CONFIG_MODULES
 void unwind_module_init(struct module *mod, void *_orc_ip, size_t orc_ip_size,
 			void *_orc, size_t orc_size)
 {
-- 
2.20.1


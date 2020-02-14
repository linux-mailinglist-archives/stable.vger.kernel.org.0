Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 372FC15DF30
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 17:08:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390619AbgBNQHP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 11:07:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:58386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390613AbgBNQHO (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:07:14 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 73A2624688;
        Fri, 14 Feb 2020 16:07:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581696433;
        bh=IMsQ7+myA2VFgMAOR1pcDR51QxoVGL6Z14/X9w+j5No=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=spFycxZAzGrQTza/d1rqA4aPq47BDCwxBNlF6omuyTTHiwr+mAZrz05FL5UFuGspp
         o1OaOVuI/t45Qq9KPsgj4XBPJCXnVe50SYuFwF+Nx0LgTUwfw5JLwMx6ewltgmVfHm
         0Ytgfr1dggtk5C5h0JcTN8rlRtdN4ANJ8Cfvbl4Y=
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
Subject: [PATCH AUTOSEL 5.4 251/459] x86/unwind/orc: Fix !CONFIG_MODULES build warning
Date:   Fri, 14 Feb 2020 10:58:21 -0500
Message-Id: <20200214160149.11681-251-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214160149.11681-1-sashal@kernel.org>
References: <20200214160149.11681-1-sashal@kernel.org>
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
index 332ae6530fa88..7a9306bc5982f 100644
--- a/arch/x86/kernel/unwind_orc.c
+++ b/arch/x86/kernel/unwind_orc.c
@@ -187,6 +187,8 @@ static struct orc_entry *orc_find(unsigned long ip)
 	return orc_ftrace_find(ip);
 }
 
+#ifdef CONFIG_MODULES
+
 static void orc_sort_swap(void *_a, void *_b, int size)
 {
 	struct orc_entry *orc_a, *orc_b;
@@ -229,7 +231,6 @@ static int orc_sort_cmp(const void *_a, const void *_b)
 	return orc_a->sp_reg == ORC_REG_UNDEFINED && !orc_a->end ? -1 : 1;
 }
 
-#ifdef CONFIG_MODULES
 void unwind_module_init(struct module *mod, void *_orc_ip, size_t orc_ip_size,
 			void *_orc, size_t orc_size)
 {
-- 
2.20.1


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4E5A3CE3BF
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:29:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344223AbhGSPk1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:40:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:59806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349680AbhGSPgH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:36:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 55F48600EF;
        Mon, 19 Jul 2021 16:16:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626711406;
        bh=92c8Rd7bHo8sgZbesvkfwofkpXsdN3X7DxtbI5w4RfQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Jy+IGbmD1HoleQBFDqRAull/hNRcHi6EXXKaoBiBL3Xndt1Ag3gng0LqyTkh9fshl
         6hHRaac/HW5LMNf7GK6nslN/zwPBgsLNoizrav36wbhiZ5Qw9pxHGyAeBVxpzRQm3e
         +9KR0/tN0MiA4Dm471xLHut+cHhldtkoGEeMxW8I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 341/351] kprobe/static_call: Restore missing static_call_text_reserved()
Date:   Mon, 19 Jul 2021 16:54:47 +0200
Message-Id: <20210719144956.352840276@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144944.537151528@linuxfoundation.org>
References: <20210719144944.537151528@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit fa68bd09fc62240a383c0c601d3349c47db10c34 ]

Restore two hunks from commit:

  6333e8f73b83 ("static_call: Avoid kprobes on inline static_call()s")

that went walkabout in a Git merge commit.

Fixes: 76d4acf22b48 ("Merge tag 'perf-kprobes-2020-12-14' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip")
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Masami Hiramatsu <mhiramat@kernel.org>
Link: https://lore.kernel.org/r/20210628113045.167127609@infradead.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/kprobes.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index 745f08fdd7a6..c6b4c66b8fa2 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -35,6 +35,7 @@
 #include <linux/ftrace.h>
 #include <linux/cpu.h>
 #include <linux/jump_label.h>
+#include <linux/static_call.h>
 #include <linux/perf_event.h>
 
 #include <asm/sections.h>
@@ -1569,6 +1570,7 @@ static int check_kprobe_address_safe(struct kprobe *p,
 	if (!kernel_text_address((unsigned long) p->addr) ||
 	    within_kprobe_blacklist((unsigned long) p->addr) ||
 	    jump_label_text_reserved(p->addr, p->addr) ||
+	    static_call_text_reserved(p->addr, p->addr) ||
 	    find_bug((unsigned long)p->addr)) {
 		ret = -EINVAL;
 		goto out;
-- 
2.30.2




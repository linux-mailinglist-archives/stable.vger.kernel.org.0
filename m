Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 654B013D730
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 10:47:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729616AbgAPJrq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 04:47:46 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:38545 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729388AbgAPJrq (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Jan 2020 04:47:46 -0500
Received: by mail-pf1-f193.google.com with SMTP id x185so9966970pfc.5;
        Thu, 16 Jan 2020 01:47:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=l8c+LvOlIaXBLMpBu+gnW139ZMvxJSLj7Fg/MJCqoms=;
        b=Uw76ZTf1zqvHyf8Pb1Grjc71wgfq1iGAmnabYrBeQrIukT2j1sy4rVufnuSiGrKhma
         zifubk7YsrNHn0M8EAd8EDjnqA0TEi4gXg4BNUAtasgzFw0SAbtqTa5h3HZCnk5F3FX1
         X7xrSfCKmmeu2lufBaFobIDDSlq0fJSHTIMh93+xSzJ/NHgAit3Nbg0skYVYKALg8ahy
         /bTPieJQuT5hVd1AGweD6V3VNpwxFTtNxi4aitap1JeEgpdTPHKRFG5Sn0/n8Rw7rkf0
         a69hrk3BPRsPhNrCjsSudQuaZeHjxTwRuX3JyIC6YLMNPMtgBxFyzCK/GVoa1V+mOTBM
         pvgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=l8c+LvOlIaXBLMpBu+gnW139ZMvxJSLj7Fg/MJCqoms=;
        b=sOuBy40FcT8g52m0OSu2f8rjYjrVrK0Ha+MDZtUqePU5tyFSkxHb1+JOWXuLC6ejOZ
         rjxSZEbmxQdIB6lWs6AWfie8tcLvoa3uIRTen7XkmPTvUhLujr3TyKsL55Njw6SvaWzU
         ib8CdikCjFsV0t5gi6sy4DAW7BVNHMwSvAHtZsZX7k1h6OjFJW7SF+PRclX8mMLo1XS7
         1SzbFU9sqIE/spycw6erUoN197BRd7mG/Y3Pv6q2pQN03CMXp//3ly5DTjfqPwskZmln
         4mY0K7eNKO6vQCK1zoppZ0huxSAchKOlduOWgYB7w9YDDYtNkc/DHeCOChc8ZtbPJTAz
         569w==
X-Gm-Message-State: APjAAAWRJ6kAg7cheQXFnYBY0Z1MOP2F+RS6sANE29ee0+IrB33LNoi3
        zX9ErswUONA1BOC55A77xNqZEDGlvEKf4g==
X-Google-Smtp-Source: APXvYqzS4tS+2x7b/vzd5Xd9KF74XNEVfPPpaUoOihOElllpwY8XHXjCXoLWjVQUe1B1ZGwevI6YGw==
X-Received: by 2002:a62:5c43:: with SMTP id q64mr36911958pfb.194.1579168065677;
        Thu, 16 Jan 2020 01:47:45 -0800 (PST)
Received: from localhost.localdomain (FL1-122-135-105-104.tky.mesh.ad.jp. [122.135.105.104])
        by smtp.gmail.com with ESMTPSA id 144sm26366256pfc.124.2020.01.16.01.47.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jan 2020 01:47:45 -0800 (PST)
From:   Masami Ichikawa <masami256@gmail.com>
To:     rostedt@goodmis.org, mingo@redhat.com
Cc:     Masami Ichikawa <masami256@gmail.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH] tracing: Do not set trace clock  if tracefs lockdown is in effect
Date:   Thu, 16 Jan 2020 18:47:06 +0900
Message-Id: <20200116094707.3846565-1-masami256@gmail.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When trace_clock option is not set and unstable clcok detected,
tracing_set_default_clock() sets trace_clock(ThinkPad A285 is one of
case). In that case, if lockdown is in effect, null pointer
dereference error happens in ring_buffer_set_clock().

Link: https://bugzilla.redhat.com/show_bug.cgi?id=1788488
Signed-off-by: Masami Ichikawa <masami256@gmail.com>
---
 kernel/trace/trace.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index ddb7e7f5fe8d..5b6ee4aadc26 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -9420,6 +9420,11 @@ __init static int tracing_set_default_clock(void)
 {
 	/* sched_clock_stable() is determined in late_initcall */
 	if (!trace_boot_clock && !sched_clock_stable()) {
+		if (security_locked_down(LOCKDOWN_TRACEFS)) {
+			pr_warn("Can not set tracing clock due to lockdown\n");
+			return -EPERM;
+		}
+
 		printk(KERN_WARNING
 		       "Unstable clock detected, switching default tracing clock to \"global\"\n"
 		       "If you want to keep using the local clock, then add:\n"
-- 
2.24.1


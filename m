Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60F1A28EF6F
	for <lists+stable@lfdr.de>; Thu, 15 Oct 2020 11:35:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388515AbgJOJfi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Oct 2020 05:35:38 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:36492 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727988AbgJOJfh (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Oct 2020 05:35:37 -0400
Date:   Thu, 15 Oct 2020 09:35:33 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1602754534;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8jgkA3Tzvp+bpq+MfF+dF23BewjtCTuLwM8CXN0jaHI=;
        b=lgHk9VsyXFjCawgD0DdWWOkBC7GIL1WV5QQjCl/zl6zIPVuFt8UIqsfM9MbojgTvf33Lb2
        jWtWpEelHp0rM/CNOPXSa7yQNG9c60e4fif5eaFEQwjpuwScJZ8TkiZ8aq8TXlUFWMsEdb
        YH/ZjeZ14iJswsUPoscUnnNrKqO/5Jue/AICzprZoAq4hqyIcV8eQbkNP+fqXxNItqgIlb
        92M/wXBT0pDBfQxrl7sDNtueAfoQ26MYJ0IMpCE7TXJnTWWLdmtsbOj/SkuYtOp+g7iLOn
        cnEawoD1nfp6IW7WLnKBjV4KeSvVzLHV0YCp6r3Jh8FumGEkPsSii+KZN6Xj5A==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1602754534;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8jgkA3Tzvp+bpq+MfF+dF23BewjtCTuLwM8CXN0jaHI=;
        b=gUQAmSz9T33j/+XSiTKoiJWVfcunksZ7NKx/rHtm0vEKx32x0adqtyWuR7W+H1/LRLgXHz
        dMIfdu6DVVtZmBAg==
From:   "tip-bot2 for Andrei Vagin" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: timers/urgent] futex: Adjust futex absolute timeouts with
 per-timens offset
Cc:     Hans van der Laan <j.h.vanderlaan@student.utwente.nl>,
        Andrei Vagin <avagin@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, <stable@vger.kernel.org>,
        x86 <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20201015072909.271426-1-avagin@gmail.com>
References: <20201015072909.271426-1-avagin@gmail.com>
MIME-Version: 1.0
Message-ID: <160275453357.7002.8741717735459699835.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2.linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the timers/urgent branch of tip:

Commit-ID:     06764291690f8650a9f96dea42cc0dd4138d47d5
Gitweb:        https://git.kernel.org/tip/06764291690f8650a9f96dea42cc0dd4138d47d5
Author:        Andrei Vagin <avagin@gmail.com>
AuthorDate:    Thu, 15 Oct 2020 00:29:08 -07:00
Committer:     Thomas Gleixner <tglx@linutronix.de>
CommitterDate: Thu, 15 Oct 2020 11:24:04 +02:00

futex: Adjust futex absolute timeouts with per-timens offset

For all commands except FUTEX_WAIT, timeout is interpreted as an absolute
value. This absolute value is inside the task's time namespace and has to
be converted to the host's time.

Fixes: 5a590f35add9 ("posix-clocks: Wire up clock_gettime() with timens offsets")
Reported-by: Hans van der Laan <j.h.vanderlaan@student.utwente.nl>
Signed-off-by: Andrei Vagin <avagin@gmail.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20201015072909.271426-1-avagin@gmail.com

---
 kernel/futex.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/futex.c b/kernel/futex.c
index a587669..9ff2b8c 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -39,6 +39,7 @@
 #include <linux/freezer.h>
 #include <linux/memblock.h>
 #include <linux/fault-inject.h>
+#include <linux/time_namespace.h>
 
 #include <asm/futex.h>
 
@@ -3797,6 +3798,8 @@ SYSCALL_DEFINE6(futex, u32 __user *, uaddr, int, op, u32, val,
 		t = timespec64_to_ktime(ts);
 		if (cmd == FUTEX_WAIT)
 			t = ktime_add_safe(ktime_get(), t);
+		else if (!(cmd & FUTEX_CLOCK_REALTIME))
+			t = timens_ktime_to_host(CLOCK_MONOTONIC, t);
 		tp = &t;
 	}
 	/*

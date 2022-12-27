Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E46AF656A3E
	for <lists+stable@lfdr.de>; Tue, 27 Dec 2022 12:59:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232081AbiL0L72 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Dec 2022 06:59:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231967AbiL0L64 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Dec 2022 06:58:56 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB22DAE5A;
        Tue, 27 Dec 2022 03:58:55 -0800 (PST)
Date:   Tue, 27 Dec 2022 11:58:53 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1672142334;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=G9KGHKGvEmHY8m6mMHbHyYBd5mnPoViFa4gD7Us+W8E=;
        b=ZjzsFz30JcHNNKitODN5AzpHyFp1DhFvc08uWV/qUacYyMhxX0fknUB3nKSdZbUMQ9tHnX
        iPI0f7nhlXbXmDQ82laEvgvPX/v8wqvCza6nP4gdJ5HjA066oVzJ9Zl055rvz08CLN9WvV
        QkgzDlduiT//fmEcC/mpQKwAX+HIQiJxt2Gdf6CrvcF08kHt07EMSwWHe/C71xZEK1VOPn
        qOCKGc9j3YA4jRyqfo+H829XHJq8mTFxhofdJR1bcUgcHYJ2fInIbS7c+fIi5A5jXoUkKC
        rhrq7NbwvBS2qIztydIHMf6QSMVkX2nnSOAx5WGZMo08Iw5/wQV99yLDLV4b2A==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1672142334;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=G9KGHKGvEmHY8m6mMHbHyYBd5mnPoViFa4gD7Us+W8E=;
        b=bmtwC+3Li5Q08No3N7rc54fF5SO6AJli3YYN8Aeuym7b+dHnrVq5FL71xaqjUKzT1ejJKP
        +mdaDqZiH1KiW6Dw==
From:   "tip-bot2 for Mathieu Desnoyers" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: locking/urgent] futex: Fix futex_waitv() hrtimer debug object
 leak on kcalloc error
Cc:     Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Davidlohr Bueso <dave@stgolabs.net>, stable@vger.kernel.org,
        stable@vger.kernel.org, #@tip-bot2.tec.linutronix.de,
        v5.16+@tip-bot2.tec.linutronix.de, x86@kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20221214222008.200393-1-mathieu.desnoyers@efficios.com>
References: <20221214222008.200393-1-mathieu.desnoyers@efficios.com>
MIME-Version: 1.0
Message-ID: <167214233380.4906.7703534432069912531.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the locking/urgent branch of tip:

Commit-ID:     94cd8fa09f5f1ebdd4e90964b08b7f2cc4b36c43
Gitweb:        https://git.kernel.org/tip/94cd8fa09f5f1ebdd4e90964b08b7f2cc4b36c43
Author:        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
AuthorDate:    Wed, 14 Dec 2022 17:20:08 -05:00
Committer:     Peter Zijlstra <peterz@infradead.org>
CommitterDate: Tue, 27 Dec 2022 12:52:02 +01:00

futex: Fix futex_waitv() hrtimer debug object leak on kcalloc error

In a scenario where kcalloc() fails to allocate memory, the futex_waitv
system call immediately returns -ENOMEM without invoking
destroy_hrtimer_on_stack(). When CONFIG_DEBUG_OBJECTS_TIMERS=y, this
results in leaking a timer debug object.

Fixes: bf69bad38cf6 ("futex: Implement sys_futex_waitv()")
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Davidlohr Bueso <dave@stgolabs.net>
Cc: stable@vger.kernel.org
Cc: stable@vger.kernel.org # v5.16+
Link: https://lore.kernel.org/r/20221214222008.200393-1-mathieu.desnoyers@efficios.com
---
 kernel/futex/syscalls.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/kernel/futex/syscalls.c b/kernel/futex/syscalls.c
index 086a22d..a807407 100644
--- a/kernel/futex/syscalls.c
+++ b/kernel/futex/syscalls.c
@@ -286,19 +286,22 @@ SYSCALL_DEFINE5(futex_waitv, struct futex_waitv __user *, waiters,
 	}
 
 	futexv = kcalloc(nr_futexes, sizeof(*futexv), GFP_KERNEL);
-	if (!futexv)
-		return -ENOMEM;
+	if (!futexv) {
+		ret = -ENOMEM;
+		goto destroy_timer;
+	}
 
 	ret = futex_parse_waitv(futexv, waiters, nr_futexes);
 	if (!ret)
 		ret = futex_wait_multiple(futexv, nr_futexes, timeout ? &to : NULL);
 
+	kfree(futexv);
+
+destroy_timer:
 	if (timeout) {
 		hrtimer_cancel(&to.timer);
 		destroy_hrtimer_on_stack(&to.timer);
 	}
-
-	kfree(futexv);
 	return ret;
 }
 

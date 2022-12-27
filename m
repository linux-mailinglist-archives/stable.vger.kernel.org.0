Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C84C656A0C
	for <lists+stable@lfdr.de>; Tue, 27 Dec 2022 12:51:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231479AbiL0Lvb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Dec 2022 06:51:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231404AbiL0Lv2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Dec 2022 06:51:28 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEB089FD7;
        Tue, 27 Dec 2022 03:51:26 -0800 (PST)
Date:   Tue, 27 Dec 2022 11:51:23 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1672141883;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VIquszyJoGKEfNk8Vb4fQX7sPIFWljq/kAytjP03G60=;
        b=Qg4CniI4ziFf3VeZBtNW7lxQ7OvksBnvneFXBt8L+qFiOPkHvCUk3iVpidiQLfqMyJ0UiY
        VN3Lqwh1U2+NpxnDBHq01Dgx9SmN1h3NZhm6K4mrs5ADqlkvBjjW+f+UdBfaEnqGRt9qB4
        AsIdCDap3uhaAgkiiO2RXuWyMDAszJrlR3xmrra4W8FQVzL/ynig6b7NpuKZjn5knGwpeA
        AWYf/fqIskAitZcsQi74Eov1zudlHgswjjzzKB3wguHYzTgjQq5shc/eUfOP9+lbo+BsJz
        foy5gY2kqyOg4DYOxZ6VzNq+E0jv/1SNL05rPKj8fM9w4Clyz69GKOLXjRyRfA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1672141883;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VIquszyJoGKEfNk8Vb4fQX7sPIFWljq/kAytjP03G60=;
        b=tYxFnqRv7FCXlMo8HccNrj3Vs/ftGXAkbFFOpLvkLsKffxe1ilgjzNhdM/Mr/jAZftmn6n
        tAJgp0jjE4Z3VGDQ==
From:   "tip-bot2 for Namhyung Kim" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: perf/urgent] perf/core: Call LSM hook after copying perf_event_attr
Cc:     Namhyung Kim <namhyung@kernel.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        "Joel Fernandes (Google)" <joel@joelfernandes.org>,
        stable@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20221220223140.4020470-1-namhyung@kernel.org>
References: <20221220223140.4020470-1-namhyung@kernel.org>
MIME-Version: 1.0
Message-ID: <167214188307.4906.2093385689566390498.tip-bot2@tip-bot2>
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

The following commit has been merged into the perf/urgent branch of tip:

Commit-ID:     0a041ebca4956292cadfb14a63ace3a9c1dcb0a3
Gitweb:        https://git.kernel.org/tip/0a041ebca4956292cadfb14a63ace3a9c1dcb0a3
Author:        Namhyung Kim <namhyung@kernel.org>
AuthorDate:    Tue, 20 Dec 2022 14:31:40 -08:00
Committer:     Peter Zijlstra <peterz@infradead.org>
CommitterDate: Tue, 27 Dec 2022 12:44:01 +01:00

perf/core: Call LSM hook after copying perf_event_attr

It passes the attr struct to the security_perf_event_open() but it's
not initialized yet.

Fixes: da97e18458fb ("perf_event: Add support for LSM and SELinux checks")
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Joel Fernandes (Google) <joel@joelfernandes.org>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/20221220223140.4020470-1-namhyung@kernel.org
---
 kernel/events/core.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 63d674c..d56328e 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -12321,12 +12321,12 @@ SYSCALL_DEFINE5(perf_event_open,
 	if (flags & ~PERF_FLAG_ALL)
 		return -EINVAL;
 
-	/* Do we allow access to perf_event_open(2) ? */
-	err = security_perf_event_open(&attr, PERF_SECURITY_OPEN);
+	err = perf_copy_attr(attr_uptr, &attr);
 	if (err)
 		return err;
 
-	err = perf_copy_attr(attr_uptr, &attr);
+	/* Do we allow access to perf_event_open(2) ? */
+	err = security_perf_event_open(&attr, PERF_SECURITY_OPEN);
 	if (err)
 		return err;
 

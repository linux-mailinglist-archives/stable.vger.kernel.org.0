Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE0742D3DCD
	for <lists+stable@lfdr.de>; Wed,  9 Dec 2020 09:47:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728280AbgLIInb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Dec 2020 03:43:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726825AbgLIInb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Dec 2020 03:43:31 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6F25C061794;
        Wed,  9 Dec 2020 00:42:50 -0800 (PST)
Date:   Wed, 09 Dec 2020 08:42:47 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1607503368;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uCd85UtwLZkHqvrCynsXseZnC3AJZUD1oJk4hfgtqP8=;
        b=RnW9jlq/olGAYbw2gxz5GJKLngXE9maOv1oFrYT2HVJ+hyEAD0AP8mZ9+olHhkhqBop4dM
        8jH0kD2ws8RZ/B1rEwhNgZ4yGGSLq1NVUBdO9rKQ/iKFcU9HS4I8XodqwfhyPLPY5Mu1e9
        Ki4G543vcECft7xrgRn5aHA8I/deF4f9mnz84F9vH/jvBXeSybqL40nEQnbxWAzDxGhx+R
        Y7Ki+J1hn2FU6sKH4fxhc1hkMwN3jcYMsXmiB9orV9qUDc7AigPyC27ZsoUnwaVTC+XDu7
        2OYMNFIjexcXFzMN0tM2bc5i8/KxDKGPSLRivMKLGGo5dwT4VQQLqWmgk7b4lA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1607503368;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uCd85UtwLZkHqvrCynsXseZnC3AJZUD1oJk4hfgtqP8=;
        b=Wh1pS466zoYcFR5i/ah6mb+kGkxb9CEpcmBg6/RKSGaoUoJgUESwf2l5wDFZoK2pBhTlx5
        vfoHBp324kuxgvAg==
From:   "tip-bot2 for Andy Lutomirski" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] membarrier: Add an actual barrier before rseq_preempt()
Cc:     Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        stable@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <d3e7197e034fa4852afcf370ca49c30496e58e40.1607058304.git.luto@kernel.org>
References: <d3e7197e034fa4852afcf370ca49c30496e58e40.1607058304.git.luto@kernel.org>
MIME-Version: 1.0
Message-ID: <160750336770.3364.7388742360472960633.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     2ecedd7569080fd05c1a457e8af2165afecfa29f
Gitweb:        https://git.kernel.org/tip/2ecedd7569080fd05c1a457e8af2165afecfa29f
Author:        Andy Lutomirski <luto@kernel.org>
AuthorDate:    Thu, 03 Dec 2020 21:07:04 -08:00
Committer:     Thomas Gleixner <tglx@linutronix.de>
CommitterDate: Wed, 09 Dec 2020 09:37:43 +01:00

membarrier: Add an actual barrier before rseq_preempt()

It seems that most RSEQ membarrier users will expect any stores done before
the membarrier() syscall to be visible to the target task(s).  While this
is extremely likely to be true in practice, nothing actually guarantees it
by a strict reading of the x86 manuals.  Rather than providing this
guarantee by accident and potentially causing a problem down the road, just
add an explicit barrier.

Fixes: 70216e18e519 ("membarrier: Provide core serializing command, *_SYNC_CORE")
Signed-off-by: Andy Lutomirski <luto@kernel.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/d3e7197e034fa4852afcf370ca49c30496e58e40.1607058304.git.luto@kernel.org

---
 kernel/sched/membarrier.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/kernel/sched/membarrier.c b/kernel/sched/membarrier.c
index e23e74d..7d98ef5 100644
--- a/kernel/sched/membarrier.c
+++ b/kernel/sched/membarrier.c
@@ -40,6 +40,14 @@ static void ipi_mb(void *info)
 
 static void ipi_rseq(void *info)
 {
+	/*
+	 * Ensure that all stores done by the calling thread are visible
+	 * to the current task before the current task resumes.  We could
+	 * probably optimize this away on most architectures, but by the
+	 * time we've already sent an IPI, the cost of the extra smp_mb()
+	 * is negligible.
+	 */
+	smp_mb();
 	rseq_preempt(current);
 }
 

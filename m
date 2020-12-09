Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06B682D3DC9
	for <lists+stable@lfdr.de>; Wed,  9 Dec 2020 09:47:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728244AbgLIInb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Dec 2020 03:43:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726119AbgLIInb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Dec 2020 03:43:31 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6EC9C061793;
        Wed,  9 Dec 2020 00:42:50 -0800 (PST)
Date:   Wed, 09 Dec 2020 08:42:47 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1607503368;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3uJFJULgcZ4NEFaFoVBiAbrkwCN+alHpKoaTm1VppeA=;
        b=a1jLtg0Gwa0fEZdZWgzGO31Whfc8ef67n6Sx6YcVlUw+/FUMUZHYWgeFI28hqDWI5q8IL5
        iCcZPRtvLYpBKZM+XB+8Yi/2KiI7w44N5WPN2/rRWnC3qA0PAdxI/vaIH1Bfkd3z3MhlYv
        2XH0Cq0wPWSeFDe2llON56aatrLOd8F0cqRp5iCOzqA8KUjX/Zqm4OFnZ6ICWeVd4vv8zL
        txbKC7uZe65/B7gc3gBnYPed6/6zyODK6p09NjNtoh7qCwUoqhxYRWhRI5u2rqvRdbak5o
        FEiOGK6k/6LhwAp9KQks3vK7BgMD7YSDKsg8ecOwYNG+4kqRBYlkehEqXsfajg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1607503368;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3uJFJULgcZ4NEFaFoVBiAbrkwCN+alHpKoaTm1VppeA=;
        b=RVNDglju4l3luYvEBy6mkQXkZ8PTnNKwkQ/CLhsjfHQ3SXGLBLnOQ6eLaWKJva2W7gz8W8
        5CH9dQQjzqQq25Bg==
From:   "tip-bot2 for Andy Lutomirski" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] membarrier: Explicitly sync remote cores when
 SYNC_CORE is requested
Cc:     Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        stable@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <776b448d5f7bd6b12690707f5ed67bcda7f1d427.1607058304.git.luto@kernel.org>
References: <776b448d5f7bd6b12690707f5ed67bcda7f1d427.1607058304.git.luto@kernel.org>
MIME-Version: 1.0
Message-ID: <160750336758.3364.197715839150303565.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     758c9373d84168dc7d039cf85a0e920046b17b41
Gitweb:        https://git.kernel.org/tip/758c9373d84168dc7d039cf85a0e920046b17b41
Author:        Andy Lutomirski <luto@kernel.org>
AuthorDate:    Thu, 03 Dec 2020 21:07:05 -08:00
Committer:     Thomas Gleixner <tglx@linutronix.de>
CommitterDate: Wed, 09 Dec 2020 09:37:43 +01:00

membarrier: Explicitly sync remote cores when SYNC_CORE is requested

membarrier() does not explicitly sync_core() remote CPUs; instead, it
relies on the assumption that an IPI will result in a core sync.  On x86,
this may be true in practice, but it's not architecturally reliable.  In
particular, the SDM and APM do not appear to guarantee that interrupt
delivery is serializing.  While IRET does serialize, IPI return can
schedule, thereby switching to another task in the same mm that was
sleeping in a syscall.  The new task could then SYSRET back to usermode
without ever executing IRET.

Make this more robust by explicitly calling sync_core_before_usermode()
on remote cores.  (This also helps people who search the kernel tree for
instances of sync_core() and sync_core_before_usermode() -- one might be
surprised that the core membarrier code doesn't currently show up in a
such a search.)

Fixes: 70216e18e519 ("membarrier: Provide core serializing command, *_SYNC_CORE")
Signed-off-by: Andy Lutomirski <luto@kernel.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/776b448d5f7bd6b12690707f5ed67bcda7f1d427.1607058304.git.luto@kernel.org

---
 kernel/sched/membarrier.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/kernel/sched/membarrier.c b/kernel/sched/membarrier.c
index 7d98ef5..1c278df 100644
--- a/kernel/sched/membarrier.c
+++ b/kernel/sched/membarrier.c
@@ -38,6 +38,23 @@ static void ipi_mb(void *info)
 	smp_mb();	/* IPIs should be serializing but paranoid. */
 }
 
+static void ipi_sync_core(void *info)
+{
+	/*
+	 * The smp_mb() in membarrier after all the IPIs is supposed to
+	 * ensure that memory on remote CPUs that occur before the IPI
+	 * become visible to membarrier()'s caller -- see scenario B in
+	 * the big comment at the top of this file.
+	 *
+	 * A sync_core() would provide this guarantee, but
+	 * sync_core_before_usermode() might end up being deferred until
+	 * after membarrier()'s smp_mb().
+	 */
+	smp_mb();	/* IPIs should be serializing but paranoid. */
+
+	sync_core_before_usermode();
+}
+
 static void ipi_rseq(void *info)
 {
 	/*
@@ -162,6 +179,7 @@ static int membarrier_private_expedited(int flags, int cpu_id)
 		if (!(atomic_read(&mm->membarrier_state) &
 		      MEMBARRIER_STATE_PRIVATE_EXPEDITED_SYNC_CORE_READY))
 			return -EPERM;
+		ipi_func = ipi_sync_core;
 	} else if (flags == MEMBARRIER_FLAG_RSEQ) {
 		if (!IS_ENABLED(CONFIG_RSEQ))
 			return -EINVAL;

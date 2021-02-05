Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 880A83110D5
	for <lists+stable@lfdr.de>; Fri,  5 Feb 2021 20:14:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233331AbhBERax (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Feb 2021 12:30:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:54090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233466AbhBEP7m (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Feb 2021 10:59:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 75F1C64FDF;
        Fri,  5 Feb 2021 14:09:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612534199;
        bh=dTmxHkv9WYnVWXiZjTLOW6cKnVIyFzHtOUC/e2Ik0fI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y/o1Iy1wHayq0KL1wkb8DUWKqPxNjLEVsgoBu+poZoVDJAjKyuYY5u6OX3AyyZmoW
         V3jIDFiS330oUwRcSsE5wTg7RPuBRXwEC+3Z6W1yyq/K+sNWW44I9bjqhY+PrPcY1U
         qUlI8NNBM9SdNVF0bQitYBTKWuADOyeekjkB1LI4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 24/57] locking/lockdep: Avoid noinstr warning for DEBUG_LOCKDEP
Date:   Fri,  5 Feb 2021 15:06:50 +0100
Message-Id: <20210205140657.011942306@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210205140655.982616732@linuxfoundation.org>
References: <20210205140655.982616732@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit 77ca93a6b1223e210e58e1000c09d8d420403c94 ]

  vmlinux.o: warning: objtool: lock_is_held_type()+0x60: call to check_flags.part.0() leaves .noinstr.text section

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/r/20210106144017.652218215@infradead.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/locking/lockdep.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/kernel/locking/lockdep.c b/kernel/locking/lockdep.c
index 02bc5b8f1eb27..bdaf4829098c0 100644
--- a/kernel/locking/lockdep.c
+++ b/kernel/locking/lockdep.c
@@ -5271,12 +5271,15 @@ static void __lock_unpin_lock(struct lockdep_map *lock, struct pin_cookie cookie
 /*
  * Check whether we follow the irq-flags state precisely:
  */
-static void check_flags(unsigned long flags)
+static noinstr void check_flags(unsigned long flags)
 {
 #if defined(CONFIG_PROVE_LOCKING) && defined(CONFIG_DEBUG_LOCKDEP)
 	if (!debug_locks)
 		return;
 
+	/* Get the warning out..  */
+	instrumentation_begin();
+
 	if (irqs_disabled_flags(flags)) {
 		if (DEBUG_LOCKS_WARN_ON(lockdep_hardirqs_enabled())) {
 			printk("possible reason: unannotated irqs-off.\n");
@@ -5304,6 +5307,8 @@ static void check_flags(unsigned long flags)
 
 	if (!debug_locks)
 		print_irqtrace_events(current);
+
+	instrumentation_end();
 #endif
 }
 
-- 
2.27.0




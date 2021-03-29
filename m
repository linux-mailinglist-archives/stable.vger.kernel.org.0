Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9FCC34C5E1
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:04:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231818AbhC2IDc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:03:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:45670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231154AbhC2IDD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:03:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A6E4D61969;
        Mon, 29 Mar 2021 08:02:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617004979;
        bh=g2vrgh2c805/HPJwRpNuUE/eHD2ka+kPptCk+sRlgDs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CfDCYFdWU5ESX7SiBZG8xGmgKwaGaNZsF2BxRgeajL8ZSSBZLM80aLAspwq3qwWnP
         xKbpLdnp0BK/QEkAxetb7DgbRGCefJM94k1uazcjgv+3TPJrqeI707Wcxg28jZYmj7
         wD6LuICHpZM0FbOGY4FqDrU8H7TXU2jJt/8BjqCQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        juri.lelli@arm.com, bigeasy@linutronix.de, xlpang@redhat.com,
        rostedt@goodmis.org, mathieu.desnoyers@efficios.com,
        jdesfossez@efficios.com, dvhart@infradead.org, bristot@redhat.com,
        Thomas Gleixner <tglx@linutronix.de>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 4.9 37/53] futex: Use smp_store_release() in mark_wake_futex()
Date:   Mon, 29 Mar 2021 09:58:12 +0200
Message-Id: <20210329075608.735190492@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075607.561619583@linuxfoundation.org>
References: <20210329075607.561619583@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

commit 1b367ece0d7e696cab1c8501bab282cc6a538b3f upstream.

Since the futex_q can dissapear the instruction after assigning NULL,
this really should be a RELEASE barrier. That stops loads from hitting
dead memory too.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: juri.lelli@arm.com
Cc: bigeasy@linutronix.de
Cc: xlpang@redhat.com
Cc: rostedt@goodmis.org
Cc: mathieu.desnoyers@efficios.com
Cc: jdesfossez@efficios.com
Cc: dvhart@infradead.org
Cc: bristot@redhat.com
Link: http://lkml.kernel.org/r/20170322104151.604296452@infradead.org
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/futex.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -1565,8 +1565,7 @@ static void mark_wake_futex(struct wake_
 	 * memory barrier is required here to prevent the following
 	 * store to lock_ptr from getting ahead of the plist_del.
 	 */
-	smp_wmb();
-	q->lock_ptr = NULL;
+	smp_store_release(&q->lock_ptr, NULL);
 }
 
 /*



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77C66293F53
	for <lists+stable@lfdr.de>; Tue, 20 Oct 2020 17:11:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408589AbgJTPLa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Oct 2020 11:11:30 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:39850 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731650AbgJTPL2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Oct 2020 11:11:28 -0400
Date:   Tue, 20 Oct 2020 15:11:25 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1603206685;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uWs+ivyuBL9M0T5dbDcvO3t/OpLiDzKuGtHUeHzQOdQ=;
        b=4WUbSztGQ/pUGNOwVUGzaiJwBfAzxoSaCI4Sjhg2UyBTwYdpGbf9HelbYjatdR7bo/M6pJ
        0AYUczwsX1BhndygOo33ICN5anNaAn1YfybhHnSHCBCvRHsHamfHcn5btcgHuZkPB4sK1D
        XWo2p7uRLdf0lVYX2cZmBa1bKX5TXmgBibhhWXkH80vpAV3hDyh5dN+wbhxJvjYJWkkhMc
        iBbE7DXuipUf+XUDvamqFHYH3Ms50lo/ChtDufiRExWl7gcfsvMxCkLrexmxyGb+XMZRc9
        7sXQb3ihzMK0DhV2RG8x4hQImBnZkYEBRJamHJzGiYbmk91ZqO6QP4oWcPK+pg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1603206685;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uWs+ivyuBL9M0T5dbDcvO3t/OpLiDzKuGtHUeHzQOdQ=;
        b=mHcXy71LUdJT95lsLYjVtdcNHrI5A5dVFi450JzG/tVTiYLWJUUuqQpOKQGfstWgxI5LI+
        7Hod7eb4xwvoyACQ==
From:   "tip-bot2 for Andrei Vagin" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: timers/urgent] futex: Adjust absolute futex timeouts with per
 time namespace offset
Cc:     Hans van der Laan <j.h.vanderlaan@student.utwente.nl>,
        Andrei Vagin <avagin@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        <stable@vger.kernel.org>, x86 <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20201015160020.293748-1-avagin@gmail.com>
References: <20201015160020.293748-1-avagin@gmail.com>
MIME-Version: 1.0
Message-ID: <160320668508.7002.6186011089896637829.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2.linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the timers/urgent branch of tip:

Commit-ID:     c2f7d08cccf4af2ce6992feaabb9e68e4ae0bff3
Gitweb:        https://git.kernel.org/tip/c2f7d08cccf4af2ce6992feaabb9e68e4ae0bff3
Author:        Andrei Vagin <avagin@gmail.com>
AuthorDate:    Thu, 15 Oct 2020 09:00:19 -07:00
Committer:     Thomas Gleixner <tglx@linutronix.de>
CommitterDate: Tue, 20 Oct 2020 17:02:57 +02:00

futex: Adjust absolute futex timeouts with per time namespace offset

For all commands except FUTEX_WAIT, the timeout is interpreted as an
absolute value. This absolute value is inside the task's time namespace and
has to be converted to the host's time.

Fixes: 5a590f35add9 ("posix-clocks: Wire up clock_gettime() with timens offsets")
Reported-by: Hans van der Laan <j.h.vanderlaan@student.utwente.nl>
Signed-off-by: Andrei Vagin <avagin@gmail.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Dmitry Safonov <0x7f454c46@gmail.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20201015160020.293748-1-avagin@gmail.com
---
 kernel/futex.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/kernel/futex.c b/kernel/futex.c
index 680854d..be68ac0 100644
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
+		else if (!(op & FUTEX_CLOCK_REALTIME))
+			t = timens_ktime_to_host(CLOCK_MONOTONIC, t);
 		tp = &t;
 	}
 	/*
@@ -3989,6 +3992,8 @@ SYSCALL_DEFINE6(futex_time32, u32 __user *, uaddr, int, op, u32, val,
 		t = timespec64_to_ktime(ts);
 		if (cmd == FUTEX_WAIT)
 			t = ktime_add_safe(ktime_get(), t);
+		else if (!(op & FUTEX_CLOCK_REALTIME))
+			t = timens_ktime_to_host(CLOCK_MONOTONIC, t);
 		tp = &t;
 	}
 	if (cmd == FUTEX_REQUEUE || cmd == FUTEX_CMP_REQUEUE ||

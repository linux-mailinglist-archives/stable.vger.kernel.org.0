Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A013EE1B47
	for <lists+stable@lfdr.de>; Wed, 23 Oct 2019 14:51:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391802AbfJWMvC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Oct 2019 08:51:02 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:49246 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391775AbfJWMvA (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Oct 2019 08:51:00 -0400
Received: from [5.158.153.53] (helo=tip-bot2.lab.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tip-bot2@linutronix.de>)
        id 1iNG6I-0001hf-3r; Wed, 23 Oct 2019 14:50:54 +0200
Received: from [127.0.1.1] (localhost [IPv6:::1])
        by tip-bot2.lab.linutronix.de (Postfix) with ESMTP id AF66D1C0089;
        Wed, 23 Oct 2019 14:50:53 +0200 (CEST)
Date:   Wed, 23 Oct 2019 12:50:53 -0000
From:   "tip-bot2 for Thomas Gleixner" <tip-bot2@linutronix.de>
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: timers/urgent] lib/vdso: Make clock_getres() POSIX compliant again
Cc:     Andreas Schwab <schwab@linux-m68k.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Christophe Leroy <christophe.leroy@c-s.fr>,
        stable@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.DEB.2.21.1910211202260.1904@nanos.tec.linutronix.de>
References: <alpine.DEB.2.21.1910211202260.1904@nanos.tec.linutronix.de>
MIME-Version: 1.0
Message-ID: <157183505345.29376.7588508845309452690.tip-bot2@tip-bot2>
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot2.linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the timers/urgent branch of tip:

Commit-ID:     1638b8f096ca165965189b9626564c933c79fe63
Gitweb:        https://git.kernel.org/tip/1638b8f096ca165965189b9626564c933c79fe63
Author:        Thomas Gleixner <tglx@linutronix.de>
AuthorDate:    Mon, 21 Oct 2019 12:07:15 +02:00
Committer:     Thomas Gleixner <tglx@linutronix.de>
CommitterDate: Wed, 23 Oct 2019 14:48:23 +02:00

lib/vdso: Make clock_getres() POSIX compliant again

A recent commit removed the NULL pointer check from the clock_getres()
implementation causing a test case to fault.

POSIX requires an explicit NULL pointer check for clock_getres() aside of
the validity check of the clock_id argument for obscure reasons.

Add it back for both 32bit and 64bit.

Note, this is only a partial revert of the offending commit which does not
bring back the broken fallback invocation in the the 32bit compat
implementations of clock_getres() and clock_gettime().

Fixes: a9446a906f52 ("lib/vdso/32: Remove inconsistent NULL pointer checks")
Reported-by: Andreas Schwab <schwab@linux-m68k.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Christophe Leroy <christophe.leroy@c-s.fr>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/alpine.DEB.2.21.1910211202260.1904@nanos.tec.linutronix.de

---
 lib/vdso/gettimeofday.c |  9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/lib/vdso/gettimeofday.c b/lib/vdso/gettimeofday.c
index e630e7f..45f57fd 100644
--- a/lib/vdso/gettimeofday.c
+++ b/lib/vdso/gettimeofday.c
@@ -214,9 +214,10 @@ int __cvdso_clock_getres_common(clockid_t clock, struct __kernel_timespec *res)
 		return -1;
 	}
 
-	res->tv_sec = 0;
-	res->tv_nsec = ns;
-
+	if (likely(res)) {
+		res->tv_sec = 0;
+		res->tv_nsec = ns;
+	}
 	return 0;
 }
 
@@ -245,7 +246,7 @@ __cvdso_clock_getres_time32(clockid_t clock, struct old_timespec32 *res)
 		ret = clock_getres_fallback(clock, &ts);
 #endif
 
-	if (likely(!ret)) {
+	if (likely(!ret && res)) {
 		res->tv_sec = ts.tv_sec;
 		res->tv_nsec = ts.tv_nsec;
 	}

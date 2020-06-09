Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5AB71F3E74
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 16:40:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730424AbgFIOka (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Jun 2020 10:40:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726395AbgFIOk3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Jun 2020 10:40:29 -0400
Received: from Galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE79DC05BD1E;
        Tue,  9 Jun 2020 07:40:28 -0700 (PDT)
Received: from [5.158.153.53] (helo=tip-bot2.lab.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tip-bot2@linutronix.de>)
        id 1jifQP-0002oA-AB; Tue, 09 Jun 2020 16:40:25 +0200
Received: from [127.0.1.1] (localhost [IPv6:::1])
        by tip-bot2.lab.linutronix.de (Postfix) with ESMTP id DD4BB1C007F;
        Tue,  9 Jun 2020 16:40:24 +0200 (CEST)
Date:   Tue, 09 Jun 2020 14:40:24 -0000
From:   "tip-bot2 for Thomas Gleixner" <tip-bot2@linutronix.de>
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] clocksource: Remove obsolete ifdef
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Miklos Szeredi <mszeredi@redhat.com>, stable@vger.kernel.org,
        x86 <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20200606221531.845475036@linutronix.de>
References: <20200606221531.845475036@linutronix.de>
MIME-Version: 1.0
Message-ID: <159171362475.17951.5175349331927727185.tip-bot2@tip-bot2>
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

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     c7f3d43b629b598a2bb9ec3524e844eae7492e7e
Gitweb:        https://git.kernel.org/tip/c7f3d43b629b598a2bb9ec3524e844eae7492e7e
Author:        Thomas Gleixner <tglx@linutronix.de>
AuthorDate:    Sat, 06 Jun 2020 23:51:15 +02:00
Committer:     Thomas Gleixner <tglx@linutronix.de>
CommitterDate: Tue, 09 Jun 2020 16:36:47 +02:00

clocksource: Remove obsolete ifdef

CONFIG_GENERIC_VDSO_CLOCK_MODE was a transitional config switch which got
removed after all architectures got converted to the new storage model.

But the removal forgot to remove the #ifdef which guards the
vdso_clock_mode sanity check, which effectively disables the sanity check.

Remove it now.

Fixes: f86fd32db706 ("lib/vdso: Cleanup clock mode storage leftovers")
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Miklos Szeredi <mszeredi@redhat.com>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/20200606221531.845475036@linutronix.de

---
 kernel/time/clocksource.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index 7cb09c4..02441ea 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -928,14 +928,12 @@ int __clocksource_register_scale(struct clocksource *cs, u32 scale, u32 freq)
 
 	clocksource_arch_init(cs);
 
-#ifdef CONFIG_GENERIC_VDSO_CLOCK_MODE
 	if (cs->vdso_clock_mode < 0 ||
 	    cs->vdso_clock_mode >= VDSO_CLOCKMODE_MAX) {
 		pr_warn("clocksource %s registered with invalid VDSO mode %d. Disabling VDSO support.\n",
 			cs->name, cs->vdso_clock_mode);
 		cs->vdso_clock_mode = VDSO_CLOCKMODE_NONE;
 	}
-#endif
 
 	/* Initialize mult/shift and max_idle_ns */
 	__clocksource_update_freq_scale(cs, scale, freq);

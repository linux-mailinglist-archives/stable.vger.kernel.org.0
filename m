Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C5EA1F0AAD
	for <lists+stable@lfdr.de>; Sun,  7 Jun 2020 11:36:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726548AbgFGJgQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Jun 2020 05:36:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726503AbgFGJgH (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Jun 2020 05:36:07 -0400
Received: from Galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 878F0C08C5C4;
        Sun,  7 Jun 2020 02:36:07 -0700 (PDT)
Received: from p5de0bf0b.dip0.t-ipconnect.de ([93.224.191.11] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1jhrif-0000K8-Ok; Sun, 07 Jun 2020 11:35:57 +0200
Received: from nanos.tec.linutronix.de (localhost [IPv6:::1])
        by nanos.tec.linutronix.de (Postfix) with ESMTP id 36C5C10108F;
        Sun,  7 Jun 2020 11:35:57 +0200 (CEST)
Message-Id: <20200606221531.845475036@linutronix.de>
User-Agent: quilt/0.65
Date:   Sat, 06 Jun 2020 23:51:15 +0200
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     Miklos Szeredi <miklos@szeredi.hu>, x86@kernel.org,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Andy Lutomirski <luto@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Juergen Gross <jgross@suse.com>,
        Christophe Leroy <christophe.leroy@c-s.fr>,
        stable@vger.kernel.org
Subject: [patch 1/3] clocksource: Remove obsolete ifdef
References: <20200606215114.380723277@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-transfer-encoding: 8-bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

CONFIG_GENERIC_VDSO_CLOCK_MODE was a transitional config switch which got
removed after all architectures got converted to the new storage model.

But the removal forgot to remove the #ifdef which guards the
vdso_clock_mode sanity check, which effectively disables the sanity check.

Remove it now.

Fixes: f86fd32db706 ("lib/vdso: Cleanup clock mode storage leftovers")
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
---
 kernel/time/clocksource.c |    2 --
 1 file changed, 2 deletions(-)

--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -928,14 +928,12 @@ int __clocksource_register_scale(struct
 
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


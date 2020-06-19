Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9ABEA2010E2
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 17:36:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403767AbgFSPf0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:35:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:35754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404596AbgFSPbo (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:31:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DF3D120734;
        Fri, 19 Jun 2020 15:31:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592580703;
        bh=tJeVrSk1Su6rLW8kR1sodkhPQpUas+QA2YDQF5pVEBQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FshqMaFVm1APfeajB11oOcaBXEzQxxkHAMxqkCqUitktBy1Bdy3UHI+e/fHv6WLq1
         x6NNcylJu5GvWEQ3oH6KCwL9ZSVyS5X/xDyOuquUo5eIGyrAuAnV596QfGKPNafgxT
         nClmxH70YOsQAQipZ3BkGCUCjtNPkkISi4b1IhPM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.7 343/376] powerpc/64s: Save FSCR to init_task.thread.fscr after feature init
Date:   Fri, 19 Jun 2020 16:34:21 +0200
Message-Id: <20200619141726.569869659@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141710.350494719@linuxfoundation.org>
References: <20200619141710.350494719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Ellerman <mpe@ellerman.id.au>

commit 912c0a7f2b5daa3cbb2bc10f303981e493de73bd upstream.

At boot the FSCR is initialised via one of two paths. On most systems
it's set to a hard coded value in __init_FSCR().

On newer skiboot systems we use the device tree CPU features binding,
where firmware can tell Linux what bits to set in FSCR (and HFSCR).

In both cases the value that's configured at boot is not propagated
into the init_task.thread.fscr value prior to the initial fork of init
(pid 1), which means the value is not used by any processes other than
swapper (the idle task).

For the __init_FSCR() case this is OK, because the value in
init_task.thread.fscr is initialised to something sensible. However it
does mean that the value set in __init_FSCR() is not used other than
for swapper, which is odd and confusing.

The bigger problem is for the device tree CPU features case it
prevents firmware from setting (or clearing) FSCR bits for use by user
space. This means all existing kernels can not have features
enabled/disabled by firmware if those features require
setting/clearing FSCR bits.

We can handle both cases by saving the FSCR value into
init_task.thread.fscr after we have initialised it at boot. This fixes
the bug for device tree CPU features, and will allow us to simplify
the initialisation for the __init_FSCR() case in a future patch.

Fixes: 5a61ef74f269 ("powerpc/64s: Support new device tree binding for discovering CPU features")
Cc: stable@vger.kernel.org # v4.12+
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20200527145843.2761782-3-mpe@ellerman.id.au
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/kernel/prom.c |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

--- a/arch/powerpc/kernel/prom.c
+++ b/arch/powerpc/kernel/prom.c
@@ -685,6 +685,23 @@ static void __init tm_init(void)
 static void tm_init(void) { }
 #endif /* CONFIG_PPC_TRANSACTIONAL_MEM */
 
+#ifdef CONFIG_PPC64
+static void __init save_fscr_to_task(void)
+{
+	/*
+	 * Ensure the init_task (pid 0, aka swapper) uses the value of FSCR we
+	 * have configured via the device tree features or via __init_FSCR().
+	 * That value will then be propagated to pid 1 (init) and all future
+	 * processes.
+	 */
+	if (early_cpu_has_feature(CPU_FTR_ARCH_207S))
+		init_task.thread.fscr = mfspr(SPRN_FSCR);
+}
+#else
+static inline void save_fscr_to_task(void) {};
+#endif
+
+
 void __init early_init_devtree(void *params)
 {
 	phys_addr_t limit;
@@ -773,6 +790,8 @@ void __init early_init_devtree(void *par
 		BUG();
 	}
 
+	save_fscr_to_task();
+
 #if defined(CONFIG_SMP) && defined(CONFIG_PPC64)
 	/* We'll later wait for secondaries to check in; there are
 	 * NCPUS-1 non-boot CPUs  :-)



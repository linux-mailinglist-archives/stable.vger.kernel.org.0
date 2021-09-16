Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E70D240D7D4
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 12:50:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235570AbhIPKwJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 06:52:09 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:47102 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235487AbhIPKwJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Sep 2021 06:52:09 -0400
Date:   Thu, 16 Sep 2021 10:50:46 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1631789447;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qR1o3qe0xaqHgLlXyLMRXicOoSOA+g6lTO49OyfrGAQ=;
        b=R6M0LEvYdc2aywanBaQn+mbk4Tv55KBzU3sjq64ngLZEaldo3ptgcV80ORdf9SDbGwPhZK
        bprFMNwlrH1KP813+qB4n1IT37Q9kGkv9mYOvF5XW3O7BJ/4XkOyKMZHBkiQgKwxSsfdxT
        EuKWMyb9/QVmH31WoPUcbovdi5iyw2fuoRLHwUj1xHdA2OazUy6ZdMW20zx1S2JZp5LHwU
        VSEh8qGxQQ4qL86tvRHWTsjhQj/ZIj/ozk9u2ssT73EaIdzkUmP1y9L8m6vuDjmwYfIPbh
        yWvwOTZ8R0EDj+3J8bq0dQ6zfhtw/pNsjXFuM/YpAnkjBHrOKCEx370DfyZUaQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1631789447;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qR1o3qe0xaqHgLlXyLMRXicOoSOA+g6lTO49OyfrGAQ=;
        b=StJFRR0j2Icv+Cby3CODw4/gjzno25NRun6FXjkoZKbrHbLCOPTjUQJmYUlY71Q9yGZVcy
        VzTUz5rtNqVzWfBg==
From:   "tip-bot2 for Juergen Gross" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] x86/setup: Call early_reserve_memory() earlier
Cc:     marmarek@invisiblethingslab.com, Juergen Gross <jgross@suse.com>,
        Borislav Petkov <bp@suse.de>,
        Mike Rapoport <rppt@linux.ibm.com>, stable@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20210914094108.22482-1-jgross@suse.com>
References: <20210914094108.22482-1-jgross@suse.com>
MIME-Version: 1.0
Message-ID: <163178944634.25758.17304720937855121489.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     1c1046581f1a3809e075669a3df0191869d96dd1
Gitweb:        https://git.kernel.org/tip/1c1046581f1a3809e075669a3df0191869d=
96dd1
Author:        Juergen Gross <jgross@suse.com>
AuthorDate:    Tue, 14 Sep 2021 11:41:08 +02:00
Committer:     Borislav Petkov <bp@suse.de>
CommitterDate: Thu, 16 Sep 2021 12:38:05 +02:00

x86/setup: Call early_reserve_memory() earlier

Commit in Fixes introduced early_reserve_memory() to do all needed
initial memblock_reserve() calls in one function. Unfortunately, the call
of early_reserve_memory() is done too late for Xen dom0, as in some
cases a Xen hook called by e820__memory_setup() will need those memory
reservations to have happened already.

Move the call of early_reserve_memory() to the beginning of setup_arch()
in order to avoid such problems.

Fixes: a799c2bd29d1 ("x86/setup: Consolidate early memory reservations")
Reported-by: Marek Marczykowski-G=C3=B3recki <marmarek@invisiblethingslab.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Acked-by: Mike Rapoport <rppt@linux.ibm.com>
Tested-by: Marek Marczykowski-G=C3=B3recki <marmarek@invisiblethingslab.com>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/20210914094108.22482-1-jgross@suse.com
---
 arch/x86/kernel/setup.c | 26 ++++++++++++++------------
 1 file changed, 14 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index bff3a78..9095158 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -766,6 +766,20 @@ dump_kernel_offset(struct notifier_block *self, unsigned=
 long v, void *p)
=20
 void __init setup_arch(char **cmdline_p)
 {
+	/*
+	 * Do some memory reservations *before* memory is added to memblock, so
+	 * memblock allocations won't overwrite it.
+	 *
+	 * After this point, everything still needed from the boot loader or
+	 * firmware or kernel text should be early reserved or marked not RAM in
+	 * e820. All other memory is free game.
+	 *
+	 * This call needs to happen before e820__memory_setup() which calls
+	 * xen_memory_setup() on Xen dom0 which relies on the fact that those
+	 * early reservations have happened already.
+	 */
+	early_reserve_memory();
+
 #ifdef CONFIG_X86_32
 	memcpy(&boot_cpu_data, &new_cpu_data, sizeof(new_cpu_data));
=20
@@ -885,18 +899,6 @@ void __init setup_arch(char **cmdline_p)
=20
 	parse_early_param();
=20
-	/*
-	 * Do some memory reservations *before* memory is added to
-	 * memblock, so memblock allocations won't overwrite it.
-	 * Do it after early param, so we could get (unlikely) panic from
-	 * serial.
-	 *
-	 * After this point everything still needed from the boot loader or
-	 * firmware or kernel text should be early reserved or marked not
-	 * RAM in e820. All other memory is free game.
-	 */
-	early_reserve_memory();
-
 #ifdef CONFIG_MEMORY_HOTPLUG
 	/*
 	 * Memory used by the kernel cannot be hot-removed because Linux

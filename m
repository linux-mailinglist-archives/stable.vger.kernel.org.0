Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED9F6414EEA
	for <lists+stable@lfdr.de>; Wed, 22 Sep 2021 19:19:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236744AbhIVRUa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Sep 2021 13:20:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236701AbhIVRU3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Sep 2021 13:20:29 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1D47C061574;
        Wed, 22 Sep 2021 10:18:59 -0700 (PDT)
Date:   Wed, 22 Sep 2021 17:18:56 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1632331137;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zqj7IcfjJOmv/J61U6IgvJMO0Ih8YuG/LFZTvW7FxmY=;
        b=vVdz8med9+wY4IZRf4lqE6Vqb8jkcygNfBzhp+VDUn5dszX1EJzbHAJodGDogCEUjmj/n9
        S24WgFZ080Xp9K7SV9pTkUytNfKjs/h6Ztu0AK8QEBBr3oqW9hE9eTSk3/HW0jmFFO1v4y
        GdaSjlUzoNsJoPIFC5xQdFeHkgvXvz0rqQM6nXnZVRqP456A0WWAE4saQ78PiucJ2v9B+/
        rZSLWdUTCX7zx05MkSRwRQdRDNFJyYHRn+hwCaBSnsOXM2EjPenmtEMb7Yf6G+efCx6Xqq
        GKnE7nMmhY9jyxiFEwFVX5Gazbbboj91fWyx/QRfECk1IvH6VcYp8CKNhV6uXg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1632331137;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zqj7IcfjJOmv/J61U6IgvJMO0Ih8YuG/LFZTvW7FxmY=;
        b=LK/61yZrDt+zJ9CFP0v6C2I4/LDNPoAOO/oLZb73mr6W4UZKAVGYG4/hFZexeWeP1lNnoA
        upBecXMB18RTu/BQ==
From:   "tip-bot2 for Juergen Gross" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] x86/setup: Call early_reserve_memory() earlier
Cc:     marmarek@invisiblethingslab.com, Juergen Gross <jgross@suse.com>,
        Borislav Petkov <bp@suse.de>,
        Nathan Chancellor <nathan@kernel.org>, stable@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20210920120421.29276-1-jgross@suse.com>
References: <20210920120421.29276-1-jgross@suse.com>
MIME-Version: 1.0
Message-ID: <163233113662.25758.10031107028271701591.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     8aa83e6395ce047a506f0b16edca45f36c1ae7f8
Gitweb:        https://git.kernel.org/tip/8aa83e6395ce047a506f0b16edca45f36c1=
ae7f8
Author:        Juergen Gross <jgross@suse.com>
AuthorDate:    Mon, 20 Sep 2021 14:04:21 +02:00
Committer:     Borislav Petkov <bp@suse.de>
CommitterDate: Tue, 21 Sep 2021 09:52:08 +02:00

x86/setup: Call early_reserve_memory() earlier

Commit in Fixes introduced early_reserve_memory() to do all needed
initial memblock_reserve() calls in one function. Unfortunately, the call
of early_reserve_memory() is done too late for Xen dom0, as in some
cases a Xen hook called by e820__memory_setup() will need those memory
reservations to have happened already.

Move the call of early_reserve_memory() before the call of
e820__memory_setup() in order to avoid such problems.

Fixes: a799c2bd29d1 ("x86/setup: Consolidate early memory reservations")
Reported-by: Marek Marczykowski-G=C3=B3recki <marmarek@invisiblethingslab.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Tested-by: Marek Marczykowski-G=C3=B3recki <marmarek@invisiblethingslab.com>
Tested-by: Nathan Chancellor <nathan@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/20210920120421.29276-1-jgross@suse.com
---
 arch/x86/kernel/setup.c | 26 ++++++++++++++------------
 1 file changed, 14 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 79f1641..40ed44e 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -830,6 +830,20 @@ void __init setup_arch(char **cmdline_p)
=20
 	x86_init.oem.arch_setup();
=20
+	/*
+	 * Do some memory reservations *before* memory is added to memblock, so
+	 * memblock allocations won't overwrite it.
+	 *
+	 * After this point, everything still needed from the boot loader or
+	 * firmware or kernel text should be early reserved or marked not RAM in
+	 * e820. All other memory is free game.
+	 *
+	 * This call needs to happen before e820__memory_setup() which calls the
+	 * xen_memory_setup() on Xen dom0 which relies on the fact that those
+	 * early reservations have happened already.
+	 */
+	early_reserve_memory();
+
 	iomem_resource.end =3D (1ULL << boot_cpu_data.x86_phys_bits) - 1;
 	e820__memory_setup();
 	parse_setup_data();
@@ -876,18 +890,6 @@ void __init setup_arch(char **cmdline_p)
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

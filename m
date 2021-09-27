Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7066419CAB
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 19:29:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237234AbhI0Raz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 13:30:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:46358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238387AbhI0R2x (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 13:28:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1248661505;
        Mon, 27 Sep 2021 17:17:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632763060;
        bh=Q11rLpbcOzPwcbGfU8zIZAnps4I8QgejIKQt8T4q/4s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1qU2hdBrwJdaoU6fU4glSgWj/1N92ASsqlUQDrYuiNI/Ub9KySzUiMS/9596EKQ/b
         bQJLqg5bc7fmMCfDo4ffO9GGhXDoI+LZcbzIAQzbWo2YZba+j0Cqm9UafQzIl01tY5
         b8gIM6JINmqv5tBwdLj+nYjHBSo8nHEi+yaLecr4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Marek=20Marczykowski-G=C3=B3recki?= 
        <marmarek@invisiblethingslab.com>, Juergen Gross <jgross@suse.com>,
        Borislav Petkov <bp@suse.de>,
        Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH 5.14 152/162] x86/setup: Call early_reserve_memory() earlier
Date:   Mon, 27 Sep 2021 19:03:18 +0200
Message-Id: <20210927170238.694139363@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927170233.453060397@linuxfoundation.org>
References: <20210927170233.453060397@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Juergen Gross <jgross@suse.com>

commit 8aa83e6395ce047a506f0b16edca45f36c1ae7f8 upstream.

Commit in Fixes introduced early_reserve_memory() to do all needed
initial memblock_reserve() calls in one function. Unfortunately, the call
of early_reserve_memory() is done too late for Xen dom0, as in some
cases a Xen hook called by e820__memory_setup() will need those memory
reservations to have happened already.

Move the call of early_reserve_memory() before the call of
e820__memory_setup() in order to avoid such problems.

Fixes: a799c2bd29d1 ("x86/setup: Consolidate early memory reservations")
Reported-by: Marek Marczykowski-Górecki <marmarek@invisiblethingslab.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Tested-by: Marek Marczykowski-Górecki <marmarek@invisiblethingslab.com>
Tested-by: Nathan Chancellor <nathan@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/20210920120421.29276-1-jgross@suse.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/setup.c |   26 ++++++++++++++------------
 1 file changed, 14 insertions(+), 12 deletions(-)

--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -839,6 +839,20 @@ void __init setup_arch(char **cmdline_p)
 
 	x86_init.oem.arch_setup();
 
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
 	iomem_resource.end = (1ULL << boot_cpu_data.x86_phys_bits) - 1;
 	e820__memory_setup();
 	parse_setup_data();
@@ -885,18 +899,6 @@ void __init setup_arch(char **cmdline_p)
 
 	parse_early_param();
 
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



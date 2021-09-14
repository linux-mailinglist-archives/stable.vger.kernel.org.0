Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A927640AB0C
	for <lists+stable@lfdr.de>; Tue, 14 Sep 2021 11:41:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229699AbhINJmc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Sep 2021 05:42:32 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:41326 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229560AbhINJma (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Sep 2021 05:42:30 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id AF5EA220CC;
        Tue, 14 Sep 2021 09:41:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1631612472; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=30u9QxljtHQChxZ06/YlGhJs1iq5r8Bx3qVFUI1IaBI=;
        b=iyMgnQgHJFFJjFjFAPR5PynTg/uuBNPUBW7HSkJDvAHUqb2vI8NVwufZ9B8pw1W8RwbV21
        sY9ZPbqzyYgOU8rd59OHmzpkABuHi4r4SbS2XZaPS0OidXTQJHOpHEsK3oqq72VAHugVPv
        X+5HfzQQuA8wHQ0cTH5y8G4eeOVFOdw=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 61C0313E55;
        Tue, 14 Sep 2021 09:41:12 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 1VE8FjhuQGFuSwAAMHmgww
        (envelope-from <jgross@suse.com>); Tue, 14 Sep 2021 09:41:12 +0000
From:   Juergen Gross <jgross@suse.com>
To:     xen-devel@lists.xenproject.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Juergen Gross <jgross@suse.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, stable@vger.kernel.org,
        =?UTF-8?q?Marek=20Marczykowski-G=C3=B3recki?= 
        <marmarek@invisiblethingslab.com>
Subject: [PATCH] x86/setup: call early_reserve_memory() earlier
Date:   Tue, 14 Sep 2021 11:41:08 +0200
Message-Id: <20210914094108.22482-1-jgross@suse.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit a799c2bd29d19c565 ("x86/setup: Consolidate early memory
reservations") introduced early_reserve_memory() to do all needed
initial memblock_reserve() calls in one function. Unfortunately the
call of early_reserve_memory() is done too late for Xen dom0, as in
some cases a Xen hook called by e820__memory_setup() will need those
memory reservations to have happened already.

Move the call of early_reserve_memory() to the beginning of
setup_arch() in order to avoid such problems.

Cc: stable@vger.kernel.org
Fixes: a799c2bd29d19c565 ("x86/setup: Consolidate early memory reservations")
Reported-by: Marek Marczykowski-Górecki <marmarek@invisiblethingslab.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
---
 arch/x86/kernel/setup.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 79f164141116..f369c51ec580 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -757,6 +757,18 @@ dump_kernel_offset(struct notifier_block *self, unsigned long v, void *p)
 
 void __init setup_arch(char **cmdline_p)
 {
+	/*
+	 * Do some memory reservations *before* memory is added to
+	 * memblock, so memblock allocations won't overwrite it.
+	 * Do it after early param, so we could get (unlikely) panic from
+	 * serial.
+	 *
+	 * After this point everything still needed from the boot loader or
+	 * firmware or kernel text should be early reserved or marked not
+	 * RAM in e820. All other memory is free game.
+	 */
+	early_reserve_memory();
+
 #ifdef CONFIG_X86_32
 	memcpy(&boot_cpu_data, &new_cpu_data, sizeof(new_cpu_data));
 
@@ -876,18 +888,6 @@ void __init setup_arch(char **cmdline_p)
 
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
-- 
2.26.2


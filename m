Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E876C4113F1
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 14:04:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231645AbhITMFv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 08:05:51 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:60362 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229848AbhITMFu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Sep 2021 08:05:50 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 350D92004D;
        Mon, 20 Sep 2021 12:04:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1632139463; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=ZubaKTTsXgUFZeDqZBtaX0Nm6q+Zb0+QJDfKEe2ZOB0=;
        b=TRbibNaBw9G4ffLO9IpRWu3FotMcA752oAO1A9dRbotpmFyTBVpvcurZUpUiTsjus4WhAX
        p5bgN1t3WNH9uKH9AtdSTbqZYYGBh0IilObJrSuGDgMRJ+586GNI7L3a+B0HartVxBcRI0
        2TvIh5lA5Lr5tp6fC757ZhZnP4jql9E=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id DD4E513483;
        Mon, 20 Sep 2021 12:04:22 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id qQejNMZ4SGFcIAAAMHmgww
        (envelope-from <jgross@suse.com>); Mon, 20 Sep 2021 12:04:22 +0000
From:   Juergen Gross <jgross@suse.com>
To:     xen-devel@lists.xenproject.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
Cc:     efault@gmx.de, Juergen Gross <jgross@suse.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, stable@vger.kernel.org,
        =?UTF-8?q?Marek=20Marczykowski-G=C3=B3recki?= 
        <marmarek@invisiblethingslab.com>
Subject: [PATCH v2] x86/setup: call early_reserve_memory() earlier
Date:   Mon, 20 Sep 2021 14:04:21 +0200
Message-Id: <20210920120421.29276-1-jgross@suse.com>
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

Move the call of early_reserve_memory() before the call of
e820__memory_setup() in order to avoid such problems.

Cc: stable@vger.kernel.org
Fixes: a799c2bd29d19c565 ("x86/setup: Consolidate early memory reservations")
Reported-by: Marek Marczykowski-Górecki <marmarek@invisiblethingslab.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
---
V2:
- update comment (Jan Beulich, Boris Petkov)
- move call down in setup_arch() (Mike Galbraith)
---
 arch/x86/kernel/setup.c | 26 ++++++++++++++------------
 1 file changed, 14 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 79f164141116..40ed44ead063 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -830,6 +830,20 @@ void __init setup_arch(char **cmdline_p)
 
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
@@ -876,18 +890,6 @@ void __init setup_arch(char **cmdline_p)
 
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


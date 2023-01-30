Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 019946810F7
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:08:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237141AbjA3OI6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:08:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237138AbjA3OI4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:08:56 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CE463B0F3
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:08:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3A0C261025
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:08:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 406C9C433EF;
        Mon, 30 Jan 2023 14:08:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675087734;
        bh=LqfvX+wIlNQFUz0C4R6tC3svfrfa3hc5QBiC8wgMcPQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0j8Jgx+EJTTSxGBsTpkTFw3C0YSzPxIuL2BtW9nAQBqCEMOTj7sv+/CFhefe2scUj
         CufUYg4JW6TFG1S91zojoE415KTCGa/lg2zcKUBFfTuR3zyPmAJIVIw7xitkuxKUEx
         st6efXU3opmmYBdkue74NqKYyybBdvI37Lp7Y4dk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?Marek=20Marczykowski-G=C3=B3recki?= 
        <marmarek@invisiblethingslab.com>, Juergen Gross <jgross@suse.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.1 307/313] acpi: Fix suspend with Xen PV
Date:   Mon, 30 Jan 2023 14:52:22 +0100
Message-Id: <20230130134351.041404358@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Juergen Gross <jgross@suse.com>

commit fe0ba8c23f9a35b0307eb662f16dd3a75fcdae41 upstream.

Commit f1e525009493 ("x86/boot: Skip realmode init code when running as
Xen PV guest") missed one code path accessing real_mode_header, leading
to dereferencing NULL when suspending the system under Xen:

    [  348.284004] PM: suspend entry (deep)
    [  348.289532] Filesystems sync: 0.005 seconds
    [  348.291545] Freezing user space processes ... (elapsed 0.000 seconds) done.
    [  348.292457] OOM killer disabled.
    [  348.292462] Freezing remaining freezable tasks ... (elapsed 0.104 seconds) done.
    [  348.396612] printk: Suspending console(s) (use no_console_suspend to debug)
    [  348.749228] PM: suspend devices took 0.352 seconds
    [  348.769713] ACPI: EC: interrupt blocked
    [  348.816077] BUG: kernel NULL pointer dereference, address: 000000000000001c
    [  348.816080] #PF: supervisor read access in kernel mode
    [  348.816081] #PF: error_code(0x0000) - not-present page
    [  348.816083] PGD 0 P4D 0
    [  348.816086] Oops: 0000 [#1] PREEMPT SMP NOPTI
    [  348.816089] CPU: 0 PID: 6764 Comm: systemd-sleep Not tainted 6.1.3-1.fc32.qubes.x86_64 #1
    [  348.816092] Hardware name: Star Labs StarBook/StarBook, BIOS 8.01 07/03/2022
    [  348.816093] RIP: e030:acpi_get_wakeup_address+0xc/0x20

Fix that by adding an optional acpi callback allowing to skip setting
the wakeup address, as in the Xen PV case this will be handled by the
hypervisor anyway.

Fixes: f1e525009493 ("x86/boot: Skip realmode init code when running as Xen PV guest")
Reported-by: Marek Marczykowski-Górecki <marmarek@invisiblethingslab.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Link: https://lore.kernel.org/all/20230117155724.22940-1-jgross%40suse.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/acpi.h |    8 ++++++++
 drivers/acpi/sleep.c        |    6 +++++-
 2 files changed, 13 insertions(+), 1 deletion(-)

--- a/arch/x86/include/asm/acpi.h
+++ b/arch/x86/include/asm/acpi.h
@@ -14,6 +14,7 @@
 #include <asm/mmu.h>
 #include <asm/mpspec.h>
 #include <asm/x86_init.h>
+#include <asm/cpufeature.h>
 
 #ifdef CONFIG_ACPI_APEI
 # include <asm/pgtable_types.h>
@@ -63,6 +64,13 @@ extern int (*acpi_suspend_lowlevel)(void
 /* Physical address to resume after wakeup */
 unsigned long acpi_get_wakeup_address(void);
 
+static inline bool acpi_skip_set_wakeup_address(void)
+{
+	return cpu_feature_enabled(X86_FEATURE_XENPV);
+}
+
+#define acpi_skip_set_wakeup_address acpi_skip_set_wakeup_address
+
 /*
  * Check if the CPU can handle C2 and deeper
  */
--- a/drivers/acpi/sleep.c
+++ b/drivers/acpi/sleep.c
@@ -60,13 +60,17 @@ static struct notifier_block tts_notifie
 	.priority	= 0,
 };
 
+#ifndef acpi_skip_set_wakeup_address
+#define acpi_skip_set_wakeup_address() false
+#endif
+
 static int acpi_sleep_prepare(u32 acpi_state)
 {
 #ifdef CONFIG_ACPI_SLEEP
 	unsigned long acpi_wakeup_address;
 
 	/* do we have a wakeup address for S2 and S3? */
-	if (acpi_state == ACPI_STATE_S3) {
+	if (acpi_state == ACPI_STATE_S3 && !acpi_skip_set_wakeup_address()) {
 		acpi_wakeup_address = acpi_get_wakeup_address();
 		if (!acpi_wakeup_address)
 			return -EFAULT;



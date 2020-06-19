Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51BAA20180C
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 18:48:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405233AbgFSQqd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 12:46:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388812AbgFSQqI (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Jun 2020 12:46:08 -0400
Received: from Galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 686BAC061796;
        Fri, 19 Jun 2020 09:46:03 -0700 (PDT)
Received: from [5.158.153.53] (helo=tip-bot2.lab.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tip-bot2@linutronix.de>)
        id 1jmK9P-00043S-Dz; Fri, 19 Jun 2020 18:45:59 +0200
Received: from [127.0.1.1] (localhost [IPv6:::1])
        by tip-bot2.lab.linutronix.de (Postfix) with ESMTP id 14B161C0085;
        Fri, 19 Jun 2020 18:45:59 +0200 (CEST)
Date:   Fri, 19 Jun 2020 16:45:58 -0000
From:   "tip-bot2 for Peter Jones" <tip-bot2@linutronix.de>
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: efi/urgent] efi: Make it possible to disable efivar_ssdt entirely
Cc:     <stable@vger.kernel.org>, Peter Jones <pjones@redhat.com>,
        Ard Biesheuvel <ardb@kernel.org>, x86 <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20200615202408.2242614-1-pjones@redhat.com>
References: <20200615202408.2242614-1-pjones@redhat.com>
MIME-Version: 1.0
Message-ID: <159258515877.16989.5930030344514684706.tip-bot2@tip-bot2>
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

The following commit has been merged into the efi/urgent branch of tip:

Commit-ID:     435d1a471598752446a72ad1201b3c980526d869
Gitweb:        https://git.kernel.org/tip/435d1a471598752446a72ad1201b3c980526d869
Author:        Peter Jones <pjones@redhat.com>
AuthorDate:    Mon, 15 Jun 2020 16:24:08 -04:00
Committer:     Ard Biesheuvel <ardb@kernel.org>
CommitterDate: Tue, 16 Jun 2020 11:01:07 +02:00

efi: Make it possible to disable efivar_ssdt entirely

In most cases, such as CONFIG_ACPI_CUSTOM_DSDT and
CONFIG_ACPI_TABLE_UPGRADE, boot-time modifications to firmware tables
are tied to specific Kconfig options.  Currently this is not the case
for modifying the ACPI SSDT via the efivar_ssdt kernel command line
option and associated EFI variable.

This patch adds CONFIG_EFI_CUSTOM_SSDT_OVERLAYS, which defaults
disabled, in order to allow enabling or disabling that feature during
the build.

Cc: <stable@vger.kernel.org>
Signed-off-by: Peter Jones <pjones@redhat.com>
Link: https://lore.kernel.org/r/20200615202408.2242614-1-pjones@redhat.com
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 drivers/firmware/efi/Kconfig | 11 +++++++++++
 drivers/firmware/efi/efi.c   |  2 +-
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/firmware/efi/Kconfig b/drivers/firmware/efi/Kconfig
index e6fc022..3939699 100644
--- a/drivers/firmware/efi/Kconfig
+++ b/drivers/firmware/efi/Kconfig
@@ -278,3 +278,14 @@ config EFI_EARLYCON
 	depends on SERIAL_EARLYCON && !ARM && !IA64
 	select FONT_SUPPORT
 	select ARCH_USE_MEMREMAP_PROT
+
+config EFI_CUSTOM_SSDT_OVERLAYS
+	bool "Load custom ACPI SSDT overlay from an EFI variable"
+	depends on EFI_VARS && ACPI
+	default ACPI_TABLE_UPGRADE
+	help
+	  Allow loading of an ACPI SSDT overlay from an EFI variable specified
+	  by a kernel command line option.
+
+	  See Documentation/admin-guide/acpi/ssdt-overlays.rst for more
+	  information.
diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index edc5d36..5114cae 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -189,7 +189,7 @@ static void generic_ops_unregister(void)
 	efivars_unregister(&generic_efivars);
 }
 
-#if IS_ENABLED(CONFIG_ACPI)
+#ifdef CONFIG_EFI_CUSTOM_SSDT_OVERLAYS
 #define EFIVAR_SSDT_NAME_MAX	16
 static char efivar_ssdt[EFIVAR_SSDT_NAME_MAX] __initdata;
 static int __init efivar_ssdt_setup(char *str)

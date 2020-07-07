Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEC6C217063
	for <lists+stable@lfdr.de>; Tue,  7 Jul 2020 17:23:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728294AbgGGPQw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jul 2020 11:16:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:56306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729081AbgGGPQr (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jul 2020 11:16:47 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A0AF120674;
        Tue,  7 Jul 2020 15:16:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594135007;
        bh=msfuEiO+x7aXjVRFosgMz+O+NJtzAGraiNCQX6X1ZSE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mO7zS46FCur4h7cm+zoIVE1y/QDadI2ye6VlXGNqiQAtIiMsTmuznKGGDRYpLlY4l
         lSG31KwY1jIetIzVEGSGy+V/Sf31GW4CuFDEsnlvWSthu6HswpimDcy4DZWBxy3CBt
         piBiX+Mg81Al5Nejs/bAm0ZJvewKVhLiFJnNKyFE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Jones <pjones@redhat.com>,
        Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 4.14 27/27] efi: Make it possible to disable efivar_ssdt entirely
Date:   Tue,  7 Jul 2020 17:15:54 +0200
Message-Id: <20200707145750.239540292@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200707145748.944863698@linuxfoundation.org>
References: <20200707145748.944863698@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Jones <pjones@redhat.com>

commit 435d1a471598752446a72ad1201b3c980526d869 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/firmware/efi/Kconfig |   11 +++++++++++
 drivers/firmware/efi/efi.c   |    2 +-
 2 files changed, 12 insertions(+), 1 deletion(-)

--- a/drivers/firmware/efi/Kconfig
+++ b/drivers/firmware/efi/Kconfig
@@ -164,6 +164,17 @@ config RESET_ATTACK_MITIGATION
 	  have been evicted, since otherwise it will trigger even on clean
 	  reboots.
 
+config EFI_CUSTOM_SSDT_OVERLAYS
+	bool "Load custom ACPI SSDT overlay from an EFI variable"
+	depends on EFI_VARS && ACPI
+	default ACPI_TABLE_UPGRADE
+	help
+	  Allow loading of an ACPI SSDT overlay from an EFI variable specified
+	  by a kernel command line option.
+
+	  See Documentation/admin-guide/acpi/ssdt-overlays.rst for more
+	  information.endmenu
+
 endmenu
 
 config UEFI_CPER
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -221,7 +221,7 @@ static void generic_ops_unregister(void)
 	efivars_unregister(&generic_efivars);
 }
 
-#if IS_ENABLED(CONFIG_ACPI)
+#ifdef CONFIG_EFI_CUSTOM_SSDT_OVERLAYS
 #define EFIVAR_SSDT_NAME_MAX	16
 static char efivar_ssdt[EFIVAR_SSDT_NAME_MAX] __initdata;
 static int __init efivar_ssdt_setup(char *str)



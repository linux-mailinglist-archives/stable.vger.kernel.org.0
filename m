Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27E708D90D
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 19:05:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728300AbfHNRFF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Aug 2019 13:05:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:53986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729357AbfHNRFF (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Aug 2019 13:05:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 27EEA214DA;
        Wed, 14 Aug 2019 17:05:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565802304;
        bh=kyMMWi/9VDnkrXmroYinFKQnd21XEuq3gSb6JFy5QkQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sHrClJmDvuH2N7bu2CnFyFkIFPkrsYvIhZDHOSD4LF/mBfSp8KvdKvvQxsQ9BASmF
         FIHzoagmSKAAjzw0dUjh31BXx8asDbiWJk803scMl/sqXJiW+uCh/RTyWxbKsLx6e0
         5X1dcEGIoNNCw7IelYWqv/9EvoR1OyT3lcR3cTqQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Tai <thomas.tai@oracle.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 074/144] iscsi_ibft: make ISCSI_IBFT dependson ACPI instead of ISCSI_IBFT_FIND
Date:   Wed, 14 Aug 2019 19:00:30 +0200
Message-Id: <20190814165802.952672907@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190814165759.466811854@linuxfoundation.org>
References: <20190814165759.466811854@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 94bccc34071094c165c79b515d21b63c78f7e968 ]

iscsi_ibft can use ACPI to find the iBFT entry during bootup,
currently, ISCSI_IBFT depends on ISCSI_IBFT_FIND which is
a X86 legacy way to find the iBFT by searching through the
low memory. This patch changes the dependency so that other
arch like ARM64 can use ISCSI_IBFT as long as the arch supports
ACPI.

ibft_init() needs to use the global variable ibft_addr declared
in iscsi_ibft_find.c. A #ifndef CONFIG_ISCSI_IBFT_FIND is needed
to declare the variable if CONFIG_ISCSI_IBFT_FIND is not selected.
Moving ibft_addr into the iscsi_ibft.c does not work because if
ISCSI_IBFT is selected as a module, the arch/x86/kernel/setup.c won't
be able to find the variable at compile time.

Signed-off-by: Thomas Tai <thomas.tai@oracle.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/Kconfig      | 5 +++--
 drivers/firmware/iscsi_ibft.c | 4 ++++
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/Kconfig b/drivers/firmware/Kconfig
index d40ccc3af9e26..fa7ed01415b72 100644
--- a/drivers/firmware/Kconfig
+++ b/drivers/firmware/Kconfig
@@ -157,7 +157,7 @@ config DMI_SCAN_MACHINE_NON_EFI_FALLBACK
 
 config ISCSI_IBFT_FIND
 	bool "iSCSI Boot Firmware Table Attributes"
-	depends on X86 && ACPI
+	depends on X86 && ISCSI_IBFT
 	default n
 	help
 	  This option enables the kernel to find the region of memory
@@ -168,7 +168,8 @@ config ISCSI_IBFT_FIND
 config ISCSI_IBFT
 	tristate "iSCSI Boot Firmware Table Attributes module"
 	select ISCSI_BOOT_SYSFS
-	depends on ISCSI_IBFT_FIND && SCSI && SCSI_LOWLEVEL
+	select ISCSI_IBFT_FIND if X86
+	depends on ACPI && SCSI && SCSI_LOWLEVEL
 	default	n
 	help
 	  This option enables support for detection and exposing of iSCSI
diff --git a/drivers/firmware/iscsi_ibft.c b/drivers/firmware/iscsi_ibft.c
index ab3aa39838338..7e12cbdf957cc 100644
--- a/drivers/firmware/iscsi_ibft.c
+++ b/drivers/firmware/iscsi_ibft.c
@@ -84,6 +84,10 @@ MODULE_DESCRIPTION("sysfs interface to BIOS iBFT information");
 MODULE_LICENSE("GPL");
 MODULE_VERSION(IBFT_ISCSI_VERSION);
 
+#ifndef CONFIG_ISCSI_IBFT_FIND
+struct acpi_table_ibft *ibft_addr;
+#endif
+
 struct ibft_hdr {
 	u8 id;
 	u8 version;
-- 
2.20.1




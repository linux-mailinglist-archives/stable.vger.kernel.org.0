Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A8387FA88
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 15:34:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394001AbfHBNXj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 09:23:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:34148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393990AbfHBNXh (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 09:23:37 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 131C921773;
        Fri,  2 Aug 2019 13:23:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564752216;
        bh=Amb6Vpgt5eY3/ZTea7L07ui6x9LTjveeXCAWM334VpM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I7lurZc/l1FDJo466xKXwqQqql4XbMuUAKbiM5I0llGLpi7yYCq5UUNfIl8ZyiLzf
         Orm7a2p7DEIKDeSvWX2NUqogGwuknZSXQGaJD42iXr7RrOsig1Cou1yaxzS7YPPkxp
         ZUaUp8QRjY6k9ixNr8F2S84d1lQsnsCxSt41RjH8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thomas Tai <thomas.tai@oracle.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 12/42] iscsi_ibft: make ISCSI_IBFT dependson ACPI instead of ISCSI_IBFT_FIND
Date:   Fri,  2 Aug 2019 09:22:32 -0400
Message-Id: <20190802132302.13537-12-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190802132302.13537-1-sashal@kernel.org>
References: <20190802132302.13537-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Tai <thomas.tai@oracle.com>

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
index 6e83880046d78..ed212c8b41083 100644
--- a/drivers/firmware/Kconfig
+++ b/drivers/firmware/Kconfig
@@ -198,7 +198,7 @@ config DMI_SCAN_MACHINE_NON_EFI_FALLBACK
 
 config ISCSI_IBFT_FIND
 	bool "iSCSI Boot Firmware Table Attributes"
-	depends on X86 && ACPI
+	depends on X86 && ISCSI_IBFT
 	default n
 	help
 	  This option enables the kernel to find the region of memory
@@ -209,7 +209,8 @@ config ISCSI_IBFT_FIND
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
index c51462f5aa1e4..966aef334c420 100644
--- a/drivers/firmware/iscsi_ibft.c
+++ b/drivers/firmware/iscsi_ibft.c
@@ -93,6 +93,10 @@ MODULE_DESCRIPTION("sysfs interface to BIOS iBFT information");
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


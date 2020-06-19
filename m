Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85FEE200DCD
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 17:02:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390763AbgFSPB7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:01:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:58422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390757AbgFSPB6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:01:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D528C20776;
        Fri, 19 Jun 2020 15:01:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592578918;
        bh=yDzdQagMiPCsGwTRjlDi8kGm1xIFobVPoGqLuxP5K1M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jw1kZhu5kG3OMg2rlAMw2/px/B889i2NylGxlAS+8d35s2kQG/HiokYrIxa8bEAYI
         T2XtckVQafMwUzutHaFztiV1zcNpYgQORg6ALRc8ckR/2hW8/4ufzZagg7eB3E3wpW
         476/iO+1F2O8Nf0vH48J1hl1Y9nUWTwxiPimSux0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Brian Woods <brian.woods@amd.com>,
        Borislav Petkov <bp@suse.de>,
        Guenter Roeck <linux@roeck-us.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Clemens Ladisch <clemens@ladisch.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Jean Delvare <jdelvare@suse.com>,
        Jia Zhang <qianyue.zj@alibaba-inc.com>,
        linux-hwmon@vger.kernel.org, linux-pci@vger.kernel.org,
        Pu Wen <puwen@hygon.cn>, Thomas Gleixner <tglx@linutronix.de>,
        x86-ml <x86@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 206/267] hwmon/k10temp, x86/amd_nb: Consolidate shared device IDs
Date:   Fri, 19 Jun 2020 16:33:11 +0200
Message-Id: <20200619141658.615718247@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141648.840376470@linuxfoundation.org>
References: <20200619141648.840376470@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Woods, Brian <Brian.Woods@amd.com>

[ Upstream commit dedf7dce4cec5c0abe69f4fa6938d5100398220b ]

Consolidate shared PCI_DEVICE_IDs that were scattered through k10temp
and amd_nb, and move them into pci_ids.

Signed-off-by: Brian Woods <brian.woods@amd.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Acked-by: Guenter Roeck <linux@roeck-us.net>
CC: Bjorn Helgaas <bhelgaas@google.com>
CC: Clemens Ladisch <clemens@ladisch.de>
CC: "H. Peter Anvin" <hpa@zytor.com>
CC: Ingo Molnar <mingo@redhat.com>
CC: Jean Delvare <jdelvare@suse.com>
CC: Jia Zhang <qianyue.zj@alibaba-inc.com>
CC: <linux-hwmon@vger.kernel.org>
CC: <linux-pci@vger.kernel.org>
CC: Pu Wen <puwen@hygon.cn>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: x86-ml <x86@kernel.org>
Link: http://lkml.kernel.org/r/20181106200754.60722-2-brian.woods@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/amd_nb.c | 3 +--
 drivers/hwmon/k10temp.c  | 9 +--------
 include/linux/pci_ids.h  | 2 ++
 3 files changed, 4 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/amd_nb.c b/arch/x86/kernel/amd_nb.c
index b481b95bd8f6..bf440af5ff9c 100644
--- a/arch/x86/kernel/amd_nb.c
+++ b/arch/x86/kernel/amd_nb.c
@@ -11,13 +11,12 @@
 #include <linux/errno.h>
 #include <linux/export.h>
 #include <linux/spinlock.h>
+#include <linux/pci_ids.h>
 #include <asm/amd_nb.h>
 
 #define PCI_DEVICE_ID_AMD_17H_ROOT	0x1450
 #define PCI_DEVICE_ID_AMD_17H_M10H_ROOT	0x15d0
-#define PCI_DEVICE_ID_AMD_17H_DF_F3	0x1463
 #define PCI_DEVICE_ID_AMD_17H_DF_F4	0x1464
-#define PCI_DEVICE_ID_AMD_17H_M10H_DF_F3 0x15eb
 #define PCI_DEVICE_ID_AMD_17H_M10H_DF_F4 0x15ec
 
 /* Protect the PCI config register pairs used for SMN and DF indirect access. */
diff --git a/drivers/hwmon/k10temp.c b/drivers/hwmon/k10temp.c
index 2cef0c37ff6f..bc6871c8dd4e 100644
--- a/drivers/hwmon/k10temp.c
+++ b/drivers/hwmon/k10temp.c
@@ -23,6 +23,7 @@
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/pci.h>
+#include <linux/pci_ids.h>
 #include <asm/amd_nb.h>
 #include <asm/processor.h>
 
@@ -41,14 +42,6 @@ static DEFINE_MUTEX(nb_smu_ind_mutex);
 #define PCI_DEVICE_ID_AMD_15H_M70H_NB_F3	0x15b3
 #endif
 
-#ifndef PCI_DEVICE_ID_AMD_17H_DF_F3
-#define PCI_DEVICE_ID_AMD_17H_DF_F3	0x1463
-#endif
-
-#ifndef PCI_DEVICE_ID_AMD_17H_M10H_DF_F3
-#define PCI_DEVICE_ID_AMD_17H_M10H_DF_F3	0x15eb
-#endif
-
 /* CPUID function 0x80000001, ebx */
 #define CPUID_PKGTYPE_MASK	0xf0000000
 #define CPUID_PKGTYPE_F		0x00000000
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index 861ee391dc33..857cfd6281a0 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -545,6 +545,8 @@
 #define PCI_DEVICE_ID_AMD_16H_NB_F4	0x1534
 #define PCI_DEVICE_ID_AMD_16H_M30H_NB_F3 0x1583
 #define PCI_DEVICE_ID_AMD_16H_M30H_NB_F4 0x1584
+#define PCI_DEVICE_ID_AMD_17H_DF_F3	0x1463
+#define PCI_DEVICE_ID_AMD_17H_M10H_DF_F3 0x15eb
 #define PCI_DEVICE_ID_AMD_CNB17H_F3	0x1703
 #define PCI_DEVICE_ID_AMD_LANCE		0x2000
 #define PCI_DEVICE_ID_AMD_LANCE_HOME	0x2001
-- 
2.25.1




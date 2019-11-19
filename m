Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10FBF1016B0
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 06:55:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731647AbfKSFzE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:55:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:53340 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731631AbfKSFzE (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:55:04 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 815F7208C3;
        Tue, 19 Nov 2019 05:55:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574142903;
        bh=XnRIcdZVlp6No/mC06k2e6r9GyXH2JlTE8agqW0ry2g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v+5LacgwIOsKzdi4lBiPfXvwoYMFddsgOMcfKAStDHtdhxIiX5ylhJymm88hKL/UG
         6/bVhMcD6vCLDkx7+P0zJlohd6ljaOJFZzHSd4g1mWH3Veb1MLiaUN1QFcS+Tjrh4m
         8YfHOb9OJw95vcAsQryFvJKLuEOni7SL+GvtpGQ8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dexuan Cui <decui@microsoft.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Michael Kelley <mikelley@microsoft.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        Olaf Aepfle <olaf@aepfle.de>,
        Andy Whitcroft <apw@canonical.com>,
        Jason Wang <jasowang@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Marcelo Cerri <marcelo.cerri@canonical.com>,
        Josh Poulson <jopoulso@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 214/239] x86/hyperv: Suppress "PCI: Fatal: No config space access function found"
Date:   Tue, 19 Nov 2019 06:20:14 +0100
Message-Id: <20191119051338.898151241@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051255.850204959@linuxfoundation.org>
References: <20191119051255.850204959@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dexuan Cui <decui@microsoft.com>

[ Upstream commit 2f285f46240d67060061d153786740d4df53cd78 ]

A Generation-2 Linux VM on Hyper-V doesn't have the legacy PCI bus, and
users always see the scary warning, which is actually harmless.

Suppress it.

Signed-off-by: Dexuan Cui <decui@microsoft.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Michael Kelley <mikelley@microsoft.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: KY Srinivasan <kys@microsoft.com>
Cc: Haiyang Zhang <haiyangz@microsoft.com>
Cc: Stephen Hemminger <sthemmin@microsoft.com>
Cc: "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
Cc: Olaf Aepfle <olaf@aepfle.de>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: Jason Wang <jasowang@redhat.com>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Marcelo Cerri <marcelo.cerri@canonical.com>
Cc: Josh Poulson <jopoulso@microsoft.com>
Link: https://lkml.kernel.org/r/ <KU1P153MB0166D977DC930996C4BF538ABF1D0@KU1P153MB0166.APCP153.PROD.OUTLOOK.COM
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/hyperv/hv_init.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/arch/x86/hyperv/hv_init.c b/arch/x86/hyperv/hv_init.c
index 2e9d58cc371e6..2653b7b25d176 100644
--- a/arch/x86/hyperv/hv_init.c
+++ b/arch/x86/hyperv/hv_init.c
@@ -17,6 +17,7 @@
  *
  */
 
+#include <linux/efi.h>
 #include <linux/types.h>
 #include <asm/hypervisor.h>
 #include <asm/hyperv.h>
@@ -101,6 +102,22 @@ static int hv_cpu_init(unsigned int cpu)
 	return 0;
 }
 
+static int __init hv_pci_init(void)
+{
+	int gen2vm = efi_enabled(EFI_BOOT);
+
+	/*
+	 * For Generation-2 VM, we exit from pci_arch_init() by returning 0.
+	 * The purpose is to suppress the harmless warning:
+	 * "PCI: Fatal: No config space access function found"
+	 */
+	if (gen2vm)
+		return 0;
+
+	/* For Generation-1 VM, we'll proceed in pci_arch_init().  */
+	return 1;
+}
+
 /*
  * This function is to be invoked early in the boot sequence after the
  * hypervisor has been detected.
@@ -154,6 +171,8 @@ void hyperv_init(void)
 
 	hyper_alloc_mmu();
 
+	x86_init.pci.arch_init = hv_pci_init;
+
 	/*
 	 * Register Hyper-V specific clocksource.
 	 */
-- 
2.20.1




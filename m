Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0AFFF101798
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 07:02:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729060AbfKSFlo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:41:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:36202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729655AbfKSFll (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:41:41 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AFEDD21783;
        Tue, 19 Nov 2019 05:41:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574142100;
        bh=LlzMNDJ0JCchkYkAHu29SOMVRQeTRHAAwXM9PKy8u+4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gmd1X9nnuM2kwiJCcQjM/4dLqZ/njsfobu0HIgEk8p4F5RS+4bJc+Zk4dHW3aPPTH
         GhGR/YM2PMieMp+HE/fTo6251/PUvGLVaMyhUeuSh1KcdrixK92XpKW4kVd2WMu1bM
         5c0rPgLZ+3o0m5C0n3sGfTd2Qd/cO187gn6TVhi0=
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
Subject: [PATCH 4.19 387/422] x86/hyperv: Suppress "PCI: Fatal: No config space access function found"
Date:   Tue, 19 Nov 2019 06:19:44 +0100
Message-Id: <20191119051424.164699533@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051400.261610025@linuxfoundation.org>
References: <20191119051400.261610025@linuxfoundation.org>
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
index 3fb8551552862..8a9cff1f129dc 100644
--- a/arch/x86/hyperv/hv_init.c
+++ b/arch/x86/hyperv/hv_init.c
@@ -17,6 +17,7 @@
  *
  */
 
+#include <linux/efi.h>
 #include <linux/types.h>
 #include <asm/apic.h>
 #include <asm/desc.h>
@@ -257,6 +258,22 @@ static int hv_cpu_die(unsigned int cpu)
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
@@ -333,6 +350,8 @@ void __init hyperv_init(void)
 
 	hv_apic_init();
 
+	x86_init.pci.arch_init = hv_pci_init;
+
 	/*
 	 * Register Hyper-V specific clocksource.
 	 */
-- 
2.20.1




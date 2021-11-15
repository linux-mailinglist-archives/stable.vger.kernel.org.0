Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 777DE45260D
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:59:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240164AbhKPCBl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 21:01:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:46106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240149AbhKOSGA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:06:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BB1D963388;
        Mon, 15 Nov 2021 17:43:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636998190;
        bh=tbtY4UP8vsYl02+GyaB09PmCnCezu0hEOx0kXslO1sk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pENdqzsJh4wEPxTg+Cu2cj88Fp9bQK5XMBN0Zcyjn7vma9cFfqBNeMVALqzCwaB9p
         llWfBI/9LakFDPEX6AHhZ+hA6Uvq4qs8Hu5szQHfyNy931v6/SUVjvap8djTM54W8I
         aq/iTT84NksBA5nqbgegemgmgPbE6pB6Imfi9bYY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Waiman Long <longman@redhat.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 420/575] powerpc: Refactor is_kvm_guest() declaration to new header
Date:   Mon, 15 Nov 2021 18:02:25 +0100
Message-Id: <20211115165358.285392556@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>

[ Upstream commit 92cc6bf01c7f4c5cfefd1963985c0064687ebeda ]

Only code/declaration movement, in anticipation of doing a KVM-aware
vcpu_is_preempted(). No additional changes.

Signed-off-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Acked-by: Waiman Long <longman@redhat.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20201202050456.164005-2-srikar@linux.vnet.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/include/asm/firmware.h  |  6 ------
 arch/powerpc/include/asm/kvm_guest.h | 15 +++++++++++++++
 arch/powerpc/include/asm/kvm_para.h  |  2 +-
 arch/powerpc/kernel/firmware.c       |  1 +
 arch/powerpc/platforms/pseries/smp.c |  1 +
 5 files changed, 18 insertions(+), 7 deletions(-)
 create mode 100644 arch/powerpc/include/asm/kvm_guest.h

diff --git a/arch/powerpc/include/asm/firmware.h b/arch/powerpc/include/asm/firmware.h
index 0b295bdb201e8..aa6a5ef5d4830 100644
--- a/arch/powerpc/include/asm/firmware.h
+++ b/arch/powerpc/include/asm/firmware.h
@@ -134,12 +134,6 @@ extern int ibm_nmi_interlock_token;
 
 extern unsigned int __start___fw_ftr_fixup, __stop___fw_ftr_fixup;
 
-#if defined(CONFIG_PPC_PSERIES) || defined(CONFIG_KVM_GUEST)
-bool is_kvm_guest(void);
-#else
-static inline bool is_kvm_guest(void) { return false; }
-#endif
-
 #ifdef CONFIG_PPC_PSERIES
 void pseries_probe_fw_features(void);
 #else
diff --git a/arch/powerpc/include/asm/kvm_guest.h b/arch/powerpc/include/asm/kvm_guest.h
new file mode 100644
index 0000000000000..d2c946dbbd2c0
--- /dev/null
+++ b/arch/powerpc/include/asm/kvm_guest.h
@@ -0,0 +1,15 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (C) 2020 IBM Corporation
+ */
+
+#ifndef _ASM_POWERPC_KVM_GUEST_H_
+#define _ASM_POWERPC_KVM_GUEST_H_
+
+#if defined(CONFIG_PPC_PSERIES) || defined(CONFIG_KVM_GUEST)
+bool is_kvm_guest(void);
+#else
+static inline bool is_kvm_guest(void) { return false; }
+#endif
+
+#endif /* _ASM_POWERPC_KVM_GUEST_H_ */
diff --git a/arch/powerpc/include/asm/kvm_para.h b/arch/powerpc/include/asm/kvm_para.h
index 744612054c94c..abe1b5e82547b 100644
--- a/arch/powerpc/include/asm/kvm_para.h
+++ b/arch/powerpc/include/asm/kvm_para.h
@@ -8,7 +8,7 @@
 #ifndef __POWERPC_KVM_PARA_H__
 #define __POWERPC_KVM_PARA_H__
 
-#include <asm/firmware.h>
+#include <asm/kvm_guest.h>
 
 #include <uapi/asm/kvm_para.h>
 
diff --git a/arch/powerpc/kernel/firmware.c b/arch/powerpc/kernel/firmware.c
index fe48d319d490e..5f48e5ad24cdd 100644
--- a/arch/powerpc/kernel/firmware.c
+++ b/arch/powerpc/kernel/firmware.c
@@ -14,6 +14,7 @@
 #include <linux/of.h>
 
 #include <asm/firmware.h>
+#include <asm/kvm_guest.h>
 
 #ifdef CONFIG_PPC64
 unsigned long powerpc_firmware_features __read_mostly;
diff --git a/arch/powerpc/platforms/pseries/smp.c b/arch/powerpc/platforms/pseries/smp.c
index 624e80b00eb18..7be7094075ab5 100644
--- a/arch/powerpc/platforms/pseries/smp.c
+++ b/arch/powerpc/platforms/pseries/smp.c
@@ -42,6 +42,7 @@
 #include <asm/plpar_wrappers.h>
 #include <asm/code-patching.h>
 #include <asm/svm.h>
+#include <asm/kvm_guest.h>
 
 #include "pseries.h"
 
-- 
2.33.0




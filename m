Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8675D4527E
	for <lists+stable@lfdr.de>; Fri, 14 Jun 2019 05:13:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726028AbfFNDNP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 23:13:15 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:40845 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725819AbfFNDNO (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Jun 2019 23:13:14 -0400
Received: by mail-pg1-f194.google.com with SMTP id d30so672774pgm.7
        for <stable@vger.kernel.org>; Thu, 13 Jun 2019 20:13:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RBs1rUgoU6ONwGkddceY1nFBB7cQx3Xs99bBwFEL95E=;
        b=Y+C3vCm4FkAIC9ch5xg5mi8S62oaHgpJnjqQq+9lw8g9Xph7XUJlAmNDCc33ug39w6
         e/FxICYL1v+gXJSPGpk4abMVGyBOrKwE/0zjP4smzzCzNga3q90iJtaLrxAMC1tz/wO4
         fYKov71NsbdHsYB+kGPyzeMqqqn3qVMEdnwq5VGs/UawuNFTPwh0GTBWmOr8exKBwGM0
         HCnGqmdUj/OrLoPiL3ABfRNC5FWKxQfoupQcwJe7fzwger9I++tW2np6m5KhLbY6oHqR
         D5K3XavaqFUz33yhK5eXM/BXTUiaxAip93SGy2tDEVN/C0lP2cPT0x1nl5fZuDHreUDV
         JC3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RBs1rUgoU6ONwGkddceY1nFBB7cQx3Xs99bBwFEL95E=;
        b=jGgIc8p+OiQ2zi+1ka4nvzB+KAuhao1VYxzsC8BWP7NajSWA7bG5pFPdTOzDujHxRR
         92zkpdYAn7Drs3Dvps7HyB4zHjmx0SeWm4WYhf3dTyrjr+ybCooueooIIEZ6EpM0sJA3
         cd89EwqDKKTX/YJ1HujeDUPk9hplrl8YK+gcga6eKkglyCaUU1+fQrKJxRcLM6AaEzBH
         qA+cPBcN7tMO0zXgp7C4/Ctdl8QFoY8l/0d3RaM571WDdTpGpg/OpOcUHQfH04KZpbxl
         /LdsiTOgKhR3RFCdGziJcX15VRGyuCQ0i9UlnjPNlyvReYJdL1Vv8fo1A1Wnf9U0QQEh
         fwNQ==
X-Gm-Message-State: APjAAAVaBWlLqJxq73Xo4ACAVv7Rw5GvHmtXs/wnUlcNjpbup+sG7lV2
        +QTIa8XmxT6l9ohZU5T/aqVtXg==
X-Google-Smtp-Source: APXvYqx1w5jIHExWIUiykLHbam+LKm0LbPJSJi662J7oNbLxNPX3VOKBfV57rgpjB/MT0Ts0/xEdpg==
X-Received: by 2002:a63:1617:: with SMTP id w23mr25538091pgl.183.1560481993805;
        Thu, 13 Jun 2019 20:13:13 -0700 (PDT)
Received: from localhost ([122.172.66.84])
        by smtp.gmail.com with ESMTPSA id f17sm1131479pgv.16.2019.06.13.20.13.12
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Jun 2019 20:13:13 -0700 (PDT)
From:   Viresh Kumar <viresh.kumar@linaro.org>
To:     linux-arm-kernel@lists.infradead.org,
        Julien Thierry <Julien.Thierry@arm.com>
Cc:     Viresh Kumar <viresh.kumar@linaro.org>, stable@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        mark.brown@arm.com
Subject: [PATCH v4.4 30/45] arm/arm64: KVM: Consolidate the PSCI include files
Date:   Fri, 14 Jun 2019 08:38:13 +0530
Message-Id: <165e8628ae4e24397d1dcee69d10487d53a7df98.1560480942.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.21.0.rc0.269.g1a574e7a288b
In-Reply-To: <cover.1560480942.git.viresh.kumar@linaro.org>
References: <cover.1560480942.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Rutland <mark.rutland@arm.com>

commit 1a2fb94e6a771ff94f4afa22497a4695187b820c upstream.

As we're about to update the PSCI support, and because I'm lazy,
let's move the PSCI include file to include/kvm so that both
ARM architectures can find it.

Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
Tested-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
[ v4.4: account for files moved to virt/ upstream ]
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 arch/arm/include/asm/kvm_psci.h               | 27 -------------------
 arch/arm/kvm/arm.c                            |  2 +-
 arch/arm/kvm/handle_exit.c                    |  2 +-
 arch/arm/kvm/psci.c                           |  3 ++-
 arch/arm64/kvm/handle_exit.c                  |  5 +++-
 .../asm/kvm_psci.h => include/kvm/arm_psci.h  |  6 ++---
 6 files changed, 11 insertions(+), 34 deletions(-)
 delete mode 100644 arch/arm/include/asm/kvm_psci.h
 rename arch/arm64/include/asm/kvm_psci.h => include/kvm/arm_psci.h (89%)

diff --git a/arch/arm/include/asm/kvm_psci.h b/arch/arm/include/asm/kvm_psci.h
deleted file mode 100644
index 6bda945d31fa..000000000000
--- a/arch/arm/include/asm/kvm_psci.h
+++ /dev/null
@@ -1,27 +0,0 @@
-/*
- * Copyright (C) 2012 - ARM Ltd
- * Author: Marc Zyngier <marc.zyngier@arm.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program.  If not, see <http://www.gnu.org/licenses/>.
- */
-
-#ifndef __ARM_KVM_PSCI_H__
-#define __ARM_KVM_PSCI_H__
-
-#define KVM_ARM_PSCI_0_1	1
-#define KVM_ARM_PSCI_0_2	2
-
-int kvm_psci_version(struct kvm_vcpu *vcpu);
-int kvm_psci_call(struct kvm_vcpu *vcpu);
-
-#endif /* __ARM_KVM_PSCI_H__ */
diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
index d7bef2144760..96fa300cf581 100644
--- a/arch/arm/kvm/arm.c
+++ b/arch/arm/kvm/arm.c
@@ -28,6 +28,7 @@
 #include <linux/sched.h>
 #include <linux/kvm.h>
 #include <trace/events/kvm.h>
+#include <kvm/arm_psci.h>
 
 #define CREATE_TRACE_POINTS
 #include "trace.h"
@@ -43,7 +44,6 @@
 #include <asm/kvm_mmu.h>
 #include <asm/kvm_emulate.h>
 #include <asm/kvm_coproc.h>
-#include <asm/kvm_psci.h>
 
 #ifdef REQUIRES_VIRT
 __asm__(".arch_extension	virt");
diff --git a/arch/arm/kvm/handle_exit.c b/arch/arm/kvm/handle_exit.c
index 05b2f8294968..ed879e3238d3 100644
--- a/arch/arm/kvm/handle_exit.c
+++ b/arch/arm/kvm/handle_exit.c
@@ -21,7 +21,7 @@
 #include <asm/kvm_emulate.h>
 #include <asm/kvm_coproc.h>
 #include <asm/kvm_mmu.h>
-#include <asm/kvm_psci.h>
+#include <kvm/arm_psci.h>
 #include <trace/events/kvm.h>
 
 #include "trace.h"
diff --git a/arch/arm/kvm/psci.c b/arch/arm/kvm/psci.c
index 443db0c43d7c..b4acfec9b459 100644
--- a/arch/arm/kvm/psci.c
+++ b/arch/arm/kvm/psci.c
@@ -21,9 +21,10 @@
 
 #include <asm/cputype.h>
 #include <asm/kvm_emulate.h>
-#include <asm/kvm_psci.h>
 #include <asm/kvm_host.h>
 
+#include <kvm/arm_psci.h>
+
 #include <uapi/linux/psci.h>
 
 /*
diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index c43e0e100c11..5b7fb5ab9136 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -22,11 +22,14 @@
 #include <linux/kvm.h>
 #include <linux/kvm_host.h>
 
+#include <kvm/arm_psci.h>
+
 #include <asm/esr.h>
 #include <asm/kvm_coproc.h>
 #include <asm/kvm_emulate.h>
 #include <asm/kvm_mmu.h>
-#include <asm/kvm_psci.h>
+#include <asm/debug-monitors.h>
+#include <asm/traps.h>
 
 #define CREATE_TRACE_POINTS
 #include "trace.h"
diff --git a/arch/arm64/include/asm/kvm_psci.h b/include/kvm/arm_psci.h
similarity index 89%
rename from arch/arm64/include/asm/kvm_psci.h
rename to include/kvm/arm_psci.h
index bc39e557c56c..2042bb909474 100644
--- a/arch/arm64/include/asm/kvm_psci.h
+++ b/include/kvm/arm_psci.h
@@ -15,8 +15,8 @@
  * along with this program.  If not, see <http://www.gnu.org/licenses/>.
  */
 
-#ifndef __ARM64_KVM_PSCI_H__
-#define __ARM64_KVM_PSCI_H__
+#ifndef __KVM_ARM_PSCI_H__
+#define __KVM_ARM_PSCI_H__
 
 #define KVM_ARM_PSCI_0_1	1
 #define KVM_ARM_PSCI_0_2	2
@@ -24,4 +24,4 @@
 int kvm_psci_version(struct kvm_vcpu *vcpu);
 int kvm_psci_call(struct kvm_vcpu *vcpu);
 
-#endif /* __ARM64_KVM_PSCI_H__ */
+#endif /* __KVM_ARM_PSCI_H__ */
-- 
2.21.0.rc0.269.g1a574e7a288b


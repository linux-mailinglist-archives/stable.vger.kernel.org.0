Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C44A4450E40
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:12:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240822AbhKOSNw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 13:13:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:49940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240191AbhKOSHS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:07:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 27AB56338E;
        Mon, 15 Nov 2021 17:43:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636998198;
        bh=PlJejh/rkV2tW7tVXcaRtBDv48+04XF1es1DUNrK/K4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JTDOKpVbtksElueOT8lakXIT1JTKeL+AB/wLXU+LoyydKHBSLrdMtuGf3NGMQ52XG
         UzYrE6UKTgOwqIuYXoAP2+mH3/oHuvuVjOSZdArcgSFHhG2uz7q7wcF4EedncJ2/xn
         GsIhWNlerfxiWpMu5GHqqGoh7BTF0gXEYPdvXtBc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Waiman Long <longman@redhat.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 422/575] powerpc: Reintroduce is_kvm_guest() as a fast-path check
Date:   Mon, 15 Nov 2021 18:02:27 +0100
Message-Id: <20211115165358.369501106@linuxfoundation.org>
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

[ Upstream commit a21d1becaa3f17a97b933ffa677b526afc514ec5 ]

Introduce a static branch that would be set during boot if the OS
happens to be a KVM guest. Subsequent checks to see if we are on KVM
will rely on this static branch. This static branch would be used in
vcpu_is_preempted() in a subsequent patch.

Signed-off-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Acked-by: Waiman Long <longman@redhat.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20201202050456.164005-4-srikar@linux.vnet.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/include/asm/kvm_guest.h | 10 ++++++++++
 arch/powerpc/include/asm/kvm_para.h  |  2 +-
 arch/powerpc/kernel/firmware.c       |  2 ++
 3 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/include/asm/kvm_guest.h b/arch/powerpc/include/asm/kvm_guest.h
index d7749ecb30d49..2fca299f7e192 100644
--- a/arch/powerpc/include/asm/kvm_guest.h
+++ b/arch/powerpc/include/asm/kvm_guest.h
@@ -7,8 +7,18 @@
 #define _ASM_POWERPC_KVM_GUEST_H_
 
 #if defined(CONFIG_PPC_PSERIES) || defined(CONFIG_KVM_GUEST)
+#include <linux/jump_label.h>
+
+DECLARE_STATIC_KEY_FALSE(kvm_guest);
+
+static inline bool is_kvm_guest(void)
+{
+	return static_branch_unlikely(&kvm_guest);
+}
+
 bool check_kvm_guest(void);
 #else
+static inline bool is_kvm_guest(void) { return false; }
 static inline bool check_kvm_guest(void) { return false; }
 #endif
 
diff --git a/arch/powerpc/include/asm/kvm_para.h b/arch/powerpc/include/asm/kvm_para.h
index 6fba06b6cfdbc..abe1b5e82547b 100644
--- a/arch/powerpc/include/asm/kvm_para.h
+++ b/arch/powerpc/include/asm/kvm_para.h
@@ -14,7 +14,7 @@
 
 static inline int kvm_para_available(void)
 {
-	return IS_ENABLED(CONFIG_KVM_GUEST) && check_kvm_guest();
+	return IS_ENABLED(CONFIG_KVM_GUEST) && is_kvm_guest();
 }
 
 static inline unsigned int kvm_arch_para_features(void)
diff --git a/arch/powerpc/kernel/firmware.c b/arch/powerpc/kernel/firmware.c
index c3140c6084c93..c9e2819b095ab 100644
--- a/arch/powerpc/kernel/firmware.c
+++ b/arch/powerpc/kernel/firmware.c
@@ -22,6 +22,7 @@ EXPORT_SYMBOL_GPL(powerpc_firmware_features);
 #endif
 
 #if defined(CONFIG_PPC_PSERIES) || defined(CONFIG_KVM_GUEST)
+DEFINE_STATIC_KEY_FALSE(kvm_guest);
 bool check_kvm_guest(void)
 {
 	struct device_node *hyper_node;
@@ -33,6 +34,7 @@ bool check_kvm_guest(void)
 	if (!of_device_is_compatible(hyper_node, "linux,kvm"))
 		return false;
 
+	static_branch_enable(&kvm_guest);
 	return true;
 }
 #endif
-- 
2.33.0




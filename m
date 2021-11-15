Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C1FB450E3A
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:12:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240784AbhKOSNl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 13:13:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:49920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240187AbhKOSHS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:07:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8C5D063387;
        Mon, 15 Nov 2021 17:43:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636998193;
        bh=dFxQ0ogb3P0ZYRHEjk1S85kd5p5sZall410qwzf/OBo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mbciulmfCXdtJQYHSMtCj+i4ExXJIhI38diSmkjq2i+bz59wcfMR5zCcD3gBQwq98
         zcGFcmwKKDy2q1MaxtDRtcF5zTIWwOe8ZuFdMEAS3T/tuktANwTzWOSoLDl0W3fKGv
         fsEXxryZwg4RIWGktiANtt65/wQEc0plAgCm65XA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Waiman Long <longman@redhat.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>,
        kernel test robot <lkp@intel.com>
Subject: [PATCH 5.10 421/575] powerpc: Rename is_kvm_guest() to check_kvm_guest()
Date:   Mon, 15 Nov 2021 18:02:26 +0100
Message-Id: <20211115165358.329048810@linuxfoundation.org>
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

[ Upstream commit 16520a858a995742c2d2248e86a6026bd0316562 ]

We want to reuse the is_kvm_guest() name in a subsequent patch but
with a new body. Hence rename is_kvm_guest() to check_kvm_guest(). No
additional changes.

Signed-off-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Acked-by: Waiman Long <longman@redhat.com>
Signed-off-by: kernel test robot <lkp@intel.com> # int -> bool fix
[mpe: Fold in fix from lkp to use true/false not 0/1]
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20201202050456.164005-3-srikar@linux.vnet.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/include/asm/kvm_guest.h | 4 ++--
 arch/powerpc/include/asm/kvm_para.h  | 2 +-
 arch/powerpc/kernel/firmware.c       | 8 ++++----
 arch/powerpc/platforms/pseries/smp.c | 2 +-
 4 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/powerpc/include/asm/kvm_guest.h b/arch/powerpc/include/asm/kvm_guest.h
index d2c946dbbd2c0..d7749ecb30d49 100644
--- a/arch/powerpc/include/asm/kvm_guest.h
+++ b/arch/powerpc/include/asm/kvm_guest.h
@@ -7,9 +7,9 @@
 #define _ASM_POWERPC_KVM_GUEST_H_
 
 #if defined(CONFIG_PPC_PSERIES) || defined(CONFIG_KVM_GUEST)
-bool is_kvm_guest(void);
+bool check_kvm_guest(void);
 #else
-static inline bool is_kvm_guest(void) { return false; }
+static inline bool check_kvm_guest(void) { return false; }
 #endif
 
 #endif /* _ASM_POWERPC_KVM_GUEST_H_ */
diff --git a/arch/powerpc/include/asm/kvm_para.h b/arch/powerpc/include/asm/kvm_para.h
index abe1b5e82547b..6fba06b6cfdbc 100644
--- a/arch/powerpc/include/asm/kvm_para.h
+++ b/arch/powerpc/include/asm/kvm_para.h
@@ -14,7 +14,7 @@
 
 static inline int kvm_para_available(void)
 {
-	return IS_ENABLED(CONFIG_KVM_GUEST) && is_kvm_guest();
+	return IS_ENABLED(CONFIG_KVM_GUEST) && check_kvm_guest();
 }
 
 static inline unsigned int kvm_arch_para_features(void)
diff --git a/arch/powerpc/kernel/firmware.c b/arch/powerpc/kernel/firmware.c
index 5f48e5ad24cdd..c3140c6084c93 100644
--- a/arch/powerpc/kernel/firmware.c
+++ b/arch/powerpc/kernel/firmware.c
@@ -22,17 +22,17 @@ EXPORT_SYMBOL_GPL(powerpc_firmware_features);
 #endif
 
 #if defined(CONFIG_PPC_PSERIES) || defined(CONFIG_KVM_GUEST)
-bool is_kvm_guest(void)
+bool check_kvm_guest(void)
 {
 	struct device_node *hyper_node;
 
 	hyper_node = of_find_node_by_path("/hypervisor");
 	if (!hyper_node)
-		return 0;
+		return false;
 
 	if (!of_device_is_compatible(hyper_node, "linux,kvm"))
-		return 0;
+		return false;
 
-	return 1;
+	return true;
 }
 #endif
diff --git a/arch/powerpc/platforms/pseries/smp.c b/arch/powerpc/platforms/pseries/smp.c
index 7be7094075ab5..9d596b41ec675 100644
--- a/arch/powerpc/platforms/pseries/smp.c
+++ b/arch/powerpc/platforms/pseries/smp.c
@@ -208,7 +208,7 @@ static __init void pSeries_smp_probe(void)
 	if (!cpu_has_feature(CPU_FTR_SMT))
 		return;
 
-	if (is_kvm_guest()) {
+	if (check_kvm_guest()) {
 		/*
 		 * KVM emulates doorbells by disabling FSCR[MSGP] so msgsndp
 		 * faults to the hypervisor which then reads the instruction
-- 
2.33.0




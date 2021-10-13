Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A12242B18B
	for <lists+stable@lfdr.de>; Wed, 13 Oct 2021 02:58:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237513AbhJMA6x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Oct 2021 20:58:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:42606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236401AbhJMA6U (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Oct 2021 20:58:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5AF1960F21;
        Wed, 13 Oct 2021 00:56:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634086578;
        bh=GyFV7MR+V1UTB57sUQk2mtvew2C60CiCYaYMvCzyMu8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ded2fSU5TFrm4gHE8Jm+jPcrBvLE0dVMVFY5XsAxKCqjOCnJOLnt9u8//nxG1ItTX
         vA9FpAYBqa2NcYL1ildVE2xySDidTcpYNaG7inpw+stuOYxNpUYiI6aFwq6VE0T0X6
         KNNxzTe+hfk0g2sdRAiK93e5OXoEwHbzGA1E9m/JJZ+6aPeMQQ6z1f4ztCbjKI4zle
         j7W/ZvDv40hzA0pIrqM/ZADTesMBiwdO9PjIHtWM5LoEcWeeyr8R3s7Wp9rAmqJBfs
         lTvN1n2irnP3q98AHwr4JE154VWzoFF6VBydoDE0HKPP84pU8whFOS6t1qzD1ZBLXz
         vqidcr6HqPmVw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, npiggin@gmail.com,
        dja@axtens.net, aik@ozlabs.ru, christophe.leroy@csgroup.eu,
        aneesh.kumar@linux.ibm.com, lihuafei1@huawei.com,
        linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 5.4 6/6] powerpc/security: Add a helper to query stf_barrier type
Date:   Tue, 12 Oct 2021 20:56:02 -0400
Message-Id: <20211013005603.700363-6-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211013005603.700363-1-sashal@kernel.org>
References: <20211013005603.700363-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>

[ Upstream commit 030905920f32e91a52794937f67434ac0b3ea41a ]

Add a helper to return the stf_barrier type for the current processor.

Signed-off-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/3bd5d7f96ea1547991ac2ce3137dc2b220bae285.1633464148.git.naveen.n.rao@linux.vnet.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/include/asm/security_features.h | 5 +++++
 arch/powerpc/kernel/security.c               | 5 +++++
 2 files changed, 10 insertions(+)

diff --git a/arch/powerpc/include/asm/security_features.h b/arch/powerpc/include/asm/security_features.h
index e9e3f85134e5..316a9c8d1929 100644
--- a/arch/powerpc/include/asm/security_features.h
+++ b/arch/powerpc/include/asm/security_features.h
@@ -39,6 +39,11 @@ static inline bool security_ftr_enabled(u64 feature)
 	return !!(powerpc_security_features & feature);
 }
 
+#ifdef CONFIG_PPC_BOOK3S_64
+enum stf_barrier_type stf_barrier_type_get(void);
+#else
+static inline enum stf_barrier_type stf_barrier_type_get(void) { return STF_BARRIER_NONE; }
+#endif
 
 // Features indicating support for Spectre/Meltdown mitigations
 
diff --git a/arch/powerpc/kernel/security.c b/arch/powerpc/kernel/security.c
index 1740a66cea84..ff022e725693 100644
--- a/arch/powerpc/kernel/security.c
+++ b/arch/powerpc/kernel/security.c
@@ -256,6 +256,11 @@ static int __init handle_no_stf_barrier(char *p)
 
 early_param("no_stf_barrier", handle_no_stf_barrier);
 
+enum stf_barrier_type stf_barrier_type_get(void)
+{
+	return stf_enabled_flush_types;
+}
+
 /* This is the generic flag used by other architectures */
 static int __init handle_ssbd(char *p)
 {
-- 
2.33.0


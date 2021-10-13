Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BFAF42B1A6
	for <lists+stable@lfdr.de>; Wed, 13 Oct 2021 02:58:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237634AbhJMA73 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Oct 2021 20:59:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:43086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237637AbhJMA6p (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Oct 2021 20:58:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BC64660EB4;
        Wed, 13 Oct 2021 00:56:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634086602;
        bh=sgZkco8fLQdzPtHZhHs4Bu9AcUVfHeWOR+grmPeD2qQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g7058hQYsfgNasbMOOZF4jZfcyEYn6xUcaG5rrRm3yN67fArm02KUIHPWWX/UTToH
         vLeL4+hVDWnb2AImTFAycrafUeJHMvmI3s4RzbMQ6XaKj/nCaBo9BjR2b4HTZZ3pMi
         JPdFYblZvaT58cLIpEc1SI5c3Rrlx2Gmu77nF2kRWw7dbyWbgJZ1rMBmDYaa8COv9b
         pm5whkOHtUIeGLsljL3hs4zoq8wAeEvRiiVf/3C0hhrhCpUDvx+LtbbkPajwmEBggC
         ntebEGuTO0tifAgn0UlhUJBAw8bdhZrfFtz7ALTI0Fe5ocs/PIbo2vhDg7Hqwtqjo+
         pzyRML7yiOfbw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, npiggin@gmail.com,
        dja@axtens.net, lihuafei1@huawei.com, aneesh.kumar@linux.ibm.com,
        christophe.leroy@csgroup.eu, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 4.14 5/5] powerpc/security: Add a helper to query stf_barrier type
Date:   Tue, 12 Oct 2021 20:56:31 -0400
Message-Id: <20211013005631.700631-5-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211013005631.700631-1-sashal@kernel.org>
References: <20211013005631.700631-1-sashal@kernel.org>
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
index 3b45a64e491e..a673416da388 100644
--- a/arch/powerpc/include/asm/security_features.h
+++ b/arch/powerpc/include/asm/security_features.h
@@ -39,6 +39,11 @@ static inline bool security_ftr_enabled(unsigned long feature)
 	return !!(powerpc_security_features & feature);
 }
 
+#ifdef CONFIG_PPC_BOOK3S_64
+enum stf_barrier_type stf_barrier_type_get(void);
+#else
+static inline enum stf_barrier_type stf_barrier_type_get(void) { return STF_BARRIER_NONE; }
+#endif
 
 // Features indicating support for Spectre/Meltdown mitigations
 
diff --git a/arch/powerpc/kernel/security.c b/arch/powerpc/kernel/security.c
index b3f540c9f410..75a5277ef7b8 100644
--- a/arch/powerpc/kernel/security.c
+++ b/arch/powerpc/kernel/security.c
@@ -248,6 +248,11 @@ static int __init handle_no_stf_barrier(char *p)
 
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


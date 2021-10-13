Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B2A642B1B5
	for <lists+stable@lfdr.de>; Wed, 13 Oct 2021 02:59:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237898AbhJMA7u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Oct 2021 20:59:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:42686 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237273AbhJMA7C (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Oct 2021 20:59:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 02F1E60F38;
        Wed, 13 Oct 2021 00:56:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634086620;
        bh=/KC2OKpQbjlEYX3CkEckNXdgHfX4T7wob+fNzJx7h/k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B4eQCSY/zJ2CH+JBMVpj5xy8Aq3gO9X6/Wgx4JUMthWS5gx0XPQsofqeKDZ+/X8LR
         joGqgjWSwwFJ7HdWlVFP7za8O0yogv2PnSAXM2yvVSf40scZIZ9iEqBkP0aKyKaRk0
         EP9lkv1TmKrGI1SI64J7FiZO4H9K2pKl0K8JlynNdhM7lACEnbYSMAO/FCCUe/Spb5
         V98sqAQa9Fl0DJkAJ3J6FujLKBvX6ni1Ety8m2i0eBtKuLByIY4sCpBE+NZ8cG4qGo
         +j8zW+lS6nH+X9+auIePmiZfmDrCFU+AfA/qmfhxW05z+eIAJmdR4P+jNvVRl2TpP6
         bEbw2niyX/4+w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, npiggin@gmail.com,
        dja@axtens.net, christophe.leroy@csgroup.eu, aik@ozlabs.ru,
        lihuafei1@huawei.com, aneesh.kumar@linux.ibm.com,
        linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 4.4 2/2] powerpc/security: Add a helper to query stf_barrier type
Date:   Tue, 12 Oct 2021 20:56:54 -0400
Message-Id: <20211013005654.700769-2-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211013005654.700769-1-sashal@kernel.org>
References: <20211013005654.700769-1-sashal@kernel.org>
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
index 45778c83038f..ac9a2498efe7 100644
--- a/arch/powerpc/kernel/security.c
+++ b/arch/powerpc/kernel/security.c
@@ -249,6 +249,11 @@ static int __init handle_no_stf_barrier(char *p)
 
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


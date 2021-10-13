Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B63042B14E
	for <lists+stable@lfdr.de>; Wed, 13 Oct 2021 02:56:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236749AbhJMA5l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Oct 2021 20:57:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:41232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236904AbhJMA5X (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Oct 2021 20:57:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5762260EB4;
        Wed, 13 Oct 2021 00:55:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634086521;
        bh=a6O9WCTF/LMiJc6mOpPugAxRSA3fH/eJdsDcax8o1+w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YPn4gDi9E7wCTfAAk+Dk+iea1zPKtZ8A0GEXdXRslsJNVKigirHBFvY69OlywX4lr
         zcEZCTKvMsKMiOk0OdQp+yt0GNReh/Vut/GJLLNX+V9sFF/tysY6UQIjpfxw1E14hV
         XWzeWBPL+ZSs8L7TcanEIz8zTJYgeDE2OSbmo2raSv3n6GMHR8eBiLCpdrS6uStv/Z
         Ak7/w94FvOEF8ggl6YHq6qD2zczBdISuotTL3oCyJ2r5htIMQzARuJRhL4YVfqV5ih
         CvvQxmXEgDDS2gqTjYYKk6pfTKSQ8m9ZYefQK6UxxnprLnuTthbBWHBQArHK/GsRBz
         HhLj7iEHlicQg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, npiggin@gmail.com,
        dja@axtens.net, lihuafei1@huawei.com, aik@ozlabs.ru,
        aneesh.kumar@linux.ibm.com, christophe.leroy@csgroup.eu,
        linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 5.14 15/17] powerpc/security: Add a helper to query stf_barrier type
Date:   Tue, 12 Oct 2021 20:54:39 -0400
Message-Id: <20211013005441.699846-15-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211013005441.699846-1-sashal@kernel.org>
References: <20211013005441.699846-1-sashal@kernel.org>
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
index 792eefaf230b..27574f218b37 100644
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
index cc51fa52e783..e723ff77cc9b 100644
--- a/arch/powerpc/kernel/security.c
+++ b/arch/powerpc/kernel/security.c
@@ -263,6 +263,11 @@ static int __init handle_no_stf_barrier(char *p)
 
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


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31A4042B1B0
	for <lists+stable@lfdr.de>; Wed, 13 Oct 2021 02:58:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237880AbhJMA7n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Oct 2021 20:59:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:42664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237551AbhJMA6z (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Oct 2021 20:58:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8BC006109E;
        Wed, 13 Oct 2021 00:56:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634086613;
        bh=XkNICrx/CARGWkSUAp287RuUq27QvtIo7Wv371x+kMI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KPfGOBwa5wSon73bbteghYZZGETyQEX2MCIkuQu8u6X2WH1f6IojPxqy/y8qxHSFq
         xU9eRO0bSCh68Vlue1J9/pyES7lypWlZid3dbRE6p41lOP7d7G3cjSo12Q1V+6Y57t
         ok+zNUFye3JLjJ9Agx7O0O8f9u/zXdzl2w+wPMuelIrl7I1L0WeVXWit8S8IVjWvx6
         /jTUYIpIURd9JEBv0NbDW7B6rvWC/4ROY949TK53teA8TWj09c7/FgvEp6VIcEaFOq
         BhliSHCAj4A++ssCsfd9hmF4mv9LF3jl8Wiwk6XocrCiDLaa7mDOu/sII8FarC0WF8
         KWJugHSJoxBuQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, npiggin@gmail.com,
        dja@axtens.net, christophe.leroy@csgroup.eu, aik@ozlabs.ru,
        aneesh.kumar@linux.ibm.com, lihuafei1@huawei.com,
        linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 4.9 4/4] powerpc/security: Add a helper to query stf_barrier type
Date:   Tue, 12 Oct 2021 20:56:43 -0400
Message-Id: <20211013005644.700705-4-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211013005644.700705-1-sashal@kernel.org>
References: <20211013005644.700705-1-sashal@kernel.org>
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
index ff85fc800183..df42f020e703 100644
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


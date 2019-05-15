Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED7E61F381
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 14:16:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727446AbfEOLDf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:03:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:32882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727570AbfEOLDe (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:03:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 17C2320881;
        Wed, 15 May 2019 11:03:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557918213;
        bh=hHBb+FhQureF1N1HjVTrbIcBV14npfrIhCUIRJImmso=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hivoYZePCoveDNrjqgboGMZ8bghx0HLr2eagw0d2zO++MatI+3OlqAburiUjXPRqd
         RxTDo9WSDhQGreeUrsSBcaH6NCloEWGcFIbE0nszpUNWGvEntN20YfNkq6HZPZq6fx
         LPArR9zlvjUn1hKXwLFu51Fq1HlH17RJx8P3Sb+M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Diana Craciun <diana.craciun@nxp.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 4.4 048/266] powerpc/64: Call setup_barrier_nospec() from setup_arch()
Date:   Wed, 15 May 2019 12:52:35 +0200
Message-Id: <20190515090724.080983555@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090722.696531131@linuxfoundation.org>
References: <20190515090722.696531131@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Ellerman <mpe@ellerman.id.au>

commit af375eefbfb27cbb5b831984e66d724a40d26b5c upstream.

Currently we require platform code to call setup_barrier_nospec(). But
if we add an empty definition for the !CONFIG_PPC_BARRIER_NOSPEC case
then we can call it in setup_arch().

Signed-off-by: Diana Craciun <diana.craciun@nxp.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/include/asm/setup.h       |    4 ++++
 arch/powerpc/kernel/setup_32.c         |    2 ++
 arch/powerpc/kernel/setup_64.c         |    2 ++
 arch/powerpc/platforms/powernv/setup.c |    1 -
 arch/powerpc/platforms/pseries/setup.c |    1 -
 5 files changed, 8 insertions(+), 2 deletions(-)

--- a/arch/powerpc/include/asm/setup.h
+++ b/arch/powerpc/include/asm/setup.h
@@ -38,7 +38,11 @@ enum l1d_flush_type {
 
 void setup_rfi_flush(enum l1d_flush_type, bool enable);
 void do_rfi_flush_fixups(enum l1d_flush_type types);
+#ifdef CONFIG_PPC_BARRIER_NOSPEC
 void setup_barrier_nospec(void);
+#else
+static inline void setup_barrier_nospec(void) { };
+#endif
 void do_barrier_nospec_fixups(bool enable);
 extern bool barrier_nospec_enabled;
 
--- a/arch/powerpc/kernel/setup_32.c
+++ b/arch/powerpc/kernel/setup_32.c
@@ -322,6 +322,8 @@ void __init setup_arch(char **cmdline_p)
 		ppc_md.setup_arch();
 	if ( ppc_md.progress ) ppc_md.progress("arch: exit", 0x3eab);
 
+	setup_barrier_nospec();
+
 	paging_init();
 
 	/* Initialize the MMU context management stuff */
--- a/arch/powerpc/kernel/setup_64.c
+++ b/arch/powerpc/kernel/setup_64.c
@@ -736,6 +736,8 @@ void __init setup_arch(char **cmdline_p)
 	if (ppc_md.setup_arch)
 		ppc_md.setup_arch();
 
+	setup_barrier_nospec();
+
 	paging_init();
 
 	/* Initialize the MMU context management stuff */
--- a/arch/powerpc/platforms/powernv/setup.c
+++ b/arch/powerpc/platforms/powernv/setup.c
@@ -123,7 +123,6 @@ static void pnv_setup_rfi_flush(void)
 		  security_ftr_enabled(SEC_FTR_L1D_FLUSH_HV));
 
 	setup_rfi_flush(type, enable);
-	setup_barrier_nospec();
 }
 
 static void __init pnv_setup_arch(void)
--- a/arch/powerpc/platforms/pseries/setup.c
+++ b/arch/powerpc/platforms/pseries/setup.c
@@ -574,7 +574,6 @@ void pseries_setup_rfi_flush(void)
 		 security_ftr_enabled(SEC_FTR_L1D_FLUSH_PR);
 
 	setup_rfi_flush(types, enable);
-	setup_barrier_nospec();
 }
 
 static void __init pSeries_setup_arch(void)



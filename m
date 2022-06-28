Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7004455CACD
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 14:59:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244632AbiF1C3j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 22:29:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243042AbiF1C1L (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 22:27:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B23524F0C;
        Mon, 27 Jun 2022 19:24:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DD578617A6;
        Tue, 28 Jun 2022 02:24:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 166C7C341CC;
        Tue, 28 Jun 2022 02:24:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656383079;
        bh=TFlHdgNdgdIB6wbPqInLVg9UzcNtIiE8X/fdYpv3fmA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EffcpxaM5tQc8s4K8Ep4g5WsBP+OLA93iC2ISHGZrcrTMYPzNX3uWQeX61gkn+1g0
         suVKInzdCXsI16bu0oKTD+M6nEPvc9pG6A87H3hE/EWDaZRzeLJ3rxiUq7uFuG72yw
         Ms3zAalA78NQzG3v3UDkkgLf+I8jNfiSdKj2MkGO/d4XmAInYxVFKojw+gN3Snv4dR
         T97vm8QkZLs/MlVogQFxC37kq+EMHPag4rGwHyH1v2TYSMVZSUhlGcD+yCxbbMBec3
         eIk1PjJPFgZHRIjUIAKjruSdiGoiFmfnuCKyqH2+MxipJgmW6anMs149uFTbdcb3iG
         bfYzDVyuqS/cA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christophe Leroy <christophe.leroy@csgroup.eu>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, aneesh.kumar@linux.ibm.com,
        rafael.j.wysocki@intel.com, jlu.hpw@foxmail.com,
        Julia.Lawall@inria.fr, nick.child@ibm.com, adobriyan@gmail.com,
        linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 5.4 10/27] powerpc/prom_init: Fix build failure with GCC_PLUGIN_STRUCTLEAK_BYREF_ALL and KASAN
Date:   Mon, 27 Jun 2022 22:23:56 -0400
Message-Id: <20220628022413.596341-10-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220628022413.596341-1-sashal@kernel.org>
References: <20220628022413.596341-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Leroy <christophe.leroy@csgroup.eu>

[ Upstream commit ca5dabcff1df6bc8c413922b5fa63cc602858803 ]

When CONFIG_KASAN is selected, we expect prom_init to use __memset()
because it is too early to use memset().

But with CONFIG_GCC_PLUGIN_STRUCTLEAK_BYREF_ALL, the compiler adds calls
to memset() to clear objects on stack, hence the following failure:

	  PROMCHK arch/powerpc/kernel/prom_init_check
	Error: External symbol 'memset' referenced from prom_init.c
	make[2]: *** [arch/powerpc/kernel/Makefile:204 : arch/powerpc/kernel/prom_init_check] Erreur 1

prom_find_machine_type() is called from prom_init() and is called only
once, so lets put compat[] in BSS instead of stack to avoid that.

Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/3802811f7cf94f730be44688539c01bba3a3b5c0.1654875808.git.christophe.leroy@csgroup.eu
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/prom_init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/kernel/prom_init.c b/arch/powerpc/kernel/prom_init.c
index 7f4e2c031a9a..0391b3225970 100644
--- a/arch/powerpc/kernel/prom_init.c
+++ b/arch/powerpc/kernel/prom_init.c
@@ -2237,7 +2237,7 @@ static void __init prom_init_stdout(void)
 
 static int __init prom_find_machine_type(void)
 {
-	char compat[256];
+	static char compat[256] __prombss;
 	int len, i = 0;
 #ifdef CONFIG_PPC64
 	phandle rtas;
-- 
2.35.1


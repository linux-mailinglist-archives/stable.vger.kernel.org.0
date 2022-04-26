Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A3C2510866
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 21:05:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353828AbiDZTF4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 15:05:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353774AbiDZTFk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 15:05:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D9D61999E6;
        Tue, 26 Apr 2022 12:02:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 36C3B6199A;
        Tue, 26 Apr 2022 19:02:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75078C385B0;
        Tue, 26 Apr 2022 19:02:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650999748;
        bh=+Rmjm5j+NVCX092c+nELx71iEIRBfHPkU0zB4Hx6TB8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KWAyOTy/S9i6LkNMyyS1a24WIB1omL8tm73edyXQVEC1jEekeNIT3rzk57gzhXLtl
         Mu43jnBN8dWyo+rxsVTFMHGVYs8ahrgp3YGGTJeXtKtvO/WvDeWKCrCQddBTZfLLFr
         C11h9rtUcdjOD+YjmN6OFkTVrct/08sFn3rKOQ9ib7eG38zw4VU4YGyj9abcPkvO9z
         jYKZ4v/k8epbG1D+a8DkAUlbisUKwadLTO1urhfnN4RxrbnJ2x1nl/qk7OFZVfDTEK
         l9z0emhfJX5kg93h+JBLojK8C9xxgDwXim8wvEi0W3BTXBqzHwdrTopaKleah7hym+
         aMfGUhjFuoz2g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexey Kardashevskiy <aik@ozlabs.ru>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, nathan@kernel.org,
        ndesaulniers@google.com, christophe.leroy@csgroup.eu,
        msuchanek@suse.de, linuxppc-dev@lists.ozlabs.org,
        llvm@lists.linux.dev
Subject: [PATCH AUTOSEL 5.15 12/15] powerpc/perf: Fix 32bit compile
Date:   Tue, 26 Apr 2022 15:02:11 -0400
Message-Id: <20220426190216.2351413-12-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220426190216.2351413-1-sashal@kernel.org>
References: <20220426190216.2351413-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexey Kardashevskiy <aik@ozlabs.ru>

[ Upstream commit bb82c574691daf8f7fa9a160264d15c5804cb769 ]

The "read_bhrb" global symbol is only called under CONFIG_PPC64 of
arch/powerpc/perf/core-book3s.c but it is compiled for both 32 and 64 bit
anyway (and LLVM fails to link this on 32bit).

This fixes it by moving bhrb.o to obj64 targets.

Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20220421025756.571995-1-aik@ozlabs.ru
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/perf/Makefile | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/perf/Makefile b/arch/powerpc/perf/Makefile
index 2f46e31c7612..4f53d0b97539 100644
--- a/arch/powerpc/perf/Makefile
+++ b/arch/powerpc/perf/Makefile
@@ -3,11 +3,11 @@
 obj-y				+= callchain.o callchain_$(BITS).o perf_regs.o
 obj-$(CONFIG_COMPAT)		+= callchain_32.o
 
-obj-$(CONFIG_PPC_PERF_CTRS)	+= core-book3s.o bhrb.o
+obj-$(CONFIG_PPC_PERF_CTRS)	+= core-book3s.o
 obj64-$(CONFIG_PPC_PERF_CTRS)	+= ppc970-pmu.o power5-pmu.o \
 				   power5+-pmu.o power6-pmu.o power7-pmu.o \
 				   isa207-common.o power8-pmu.o power9-pmu.o \
-				   generic-compat-pmu.o power10-pmu.o
+				   generic-compat-pmu.o power10-pmu.o bhrb.o
 obj32-$(CONFIG_PPC_PERF_CTRS)	+= mpc7450-pmu.o
 
 obj-$(CONFIG_PPC_POWERNV)	+= imc-pmu.o
-- 
2.35.1


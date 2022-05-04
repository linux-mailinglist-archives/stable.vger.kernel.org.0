Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 126F651A75C
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:00:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354511AbiEDRCu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:02:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355515AbiEDRAI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:00:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8B054B848;
        Wed,  4 May 2022 09:51:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7DDD7B827A7;
        Wed,  4 May 2022 16:51:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03A95C385A5;
        Wed,  4 May 2022 16:51:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651683101;
        bh=ebOr44XK2DxN/BZFmPjSWlHCRGwu+FBZ8dwVpzqybFw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JPOjGob0Sm6XccGlWjkA8j3ZyM8MLn9luBtVVJyguJMaGJ1SWXBxcvUqQFSHkrF7f
         AT+HA7haI4Gn0W9VL4OJk1FhQFewLnsfcH3cv6/WzQDdzj3nh12AObFCzOA8r9N6OO
         2C4PDmuEUOob2+SzC1ziBWa4K1OlkEPQmfL3T7RI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexey Kardashevskiy <aik@ozlabs.ru>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 105/129] powerpc/perf: Fix 32bit compile
Date:   Wed,  4 May 2022 18:44:57 +0200
Message-Id: <20220504153029.323810206@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504153021.299025455@linuxfoundation.org>
References: <20220504153021.299025455@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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
 arch/powerpc/perf/Makefile |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/powerpc/perf/Makefile
+++ b/arch/powerpc/perf/Makefile
@@ -5,11 +5,11 @@ ifdef CONFIG_COMPAT
 obj-$(CONFIG_PERF_EVENTS)	+= callchain_32.o
 endif
 
-obj-$(CONFIG_PPC_PERF_CTRS)	+= core-book3s.o bhrb.o
+obj-$(CONFIG_PPC_PERF_CTRS)	+= core-book3s.o
 obj64-$(CONFIG_PPC_PERF_CTRS)	+= ppc970-pmu.o power5-pmu.o \
 				   power5+-pmu.o power6-pmu.o power7-pmu.o \
 				   isa207-common.o power8-pmu.o power9-pmu.o \
-				   generic-compat-pmu.o power10-pmu.o
+				   generic-compat-pmu.o power10-pmu.o bhrb.o
 obj32-$(CONFIG_PPC_PERF_CTRS)	+= mpc7450-pmu.o
 
 obj-$(CONFIG_PPC_POWERNV)	+= imc-pmu.o



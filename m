Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E759F51AA31
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:19:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356210AbiEDRWO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:22:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357366AbiEDRPA (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:15:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17C4454BD5;
        Wed,  4 May 2022 09:58:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D95D0616AC;
        Wed,  4 May 2022 16:58:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D820C385B3;
        Wed,  4 May 2022 16:58:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651683510;
        bh=+Rmjm5j+NVCX092c+nELx71iEIRBfHPkU0zB4Hx6TB8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IOYUAmhyUN3mB5VpWa0y0n8nj6u5k3NmLvZuPM3he2YoSRY7rwHrPK4OcR6kUAKwp
         0wfLhcAJS8yr0VVcQqRgWgr3O1KNcbT0zg+/uQP8FI90FqEDuW+lw49f5QMGXsK7jc
         07ISTyQTOmjxKBPqV8qITfEBXmnryoTcVOmRqgw0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexey Kardashevskiy <aik@ozlabs.ru>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 173/225] powerpc/perf: Fix 32bit compile
Date:   Wed,  4 May 2022 18:46:51 +0200
Message-Id: <20220504153125.711968616@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504153110.096069935@linuxfoundation.org>
References: <20220504153110.096069935@linuxfoundation.org>
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




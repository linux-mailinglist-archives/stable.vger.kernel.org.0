Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFC202B9E99
	for <lists+stable@lfdr.de>; Fri, 20 Nov 2020 00:45:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726308AbgKSXmN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Nov 2020 18:42:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726145AbgKSXmN (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Nov 2020 18:42:13 -0500
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFE1EC0613CF
        for <stable@vger.kernel.org>; Thu, 19 Nov 2020 15:42:11 -0800 (PST)
Received: by mail-pf1-x442.google.com with SMTP id t8so6046009pfg.8
        for <stable@vger.kernel.org>; Thu, 19 Nov 2020 15:42:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=axtens.net; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QJ3Aia59xJf/ZoVvP47M+grhiGAAkBJK03tORmiH65s=;
        b=WsSPMA1PkObVadqBaAU+1HFbja3AnJPpNAD7nhnaSs0bLxuyWJHpvLfwK6rg9giQvp
         shLZWtaG99oix8kFVdjIkGFAsOGny4VmG+QS/1x+2EBuSt30XTJhbbFWdtHQUJVeK4vM
         3QhO3ZvSAHMDGgU4dexRjAODhkifnZUPGNG0Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QJ3Aia59xJf/ZoVvP47M+grhiGAAkBJK03tORmiH65s=;
        b=d1rvl7zc7ezOBnxSFgI/H5lrSyL3lQINnQXeKiseWEpkwF8gfRCeu55T1xKKSLK02U
         I0RR44m4GlawqGGfQj2/uU1Vq38ThlqFnZcF8/xTfSLQwPF2qmHc46TFXEXcAjBlne+u
         i6/jl+1z4F/r3ymS+hus/IbG8DPAEexsMqFbrorpzLits8WQaUn2f6LcQFpmECPP5Q3v
         Cwkccog9twgXfEfCZ64pFWr222pK+wTmraB1N6C/GTEdZfpCoJ7wPxirUzarDqNmdg2M
         oy+JwebZVwGcZUvYVthr2aCrgPadLmsoiHojdGS99jcT35aPhEXWp4z4FoNZV/G/R9jX
         GDvg==
X-Gm-Message-State: AOAM532uReyO1cA7Itfgm/DtJ7JSYlV3IMfO89nj/BJtaPuE/WhbdK8F
        MB3NDJZG1aFSwfFswbEYY7c26SNeUuAZzA==
X-Google-Smtp-Source: ABdhPJy52A2e6TCTSvn7Ecm50Xuc9zbYEREZPl1fHYTyaBEE9sWPjuDP4p3ccQZscld5VuGa5plofQ==
X-Received: by 2002:a62:62c7:0:b029:18b:c7ae:934a with SMTP id w190-20020a6262c70000b029018bc7ae934amr11084138pfb.18.1605829331209;
        Thu, 19 Nov 2020 15:42:11 -0800 (PST)
Received: from localhost (2001-44b8-1113-6700-4d44-522c-3789-8f33.static.ipv6.internode.on.net. [2001:44b8:1113:6700:4d44:522c:3789:8f33])
        by smtp.gmail.com with ESMTPSA id u24sm1102993pfm.51.2020.11.19.15.42.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2020 15:42:10 -0800 (PST)
From:   Daniel Axtens <dja@axtens.net>
To:     stable@vger.kernel.org
Cc:     dja@axtens.net
Subject: [PATCH 4.19 1/7] powerpc/64s: move some exception handlers out of line
Date:   Fri, 20 Nov 2020 10:41:57 +1100
Message-Id: <20201119234203.370400-2-dja@axtens.net>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201119234203.370400-1-dja@axtens.net>
References: <20201119234203.370400-1-dja@axtens.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

(backport only)

We're about to grow the exception handlers, which will make a bunch of them
no longer fit within the space available. We move them out of line.

This is a fiddly and error-prone business, so in the interests of reviewability
I haven't merged this in with the addition of the entry flush.

Signed-off-by: Daniel Axtens <dja@axtens.net>
---
 arch/powerpc/kernel/exceptions-64s.S | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/kernel/exceptions-64s.S b/arch/powerpc/kernel/exceptions-64s.S
index e1dab9b1e447..fcf459694ccb 100644
--- a/arch/powerpc/kernel/exceptions-64s.S
+++ b/arch/powerpc/kernel/exceptions-64s.S
@@ -572,13 +572,16 @@ ALT_MMU_FTR_SECTION_END_IFCLR(MMU_FTR_TYPE_RADIX)
 EXC_REAL_BEGIN(data_access_slb, 0x380, 0x80)
 	SET_SCRATCH0(r13)
 	EXCEPTION_PROLOG_0(PACA_EXSLB)
+	b tramp_data_access_slb
+EXC_REAL_END(data_access_slb, 0x380, 0x80)
+
+TRAMP_REAL_BEGIN(tramp_data_access_slb)
 	EXCEPTION_PROLOG_1(PACA_EXSLB, KVMTEST_PR, 0x380)
 	mr	r12,r3	/* save r3 */
 	mfspr	r3,SPRN_DAR
 	mfspr	r11,SPRN_SRR1
 	crset	4*cr6+eq
 	BRANCH_TO_COMMON(r10, slb_miss_common)
-EXC_REAL_END(data_access_slb, 0x380, 0x80)
 
 EXC_VIRT_BEGIN(data_access_slb, 0x4380, 0x80)
 	SET_SCRATCH0(r13)
@@ -616,13 +619,16 @@ ALT_MMU_FTR_SECTION_END_IFCLR(MMU_FTR_TYPE_RADIX)
 EXC_REAL_BEGIN(instruction_access_slb, 0x480, 0x80)
 	SET_SCRATCH0(r13)
 	EXCEPTION_PROLOG_0(PACA_EXSLB)
+	b tramp_instruction_access_slb
+EXC_REAL_END(instruction_access_slb, 0x480, 0x80)
+
+TRAMP_REAL_BEGIN(tramp_instruction_access_slb)
 	EXCEPTION_PROLOG_1(PACA_EXSLB, KVMTEST_PR, 0x480)
 	mr	r12,r3	/* save r3 */
 	mfspr	r3,SPRN_SRR0		/* SRR0 is faulting address */
 	mfspr	r11,SPRN_SRR1
 	crclr	4*cr6+eq
 	BRANCH_TO_COMMON(r10, slb_miss_common)
-EXC_REAL_END(instruction_access_slb, 0x480, 0x80)
 
 EXC_VIRT_BEGIN(instruction_access_slb, 0x4480, 0x80)
 	SET_SCRATCH0(r13)
-- 
2.25.1


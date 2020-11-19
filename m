Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB62A2B9EB2
	for <lists+stable@lfdr.de>; Fri, 20 Nov 2020 00:54:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726596AbgKSXw6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Nov 2020 18:52:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726475AbgKSXw6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Nov 2020 18:52:58 -0500
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4FA6C0613CF
        for <stable@vger.kernel.org>; Thu, 19 Nov 2020 15:52:56 -0800 (PST)
Received: by mail-pf1-x443.google.com with SMTP id v5so2035402pff.10
        for <stable@vger.kernel.org>; Thu, 19 Nov 2020 15:52:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=axtens.net; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pdhLUyohS0zMy0vBj/fBbhk4U7dt29WT+P9oPT1wuI4=;
        b=k/eOrEy5ttu0B61KqMRTVhjgtkLOb2MojQEjfTNXBCLZ+SmXT4AJd9x7IEJQpmLjpJ
         HyN/wkH9afbDEN46CAsQv+zDswmrjjYKUyJ1IRT1PV/0x3VjfwlAkDvK1gpBuhjYDD0f
         2mPcADteey+AnnJouRFkeFG3ewxRSTp4okMNM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pdhLUyohS0zMy0vBj/fBbhk4U7dt29WT+P9oPT1wuI4=;
        b=FvODAWDel8uZLF7gCIyR2oeldBgf3oz13wavijWAit8hv4mp7XxxvWzLIjiJkPRPyQ
         60ZKNrWCjdpeKs5zWYvGLeqYpEk3KWvdfr2mMLe31albxdwLuT9uRNFLhyUorAYoDKjd
         cGzQ9j5KdoC4qlfAwmN5vsKWgkMlzNBCMGFA/4ii8KZaebbp93AcLXp6qffZ2hLFVRJE
         HK6AKwPFJFDqIXzTDy/KSlbogwq0wtsBOGrFqwcx9RnZ1+4c9edZLYvV/PYo52DvDA4u
         YYtcdOL6uHu3KAP+886n7KAIc30KbVV8pC6rQqPI7N8IphVMu1ZJsfsZ8ebEec8eKJSN
         u5aA==
X-Gm-Message-State: AOAM532BHMGiVPAMJl43tdGUlSm8flDBseSt5oGkCyLhfujYULed4Dm8
        TixNNHf6HbEYFOK/Ze/TvCPWrYioJyWtjQ==
X-Google-Smtp-Source: ABdhPJzMvGRrwAKU9qlcFkrHnhohpAQZA0qzA9OLuXU6SNfihLmqTJsly0MIBoq8yvyoJjrdX/EDJw==
X-Received: by 2002:a63:5963:: with SMTP id j35mr14185109pgm.55.1605829976377;
        Thu, 19 Nov 2020 15:52:56 -0800 (PST)
Received: from localhost (2001-44b8-1113-6700-4d44-522c-3789-8f33.static.ipv6.internode.on.net. [2001:44b8:1113:6700:4d44:522c:3789:8f33])
        by smtp.gmail.com with ESMTPSA id d22sm967585pjw.11.2020.11.19.15.52.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2020 15:52:55 -0800 (PST)
From:   Daniel Axtens <dja@axtens.net>
To:     stable@vger.kernel.org
Cc:     dja@axtens.net
Subject: [PATCH 4.14 2/8] powerpc/64s: move some exception handlers out of line
Date:   Fri, 20 Nov 2020 10:52:38 +1100
Message-Id: <20201119235244.373127-3-dja@axtens.net>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201119235244.373127-1-dja@axtens.net>
References: <20201119235244.373127-1-dja@axtens.net>
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
index cdc53fd90597..f619e0deb23b 100644
--- a/arch/powerpc/kernel/exceptions-64s.S
+++ b/arch/powerpc/kernel/exceptions-64s.S
@@ -516,13 +516,16 @@ ALT_MMU_FTR_SECTION_END_IFCLR(MMU_FTR_TYPE_RADIX)
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
@@ -560,13 +563,16 @@ ALT_MMU_FTR_SECTION_END_IFCLR(MMU_FTR_TYPE_RADIX)
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


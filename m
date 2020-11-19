Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E356A2B9EED
	for <lists+stable@lfdr.de>; Fri, 20 Nov 2020 00:59:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727449AbgKSX5z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Nov 2020 18:57:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727445AbgKSX5y (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Nov 2020 18:57:54 -0500
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A04A8C0613CF
        for <stable@vger.kernel.org>; Thu, 19 Nov 2020 15:57:54 -0800 (PST)
Received: by mail-pf1-x442.google.com with SMTP id q5so6092957pfk.6
        for <stable@vger.kernel.org>; Thu, 19 Nov 2020 15:57:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=axtens.net; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=75toVZcA9L7uDYYUsxmGPlkvl5U1hsC84fvTX8Y2fv0=;
        b=gVD04LoTy9markBkOSgtO6HXxyT12uvmTpKzLGgKysGuSxAX7vuJ41o98fICOZfABW
         u1663gw4y23fqHN5sy8oQUqat/BoFF3/IGA//eQm8ab/MtXRpNrwwXIHAUM8v9Wcuk2g
         CJXuyVxItr4pMI4g7iJ3uvK7wPMcWyWr5lz3E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=75toVZcA9L7uDYYUsxmGPlkvl5U1hsC84fvTX8Y2fv0=;
        b=Ql82QUNQTaY7tQn1Y49B9Nw8lJaIvFqWUYQMYZkfa4uaTTUbU4URyEtOditi8yJr9l
         S5nBIonprqajakEUZ4/kb5iq+R4kzbWahCx5jI/gMgZKZb54XCJMyDPeqN+NXsnh6/Gx
         BTfcQPjkK+kLM8BazwAoklOmDC4tnrNzyaK+oRleeYLeoi7fLgmnG6Qk1nPVY17TfgLu
         5pIfvo00K4wC7Pjp66HW3quZf7agRaY9C7x6QkR5Kn5VYzo/4QU/i4tUyu1ManRFUCFs
         4NAeqZ+xJTA5JQe/5GHgL75fVTvm9mvajPanlsNFHllC3rZm2T35rMBuNXOzYxdwjUSN
         hNWw==
X-Gm-Message-State: AOAM533GLPpYHvAPsRizJQFyY4GA+y8mtiteAriApcEe8GV/X3L3XhGQ
        00Pt3kXmI1iab0FGNf7zZveTkutt56KMgQ==
X-Google-Smtp-Source: ABdhPJylFsk+aRWXdMrZqv4I+58YvKyhL03Kx4s22SW6XaM5SPMTLDJ/OgJZ6eGaXiCJHRKWiO3h6A==
X-Received: by 2002:a17:90a:7341:: with SMTP id j1mr6859664pjs.78.1605830274106;
        Thu, 19 Nov 2020 15:57:54 -0800 (PST)
Received: from localhost (2001-44b8-1113-6700-4d44-522c-3789-8f33.static.ipv6.internode.on.net. [2001:44b8:1113:6700:4d44:522c:3789:8f33])
        by smtp.gmail.com with ESMTPSA id 194sm1107038pfz.142.2020.11.19.15.57.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2020 15:57:53 -0800 (PST)
From:   Daniel Axtens <dja@axtens.net>
To:     stable@vger.kernel.org
Cc:     dja@axtens.net
Subject: [PATCH 4.9 2/8] powerpc/64s: move some exception handlers out of line
Date:   Fri, 20 Nov 2020 10:57:37 +1100
Message-Id: <20201119235743.373635-3-dja@axtens.net>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201119235743.373635-1-dja@axtens.net>
References: <20201119235743.373635-1-dja@axtens.net>
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
index 0c8b966e8070..05c1f0c90316 100644
--- a/arch/powerpc/kernel/exceptions-64s.S
+++ b/arch/powerpc/kernel/exceptions-64s.S
@@ -519,6 +519,10 @@ ALT_MMU_FTR_SECTION_END_IFCLR(MMU_FTR_TYPE_RADIX)
 EXC_REAL_BEGIN(data_access_slb, 0x380, 0x400)
 	SET_SCRATCH0(r13)
 	EXCEPTION_PROLOG_0(PACA_EXSLB)
+	b tramp_data_access_slb
+EXC_REAL_END(data_access_slb, 0x380, 0x400)
+
+TRAMP_REAL_BEGIN(tramp_data_access_slb)
 	EXCEPTION_PROLOG_1(PACA_EXSLB, KVMTEST_PR, 0x380)
 	std	r3,PACA_EXSLB+EX_R3(r13)
 	mfspr	r3,SPRN_DAR
@@ -537,7 +541,6 @@ EXC_REAL_BEGIN(data_access_slb, 0x380, 0x400)
 	mtctr	r10
 	bctr
 #endif
-EXC_REAL_END(data_access_slb, 0x380, 0x400)
 
 EXC_VIRT_BEGIN(data_access_slb, 0x4380, 0x4400)
 	SET_SCRATCH0(r13)
@@ -587,6 +590,10 @@ ALT_MMU_FTR_SECTION_END_IFCLR(MMU_FTR_TYPE_RADIX)
 EXC_REAL_BEGIN(instruction_access_slb, 0x480, 0x500)
 	SET_SCRATCH0(r13)
 	EXCEPTION_PROLOG_0(PACA_EXSLB)
+	b tramp_instruction_access_slb
+EXC_REAL_END(instruction_access_slb, 0x480, 0x500)
+
+TRAMP_REAL_BEGIN(tramp_instruction_access_slb)
 	EXCEPTION_PROLOG_1(PACA_EXSLB, KVMTEST_PR, 0x480)
 	std	r3,PACA_EXSLB+EX_R3(r13)
 	mfspr	r3,SPRN_SRR0		/* SRR0 is faulting address */
@@ -600,7 +607,6 @@ EXC_REAL_BEGIN(instruction_access_slb, 0x480, 0x500)
 	mtctr	r10
 	bctr
 #endif
-EXC_REAL_END(instruction_access_slb, 0x480, 0x500)
 
 EXC_VIRT_BEGIN(instruction_access_slb, 0x4480, 0x4500)
 	SET_SCRATCH0(r13)
-- 
2.25.1


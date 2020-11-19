Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 771E42B9EEC
	for <lists+stable@lfdr.de>; Fri, 20 Nov 2020 00:59:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727442AbgKSX5w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Nov 2020 18:57:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726983AbgKSX5w (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Nov 2020 18:57:52 -0500
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05573C0613CF
        for <stable@vger.kernel.org>; Thu, 19 Nov 2020 15:57:51 -0800 (PST)
Received: by mail-pf1-x442.google.com with SMTP id v12so6069923pfm.13
        for <stable@vger.kernel.org>; Thu, 19 Nov 2020 15:57:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=axtens.net; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DWPnK3G3wyk4doBZnCksL03FSzTrG489vR4nwxLwnEU=;
        b=cGve/OMsf/aiaMovOHPtMo+tcGQuuvtDKPq2LvlkNKhiYfwsfocKbuI0gcTI0fj7ol
         uZqSiu0dnN2fQjRprxvhLWBUxPS7j4Nkorqnj3D0JFbXB54znb9JmZ7O+FZ4knNuSVAg
         x/2LhdiJj6PISETjNAr/QFhmUBPsEInqrmCwo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DWPnK3G3wyk4doBZnCksL03FSzTrG489vR4nwxLwnEU=;
        b=Ce2Nc555pfIbpkr5jUTb35zivyU8GUc0CXNk3QAEs4bQRvymxAzeZYgAcRBCFOiTf7
         fm5NgQc1rFIkEM2e/w9Ztcu4dSHQhqnej5fxWpTARbvgbyYFbY97XaZpCHRRVQmhtt6l
         dnd77ugPiC9oNGOTX/zFrUS8bW3CNJxg1i39h5JGN986FDRS2UMR0VXNaPNPdH1I2cjM
         HkZ59wrxjOGYz6LENmtvPEhSGgYvV6MZlBjWsbvueDXNuTQC4ZWZJlNT/iWAcFWXnjWt
         5asm+H7BozSkM0uSUj+A+9s8eb+hiPEbYG8moyLJJbPE/jjxBTVucGk4xAeLIRlO9Vpc
         rWUg==
X-Gm-Message-State: AOAM530w5mF9CjNYYSIAtldKakQUFSodRJ+nXbmupj/tnuqCkwObdvR2
        v6E9V8jFQ039VNJKJci5DOy8xzfeKJxOeg==
X-Google-Smtp-Source: ABdhPJyBbLiqzxL89cmy82I1yZtisuW3mgqrT7s3FIJcQsg9Seu21u1qgqosYJaRi5amkWH4hmpxAw==
X-Received: by 2002:a62:e519:0:b029:197:bcec:7c0c with SMTP id n25-20020a62e5190000b0290197bcec7c0cmr4203268pff.63.1605830270433;
        Thu, 19 Nov 2020 15:57:50 -0800 (PST)
Received: from localhost (2001-44b8-1113-6700-4d44-522c-3789-8f33.static.ipv6.internode.on.net. [2001:44b8:1113:6700:4d44:522c:3789:8f33])
        by smtp.gmail.com with ESMTPSA id 194sm1106944pfz.142.2020.11.19.15.57.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2020 15:57:50 -0800 (PST)
From:   Daniel Axtens <dja@axtens.net>
To:     stable@vger.kernel.org
Cc:     dja@axtens.net
Subject: [PATCH 4.9 1/8] powerpc/64s: Define MASKABLE_RELON_EXCEPTION_PSERIES_OOL
Date:   Fri, 20 Nov 2020 10:57:36 +1100
Message-Id: <20201119235743.373635-2-dja@axtens.net>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201119235743.373635-1-dja@axtens.net>
References: <20201119235743.373635-1-dja@axtens.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit da2bc4644c75 ("powerpc/64s: Add new exception vector macros")
adds:

+#define __TRAMP_REAL_VIRT_OOL_MASKABLE(name, realvec)          \
+       TRAMP_REAL_BEGIN(tramp_virt_##name);                            \
+       MASKABLE_RELON_EXCEPTION_PSERIES_OOL(realvec, name##_common);   \

However there's no reference there or anywhere else to
MASKABLE_RELON_EXCEPTION_PSERIES_OOL and an attempt to use it
unsurprisingly doesn't work.

Add a definition provided by mpe.

Fixes: da2bc4644c75 ("powerpc/64s: Add new exception vector macros")
Signed-off-by: Daniel Axtens <dja@axtens.net>
---
 arch/powerpc/include/asm/exception-64s.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/powerpc/include/asm/exception-64s.h b/arch/powerpc/include/asm/exception-64s.h
index e2200100828d..9616fe842202 100644
--- a/arch/powerpc/include/asm/exception-64s.h
+++ b/arch/powerpc/include/asm/exception-64s.h
@@ -563,6 +563,10 @@ END_FTR_SECTION_NESTED(ftr,ftr,943)
 	EXCEPTION_PROLOG_1(PACA_EXGEN, SOFTEN_NOTEST_HV, vec);		\
 	EXCEPTION_PROLOG_PSERIES_1(label, EXC_HV)
 
+#define MASKABLE_RELON_EXCEPTION_PSERIES_OOL(vec, label)               \
+       EXCEPTION_PROLOG_1(PACA_EXGEN, SOFTEN_NOTEST_PR, vec);          \
+       EXCEPTION_PROLOG_PSERIES_1(label, EXC_STD)
+
 /*
  * Our exception common code can be passed various "additions"
  * to specify the behaviour of interrupts, whether to kick the
-- 
2.25.1


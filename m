Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E81F2B9EB1
	for <lists+stable@lfdr.de>; Fri, 20 Nov 2020 00:54:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726563AbgKSXwy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Nov 2020 18:52:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726475AbgKSXwy (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Nov 2020 18:52:54 -0500
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B87EC0613CF
        for <stable@vger.kernel.org>; Thu, 19 Nov 2020 15:52:53 -0800 (PST)
Received: by mail-pl1-x643.google.com with SMTP id 5so3868693plj.8
        for <stable@vger.kernel.org>; Thu, 19 Nov 2020 15:52:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=axtens.net; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fd8+abPY3FXnBnlA7/77pqVtnD1+7oKgxfhh0N16GrU=;
        b=HoCMf06tYnEolaltkVBGTqUWoANCb9kbx5nAO/St2g6b9n6znznvOsj3E7MpOAtBks
         M+QJfeI9Pt6HpF68rfrlWfihpdDUm5A5HCF45Qd7GqbHHA1l7Z87j+R5xMqpN3WamAe9
         mDQ4G+1I2q7BlmIGK5OzS936cDxjQbXfkKn70=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fd8+abPY3FXnBnlA7/77pqVtnD1+7oKgxfhh0N16GrU=;
        b=MVoE1Ppmro1XbDSqpZG/8jw2ygcCYmt7jsIBdb7Mog5SC2IRjGp64Lexavh8Fnw7Qp
         9jrGVrz6t3M3dJZwoKB1+bJFGMDnkQ6rl6Q+kVzjD0WpOD+DuZWqrlAlVCOqbi6VUfh+
         LTEgQKvFi2S3u1bYhjBDFiAlC11iL6R1ha6dYAWe5slj3Po/m/Fn5k+qY+JpaNUG4Wzx
         5JO2zh2gO5t7hjG+OggvRcRo8Fc79wqtDB/J5sIWQzmgriEHTx35KcnXqYOp8ZDgqtvG
         893AIXTyzSiMCZ/UFm1aMij80q0ugme+D+KmQyeGevxa8Fj88cg8mdGDYbmdAbxIknxi
         xEqg==
X-Gm-Message-State: AOAM530E8yWuylDy51YvJdZZqD4mp1iZzPYFsug5UzXm/dMpwmgoihHV
        VGGR8mBauK/nr7DrV1td1cYzfcUmukw7jw==
X-Google-Smtp-Source: ABdhPJzXooM/icahlKrm9NAdG0IYcuYcG/Qk6Ds7MmugGnCDhVKQsmcxRP5kv8JZ9pInFjDz4E+uSg==
X-Received: by 2002:a17:902:6943:b029:d6:bd35:c84b with SMTP id k3-20020a1709026943b02900d6bd35c84bmr11151377plt.53.1605829972516;
        Thu, 19 Nov 2020 15:52:52 -0800 (PST)
Received: from localhost (2001-44b8-1113-6700-4d44-522c-3789-8f33.static.ipv6.internode.on.net. [2001:44b8:1113:6700:4d44:522c:3789:8f33])
        by smtp.gmail.com with ESMTPSA id k6sm1110224pfd.169.2020.11.19.15.52.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2020 15:52:52 -0800 (PST)
From:   Daniel Axtens <dja@axtens.net>
To:     stable@vger.kernel.org
Cc:     dja@axtens.net
Subject: [PATCH 4.14 1/8] powerpc/64s: Define MASKABLE_RELON_EXCEPTION_PSERIES_OOL
Date:   Fri, 20 Nov 2020 10:52:37 +1100
Message-Id: <20201119235244.373127-2-dja@axtens.net>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201119235244.373127-1-dja@axtens.net>
References: <20201119235244.373127-1-dja@axtens.net>
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
index c3bdd2d8ec90..a99a455bc267 100644
--- a/arch/powerpc/include/asm/exception-64s.h
+++ b/arch/powerpc/include/asm/exception-64s.h
@@ -645,6 +645,10 @@ END_FTR_SECTION_NESTED(ftr,ftr,943)
 	EXCEPTION_PROLOG_1(PACA_EXGEN, SOFTEN_TEST_HV, vec);		\
 	EXCEPTION_RELON_PROLOG_PSERIES_1(label, EXC_HV)
 
+#define MASKABLE_RELON_EXCEPTION_PSERIES_OOL(vec, label)               \
+       EXCEPTION_PROLOG_1(PACA_EXGEN, SOFTEN_NOTEST_PR, vec);          \
+       EXCEPTION_PROLOG_PSERIES_1(label, EXC_STD)
+
 /*
  * Our exception common code can be passed various "additions"
  * to specify the behaviour of interrupts, whether to kick the
-- 
2.25.1


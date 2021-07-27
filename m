Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98DEC3D7935
	for <lists+stable@lfdr.de>; Tue, 27 Jul 2021 17:00:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231825AbhG0PAd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Jul 2021 11:00:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231552AbhG0PAd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Jul 2021 11:00:33 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13F1FC061757
        for <stable@vger.kernel.org>; Tue, 27 Jul 2021 08:00:33 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id bp1so22263139lfb.3
        for <stable@vger.kernel.org>; Tue, 27 Jul 2021 08:00:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=x9Ijoqsdh13AHKF42vRDqKmRqsGvnMKBQQ/wbCHMhzI=;
        b=tNUKpDA4Ny4n+/1ArvsR/d2Wt1Lwl0CUQ72YQxr7tRYLOFWPYk7bxRvKYujjnRE+2B
         +m5BmOntw8fMsyXivHs7hyEVd70U2GWM+3qVwc9LNjB2SGW06tv/NrURD1z9Ft8ZrX1X
         wVQbxXs3zVUjWLffPgf3wdJefZ7dL29Ii1n3U4BEhNFj4iDxMOXZRgpS3iiX83/L5GiY
         J0FMauPpF4J3qRC+Al2dgweaZnHgBJLvfNz1UOVB3YDtwo0L2YA2AJXzB/R+laecWXEY
         hc31VkKT3F8p8M1x0fhYOqHiH2tEGiiBLsxLy9uxKujQ9T3Qsj5RNY4CnyJX6Xo9BTZt
         sz8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=x9Ijoqsdh13AHKF42vRDqKmRqsGvnMKBQQ/wbCHMhzI=;
        b=MrRh2QEiHdTfOwMFzN9Cpl1ftKVhSdkdnn+TKtknQoIjGotnofP3iuf/kPxWjMbwMT
         mfVBatIHDeutuWsuiD/CbfKoSTl8LLAf4TSHeyVcZw8GMYaUW5Pk5hsDukctejXsxDxm
         s4HJ2kJoNIg9+4eICNrvXrJAW8B5tBsCUAQGwOy8GFwJQ4OuliZyntYwRxne+MaYACN7
         Zm9i5JYc8m7JH1+RLp57Ax7OrnDc/HV5AFnN+HCyOfACutnkF/4kDK9okxgl6zA60ibx
         QaR/jhToclbLtCz688WP7andzysd0WLt84wqCMrc7/exiphmGvJXC5fSt3UtxpgjW8hJ
         HKSQ==
X-Gm-Message-State: AOAM530dr2GSYoIT1h6RiLF0ZmPiNwP6WacpenV5D5ReLCqfwolcvEYY
        XFpDEDE81MIikWDYG3+4uforiUWt8BchmA==
X-Google-Smtp-Source: ABdhPJzCBVpZ9fS8tbRyCaot3YZwaF8r7NJmX3NuDKJzO9aew8gyFRaRIQmNZEMuhKbrvwkNhnkmtw==
X-Received: by 2002:a19:f815:: with SMTP id a21mr17730092lff.507.1627398031345;
        Tue, 27 Jul 2021 08:00:31 -0700 (PDT)
Received: from localhost (c-9b28e555.07-21-73746f28.bbcust.telenor.se. [85.229.40.155])
        by smtp.gmail.com with ESMTPSA id f6sm352088lfr.180.2021.07.27.08.00.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jul 2021 08:00:31 -0700 (PDT)
From:   Anders Roxell <anders.roxell@linaro.org>
To:     stable@vger.kernel.org
Cc:     yhs@fb.com, ast@kernel.org, gregkh@linuxfoundation.org,
        sashal@kernel.org
Subject: [PATCH] tools: Allow proper CC/CXX/... override with LLVM=1 in Makefile.include
Date:   Tue, 27 Jul 2021 17:00:27 +0200
Message-Id: <20210727150027.3710100-1-anders.roxell@linaro.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yonghong Song <yhs@fb.com>

[ Upstream commit f62700ce63a315b4607cc9e97aa15ea409a677b9 ]

selftests/bpf/Makefile includes tools/scripts/Makefile.include.
With the following command
  make -j60 LLVM=1 LLVM_IAS=1  <=== compile kernel
  make -j60 -C tools/testing/selftests/bpf LLVM=1 LLVM_IAS=1 V=1
some files are still compiled with gcc. This patch
fixed the case if CC/AR/LD/CXX/STRIP is allowed to be
overridden, it will be written to clang/llvm-ar/..., instead of
gcc binaries. The definition of CC_NO_CLANG is also relocated
to the place after the above CC is defined.

Cc: <stable@vger.kernel.org> # v5.4 v5.10
Signed-off-by: Yonghong Song <yhs@fb.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/bpf/20210413153419.3028165-1-yhs@fb.com
---
 tools/scripts/Makefile.include | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/tools/scripts/Makefile.include b/tools/scripts/Makefile.include
index a402f32a145c..91130648d8e6 100644
--- a/tools/scripts/Makefile.include
+++ b/tools/scripts/Makefile.include
@@ -39,8 +39,6 @@ EXTRA_WARNINGS += -Wundef
 EXTRA_WARNINGS += -Wwrite-strings
 EXTRA_WARNINGS += -Wformat
 
-CC_NO_CLANG := $(shell $(CC) -dM -E -x c /dev/null | grep -Fq "__clang__"; echo $$?)
-
 # Makefiles suck: This macro sets a default value of $(2) for the
 # variable named by $(1), unless the variable has been set by
 # environment or command line. This is necessary for CC and AR
@@ -52,12 +50,22 @@ define allow-override
     $(eval $(1) = $(2)))
 endef
 
+ifneq ($(LLVM),)
+$(call allow-override,CC,clang)
+$(call allow-override,AR,llvm-ar)
+$(call allow-override,LD,ld.lld)
+$(call allow-override,CXX,clang++)
+$(call allow-override,STRIP,llvm-strip)
+else
 # Allow setting various cross-compile vars or setting CROSS_COMPILE as a prefix.
 $(call allow-override,CC,$(CROSS_COMPILE)gcc)
 $(call allow-override,AR,$(CROSS_COMPILE)ar)
 $(call allow-override,LD,$(CROSS_COMPILE)ld)
 $(call allow-override,CXX,$(CROSS_COMPILE)g++)
 $(call allow-override,STRIP,$(CROSS_COMPILE)strip)
+endif
+
+CC_NO_CLANG := $(shell $(CC) -dM -E -x c /dev/null | grep -Fq "__clang__"; echo $$?)
 
 ifneq ($(LLVM),)
 HOSTAR  ?= llvm-ar
-- 
2.30.2


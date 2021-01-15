Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8ABC2F7C28
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 14:11:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732964AbhAONKJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 08:10:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732437AbhAONKI (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Jan 2021 08:10:08 -0500
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A069C061793
        for <stable@vger.kernel.org>; Fri, 15 Jan 2021 05:09:27 -0800 (PST)
Received: by mail-lf1-x129.google.com with SMTP id u25so13056728lfc.2
        for <stable@vger.kernel.org>; Fri, 15 Jan 2021 05:09:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=H77013el4oj537KcWbHAa6KZVwXfxWSrY6uuE6Q0sc4=;
        b=q9Ztcgsg9ICz4CPGi3AqBhJCCqaJbGEsok4o83u+3cAvltOWTKPufA+zeM/V62Iwkk
         yTiRg2yJPFZ9i81ri9+DmcbXtA6s2ZQpW9iXVEiSowSmETLz8pOMMsXmWBsqOjzEy7Yl
         2I5jdF6KJv3XnTVtXFowFQXXpYmcjQcsqBgnWnDu5qPovVSoGNqzas3T51ES79XsGY3t
         tr4OJSVbMhjKxxFVPEpS6AjNruNqaTRvHOtgQ/QsVs0bl6BkOseOZzFI4Xn0uPERH8Xq
         nO6GR1ysXN9yl5DSKd5FAVlgeOKH6oDsZWAqCKKOnc0N4oL2r/6eDlC9B30LOApr+pm1
         u0Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=H77013el4oj537KcWbHAa6KZVwXfxWSrY6uuE6Q0sc4=;
        b=D+42MsaF7v96WuojI0gXXEfxldZILJ7hLUe0KsP+F+WDKOsWgMSCjxkuljoR2uSDIL
         gLPgnZ2eaXNG8OT1MP48FFTfO6wb6pp/gVseqi7rdLtma7onCQQPsG/VJ7gq6xjrivCl
         JWHEZ1Woh9mMRFnYg4BBbfGRaWdcMWyqfc4SmAK1+Ddhrjuo5hWHtF0Hp1tLkMS3WdL7
         Y2C9AILUa/HtR9b7SD3W1IBRhil8AShzeqmdawFhEUUwI+weD68Ql6mTfFBCth/0p3gS
         xr6Dg5idpSrrtgsWneQFRbzdiKbNyRKcvLYBWq6/7Wihg8Gq1eulzimkV3UMjI54V8aA
         /zjA==
X-Gm-Message-State: AOAM530S9oqoStiTUOJy5mjys5Pv4cetvsEyf1EPe3bQex7nJiUS4fRy
        Mz0PrsEh6+cqzyK+99adtei2xZs+JIsvJ5NF
X-Google-Smtp-Source: ABdhPJyG2oDWX/iHDn0EzcUpg9Y7uXUM0ZxWDSMRL8PRfQVX5L9HOjTP5ybHpNEYfyI+wZZH57VpwA==
X-Received: by 2002:a19:8c18:: with SMTP id o24mr5567101lfd.121.1610716165947;
        Fri, 15 Jan 2021 05:09:25 -0800 (PST)
Received: from localhost (c-9b28e555.07-21-73746f28.bbcust.telenor.se. [85.229.40.155])
        by smtp.gmail.com with ESMTPSA id 25sm897153lfr.74.2021.01.15.05.09.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jan 2021 05:09:25 -0800 (PST)
From:   Anders Roxell <anders.roxell@linaro.org>
To:     stable@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Anders Roxell <anders.roxell@linaro.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH] mips: fix Section mismatch in reference
Date:   Fri, 15 Jan 2021 14:09:05 +0100
Message-Id: <20210115130906.1084281-1-anders.roxell@linaro.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit ad4fddef5f2345aa9214e979febe2f47639c10d9 upstream.

When building mips tinyconfig with clang the following error show up:

WARNING: modpost: vmlinux.o(.text+0x1940c): Section mismatch in reference from the function r4k_cache_init() to the function .init.text:loongson3_sc_init()
The function r4k_cache_init() references
the function __init loongson3_sc_init().
This is often because r4k_cache_init lacks a __init
annotation or the annotation of loongson3_sc_init is wrong.

Remove marked __init from function loongson3_sc_init(),
mips_sc_probe_cm3(), and mips_sc_probe().

Cc: <stable@vger.kernel.org> # v5.4+
Signed-off-by: Anders Roxell <anders.roxell@linaro.org>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
---
 arch/mips/mm/c-r4k.c   | 2 +-
 arch/mips/mm/sc-mips.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/mips/mm/c-r4k.c b/arch/mips/mm/c-r4k.c
index 9cede7ce37e6..c9644c38ec28 100644
--- a/arch/mips/mm/c-r4k.c
+++ b/arch/mips/mm/c-r4k.c
@@ -1609,7 +1609,7 @@ static void __init loongson2_sc_init(void)
 	c->options |= MIPS_CPU_INCLUSIVE_CACHES;
 }
 
-static void __init loongson3_sc_init(void)
+static void loongson3_sc_init(void)
 {
 	struct cpuinfo_mips *c = &current_cpu_data;
 	unsigned int config2, lsize;
diff --git a/arch/mips/mm/sc-mips.c b/arch/mips/mm/sc-mips.c
index dd0a5becaabd..06ec304ad4d1 100644
--- a/arch/mips/mm/sc-mips.c
+++ b/arch/mips/mm/sc-mips.c
@@ -146,7 +146,7 @@ static inline int mips_sc_is_activated(struct cpuinfo_mips *c)
 	return 1;
 }
 
-static int __init mips_sc_probe_cm3(void)
+static int mips_sc_probe_cm3(void)
 {
 	struct cpuinfo_mips *c = &current_cpu_data;
 	unsigned long cfg = read_gcr_l2_config();
@@ -180,7 +180,7 @@ static int __init mips_sc_probe_cm3(void)
 	return 0;
 }
 
-static inline int __init mips_sc_probe(void)
+static inline int mips_sc_probe(void)
 {
 	struct cpuinfo_mips *c = &current_cpu_data;
 	unsigned int config1, config2;
-- 
2.29.2


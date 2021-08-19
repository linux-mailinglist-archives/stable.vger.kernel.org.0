Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 471143F1860
	for <lists+stable@lfdr.de>; Thu, 19 Aug 2021 13:40:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239094AbhHSLks (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Aug 2021 07:40:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238210AbhHSLkr (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Aug 2021 07:40:47 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDFA4C061575;
        Thu, 19 Aug 2021 04:40:10 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id c129-20020a1c35870000b02902e6b6135279so3885716wma.0;
        Thu, 19 Aug 2021 04:40:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FO+lf3R/yjc9KGpGIWIOuNRXRBvu2rIu+mbHK5sUlLs=;
        b=HiAgE7KdhsVN8wOgbXI3aTxGbM4SVbP3/MgUGYmbRYOdUN7j0IBITf8DJuDd/WRSX3
         ei1oOKPqzbpQ7J/ea0n10NGQjVvlhR2zrW2BgHJ0Ieyjr5Px0iSYYk0XuhI2e7+tllF7
         Z2FMFvN+4TgFjiMaUz7MoDfyVewMke+UZbFfKowCo+ZJwT7dxlpjQVelv5cErUbTj6B2
         Wq6qiCdNCmGHyAp/6TK5kaPGW4xJ3WEsHJGyfrPyjdciizc0eAVOWM4gkI92O/ny2YaF
         0/4kINHGepsUB1QFUelgu3kOdStUdTDeGahulKWYB91bt85Zd9uCwYSkcVNtwtOU9pxD
         IefA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FO+lf3R/yjc9KGpGIWIOuNRXRBvu2rIu+mbHK5sUlLs=;
        b=oB8IPxuCowMaMjclYl+7An0E3An9mj0zcpvi2rZH643bq11BCSa0Z1EW5EeubphA4N
         sCGTdTDD4+UGZCuG5HgSb4KOZhR+jn9ye3OojIVOPMBspRVmfATomZ0Q0+YVG9cUFWlN
         ZsCCQmDTa6+D33Q87k2o69lxrUz4E6WsO1xQQ161bFOMRQTrAIa6SNY5gvn+WJjgiL/t
         LRrejHE92mSuR5yVkJgOUWMkVUdG7AQxwwSZwspnedXrSn/FYFTmxbpEavVJvUkHFT6/
         gEkzm8iQIpO2eS1s9r5qkUtbpXFTYbgz16WAKHXghKhjTnn9LJCvREj+2JHBygo2JUDM
         fi+w==
X-Gm-Message-State: AOAM530rI/RZ5KT3fGCWkuR0ZNVKZhhe+yhqSk/zNhkS+KEfoKUcsWe+
        4zs0XRW6geHeJFICmQzQIqI=
X-Google-Smtp-Source: ABdhPJyxKopaR6HtUR6X5E06d0TM/76Uxg1B0Ih/1vlvj9BWdq72+EoGJs3R1ghyv0SDVl4evA11Nw==
X-Received: by 2002:a1c:3909:: with SMTP id g9mr13187347wma.63.1629373209476;
        Thu, 19 Aug 2021 04:40:09 -0700 (PDT)
Received: from localhost.localdomain (arl-84-90-178-246.netvisao.pt. [84.90.178.246])
        by smtp.gmail.com with ESMTPSA id b13sm2650891wrf.86.2021.08.19.04.40.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Aug 2021 04:40:09 -0700 (PDT)
From:   Lukas Bulwahn <lukas.bulwahn@gmail.com>
To:     Paul Mackerras <paulus@ozlabs.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Michael Neuling <mikey@neuling.org>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Cc:     Christophe Leroy <christophe.leroy@csgroup.eu>,
        stable@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>
Subject: [PATCH v2 2/2] powerpc: rectify selection to ARCH_ENABLE_SPLIT_PMD_PTLOCK
Date:   Thu, 19 Aug 2021 13:39:54 +0200
Message-Id: <20210819113954.17515-3-lukas.bulwahn@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210819113954.17515-1-lukas.bulwahn@gmail.com>
References: <20210819113954.17515-1-lukas.bulwahn@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit 66f24fa766e3 ("mm: drop redundant ARCH_ENABLE_SPLIT_PMD_PTLOCK")
selects the non-existing config ARCH_ENABLE_PMD_SPLIT_PTLOCK in
./arch/powerpc/platforms/Kconfig.cputype, but clearly it intends to select
ARCH_ENABLE_SPLIT_PMD_PTLOCK here (notice the word swapping!), as this
commit does select that for all other architectures.

Rectify selection to ARCH_ENABLE_SPLIT_PMD_PTLOCK instead.

Fixes: 66f24fa766e3 ("mm: drop redundant ARCH_ENABLE_SPLIT_PMD_PTLOCK")
Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
---
 arch/powerpc/platforms/Kconfig.cputype | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/platforms/Kconfig.cputype b/arch/powerpc/platforms/Kconfig.cputype
index 6794145603de..a208997ade88 100644
--- a/arch/powerpc/platforms/Kconfig.cputype
+++ b/arch/powerpc/platforms/Kconfig.cputype
@@ -98,7 +98,7 @@ config PPC_BOOK3S_64
 	select PPC_HAVE_PMU_SUPPORT
 	select HAVE_ARCH_TRANSPARENT_HUGEPAGE
 	select ARCH_ENABLE_HUGEPAGE_MIGRATION if HUGETLB_PAGE && MIGRATION
-	select ARCH_ENABLE_PMD_SPLIT_PTLOCK
+	select ARCH_ENABLE_SPLIT_PMD_PTLOCK
 	select ARCH_ENABLE_THP_MIGRATION if TRANSPARENT_HUGEPAGE
 	select ARCH_SUPPORTS_HUGETLBFS
 	select ARCH_SUPPORTS_NUMA_BALANCING
-- 
2.26.2


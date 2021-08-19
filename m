Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A88823F1645
	for <lists+stable@lfdr.de>; Thu, 19 Aug 2021 11:32:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237757AbhHSJdY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Aug 2021 05:33:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237735AbhHSJdX (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Aug 2021 05:33:23 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8668CC061575;
        Thu, 19 Aug 2021 02:32:47 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id q10so8074991wro.2;
        Thu, 19 Aug 2021 02:32:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FO+lf3R/yjc9KGpGIWIOuNRXRBvu2rIu+mbHK5sUlLs=;
        b=BM4IKNhCtQRKZxA0sZ4q1/jIzjHv+b7LZPW+AfBbbBQ0vP4MQlKD2NXPkieTMmquaD
         kcLfOqxYwR9WnKn/TcY4IhyUUtuBXi0laK22N8HqvBPCS/HGQ7ha4TNeQUThChMpwL2t
         xv7+CCGEd1IcRlV2AzP2hrh5omnShKYloHOw+uCVsvHLpiaOzNiTxgnzmQmb8z3272N1
         M0WyPaS4B2PuFpjGPoU8W9Q3qGiKCVeaBlrPjz5sUJPlZbJm0wzxyxYKeExKrUP/G5ki
         VliwdIAAhjkMCw0xOCmUp1eWu2bG1NPFs6Kf2Q6AmmdOaGl6+/kDVzap1r2qLSaMrTcQ
         tpMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FO+lf3R/yjc9KGpGIWIOuNRXRBvu2rIu+mbHK5sUlLs=;
        b=qo1dTgnvQrp/GNj+ScNeD7EpNOczpNnSraA5e/J3IYSdQnhMFyBYgcP748jvSSavQV
         cNofDrsrZSUY7EJUecHcFO2H4e3KZljAMcHPkm3yhmcUos60jHozRnkd/0f//ZsfC0aF
         NCxAS+tCFch0u5P/Xnmyl7y9fLzoseYFtz40rJeNYsNASjs6xkr+wGYUkAORl+BaraP+
         vdlvH7k5zCpaIseSnnWGXIjTHpOGVizqWqw1GZKYJC75KMK+QGnrZGorTcbVALx6YeHL
         QW+SYsZBDuXVVo4cGnndR5pIKd8tKsCMLPoZNtCtiOfUZWCe0tBrOUaKE7K6iaOy378/
         yb7w==
X-Gm-Message-State: AOAM530h0xqOjGwmZ8JLxk7sTsriK/1aDR3IYheZ94JghUzjB8paqC17
        H4IcooCQIBzMIAtM/ZOsGkE=
X-Google-Smtp-Source: ABdhPJwu7l1e14z3CvBWCEbrYHKKMJmpt16r4+Dcm6OhP5DvDOyQWjLUEWmRVRqIBmTBER8QJHSQKQ==
X-Received: by 2002:a5d:4586:: with SMTP id p6mr2620112wrq.55.1629365566140;
        Thu, 19 Aug 2021 02:32:46 -0700 (PDT)
Received: from localhost.localdomain (arl-84-90-178-246.netvisao.pt. [84.90.178.246])
        by smtp.gmail.com with ESMTPSA id h11sm8485061wmc.23.2021.08.19.02.32.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Aug 2021 02:32:45 -0700 (PDT)
From:   Lukas Bulwahn <lukas.bulwahn@gmail.com>
To:     Paul Mackerras <paulus@ozlabs.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Michael Neuling <mikey@neuling.org>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Cc:     stable@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>
Subject: [PATCH 2/2] powerpc: rectify selection to ARCH_ENABLE_SPLIT_PMD_PTLOCK
Date:   Thu, 19 Aug 2021 11:32:26 +0200
Message-Id: <20210819093226.13955-3-lukas.bulwahn@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210819093226.13955-1-lukas.bulwahn@gmail.com>
References: <20210819093226.13955-1-lukas.bulwahn@gmail.com>
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


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2094F608178
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 00:28:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229649AbiJUW2Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Oct 2022 18:28:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbiJUW2Y (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Oct 2022 18:28:24 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A6C018E28E
        for <stable@vger.kernel.org>; Fri, 21 Oct 2022 15:28:22 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-360b9418f64so41475557b3.7
        for <stable@vger.kernel.org>; Fri, 21 Oct 2022 15:28:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=UNGrrBQSFJPioHxic2YhpQaL13tNOPKKc9e4+Y6lW8k=;
        b=GRjRHyXTE27B29YnD2HJByyz3W+700Npn0UlJyjcUv0fTWRPpk97F2bNonvmnpiDxh
         g/78zE0v2v228u8mCtmIvNuulUIzJU1BjwAijMPIxh9Rcg1p7sOtw2GiPxuAx+TPnpQd
         syLdHCxlIqOxrJmbssi6cOkK3CP06GK+70QGTkOSqcnw5vpjij0H7u8hWTD6yC2WIxjz
         /UJ3W3L7OpKZO3zw8kAXtj0iectnuEdw3c9hoGKMLtIo3Oe6V/YlqbNOH/yGyj9YJBNm
         vaIsPoH74TVQXh/5h7oXgdBAyKbwRwb5LxAl4j9TTKx+te6MOjhqPpttBElipDkFhDf7
         btJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=UNGrrBQSFJPioHxic2YhpQaL13tNOPKKc9e4+Y6lW8k=;
        b=my78BbC301AmJ1RU3tvSNT8kYFTtYvSkcE03y7YqxuaL4x2p8ru0gZHQhJIDI5xXLz
         x+vwErpxL2EI4YvvJrcXMHVksjuehXkys5WYAqKnCE1sI3YLnVbtQXI8o320Kfgphney
         CTMWD4naB1OoPWcssKpWGv6f8Z65lf/7DAP8GsnBC/nu0SlPsWP8yriwyFlMxTRnxFsB
         H8l0BRW1VIho9KwsVYTR9D80FNarCwJXX6YaQnX+7DPOrk+jbXbVEEQRw+dOMtyl9AoN
         pdjWmW9b58XhHCWorSnegK1RHUSiRTKTRhbpYryru9/Ce/U7dXt5FLlJRuV6r+pKqwLH
         n0lA==
X-Gm-Message-State: ACrzQf3Zu/RMIiUzR5YWDc7YONpqbKkMInyNvQPi4wBtuScKhdBGc5O4
        v0imanCVUHGYsbf8sQ47fVEL4DWKgfYN
X-Google-Smtp-Source: AMsMyM5TbyMWFj8dXnMjbTzsabuwCCGxprLxGdPNkjU9sB5Pn03oatqgJU6mjH6D+fPclNH2ondarbIPH43I
X-Received: from eugenis.svl.corp.google.com ([2620:15c:2ce:200:8a12:10f5:7696:29de])
 (user=eugenis job=sendgmr) by 2002:a81:130a:0:b0:360:9739:82be with SMTP id
 10-20020a81130a000000b00360973982bemr19424499ywt.69.1666391301693; Fri, 21
 Oct 2022 15:28:21 -0700 (PDT)
Date:   Fri, 21 Oct 2022 15:28:11 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.38.0.135.g90850a2211-goog
Message-ID: <20221021222811.2366215-1-eugenis@google.com>
Subject: [PATCH] arm64/mm: Consolidate TCR_EL1 fields
From:   Evgenii Stepanov <eugenis@google.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Anshuman Khandual <anshuman.khandual@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anshuman Khandual <anshuman.khandual@arm.com>

commit e921da6bc7cac5f0e8458fe5df18ae08eb538f54 upstream.

This renames and moves SYS_TCR_EL1_TCMA1 and SYS_TCR_EL1_TCMA0 definitions
into pgtable-hwdef.h thus consolidating all TCR fields in a single header.
This does not cause any functional change.

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Link: https://lore.kernel.org/r/1643121513-21854-1-git-send-email-anshuman.khandual@arm.com
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/include/asm/pgtable-hwdef.h | 2 ++
 arch/arm64/include/asm/sysreg.h        | 4 ----
 arch/arm64/mm/proc.S                   | 2 +-
 3 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/include/asm/pgtable-hwdef.h b/arch/arm64/include/asm/pgtable-hwdef.h
index 40085e53f573..66671ff05183 100644
--- a/arch/arm64/include/asm/pgtable-hwdef.h
+++ b/arch/arm64/include/asm/pgtable-hwdef.h
@@ -273,6 +273,8 @@
 #define TCR_NFD1		(UL(1) << 54)
 #define TCR_E0PD0		(UL(1) << 55)
 #define TCR_E0PD1		(UL(1) << 56)
+#define TCR_TCMA0		(UL(1) << 57)
+#define TCR_TCMA1		(UL(1) << 58)
 
 /*
  * TTBR.
diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index 394fc5998a4b..f79f3720e4cb 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -1094,10 +1094,6 @@
 #define CPACR_EL1_ZEN_EL0EN	(BIT(17)) /* enable EL0 access, if EL1EN set */
 #define CPACR_EL1_ZEN		(CPACR_EL1_ZEN_EL1EN | CPACR_EL1_ZEN_EL0EN)
 
-/* TCR EL1 Bit Definitions */
-#define SYS_TCR_EL1_TCMA1	(BIT(58))
-#define SYS_TCR_EL1_TCMA0	(BIT(57))
-
 /* GCR_EL1 Definitions */
 #define SYS_GCR_EL1_RRND	(BIT(16))
 #define SYS_GCR_EL1_EXCL_MASK	0xffffUL
diff --git a/arch/arm64/mm/proc.S b/arch/arm64/mm/proc.S
index d35c90d2e47a..50bbed947bec 100644
--- a/arch/arm64/mm/proc.S
+++ b/arch/arm64/mm/proc.S
@@ -46,7 +46,7 @@
 #endif
 
 #ifdef CONFIG_KASAN_HW_TAGS
-#define TCR_MTE_FLAGS SYS_TCR_EL1_TCMA1 | TCR_TBI1 | TCR_TBID1
+#define TCR_MTE_FLAGS TCR_TCMA1 | TCR_TBI1 | TCR_TBID1
 #else
 /*
  * The mte_zero_clear_page_tags() implementation uses DC GZVA, which relies on
-- 
2.38.0.135.g90850a2211-goog


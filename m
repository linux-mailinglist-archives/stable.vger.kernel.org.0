Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8770757AA93
	for <lists+stable@lfdr.de>; Wed, 20 Jul 2022 01:49:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229585AbiGSXtY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 19:49:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbiGSXtW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 19:49:22 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90A8B43E6D
        for <stable@vger.kernel.org>; Tue, 19 Jul 2022 16:49:21 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-31e60b8bb07so19857287b3.1
        for <stable@vger.kernel.org>; Tue, 19 Jul 2022 16:49:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=Po9Y/gTzarxHrhYTITOFvy2JwCB88ahX2IAz9RZr3y8=;
        b=CBu2FxXInNBIGTHwxBQtN5BTaJRj7DzoWL4LiKBMXadUQbInajt5azKCCiPzvAQ2J9
         CVjHorJd7GhmvuW+i3r5vx7Ts7ORtSrQRK5lkPKjyAWwsKDXXgzjUxUqd5Cm7QZRadoj
         I/5wl2Gdb2OS9eYMPLprZwp0dyEzNeIU818n4HNyVB/FvhgZtHUX0/B0HhZBFfcfl/2V
         GQFkwSL4KPAzxWPurFrezGFbWZNdNhXKzINPET3WMavcLTlDaaFAVqhlq6s8Eje3laRB
         iyxpICNm3o2cFMK0uXovPZy50k6nWEo+CRYAy+db/Q8jGblRWoqBy47K71sPfYSu/lMj
         8z6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=Po9Y/gTzarxHrhYTITOFvy2JwCB88ahX2IAz9RZr3y8=;
        b=Fq/BSR32j2551rAfFrcKt7jRzUdNYgRTxoxRltXz4rvS8ZdY7Ni0abjJANDtTswyf8
         /4kbvhPOuqDSw1y91uRLjxt7uW3L64d6cnN7x78I3fLEuepnhb0OF57Qs7Zij1Vjwi5t
         nROpADZKf+30mCu6EUDDfl8+4sPqCOcG9QzSUH4iKSjiPjdkGhkySNDuQl+H8eUBAa+v
         2Lli+6DmymZwnpfvlrQEew50uSO1WY9uP9QjR6bij94gZo457sPkKfA/EOJ+hbi1wg9m
         7KA11myoFk1B7+nRbTlIZYJIdcvIQzIycrMceMY7FX951DadpD7A089J5g8qWFZeqrFB
         ZlbA==
X-Gm-Message-State: AJIora8g6pIQIWKPkA4L+8keJDEXh9HqRNC1/o83Rd7pinhbSm/CbIwm
        RXerGrFFc3+DkeHXi7RadHu4rzs=
X-Google-Smtp-Source: AGRyM1uaSZq7mthNo3vJmYZMkFYqfacvzy6A82uZNxJZGnURkqGX0BU/D616Fm+/JRRyoh8h3aWTqE0=
X-Received: from pcc-desktop.svl.corp.google.com ([2620:15c:2ce:200:966b:4dac:ab6b:a57a])
 (user=pcc job=sendgmr) by 2002:a81:a102:0:b0:31e:6264:3c3c with SMTP id
 y2-20020a81a102000000b0031e62643c3cmr4235308ywg.476.1658274560855; Tue, 19
 Jul 2022 16:49:20 -0700 (PDT)
Date:   Tue, 19 Jul 2022 16:49:09 -0700
Message-Id: <20220719234909.1398992-1-pcc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.0.170.g444d1eabd0-goog
Subject: [PATCH] arm64: set UXN on swapper page tables
From:   Peter Collingbourne <pcc@google.com>
To:     Will Deacon <will@kernel.org>
Cc:     Peter Collingbourne <pcc@google.com>,
        Marc Zyngier <maz@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        stable@vger.kernel.org
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

On a system that implements FEAT_EPAN, read/write access to the idmap
is denied because UXN is not set on the swapper PTEs. As a result,
idmap_kpti_install_ng_mappings panics the kernel when accessing
__idmap_kpti_flag. Fix it by setting UXN on these PTEs.

Fixes: 18107f8a2df6 ("arm64: Support execute-only permissions with Enhanced PAN")
Cc: <stable@vger.kernel.org> # 5.15
Link: https://linux-review.googlesource.com/id/Ic452fa4b4f74753e54f71e61027e7222a0fae1b1
Signed-off-by: Peter Collingbourne <pcc@google.com>
---
This fix is no longer needed since commit c3cee924bd85 ("arm64: head:
cover entire kernel image in initial ID map"), which moved __idmap_kpti_flag
to .data, but that commit is currently only present in next.

 arch/arm64/include/asm/kernel-pgtable.h | 4 ++--
 arch/arm64/kernel/head.S                | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/kernel-pgtable.h b/arch/arm64/include/asm/kernel-pgtable.h
index 96dc0f7da258..a971d462f531 100644
--- a/arch/arm64/include/asm/kernel-pgtable.h
+++ b/arch/arm64/include/asm/kernel-pgtable.h
@@ -103,8 +103,8 @@
 /*
  * Initial memory map attributes.
  */
-#define SWAPPER_PTE_FLAGS	(PTE_TYPE_PAGE | PTE_AF | PTE_SHARED)
-#define SWAPPER_PMD_FLAGS	(PMD_TYPE_SECT | PMD_SECT_AF | PMD_SECT_S)
+#define SWAPPER_PTE_FLAGS	(PTE_TYPE_PAGE | PTE_AF | PTE_SHARED | PTE_UXN)
+#define SWAPPER_PMD_FLAGS	(PMD_TYPE_SECT | PMD_SECT_AF | PMD_SECT_S | PMD_SECT_UXN)
 
 #if ARM64_KERNEL_USES_PMD_MAPS
 #define SWAPPER_MM_MMUFLAGS	(PMD_ATTRINDX(MT_NORMAL) | SWAPPER_PMD_FLAGS)
diff --git a/arch/arm64/kernel/head.S b/arch/arm64/kernel/head.S
index 6a98f1a38c29..8a93a0a7489b 100644
--- a/arch/arm64/kernel/head.S
+++ b/arch/arm64/kernel/head.S
@@ -285,7 +285,7 @@ SYM_FUNC_START_LOCAL(__create_page_tables)
 	subs	x1, x1, #64
 	b.ne	1b
 
-	mov	x7, SWAPPER_MM_MMUFLAGS
+	mov_q	x7, SWAPPER_MM_MMUFLAGS
 
 	/*
 	 * Create the identity mapping.
-- 
2.37.0.170.g444d1eabd0-goog


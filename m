Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 032884E447A
	for <lists+stable@lfdr.de>; Tue, 22 Mar 2022 17:45:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239242AbiCVQrK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Mar 2022 12:47:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235446AbiCVQrJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Mar 2022 12:47:09 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74BFBBC2C;
        Tue, 22 Mar 2022 09:45:42 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id mp6-20020a17090b190600b001c6841b8a52so3456328pjb.5;
        Tue, 22 Mar 2022 09:45:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hfRgv6jdzK8YulxLImbs+RMzKkrNiSCQi//JUrZBqC0=;
        b=MoOu0p755ivzIOlPR9Bapgru6r7wiIpiB8r+3PGw4SkStK/VcXRUvBOaMb54A3cSvW
         Z7GQXEPPbE2FAb0Dw4MljIT330zefErVhDJBBLt9CMku7KyHO8+nI3MeHQ1EdOj9vJnm
         EuEergroqdkXWVdc1u9knYYQvtBX04oCUA+EZw36H3lePZzcAWpQpYxocKguR9frlUCs
         WioxfVwp7AsLBXdNuspNszxQg5Q+fEhHRrHHGux0/pDoj0/3TdxuHbTaLWaVcnJxFbrk
         n8Vt9F6V06Am6rhmS3suHxa3yyT2UB7+JntlCqp3wbhUIPDQzdZi2HQAR4o9dU9EshfC
         qONg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hfRgv6jdzK8YulxLImbs+RMzKkrNiSCQi//JUrZBqC0=;
        b=vwfv1Iz9WuqTdmlISmu2gqpaDpkS+WaLABCe86s/c3ckxoYlhg1Doiqytxc+kBbjTg
         /cGCH/dZ3mhZKzYz+p0EP8pNadgAt01wlpOmenCTmA7ptYhfCKdQPlUsg55vn1Sr7I4C
         jNjgLeXF1TpWHu93/Da3TgghJgj9rW0hDR6EEwV3smwPNHqfi4Ko/Lb2JYqCyVBH8C/j
         e+HJ9bAp1aXTYXm1KwEniVVMwlcy+pijHBR1YtdScmHiVjHglRdLiTrvdlHQ/dl8FZ7y
         +pouai+cnEF2YdZS98EaO/WUZYuzt2Drq686G8eBaTX1u3PE2R6tdRClYCh1E9FIH+lq
         VHNw==
X-Gm-Message-State: AOAM5301TGrhi+eWMAa9spCFcstPJvZ38/aVjK1iruLwjrv+TTzw6jl8
        B/xVIG5tHrdo7RRzNcXlOMA=
X-Google-Smtp-Source: ABdhPJyTPxL3VEmB64sxKlaS6AIXzW12S4IN0SS3U3LFpVoXAfVs88wjAOM88y5mN06pFQCIkw1grw==
X-Received: by 2002:a17:90b:4a0d:b0:1c6:f480:b7f2 with SMTP id kk13-20020a17090b4a0d00b001c6f480b7f2mr6130673pjb.79.1647967541900;
        Tue, 22 Mar 2022 09:45:41 -0700 (PDT)
Received: from octofox.hsd1.ca.comcast.net ([2601:641:401:1d20:b4a1:cd7d:303a:93b9])
        by smtp.gmail.com with ESMTPSA id h2-20020a056a00218200b004f66d50f054sm23335159pfi.158.2022.03.22.09.45.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Mar 2022 09:45:41 -0700 (PDT)
From:   Max Filippov <jcmvbkbc@gmail.com>
To:     linux-xtensa@linux-xtensa.org
Cc:     Chris Zankel <chris@zankel.net>, linux-kernel@vger.kernel.org,
        Max Filippov <jcmvbkbc@gmail.com>, stable@vger.kernel.org
Subject: [PATCH] xtensa: define update_mmu_tlb function
Date:   Tue, 22 Mar 2022 09:45:31 -0700
Message-Id: <20220322164531.3513925-1-jcmvbkbc@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        FROM_LOCAL_NOVOWEL,HK_RANDOM_ENVFROM,HK_RANDOM_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Before the commit f9ce0be71d1f ("mm: Cleanup faultaround and finish_fault()
codepaths") there was a call to update_mmu_cache in alloc_set_pte that
used to invalidate TLB entry caching invalid PTE that caused a page
fault. That commit removed that call so now invalid TLB entry survives
causing repetitive page faults on the CPU that took the initial fault
until that TLB entry is occasionally evicted. This issue is spotted by
the xtensa TLB sanity checker.

Fix this issue by defining update_mmu_tlb function that flushes TLB entry
for the faulting address.

Cc: stable@vger.kernel.org # 5.12+
Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
---
 arch/xtensa/include/asm/pgtable.h | 4 ++++
 arch/xtensa/mm/tlb.c              | 6 ++++++
 2 files changed, 10 insertions(+)

diff --git a/arch/xtensa/include/asm/pgtable.h b/arch/xtensa/include/asm/pgtable.h
index bd5aeb795567..a63eca126657 100644
--- a/arch/xtensa/include/asm/pgtable.h
+++ b/arch/xtensa/include/asm/pgtable.h
@@ -411,6 +411,10 @@ extern  void update_mmu_cache(struct vm_area_struct * vma,
 
 typedef pte_t *pte_addr_t;
 
+void update_mmu_tlb(struct vm_area_struct *vma,
+		    unsigned long address, pte_t *ptep);
+#define __HAVE_ARCH_UPDATE_MMU_TLB
+
 #endif /* !defined (__ASSEMBLY__) */
 
 #define __HAVE_ARCH_PTEP_TEST_AND_CLEAR_YOUNG
diff --git a/arch/xtensa/mm/tlb.c b/arch/xtensa/mm/tlb.c
index f436cf2efd8b..27a477dae232 100644
--- a/arch/xtensa/mm/tlb.c
+++ b/arch/xtensa/mm/tlb.c
@@ -162,6 +162,12 @@ void local_flush_tlb_kernel_range(unsigned long start, unsigned long end)
 	}
 }
 
+void update_mmu_tlb(struct vm_area_struct *vma,
+		    unsigned long address, pte_t *ptep)
+{
+	local_flush_tlb_page(vma, address);
+}
+
 #ifdef CONFIG_DEBUG_TLB_SANITY
 
 static unsigned get_pte_for_vaddr(unsigned vaddr)
-- 
2.30.2


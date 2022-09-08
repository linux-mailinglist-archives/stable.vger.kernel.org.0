Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76BDF5B27DF
	for <lists+stable@lfdr.de>; Thu,  8 Sep 2022 22:48:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229624AbiIHUsZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Sep 2022 16:48:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbiIHUsZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Sep 2022 16:48:25 -0400
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2980DE9025;
        Thu,  8 Sep 2022 13:48:22 -0700 (PDT)
Received: by mail-lj1-x234.google.com with SMTP id bx38so21362772ljb.10;
        Thu, 08 Sep 2022 13:48:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=mFw2h/Ri2/bIxA8fteahahsAIbUWAOrFqK6aSuy87lQ=;
        b=n4rTTgToDl5DYCN6bLMJk0mgVYr1H7F22SRmYfIXkncpwutmjQwkXquSwkiZ3/wm7s
         gUbtPS7wlm41dsTuTnEETgFcy4EvmKnpSuMRM3ze5bj0cFYqyfuhjNs+ZOuFl0vRFmgr
         qArFsOc776Cbz5fTPdvRY+m5/F3jszfugzhZ5KLt4OcsIiFp+xQEu7231d4qmi3B5BVP
         mJqBMXZVux97mKIJUGrdokPkHREH5mwyejadgSbugbgeEzBpXQbR2PhLk53odyUZF5+N
         iEoErCCdjdCfnYes3+OOPGODYZ5Tix6XxnsSeSsWJaVM5TaEZIGZRJMaco8EcHMtw/xT
         8SIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=mFw2h/Ri2/bIxA8fteahahsAIbUWAOrFqK6aSuy87lQ=;
        b=jdVROuLNMaDGYlKJbUmzdgPrE/xr4KYFDuThWSSJS5ghU3q9bUrKZK9sLY8HF58O3B
         a0DUEtk4TsDcKrQVSnBVxCUNvyQCcM3CNOAbayMkjeQfCFPFWYFxVB7S0zPKsPTwe0Qp
         uN48/vALZqxcY7ZfF/uT36/2AZ4BkBFfnLuUaUiFqDFaSdPzdaiYIxv6ml+HtwKw7QzV
         j9+cnscNaT7NmUKWoWbsK3hNX7yDmRkMtLz+eDtmnRO69Ig309Xp0Ti+yPE1dVUx6Jn+
         E7q0Lo2uPOJD6Xwpb8wCqLwREx4kZSaevYzE57C7z1mOxK9Uz22O+HYPIU9+9Knrvj/P
         46pw==
X-Gm-Message-State: ACgBeo31ZNiqrpFHTl0EUTmvESp+vgtqVi3VN7blnT0NvMcvWhE/SUZO
        rK0Cbp+rcCoNGpKAKYN8KcA=
X-Google-Smtp-Source: AA6agR4qNb7yw9CwK8YVXamz9lVNOsxk5VoeFFCF2eZ9wQ+TxW8Wyg3YU7Z5hBSVSNMplKLVy/A5uw==
X-Received: by 2002:a2e:3002:0:b0:26a:b199:46df with SMTP id w2-20020a2e3002000000b0026ab19946dfmr2805220ljw.304.1662670100391;
        Thu, 08 Sep 2022 13:48:20 -0700 (PDT)
Received: from saproj-Latitude-5501.yandex.net ([2a02:6b8:0:40c:3f3a:cd4:e3fd:6ec6])
        by smtp.gmail.com with ESMTPSA id g1-20020a0565123b8100b00494767f1a4fsm3180725lfv.21.2022.09.08.13.48.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Sep 2022 13:48:20 -0700 (PDT)
From:   Sergei Antonov <saproj@gmail.com>
To:     linux-mm@kvack.org, akpm@linux-foundation.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Sergei Antonov <saproj@gmail.com>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [PATCH] mm: bring back update_mmu_cache() to finish_fault()
Date:   Thu,  8 Sep 2022 23:48:09 +0300
Message-Id: <20220908204809.2012451-1-saproj@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Running this test program on ARMv4 a few times (sometimes just once)
reproduces the bug.

int main()
{
        unsigned i;
        char paragon[SIZE];
        void* ptr;

        memset(paragon, 0xAA, SIZE);
        ptr = mmap(NULL, SIZE, PROT_READ | PROT_WRITE,
                   MAP_ANON | MAP_SHARED, -1, 0);
        if (ptr == MAP_FAILED) return 1;
        printf("ptr = %p\n", ptr);
        for (i=0;i<10000;i++){
                memset(ptr, 0xAA, SIZE);
                if (memcmp(ptr, paragon, SIZE)) {
                        printf("Unexpected bytes on iteration %u!!!\n", i);
                        break;
                }
        }
        munmap(ptr, SIZE);
}

In the "ptr" buffer there appear runs of zero bytes which are aligned
by 16 and their lengths are multiple of 16.

Linux v5.11 does not have the bug, "git bisect" finds the first bad commit:
f9ce0be71d1f ("mm: Cleanup faultaround and finish_fault() codepaths")

Before the commit update_mmu_cache() was called during a call to
filemap_map_pages() as well as finish_fault(). After the commit
finish_fault() lacks it.

Bring back update_mmu_cache() to finish_fault() to fix the bug.
Also call update_mmu_tlb() only when returning VM_FAULT_NOPAGE to more
closely reproduce the code of alloc_set_pte() function that existed before
the commit.

On many platforms update_mmu_cache() is nop:
 x86, see arch/x86/include/asm/pgtable
 ARMv6+, see arch/arm/include/asm/tlbflush.h
So, it seems, few users ran into this bug.

Fixes: f9ce0be71d1f ("mm: Cleanup faultaround and finish_fault() codepaths")
Signed-off-by: Sergei Antonov <saproj@gmail.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 mm/memory.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 4ba73f5aa8bb..a78814413ac0 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4386,14 +4386,20 @@ vm_fault_t finish_fault(struct vm_fault *vmf)
 
 	vmf->pte = pte_offset_map_lock(vma->vm_mm, vmf->pmd,
 				      vmf->address, &vmf->ptl);
-	ret = 0;
+
 	/* Re-check under ptl */
-	if (likely(!vmf_pte_changed(vmf)))
+	if (likely(!vmf_pte_changed(vmf))) {
 		do_set_pte(vmf, page, vmf->address);
-	else
+
+		/* no need to invalidate: a not-present page won't be cached */
+		update_mmu_cache(vma, vmf->address, vmf->pte);
+
+		ret = 0;
+	} else {
+		update_mmu_tlb(vma, vmf->address, vmf->pte);
 		ret = VM_FAULT_NOPAGE;
+	}
 
-	update_mmu_tlb(vma, vmf->address, vmf->pte);
 	pte_unmap_unlock(vmf->pte, vmf->ptl);
 	return ret;
 }
-- 
2.34.1


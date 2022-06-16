Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7003F54E2A8
	for <lists+stable@lfdr.de>; Thu, 16 Jun 2022 15:57:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233726AbiFPN5Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jun 2022 09:57:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377355AbiFPN4X (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Jun 2022 09:56:23 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 411DD46B3B;
        Thu, 16 Jun 2022 06:56:23 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id f16so490993pjj.1;
        Thu, 16 Jun 2022 06:56:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=c2gM3wzeGG5xpS3I4Gd+kO+ny3mVcmHQeudfRtcSuyY=;
        b=oqnQ1amYllYfMFhLL6UGLzNaDOjk0tNOtVEfL2PxqSzpHqdEC59/uDNDqNzMkQA3pg
         hiUS9ASzkdqBYNglhisltpP0eE1cQD3a/xkmrQqzo8JxIsh7+4FbHjAGuB2Ef5bJDtzo
         hiex/jO2Wx2e7VMbSnwfEatDvNK8M+l2m43PxB5qHr60UPwRiy5BN2KXaw3b5y2kYW5z
         Rc+jeUGWyAP5Md4ZXMu7vG35ee6KJXtHoJr0GH+FLPwXWpXLYydlgFCBE8+Pi4Hr1xWS
         1w2RfzQG73cX/sLbNoxz+IOTTnuVrA/hncQ1GrACZml3svh8+S4L3JWWRMkSP9/AxoKc
         7ISQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=c2gM3wzeGG5xpS3I4Gd+kO+ny3mVcmHQeudfRtcSuyY=;
        b=6QQh/Fsg09Fds/B+joHw2ydMnhFmx44LlOCtelD59N3DoJIvG5oaMt4xRg6c6KCKQV
         01NM2ka8oZPrmDfHtu5qSL1kPZIh5/0LAsGKG7nX4PNVdy+4aSmJoQSa3NflKEQ8y/Ls
         /gx0JCErCoe8gxIFMcqD7AqJl5YYALRUvzIJtwqvqeVXq7A3mZrMUGC2gif9wF9MmrYb
         pLnpTko5rNNpaWNJrdXFPk5Ed1xz2oaTD0YyxArI9IjhpT2edE7f9Ia+HD+iCtA9Vhmd
         TZ+hXTh+0o2lZlSbavJHcTor18JTy3nLDB7zAu4ODZX0ZAvPvONH6PYn85CflP6yfk9p
         rQzg==
X-Gm-Message-State: AJIora/eIRxs5UnlXE2hpCZSONrtAy6wciqLDNSCI/sFDaS0xmaR2LjV
        z7DL1HmGZDRF2hkrVCxMYpI=
X-Google-Smtp-Source: AGRyM1sGhY2Fhf8p+iBBnlUJMnC30ww+CqWuVYAFjW8KGj/XYkqVsd5zWoLe9ckN+61VHkOeplwgeA==
X-Received: by 2002:a17:902:aa43:b0:168:ef35:5bd9 with SMTP id c3-20020a170902aa4300b00168ef355bd9mr4491890plr.137.1655387782699;
        Thu, 16 Jun 2022 06:56:22 -0700 (PDT)
Received: from localhost.localdomain ([43.132.141.9])
        by smtp.gmail.com with ESMTPSA id k16-20020a17090aaa1000b001e3351cb7fbsm3814583pjq.28.2022.06.16.06.56.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jun 2022 06:56:22 -0700 (PDT)
From:   Yuntao Wang <ytcoode@gmail.com>
To:     Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>
Cc:     "H. Peter Anvin" <hpa@zytor.com>, Baoquan He <bhe@redhat.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Yuntao Wang <ytcoode@gmail.com>,
        stable@vger.kernel.org
Subject: [PATCH] x86/mm: Fix possible index overflow when creating page table mapping
Date:   Thu, 16 Jun 2022 21:55:10 +0800
Message-Id: <20220616135510.1784995-1-ytcoode@gmail.com>
X-Mailer: git-send-email 2.36.0
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

There are two issues in phys_p4d_init():

- The __kernel_physical_mapping_init() does not do boundary-checking for
  paddr_end and passes it directly to phys_p4d_init(), phys_p4d_init() does
  not do bounds checking either, so if the physical memory to be mapped is
  large enough, 'p4d_page + p4d_index(vaddr)' will wrap around to the
  beginning entry of the P4D table and its data will be overwritten.

- The for loop body will be executed only when 'vaddr < vaddr_end'
  evaluates to true, but if that condition is true, 'paddr >= paddr_end'
  will evaluate to false, thus the 'if (paddr >= paddr_end) {}' block will
  never be executed and become dead code.

To fix these issues, use 'i < PTRS_PER_P4D' instead of 'vaddr < vaddr_end'
as the for loop condition, this also make it more consistent with the logic
of the phys_{pud,pmt,pte}_init() functions.

Fixes: 432c833218dd ("x86/mm: Handle physical-virtual alignment mismatch in phys_p4d_init()")
Cc: stable@vger.kernel.org
Signed-off-by: Yuntao Wang <ytcoode@gmail.com>
---
 arch/x86/mm/init_64.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 8779d6be6a49..e718c9b3f539 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -674,18 +674,18 @@ static unsigned long __meminit
 phys_p4d_init(p4d_t *p4d_page, unsigned long paddr, unsigned long paddr_end,
 	      unsigned long page_size_mask, pgprot_t prot, bool init)
 {
-	unsigned long vaddr, vaddr_end, vaddr_next, paddr_next, paddr_last;
-
-	paddr_last = paddr_end;
-	vaddr = (unsigned long)__va(paddr);
-	vaddr_end = (unsigned long)__va(paddr_end);
+	unsigned long vaddr, vaddr_next, paddr_next, paddr_last;
+	int i;
 
 	if (!pgtable_l5_enabled())
 		return phys_pud_init((pud_t *) p4d_page, paddr, paddr_end,
 				     page_size_mask, prot, init);
 
-	for (; vaddr < vaddr_end; vaddr = vaddr_next) {
-		p4d_t *p4d = p4d_page + p4d_index(vaddr);
+	paddr_last = paddr_end;
+	vaddr = (unsigned long)__va(paddr);
+
+	for (i = p4d_index(vaddr); i < PTRS_PER_P4D; i++, vaddr = vaddr_next) {
+		p4d_t *p4d = p4d_page + i;
 		pud_t *pud;
 
 		vaddr_next = (vaddr & P4D_MASK) + P4D_SIZE;
@@ -704,13 +704,13 @@ phys_p4d_init(p4d_t *p4d_page, unsigned long paddr, unsigned long paddr_end,
 
 		if (!p4d_none(*p4d)) {
 			pud = pud_offset(p4d, 0);
-			paddr_last = phys_pud_init(pud, paddr, __pa(vaddr_end),
+			paddr_last = phys_pud_init(pud, paddr, paddr_end,
 					page_size_mask, prot, init);
 			continue;
 		}
 
 		pud = alloc_low_page();
-		paddr_last = phys_pud_init(pud, paddr, __pa(vaddr_end),
+		paddr_last = phys_pud_init(pud, paddr, paddr_end,
 					   page_size_mask, prot, init);
 
 		spin_lock(&init_mm.page_table_lock);
-- 
2.36.0


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E101F9592B
	for <lists+stable@lfdr.de>; Tue, 20 Aug 2019 10:14:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729396AbfHTIOI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Aug 2019 04:14:08 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:35711 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729387AbfHTIOH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Aug 2019 04:14:07 -0400
Received: by mail-pl1-f196.google.com with SMTP id gn20so2370579plb.2
        for <stable@vger.kernel.org>; Tue, 20 Aug 2019 01:14:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fossix-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XQA3UCdGC7caS48ij4zC/iNWJe//yYh8xmEXn6HYb5Q=;
        b=ZaxOt8lk22Z21ulmXMLkeo0R/2PTzZDR0R59vKVCfgZDN+uL7ZpYx1PvlCJfYueDro
         0+iBPqErLvoipl5xvSp7vEG5falbWHLpEPg5ypzBjEf8/k1FBngvApv3z67S5WLsZJMt
         mnMgTwgsaNsf9qzaMKnwiJ36s+EIsL+8fLtrDdWbyrexuraTZIp8JMe9ECT4fp0zQbSv
         lfOwLIRUpV7X8afUFwENMwTu2KajbnGZpMxfWW4Fh68lFD4sdthbwcapSbGieEc32Ddc
         n9FJo7AcVmmXhFBst/qWjg54KCZJ8XK61xbCBHNv5qtO0PpQvjDw6gnY5bc0QMok60VT
         i7Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XQA3UCdGC7caS48ij4zC/iNWJe//yYh8xmEXn6HYb5Q=;
        b=smTDwTApWGg5l0iK2VQmTxnk8W5j7O4AApg2HyT0ahatQoxEO0lPbd3fOnvPu9jGCC
         JkU2rw/ONYeEYaLgsE8wbC11GRO54Kuofp7XqMflSPl5rWq/oEXQm1hEr2ksb4234E2z
         dRIwyMp+nqaNChAP+fa4ju2WXmws9x98tdNtwsCOY/lJA895yZIVnAVvvCkxmGkD4kue
         hgrGXVmFS/iyhVAKUv11XW/T4zY14L7umrpWwrUxQckM9R7NUg7i0KylGj1xdntdydVR
         FkLDYph09os+/0bFQY6SiHWeG1gE2Ialqkt7mTnTHt2k71J0GeCJZ54/X2grMp1wTEdk
         eCsg==
X-Gm-Message-State: APjAAAX7aTBqnws2ehe5xBe4YrCR24mCT0XBxflGXwWCsf01QfhOu5EA
        3yewGjFdQVBBv0k9ZB5qcwXLWA==
X-Google-Smtp-Source: APXvYqwKartOprZEYdfxJQodngK2fUrnjvEtKW/9LFLWW5vrWacynvDQZeXWHe7YGCrlHyzifHiUvw==
X-Received: by 2002:a17:902:fe06:: with SMTP id g6mr26976368plj.265.1566288847004;
        Tue, 20 Aug 2019 01:14:07 -0700 (PDT)
Received: from santosiv.in.ibm.com ([129.41.84.78])
        by smtp.gmail.com with ESMTPSA id b14sm18949265pfo.15.2019.08.20.01.14.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Aug 2019 01:14:06 -0700 (PDT)
From:   Santosh Sivaraj <santosh@fossix.org>
To:     linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Cc:     "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        Mahesh Salgaonkar <mahesh@linux.ibm.com>,
        Reza Arbab <arbab@linux.ibm.com>,
        Chandan Rajendra <chandan@linux.ibm.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Balbir Singh <bsingharora@gmail.com>,
        Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>,
        stable@vger.kernel.org
Subject: [PATCH v11 2/7] powerpc/mce: Fix MCE handling for huge pages
Date:   Tue, 20 Aug 2019 13:43:47 +0530
Message-Id: <20190820081352.8641-3-santosh@fossix.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190820081352.8641-1-santosh@fossix.org>
References: <20190820081352.8641-1-santosh@fossix.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Balbir Singh <bsingharora@gmail.com>

The current code would fail on huge pages addresses, since the shift would
be incorrect. Use the correct page shift value returned by
__find_linux_pte() to get the correct physical address. The code is more
generic and can handle both regular and compound pages.

Fixes: ba41e1e1ccb9 ("powerpc/mce: Hookup derror (load/store) UE errors")
Signed-off-by: Balbir Singh <bsingharora@gmail.com>
[arbab@linux.ibm.com: Fixup pseries_do_memory_failure()]
Signed-off-by: Reza Arbab <arbab@linux.ibm.com>
Tested-by: Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>
Signed-off-by: Santosh Sivaraj <santosh@fossix.org>
Cc: stable@vger.kernel.org # v4.15+
---
 arch/powerpc/kernel/mce_power.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/arch/powerpc/kernel/mce_power.c b/arch/powerpc/kernel/mce_power.c
index a814d2dfb5b0..714a98e0927f 100644
--- a/arch/powerpc/kernel/mce_power.c
+++ b/arch/powerpc/kernel/mce_power.c
@@ -26,6 +26,7 @@
 unsigned long addr_to_pfn(struct pt_regs *regs, unsigned long addr)
 {
 	pte_t *ptep;
+	unsigned int shift;
 	unsigned long flags;
 	struct mm_struct *mm;
 
@@ -35,13 +36,18 @@ unsigned long addr_to_pfn(struct pt_regs *regs, unsigned long addr)
 		mm = &init_mm;
 
 	local_irq_save(flags);
-	if (mm == current->mm)
-		ptep = find_current_mm_pte(mm->pgd, addr, NULL, NULL);
-	else
-		ptep = find_init_mm_pte(addr, NULL);
+	ptep = __find_linux_pte(mm->pgd, addr, NULL, &shift);
 	local_irq_restore(flags);
+
 	if (!ptep || pte_special(*ptep))
 		return ULONG_MAX;
+
+	if (shift > PAGE_SHIFT) {
+		unsigned long rpnmask = (1ul << shift) - PAGE_SIZE;
+
+		return pte_pfn(__pte(pte_val(*ptep) | (addr & rpnmask)));
+	}
+
 	return pte_pfn(*ptep);
 }
 
@@ -344,7 +350,7 @@ static const struct mce_derror_table mce_p9_derror_table[] = {
   MCE_INITIATOR_CPU,   MCE_SEV_SEVERE, true },
 { 0, false, 0, 0, 0, 0, 0 } };
 
-static int mce_find_instr_ea_and_pfn(struct pt_regs *regs, uint64_t *addr,
+static int mce_find_instr_ea_and_phys(struct pt_regs *regs, uint64_t *addr,
 					uint64_t *phys_addr)
 {
 	/*
@@ -541,7 +547,8 @@ static int mce_handle_derror(struct pt_regs *regs,
 			 * kernel/exception-64s.h
 			 */
 			if (get_paca()->in_mce < MAX_MCE_DEPTH)
-				mce_find_instr_ea_and_pfn(regs, addr, phys_addr);
+				mce_find_instr_ea_and_phys(regs, addr,
+							   phys_addr);
 		}
 		found = 1;
 	}
-- 
2.21.0


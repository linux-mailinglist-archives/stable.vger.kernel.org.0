Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAF3A3D0A0A
	for <lists+stable@lfdr.de>; Wed, 21 Jul 2021 09:51:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234291AbhGUHKL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Jul 2021 03:10:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235956AbhGUHJf (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Jul 2021 03:09:35 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 581DDC0613E0
        for <stable@vger.kernel.org>; Wed, 21 Jul 2021 00:49:34 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id h6-20020a17090a6486b029017613554465so533902pjj.4
        for <stable@vger.kernel.org>; Wed, 21 Jul 2021 00:49:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5SiPzH0oQvD2cNeDSmkgLcQ+i377uBDVUSzyiSv2rLY=;
        b=qfZqotzquTXe7VSUITa6ZJmoYJKz5MciCfcteq60Ba+A+X0MqWUyOHtIOfjBfam0B6
         3QWsfNofdh4IjaJNL5SUblYuQuGncudv8j1MvMsL1DabZlxjw78MeM/XxOqaGz/H1Fft
         n3JllH2c3ZnZI3L2e+b4ypu9jIdBhHitxhF/mxsjQVnxiUNAYqxx3/1dXk8uMh0yP8wy
         rLKkG8C6vxdmUZWCB8XUPI0so0ra6APk1hFy1X8dKU5Nyh4K1xrbNqSoraDVN+Dlm67m
         ZxhvR8YA0eXOZLEtH/iUGwcRtvupZCTc+4rlp94jQbhXdkmob9kOStBHvvAdJoJPA30B
         vVlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5SiPzH0oQvD2cNeDSmkgLcQ+i377uBDVUSzyiSv2rLY=;
        b=iwS34WP/RBB6LI3MqOwA8OnTrnQkkQuHKf/TsGVcLoLKWDviavwev3fRK31wUduUbf
         SVTQEg2ibleAxatYDRCnN1aJhEkN4UZd/iFs+xebzowyGM8g8CJodnzfZXL4+jd4mc/W
         M7zUn0f5Q0vTtGcnEunBQq3RfWdx9JoT6kvJnOedBInVglyWXrNNDZ/1oDAAsb1D0e21
         U9BCG4NdDYTM1OXs2iVh1hJUCUskOIQPvPA77OmvaaoRPItSRH83rMAiMMNxw6LXpvA9
         BhQOSlnKdwciDjRiI0rtzQ7iZ4Wj2V0KO1W7LwNhLO3pVWVdqaEoU3z/bUXIMFJ+CXjj
         CdcA==
X-Gm-Message-State: AOAM532880tU3dXgKi1P7zlBX9lgb3YW90bpw+cfRbYtQQgfhI2zAu/w
        EtpQ3Uo+QI9lAEOHlAJeLCgEOA==
X-Google-Smtp-Source: ABdhPJwVcTa6ayV2xNFTtcBA4UI1/B6NB25ALk4yhn4ZuTduJWQZ0/ET+0UopsBFy2MS3zrj2pWlvA==
X-Received: by 2002:a17:90a:fa88:: with SMTP id cu8mr34258238pjb.198.1626853773904;
        Wed, 21 Jul 2021 00:49:33 -0700 (PDT)
Received: from C02DW0BEMD6R.bytedance.net ([139.177.225.250])
        by smtp.gmail.com with ESMTPSA id c83sm791163pfb.164.2021.07.21.00.49.26
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 21 Jul 2021 00:49:33 -0700 (PDT)
From:   Qi Zheng <zhengqi.arch@bytedance.com>
To:     akpm@linux-foundation.org, tglx@linutronix.de, hannes@cmpxchg.org,
        mhocko@kernel.org, vdavydov.dev@gmail.com,
        kirill.shutemov@linux.intel.com
Cc:     linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, songmuchun@bytedance.com,
        Qi Zheng <zhengqi.arch@bytedance.com>, stable@vger.kernel.org
Subject: [PATCH v2] mm: fix the deadlock in finish_fault()
Date:   Wed, 21 Jul 2021 15:48:49 +0800
Message-Id: <20210721074849.57004-1-zhengqi.arch@bytedance.com>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The commit 63f3655f9501 ("mm, memcg: fix reclaim deadlock with
writeback") fix the following ABBA deadlock by pre-allocating
the pte page table without holding the page lock.

	                                lock_page(A)
                                        SetPageWriteback(A)
                                        unlock_page(A)
  lock_page(B)
                                        lock_page(B)
  pte_alloc_one
    shrink_page_list
      wait_on_page_writeback(A)
                                        SetPageWriteback(B)
                                        unlock_page(B)

                                        # flush A, B to clear the writeback

The commit f9ce0be71d1f ("mm: Cleanup faultaround and finish_fault()
codepaths") rework the relevant code but ignore this race. This will
cause the deadlock above to appear again, so fix it.

Fixes: f9ce0be71d1f ("mm: Cleanup faultaround and finish_fault() codepaths")
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
CC: <stable@vger.kernel.org>
---
 Changelog in v1 -> v2:
  - Update commit log

 mm/memory.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/mm/memory.c b/mm/memory.c
index db86558791f1..94a17a9a48ab 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4026,8 +4026,17 @@ vm_fault_t finish_fault(struct vm_fault *vmf)
 				return ret;
 		}

-		if (unlikely(pte_alloc(vma->vm_mm, vmf->pmd)))
+		if (vmf->prealloc_pte) {
+			vmf->ptl = pmd_lock(vma->vm_mm, vmf->pmd);
+			if (likely(pmd_none(*vmf->pmd))) {
+				mm_inc_nr_ptes(vma->vm_mm);
+				pmd_populate(vma->vm_mm, vmf->pmd, vmf->prealloc_pte);
+				vmf->prealloc_pte = NULL;
+			}
+			spin_unlock(vmf->ptl);
+		} else if (unlikely(pte_alloc(vma->vm_mm, vmf->pmd))) {
 			return VM_FAULT_OOM;
+		}
 	}

 	/* See comment in handle_pte_fault() */
--
2.11.0


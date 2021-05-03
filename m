Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 774443723B0
	for <lists+stable@lfdr.de>; Tue,  4 May 2021 01:44:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229881AbhECXo7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 19:44:59 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:28724 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229927AbhECXo6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 May 2021 19:44:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620085444;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ABt25pzgCO1gaqcFMnixhdZW8Kc2SCW/u3hnQ6DkL1o=;
        b=Ldu6//WPEoJdrO7Ox4DTsFy6xCFhqB7vgCAthUGtiKPIAAEE5ZuNkEqBXUmxwMnjC9b+Jj
        74FNyIWS7/70YqaBELKRMJjcJAkK2PhBj2Wczw78okOWewCbmciMLaCrpTPkLeQFBZCdg/
        CpNT1gHITiOZXGBaFiO4Y50xzhkoog4=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-83-3wjwS0WRNBSDjM1QFUXctw-1; Mon, 03 May 2021 19:44:03 -0400
X-MC-Unique: 3wjwS0WRNBSDjM1QFUXctw-1
Received: by mail-qv1-f69.google.com with SMTP id b10-20020a0cf04a0000b02901bda1df3afbso6202199qvl.13
        for <stable@vger.kernel.org>; Mon, 03 May 2021 16:44:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ABt25pzgCO1gaqcFMnixhdZW8Kc2SCW/u3hnQ6DkL1o=;
        b=inEKs3yQHN69GoCVU25lO6w2wRJU164DlyCA5zpmRA7geUJ6rrDMSjHY1ZX+VdA1rZ
         J9t6xRXDAE57pkPwnrJUP+gjkWlRyykJQHsbQdCEsWWdtCDbURJXhuM0XP0LM50iPe7k
         UQL1e42tXZHIPHrIfqsECxapBd20fsQ2coySXQKQqznytoOMHgwGk5v1FBtEE7G5x0io
         aiT8T+Ds5tV6dvrIBkkcGI8yLEWOoEDxRn1Tdw+RMsztS5tvNiXdVQIox0GuWYsxRgwM
         OwSt1mu4Jnylts9SyPbvoxqBBM1r0Mopat+H8tPtEC12X2bh9s6KMydExJkUNQLa+Fu+
         fwTg==
X-Gm-Message-State: AOAM530Yr2MzR+lS7zDIfvOXwaV1j/T1r5G58YAiLSp0jwVGwCrsQrb2
        UtQmf66w5wsktinjFGFTY78ds0OV2/3RfI9YkJWJ7PoApKV06wL4R2LFKEbceX5vC/oTeoHX28g
        PnslPFrUjVjyeisMS
X-Received: by 2002:a05:620a:799:: with SMTP id 25mr12553395qka.188.1620085442709;
        Mon, 03 May 2021 16:44:02 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyvHpI4ndR9mV1KvzNSVtc1wN86uhUFbQX4EF4jyJbcv4dd7JFS0AMYcw+HYYlme5jwSVS1Rg==
X-Received: by 2002:a05:620a:799:: with SMTP id 25mr12553383qka.188.1620085442514;
        Mon, 03 May 2021 16:44:02 -0700 (PDT)
Received: from t490s.redhat.com (bras-base-toroon474qw-grc-72-184-145-4-219.dsl.bell.ca. [184.145.4.219])
        by smtp.gmail.com with ESMTPSA id 189sm7126903qkh.99.2021.05.03.16.44.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 May 2021 16:44:01 -0700 (PDT)
From:   Peter Xu <peterx@redhat.com>
To:     linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc:     Axel Rasmussen <axelrasmussen@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>, peterx@redhat.com,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Hugh Dickins <hughd@google.com>, stable@vger.kernel.org
Subject: [PATCH v2 2/2] mm/hugetlb: Fix cow where page writtable in child
Date:   Mon,  3 May 2021 19:43:56 -0400
Message-Id: <20210503234356.9097-3-peterx@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210503234356.9097-1-peterx@redhat.com>
References: <20210503234356.9097-1-peterx@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When rework early cow of pinned hugetlb pages, we moved huge_ptep_get() upper
but overlooked a side effect that the huge_ptep_get() will fetch the pte after
wr-protection.  After moving it upwards, we need explicit wr-protect of child
pte or we will keep the write bit set in the child process, which could cause
data corrution where the child can write to the original page directly.

This issue can also be exposed by "memfd_test hugetlbfs" kselftest.

Cc: stable@vger.kernel.org
Fixes: 4eae4efa2c299 ("hugetlb: do early cow when page pinned on src mm")
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Peter Xu <peterx@redhat.com>
---
 mm/hugetlb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index aab3a33214d10..72544ebb24f0e 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -4076,6 +4076,7 @@ int copy_hugetlb_page_range(struct mm_struct *dst, struct mm_struct *src,
 				 * See Documentation/vm/mmu_notifier.rst
 				 */
 				huge_ptep_set_wrprotect(src, addr, src_pte);
+				entry = huge_pte_wrprotect(entry);
 			}
 
 			page_dup_rmap(ptepage, true);
-- 
2.31.1


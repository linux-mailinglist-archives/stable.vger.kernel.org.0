Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 591C63BA627
	for <lists+stable@lfdr.de>; Sat,  3 Jul 2021 00:57:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230020AbhGBW7x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Jul 2021 18:59:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229648AbhGBW7x (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Jul 2021 18:59:53 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25F30C061762
        for <stable@vger.kernel.org>; Fri,  2 Jul 2021 15:57:20 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id l16-20020a25cc100000b0290558245b7eabso14918832ybf.10
        for <stable@vger.kernel.org>; Fri, 02 Jul 2021 15:57:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=Rhp3BKIpjKyJeRxRqWuyTX92X8tONQf5DKJFV9GgdPE=;
        b=jP6e9IO3/r9FhSoIPdfURhKoRHCxT5xQUApYE6/gUGXLM9a9PTNU03v1AG559/Oef1
         qO+fMjuAi8sY6Xu2HRAFiWeqoQqEmrp20Mpwk2FgWTvkBVY7Uq998kduzXbHsgnR1MoG
         u4fYb8fR+Y5g6i7kRfqIGioY/zPUsFgjjhSgtC5EvnXeXK8WK66RpzdSez1lDSj6eruC
         1KCLWTzA02yNr119sCJPBnRLG7YdIhIOCmwVLxoXVSVVV6acel8/KcfcDRICED+6h28b
         IrL3bMSyW/1GEeH5CiLHWZxMwtvg6zrRRpr415PD7D6gHoX/JblLaw66SGkJ03zU0CVx
         HXew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Rhp3BKIpjKyJeRxRqWuyTX92X8tONQf5DKJFV9GgdPE=;
        b=Pk/AB+rMt3ToAOPCLQeOmzcGEhgKsSSnmeqXhsluv0Wak7gAQdCmpvvnf8DPeUpzgn
         xMvo96aH/aXgcG2kRjXg4SQp7tsrwsGUzdqv08oTBhBssc00tmH2fDSEJ+WCg9q5hI1Y
         jYS3FEqjqiTSn75uXwcjarIYxAoAK7fH9MR1rR3TZwhTTSU5w+89Rp+tpeo+lSOcYmdu
         yffUwByndJTk/ACss0RmqOLUNGQSKl00YjGO2GJa4rm68Kqz5Fv4oAZhuTSqaod3KU5m
         h3ZZoRaEuwL8KscGkjb7zSCt9Ao4OjGsFDLYBy5fM61Hk/ZLBrPJ0Oetft+qAY6fdL21
         O8VQ==
X-Gm-Message-State: AOAM530uSrTHVClQxgMz3wJp5MoEotKRNxR4lSVaGRRdpFaVpvIlCA5G
        nGgl9egntyssKlVFND3vBgtq0nI=
X-Google-Smtp-Source: ABdhPJyIch8GVJL4w7nrHJMHGWxgT6FV0mQw9ZNNo6Ko0q38HKIAU5ZDqISC3Io0os18G3/Bc2grOV4=
X-Received: from pcc-desktop.svl.corp.google.com ([2620:15c:2ce:200:7c5b:5407:a2db:c8fb])
 (user=pcc job=sendgmr) by 2002:a25:abf3:: with SMTP id v106mr2304897ybi.299.1625266639324;
 Fri, 02 Jul 2021 15:57:19 -0700 (PDT)
Date:   Fri,  2 Jul 2021 15:57:05 -0700
In-Reply-To: <20210702225705.2477947-1-pcc@google.com>
Message-Id: <20210702225705.2477947-3-pcc@google.com>
Mime-Version: 1.0
References: <20210702225705.2477947-1-pcc@google.com>
X-Mailer: git-send-email 2.32.0.93.g670b81a890-goog
Subject: [PATCH v3 2/2] selftest: use mmap instead of posix_memalign to
 allocate memory
From:   Peter Collingbourne <pcc@google.com>
To:     Catalin Marinas <catalin.marinas@arm.com>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Dave Martin <Dave.Martin@arm.com>,
        Will Deacon <will@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>
Cc:     Peter Collingbourne <pcc@google.com>,
        Alistair Delva <adelva@google.com>,
        Lokesh Gidra <lokeshgidra@google.com>,
        William McVicker <willmcvicker@google.com>,
        Evgenii Stepanov <eugenis@google.com>,
        Mitch Phillips <mitchp@google.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-mm@kvack.org, Andrey Konovalov <andreyknvl@gmail.com>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This test passes pointers obtained from anon_allocate_area to the
userfaultfd and mremap APIs. This causes a problem if the system
allocator returns tagged pointers because with the tagged address ABI
the kernel rejects tagged addresses passed to these APIs, which would
end up causing the test to fail. To make this test compatible with
such system allocators, stop using the system allocator to allocate
memory in anon_allocate_area, and instead just use mmap.

Co-developed-by: Lokesh Gidra <lokeshgidra@google.com>
Signed-off-by: Lokesh Gidra <lokeshgidra@google.com>
Signed-off-by: Peter Collingbourne <pcc@google.com>
Fixes: c47174fc362a ("userfaultfd: selftest")
Cc: <stable@vger.kernel.org> # 5.4
Link: https://linux-review.googlesource.com/id/Icac91064fcd923f77a83e8e133f8631c5b8fc241
---
 tools/testing/selftests/vm/userfaultfd.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/vm/userfaultfd.c b/tools/testing/selftests/vm/userfaultfd.c
index f5ab5e0312e7..d0f802053dfd 100644
--- a/tools/testing/selftests/vm/userfaultfd.c
+++ b/tools/testing/selftests/vm/userfaultfd.c
@@ -197,8 +197,10 @@ static int anon_release_pages(char *rel_area)
 
 static void anon_allocate_area(void **alloc_area)
 {
-	if (posix_memalign(alloc_area, page_size, nr_pages * page_size)) {
-		fprintf(stderr, "out of memory\n");
+	*alloc_area = mmap(NULL, nr_pages * page_size, PROT_READ | PROT_WRITE,
+			   MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
+	if (*alloc_area == MAP_FAILED) {
+		fprintf(stderr, "anon memory mmap failed\n");
 		*alloc_area = NULL;
 	}
 }
-- 
2.32.0.93.g670b81a890-goog


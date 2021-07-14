Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9716B3C91D1
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 22:10:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235949AbhGNULc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 16:11:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243074AbhGNUKW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Jul 2021 16:10:22 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6707AC00571B
        for <stable@vger.kernel.org>; Wed, 14 Jul 2021 12:54:46 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id p63-20020a25d8420000b029055bc6fd5e5bso4249662ybg.9
        for <stable@vger.kernel.org>; Wed, 14 Jul 2021 12:54:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=B2T/QoILMvWNJwGEC8KUZ3dRqSE7FSHo/f6R3sq7KQ0=;
        b=XZsShrzrStmjVySs21Gzk2A2FMCDoAPRdGrEO2gWNOpRoYsuDg8nW1yTSHBtW/k5lr
         qtwJsxcGpiaqdZLPzbgcwOuod9AVtpIpJ9JGbyVnZ7C85SNBdB7CRkXBY442pdSdx3Ji
         VjTkW53yAnDvSJUGrSRXLw2zrOgNRXsMHn9lkeEl+tjAw9jAz/6DhNvgBEarrZybI8gr
         bk8n1dUNlf9vKF27JWWt7aMSl7rZf3fZaVz2+7l/HMtvjCKTYIkGw/jQBryZQYpaAmSH
         UKvID81ySSnv9WulZYDkG3dWXTWeQsexbhyMo3JKuIlM6nSuE4Mtgkh0icAlJ4k/OurB
         9dXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=B2T/QoILMvWNJwGEC8KUZ3dRqSE7FSHo/f6R3sq7KQ0=;
        b=MoJW9Cby0OhNCfpLG2H7CNRP+kPwWkGYkInYvRKJFwxDgaWIUEfOjtmLPQxnkhP20J
         C4DkMtacaAHus5jnT6c7l60Azkr/iUny5iSiT+8UPIT6Q4OavLtvbXQmgXVo3yRCa6qe
         /uJeGgWbYAyHdeL88Vs/fMdVHpDqXPQ5ZptQJCYUvTVou6OSMvF3PwLAzvyIhxo5x22p
         B9L/sUlpVr0YrikGUWIasgjp3N4SYSS/CAuDKmllIWFF+fbLNtI7ngv2QNPayRtdqeFm
         cGpSXp2zn4evnbS5tC+ylf6DmTJqFui62fJ3axP8h/k3IdIWrwwIWLEwbr48BhN+Zdnb
         1bnw==
X-Gm-Message-State: AOAM531ymD1jVtUbQLp0Zo0WOhVcquu3LvL5R4eFVRRG1Z7A+f79lcnJ
        ujXcmWbtCjr79JlDZL4hhteReew=
X-Google-Smtp-Source: ABdhPJxHHuofGRrNpyWOKcdgFFhfd4tvNc6mNmwkGOkCIjfVdw6REnbEpqsPyP88Cl2HzCm8oQINk34=
X-Received: from pcc-desktop.svl.corp.google.com ([2620:15c:2ce:200:a993:4290:ae1e:51db])
 (user=pcc job=sendgmr) by 2002:a25:2651:: with SMTP id m78mr15159674ybm.372.1626292485613;
 Wed, 14 Jul 2021 12:54:45 -0700 (PDT)
Date:   Wed, 14 Jul 2021 12:54:37 -0700
In-Reply-To: <20210714195437.118982-1-pcc@google.com>
Message-Id: <20210714195437.118982-3-pcc@google.com>
Mime-Version: 1.0
References: <20210714195437.118982-1-pcc@google.com>
X-Mailer: git-send-email 2.32.0.93.g670b81a890-goog
Subject: [PATCH v5 2/2] selftest: use mmap instead of posix_memalign to
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
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Fixes: c47174fc362a ("userfaultfd: selftest")
Cc: <stable@vger.kernel.org> # 5.4
Link: https://linux-review.googlesource.com/id/Icac91064fcd923f77a83e8e133f8631c5b8fc241
---
v5:
- rebase to 5.14rc1

N.B. when backporting to stable branches, please use the v4 of
this patch:
https://lore.kernel.org/linux-mm/20210707184313.3697385-3-pcc@google.com/

 tools/testing/selftests/vm/userfaultfd.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/vm/userfaultfd.c b/tools/testing/selftests/vm/userfaultfd.c
index e363bdaff59d..2ea438e6b8b1 100644
--- a/tools/testing/selftests/vm/userfaultfd.c
+++ b/tools/testing/selftests/vm/userfaultfd.c
@@ -210,8 +210,10 @@ static void anon_release_pages(char *rel_area)
 
 static void anon_allocate_area(void **alloc_area)
 {
-	if (posix_memalign(alloc_area, page_size, nr_pages * page_size))
-		err("posix_memalign() failed");
+	*alloc_area = mmap(NULL, nr_pages * page_size, PROT_READ | PROT_WRITE,
+			   MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
+	if (*alloc_area == MAP_FAILED)
+		err("mmap of anonymous memory failed");
 }
 
 static void noop_alias_mapping(__u64 *start, size_t len, unsigned long offset)
-- 
2.32.0.93.g670b81a890-goog


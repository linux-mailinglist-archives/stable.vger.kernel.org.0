Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E36383BEFA4
	for <lists+stable@lfdr.de>; Wed,  7 Jul 2021 20:43:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232460AbhGGSqG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Jul 2021 14:46:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232532AbhGGSqG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Jul 2021 14:46:06 -0400
Received: from mail-qv1-xf4a.google.com (mail-qv1-xf4a.google.com [IPv6:2607:f8b0:4864:20::f4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0094C061574
        for <stable@vger.kernel.org>; Wed,  7 Jul 2021 11:43:24 -0700 (PDT)
Received: by mail-qv1-xf4a.google.com with SMTP id dj4-20020a0562140904b029028f9edbbb48so2264573qvb.23
        for <stable@vger.kernel.org>; Wed, 07 Jul 2021 11:43:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=Rhp3BKIpjKyJeRxRqWuyTX92X8tONQf5DKJFV9GgdPE=;
        b=c/OqeybiDBJu1t6JnaImpv47tr2Ob0KDl0V73uPNIXEH2QZYKXxQnns6XmMwV5PLxM
         8Lj2jF4NV17b4XKzFfqhxNVcR7ovkTKc/cy3lE3VBcvEvyrNtzEVl9w2WePyv2qJ7xss
         r+NQ7UzBdNLrW20P13Hq36xiS59Vb0/nM4mGlpqbdvQWHIDPM2Ur18UNSrdYL6ABJmDd
         KTd/IBgRuVkWgYVsc5gcK0EP2CvWtT2yg4LciWdSb2dj6y9C3u6TO1QKShMays8o2JA9
         FTyErolmjpvcq1GyTfiDU7whOe/7OuHlEWgIa0n1jJ1p+kHfmTIoPn++tjr88p9OOv9t
         5omw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Rhp3BKIpjKyJeRxRqWuyTX92X8tONQf5DKJFV9GgdPE=;
        b=UMCf/7cE0DaXQow2GjOQ7Q57D0KxOWmFCHYzUdx59e3oT6+WWFrVFIoZJOuZRnBpZy
         K1P343/MFwnmXE2ucuKQ+Vi8CevjuxVKOI/U0mBeS7vCE+hRidb/iE02RkmND2MYjAUm
         /2yQcm786mMS93MYQySQIEWERCSOykofOyj7jZCDndqSgk7QV50XgAdgFmwIuDoVotHR
         sOchXwTCfZJRewOOyp4gYIKe6Idyif9jzLRb/qVWryFoFMH9i6pJET4GS9fDfuOTizRV
         T7uZ3SWFQV55Y+FN+LgptG5naqIGACnB4lEUHIeeEB4+O4aeLDC4FUTthjTJXuSf7K1u
         YUxQ==
X-Gm-Message-State: AOAM531djOMYxicCj/cq2FghUfRHspi036JEeGoeAM8oyHdNu7jycOJW
        fJnmmM7xfuC25HVZsF/S30dHDrk=
X-Google-Smtp-Source: ABdhPJyek+w3/MK5+sdPwSDQnHlLoCSmddNfmUwmGCeqLHtiM1vO19K+SGLQtSdYi7FObRgFloXl5m0=
X-Received: from pcc-desktop.svl.corp.google.com ([2620:15c:2ce:200:3b71:8b83:5f3c:e3df])
 (user=pcc job=sendgmr) by 2002:a05:6214:1087:: with SMTP id
 o7mr3739459qvr.27.1625683403337; Wed, 07 Jul 2021 11:43:23 -0700 (PDT)
Date:   Wed,  7 Jul 2021 11:43:13 -0700
In-Reply-To: <20210707184313.3697385-1-pcc@google.com>
Message-Id: <20210707184313.3697385-3-pcc@google.com>
Mime-Version: 1.0
References: <20210707184313.3697385-1-pcc@google.com>
X-Mailer: git-send-email 2.32.0.93.g670b81a890-goog
Subject: [PATCH v4 2/2] selftest: use mmap instead of posix_memalign to
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


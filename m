Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3FD465C4F1
	for <lists+stable@lfdr.de>; Tue,  3 Jan 2023 18:17:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238471AbjACRRW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Jan 2023 12:17:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238470AbjACRRO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Jan 2023 12:17:14 -0500
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CE82335
        for <stable@vger.kernel.org>; Tue,  3 Jan 2023 09:17:13 -0800 (PST)
Received: by mail-io1-xd2d.google.com with SMTP id n63so16892940iod.7
        for <stable@vger.kernel.org>; Tue, 03 Jan 2023 09:17:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VNg+PezrkNPC94PV4J/awKgMOtDK6yG/59tqMM2iPMA=;
        b=fiF8gVSahNgtfnxeXumBOz+oVrUfL5gniE9juwSn/pYKMNhfLfuDuUvvo5hPqfBB6K
         Om5qAWU55+IiCyUmtG1HmDCBTxqvjCnsCax2r3F80vwpdIOzsugV/j1qYsII8MpjGpYv
         Fbf5VcVnQ5toeYSLfUDTEpFYlsQe1GZSwDVxH6ET6qT86/bEl0tXksiuInJIfy46Nwlb
         qv8Y5A2RxurQjxCe1DPQ4BNhJQccFhjBdO7bkZswPIHIq/m0JLpJ9myEswnrMiJL6DDM
         VfYOYD8MFY3/jZUOgnIquNnrj4CbE4wv0le8LilSf6HLrbY08iw+PgX9cKtgiJJWyZ1Q
         sK6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VNg+PezrkNPC94PV4J/awKgMOtDK6yG/59tqMM2iPMA=;
        b=fmTgpRuBS3xSOaOu3ED9DH0IMM0YE6LY2Fr257CgH+UeDH2aK9rUt20b/A1KJRmzvI
         qrLbmxhG6gF5z93T7EyAJ3FA2fRcsHc0Iy29R38JpXGbflTBO9RCa2sX3cJMi393DFC+
         6vD5X0fpUXA9HMIaIGwXyUAnCbofa88MeNPPuRRJ5NERXajI65np9NtMNjXWSmuv4Rtk
         HloRs65xoRmFbIiCkxYQRU0yR9Tlzl2iVM37COtzOm6wvexrYdLfsDvsE3f4C5Q9kv8Y
         X12UCFLpWanzDbbxwd7efZ2/nDSfOG+xs7bB/aEP+SE0smW7RXKmqRkimcJ74hg2LI8S
         5sOA==
X-Gm-Message-State: AFqh2kpobLoVJ9eRY+a4+i16lTPfagqOaBsfJlhIzyCOWHWyDPGsTmfj
        NxnDFnBTBMbBNWMwpkWcD4XbOhYl6N0pclpYNA+oHxTQFKiA+S/T
X-Google-Smtp-Source: AMrXdXuJvCcHXrXK/8flmbP/Bh2kcGwwqAmsZCAcW43esFn+ak7jV8bkq8TPwOr41EWVxmsi6763cmBl99D2AVMv/LA=
X-Received: by 2002:a5e:8419:0:b0:6e2:fd90:c48b with SMTP id
 h25-20020a5e8419000000b006e2fd90c48bmr3123917ioj.154.1672766232750; Tue, 03
 Jan 2023 09:17:12 -0800 (PST)
MIME-Version: 1.0
References: <20230103171416.286579-1-jannh@google.com>
In-Reply-To: <20230103171416.286579-1-jannh@google.com>
From:   Jann Horn <jannh@google.com>
Date:   Tue, 3 Jan 2023 18:16:36 +0100
Message-ID: <CAG48ez1mCg4ROuMdTsJZScCZqNSurP0qk7cOkZKEOQT+JgJMUw@mail.gmail.com>
Subject: Re: [PATCH v3 stable 4.9,4.14 1/2] mm/khugepaged: fix GUP-fast
 interaction by sending IPI
To:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 3, 2023 at 6:14 PM Jann Horn <jannh@google.com> wrote:
> Since commit 70cbc3cc78a99 ("mm: gup: fix the fast GUP race against THP
> collapse"), the lockless_pages_from_mm() fastpath rechecks the pmd_t to
> ensure that the page table was not removed by khugepaged in between.
>
> However, lockless_pages_from_mm() still requires that the page table is
> not concurrently freed.  Fix it by sending IPIs (if the architecture uses
> semi-RCU-style page table freeing) before freeing/reusing page tables.
>
> Link: https://lkml.kernel.org/r/20221129154730.2274278-2-jannh@google.com
> Link: https://lkml.kernel.org/r/20221128180252.1684965-2-jannh@google.com
> Link: https://lkml.kernel.org/r/20221125213714.4115729-2-jannh@google.com
> Fixes: ba76149f47d8 ("thp: khugepaged")
> Signed-off-by: Jann Horn <jannh@google.com>
> Reviewed-by: Yang Shi <shy828301@gmail.com>
> Acked-by: David Hildenbrand <david@redhat.com>
> Cc: John Hubbard <jhubbard@nvidia.com>
> Cc: Peter Xu <peterx@redhat.com>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> [manual backport: two of the three places in khugepaged that can free
> ptes were refactored into a common helper between 5.15 and 6.0;
> TLB flushing was refactored between 5.4 and 5.10;
> TLB flushing was refactored between 4.19 and 5.4;
> pmd collapse for PTE-mapped THP was only added in 5.4;
> ugly hack for s390 and arm in <=4.19]

Or if you just want a fixup commit, you can add this to 4.9, 4.14 and 4.19:

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 0f217bb9b534..0a4cace1cfc4 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -24,7 +24,7 @@
 #include "internal.h"

 /* gross hack for <=4.19 stable */
-#ifdef CONFIG_S390
+#if defined(CONFIG_S390) || defined(CONFIG_ARM)
 static void tlb_remove_table_smp_sync(void *arg)
 {
         /* Simply deliver the interrupt */

Let me know if you want me to send a fixup instead, since the
broken-on-arm version of this patch is already in a stable RC...

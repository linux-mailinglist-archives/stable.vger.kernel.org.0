Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AB3C391625
	for <lists+stable@lfdr.de>; Wed, 26 May 2021 13:30:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232919AbhEZLc1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 May 2021 07:32:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232221AbhEZLcS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 May 2021 07:32:18 -0400
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EDC4C0612F1;
        Wed, 26 May 2021 04:28:04 -0700 (PDT)
Received: by mail-yb1-xb35.google.com with SMTP id f9so1524717ybo.6;
        Wed, 26 May 2021 04:28:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YPuysl1KFSsvhAfL1UPdXbZ2154bTQNbmbljxazcv9E=;
        b=D/enDesMsLydsdWccL5EuuGiq+abApnQTnaT+qpKbSpEkWyz84NOkmEMPLslqCovwa
         SK2AxixBK3IYyNoaiQ/CN0cFrpDiIDWdtfy+7UL4bcy+Z1uoM3IZTG16mkuaSI7jgke/
         C1513z+uOf7ywRSfSZX3SjezOanodSfttgh4kYPK0zOBqSo3hXSmPFC77+MXpzKSPAFq
         n+fatfmglO3YUh7lH/N2A7MzLKODBQJWHz2scquNy3Yflho0m3XaPzPbEd1YMbW21BQJ
         Bv5a4JJUjqQINbKwlPQpSfwmA59+vyX8YmH5ygJ9EqeZ229AT6Z6VUWEfx6FWsZX9BnU
         lQEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YPuysl1KFSsvhAfL1UPdXbZ2154bTQNbmbljxazcv9E=;
        b=Zhke4OZA+aELYPy3JIRk1ve0H0Xcvu//M9dgzjuAqsAdvqpc4FTRjM5bh+k7xqA4zc
         BPlcwWy2EYKHZ+/U/6diLcqhXKbCvgxEovdt/x125yf/ym7uGCzpkTT7i6flSGlCwV8C
         5ICgJm1WSokdTrm6p8SD1tE43FnMY5ysjbl/iNuWGjmAq6LLJoRCTLKw4CLy0JXYXZs/
         NDdei4LfdQq+gJPWBOflKHVV05hQKVUw8sTQwzCMDpaZr+ampEpTcDUKNXiP1k4QDxmW
         cFZ9a9raQReB1Jo2R7an91sXju6tIgzCH410NHp+LcEbwZHJajwZ3Fhpgse7wWqUOALv
         lnLg==
X-Gm-Message-State: AOAM531KmK2xsiMdHiJYYWiks9wH9jyVbDTGKneyQHe0ye8igSr8vtbv
        QOuvun1WByiyH+RKrqufzbBuFbfNJQAEHSz1lMc=
X-Google-Smtp-Source: ABdhPJxcf0NDc02puTPTjlRoiMO/Z5BDI0CO5aTod/BOpMwDPy+iFkeahvntnN1mbq9VLsc5BnjSLNS4k4lC9jGuHvA=
X-Received: by 2002:a25:c7c9:: with SMTP id w192mr12776060ybe.101.1622028483507;
 Wed, 26 May 2021 04:28:03 -0700 (PDT)
MIME-Version: 1.0
References: <20210525130043.186290-1-gerald.schaefer@linux.ibm.com> <20210525130043.186290-2-gerald.schaefer@linux.ibm.com>
In-Reply-To: <20210525130043.186290-2-gerald.schaefer@linux.ibm.com>
From:   Anatoly Pugachev <matorola@gmail.com>
Date:   Wed, 26 May 2021 14:27:52 +0300
Message-ID: <CADxRZqxdPodO8y+u=R4HB_727pjmXZFt8M5PPhg_qSsT1S-saQ@mail.gmail.com>
Subject: Re: [PATCH 1/1] mm/debug_vm_pgtable: fix alignment for pmd/pud_advanced_tests()
To:     Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        linux-sparc <sparclinux@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 25, 2021 at 4:03 PM Gerald Schaefer
<gerald.schaefer@linux.ibm.com> wrote:
>
> In pmd/pud_advanced_tests(), the vaddr is aligned up to the next pmd/pud
> entry, and so it does not match the given pmdp/pudp and (aligned down) pfn
> any more.
>
> For s390, this results in memory corruption, because the IDTE instruction
> used e.g. in xxx_get_and_clear() will take the vaddr for some calculations,
> in combination with the given pmdp. It will then end up with a wrong table
> origin, ending on ...ff8, and some of those wrongly set low-order bits will
> also select a wrong pagetable level for the index addition. IDTE could
> therefore invalidate (or 0x20) something outside of the page tables,
> depending on the wrongly picked index, which in turn depends on the random
> vaddr.
>
> As result, we sometimes see "BUG task_struct (Not tainted): Padding
> overwritten" on s390, where one 0x5a padding value got overwritten with
> 0x7a.
>
> Fix this by aligning down, similar to how the pmd/pud_aligned pfns are
> calculated.
>
> Fixes: a5c3b9ffb0f40 ("mm/debug_vm_pgtable: add tests validating advanced arch page table helpers")
> Cc: <stable@vger.kernel.org> # v5.9+
> Signed-off-by: Gerald Schaefer <gerald.schaefer@linux.ibm.com>

boot tested on sparc64 with quick run of stress-ng ( --class memory
--sequential -1 --timeout 10s -v --pathological --oomable
--metrics-brief )
stress-ng: debug: [371408] system: Linux ttip
5.13.0-rc3-00043-gad9f25d33860-dirty #218 SMP Wed May 26 11:55:54 MSK
2021 sparc64

Tested-by: Anatoly Pugachev <matorola@gmail.com>

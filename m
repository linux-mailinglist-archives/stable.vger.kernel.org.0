Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07BD62E23E9
	for <lists+stable@lfdr.de>; Thu, 24 Dec 2020 04:10:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728470AbgLXDJz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Dec 2020 22:09:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728357AbgLXDJy (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Dec 2020 22:09:54 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F187C061794;
        Wed, 23 Dec 2020 19:09:14 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id z21so778518pgj.4;
        Wed, 23 Dec 2020 19:09:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=9YZIn5r9a16cJmb80iAADW/k9YKcZBQhhaz7cSUNZQQ=;
        b=GXqTETn+JJ3Z+Wt/ra82ifel909kps/sWbceWAZcCu2eRwX2sou8hGWtU1nDtWUeAq
         bKo1GkOt0ps7mIKK/Xrfz4cWHR4Y2u3lZ+Lo13L3qS00yzdUvTmvIhnl60A4hG5YUQTp
         hEDyKPZvgoC9sm5ChGywNwtrmAwyn8eX+qKqvaHhRzZHaxJpqKVhs8vhQ2wVN7FakaRF
         yFm5BtvLWfkmiHpOToMEqdISmNfxH8Xt2kvFXo0q0CL+a35Kdi+MPBuVn8giFgSc+aB4
         jF89vtd8BU90Oqfv3u4eW9BxpPqvpDhRmWukoESHT0JAyfWBNYHC57y0qugYf4Hbc4ZZ
         pb1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=9YZIn5r9a16cJmb80iAADW/k9YKcZBQhhaz7cSUNZQQ=;
        b=F/NwIqmJJf/w/3bwOR9SqrmjmU5SMVmWSUfoSdypeO3sVxalBlCEsq3p1L19agEo9F
         tj/caldpoV9IqianLIfs45Pe5hkW2Fw6DZz87qV/Y41svvE2W8kMR7LCN2HpD/5SYr2F
         US+rpO7a+dfyI3CFCjOf3Toxgzu8xVJ77ONuLrZksHqrDbdHMyo2ZFpCF6neFGuxASA+
         c9J5Uc7i9BhD9A7LNB7jiwAwiRoCWFJnLd0sbf6173oN8uAR77VOSAF62lUlu1iJZnzH
         wOY88lk/B5VQYT5fhTzkTq6gPsUHfj3t4DwYxGl97jvAkPpweCE4xgLhd4iCCnNqtv6a
         SGHQ==
X-Gm-Message-State: AOAM532WUFCumAL2OEeWweKYJshvVF9AzROGvSsFyqPt9CA8FQ7is+4F
        y6lnhHoDOdlxIO9QzW4iXG0=
X-Google-Smtp-Source: ABdhPJw4q3WD3Ssxx5LcXqadho/lRYLUCDdlNnQp6VM4GiGI0ojvprpCP9WUbWiIGD9fnT2qvxf7Aw==
X-Received: by 2002:a63:794:: with SMTP id 142mr26785898pgh.187.1608779353843;
        Wed, 23 Dec 2020 19:09:13 -0800 (PST)
Received: from ?IPv6:2601:647:4700:9b2:50a2:5929:401b:705e? ([2601:647:4700:9b2:50a2:5929:401b:705e])
        by smtp.gmail.com with ESMTPSA id cu4sm889005pjb.18.2020.12.23.19.09.11
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 23 Dec 2020 19:09:12 -0800 (PST)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.4\))
Subject: Re: [PATCH] mm/userfaultfd: fix memory corruption due to writeprotect
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <X+P2OnR+ipY8d2qL@redhat.com>
Date:   Wed, 23 Dec 2020 19:09:10 -0800
Cc:     Andy Lutomirski <luto@amacapital.net>, Yu Zhao <yuzhao@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Xu <peterx@redhat.com>, linux-mm <linux-mm@kvack.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Pavel Emelyanov <xemul@openvz.org>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>,
        stable <stable@vger.kernel.org>,
        Minchan Kim <minchan@kernel.org>,
        Will Deacon <will@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <3A6A1049-24C6-4B2D-8C59-21B549F742B4@gmail.com>
References: <X+PE38s2Egq4nzKv@google.com>
 <C332B03D-30B1-4C9C-99C2-E76988BFC4A1@amacapital.net>
 <X+P2OnR+ipY8d2qL@redhat.com>
To:     Andrea Arcangeli <aarcange@redhat.com>
X-Mailer: Apple Mail (2.3608.120.23.2.4)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> On Dec 23, 2020, at 6:00 PM, Andrea Arcangeli <aarcange@redhat.com> =
wrote:
>=20
> On Wed, Dec 23, 2020 at 05:21:43PM -0800, Andy Lutomirski wrote:
>> I don=E2=80=99t love this as a long term fix. AFAICT we can have =
mm_tlb_flush_pending set for quite a while =E2=80=94 mprotect seems like =
it can wait in IO while splitting a huge page, for example. That gives =
us a window in which every write fault turns into a TLB flush.
>=20
> mprotect can't run concurrently with a page fault in the first place.
>=20
> One other near zero cost improvement easy to add if this would be "if
> (vma->vm_flags & (VM_SOFTDIRTY|VM_UFFD_WP))" and it could be made
> conditional to the two config options too.
>=20
> Still I don't mind doing it in some other way, uffd-wp has much easier
> time doing it in another way in fact.
>=20
> Whatever performs better is fine, but queuing up pending invalidate
> ranges don't look very attractive since it'd be a fixed cost that we'd
> always have to pay even when there's no fault (and there can't be any
> fault at least for mprotect).

I think there are other cases in which Andy=E2=80=99s concern is =
relevant
(MADV_PAGEOUT).

Perhaps holding some small bitmap based on part of the deferred flushed
pages (e.g., bits 12-17 of the address or some other kind of a single
hash-function bloom-filter) would be more performant to avoid (most)
unnecessary TLB flushes. It will be cleared before a TLB flush and set =
while
holding the PTL.

Checking if a flush is needed, under the PTL, would require a single =
memory
access (although potentially cache miss). It will however require one =
atomic
operation for each page-table whose PTEs=E2=80=99 flushes are deferred - =
in contrast
to the current scheme which requires two atomic operations for the =
*entire*
operation.


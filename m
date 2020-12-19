Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B5622DF1ED
	for <lists+stable@lfdr.de>; Sat, 19 Dec 2020 23:07:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726332AbgLSWGy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 19 Dec 2020 17:06:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726086AbgLSWGx (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 19 Dec 2020 17:06:53 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 720B6C0613CF;
        Sat, 19 Dec 2020 14:06:06 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id lb18so3395579pjb.5;
        Sat, 19 Dec 2020 14:06:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=ZeuDbNPJjdCrxnc/whXpP5CtWhYRV2UKLbSIgMwSJ3s=;
        b=oIThQ+pmjJQj8vfLoSfRI9DcL3jQ5AqhtrrP5x28pUWjyrPz+5GCwCJMKq3oXTpUOx
         5fRC4wFYo/t245fCxQGJw7QwW7TaXcRIFDg2OPRoFR/loAKuD4N+r930ZcpaFW6LiptM
         MpPxK/37XkPcF2Vd2WnxVgVmZyjH1r+H4qPs+GoTRUDtPksL438gpmhJJ3Br65vkf/AD
         TFHCDG7StvWy5uJD4tTOf3mhr4KlBrczxb3WevYb2ZrVzEvkaNn8Q+9nXKPWGbI+eX6L
         +6TW1aYbf/Ub0dcc2/f7dAkOP10wPcU1HfFlozBPR6M2cACoKBhiXqFyhxOhva6CVkzm
         B2+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=ZeuDbNPJjdCrxnc/whXpP5CtWhYRV2UKLbSIgMwSJ3s=;
        b=O5NAKE6jT3djeb81FkH+sN3Vsa+POHVuD7igbDN1MBhRgpmdO9mgwHnV+8yxIHk8Ny
         1PX3ztw4dBLX8AO5eVPBE3FzVm5Fe7lKQSjoUJ0k33nT2120C/+Xex2c+EC/VaADwEMd
         iH62wy6NmTDKJflEZ+iqrm34OPHdf12aNk6rtbdqlzI+c+eoZd174CgFHeiqZpHjNeUB
         sbD9G5ewN5S3DZL1Hx3BWTN9WIKwuVQL1q5UD07gvLv96q/jsRSZxnCc1WJbuzKXjbPj
         e5LcCTri2YYMdzZ32ZN2J1wE4Ju9ijwbiDS0cXSrwbFONJw04DtLgeQKPp7bEC+RORxX
         KmRw==
X-Gm-Message-State: AOAM533idTkDZ5tlcwIYFPhCw16zpDzaXW5MUmKjyWbU4pjAbfsOlk4P
        rv9FyECsxUyI+rioFFbfH/8=
X-Google-Smtp-Source: ABdhPJxov/6qdC8y0CWrVUsy2gKRSlO+6b+0GpPCpXuL0XMqGU6ANXebYdF5kGNS+aeGzIstK1HZyA==
X-Received: by 2002:a17:902:e901:b029:db:c0d6:62cc with SMTP id k1-20020a170902e901b02900dbc0d662ccmr10115937pld.7.1608415565611;
        Sat, 19 Dec 2020 14:06:05 -0800 (PST)
Received: from ?IPv6:2601:647:4700:9b2:c998:6c11:32cc:4648? ([2601:647:4700:9b2:c998:6c11:32cc:4648])
        by smtp.gmail.com with ESMTPSA id er23sm10930517pjb.12.2020.12.19.14.06.03
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 19 Dec 2020 14:06:04 -0800 (PST)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.4\))
Subject: Re: [PATCH] mm/userfaultfd: fix memory corruption due to writeprotect
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <EDC00345-B46E-4396-8379-98E943723809@gmail.com>
Date:   Sat, 19 Dec 2020 14:06:02 -0800
Cc:     linux-mm <linux-mm@kvack.org>, Peter Xu <peterx@redhat.com>,
        lkml <linux-kernel@vger.kernel.org>,
        Pavel Emelyanov <xemul@openvz.org>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>,
        stable@vger.kernel.org, minchan@kernel.org,
        Andy Lutomirski <luto@kernel.org>, yuzhao@google.com,
        Will Deacon <will@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <DD367393-D1B3-4A84-AF92-9C6BAEAB40DC@gmail.com>
References: <20201219043006.2206347-1-namit@vmware.com>
 <X95RRZ3hkebEmmaj@redhat.com>
 <EDC00345-B46E-4396-8379-98E943723809@gmail.com>
To:     Andrea Arcangeli <aarcange@redhat.com>
X-Mailer: Apple Mail (2.3608.120.23.2.4)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> On Dec 19, 2020, at 1:34 PM, Nadav Amit <nadav.amit@gmail.com> wrote:
>=20
> [ cc=E2=80=99ing some more people who have experience with similar =
problems ]
>=20
>> On Dec 19, 2020, at 11:15 AM, Andrea Arcangeli <aarcange@redhat.com> =
wrote:
>>=20
>> Hello,
>>=20
>> On Fri, Dec 18, 2020 at 08:30:06PM -0800, Nadav Amit wrote:
>>> Analyzing this problem indicates that there is a real bug since
>>> mmap_lock is only taken for read in mwriteprotect_range(). This =
might
>>=20
>> Never having to take the mmap_sem for writing, and in turn never
>> blocking, in order to modify the pagetables is quite an important
>> feature in uffd that justifies uffd instead of mprotect. It's not the
>> most important reason to use uffd, but it'd be nice if that guarantee
>> would remain also for the UFFDIO_WRITEPROTECT API, not only for the
>> other pgtable manipulations.
>>=20
>>> Consider the following scenario with 3 CPUs (cpu2 is not shown):
>>>=20
>>> cpu0				cpu1
>>> ----				----
>>> userfaultfd_writeprotect()
>>> [ write-protecting ]
>>> mwriteprotect_range()
>>> mmap_read_lock()
>>> change_protection()
>>> change_protection_range()
>>>  ...
>>>  change_pte_range()
>>>  [ defer TLB flushes]
>>> 				userfaultfd_writeprotect()
>>> 				 mmap_read_lock()
>>> 				 change_protection()
>>> 				 [ write-unprotect ]
>>> 				 ...
>>> 				  [ unprotect PTE logically ]
>>> 				...
>>> 				[ page-fault]
>>> 				...
>>> 				wp_page_copy()
>>> 				[ set new writable page in PTE]
>>=20
>> Can't we check mm_tlb_flush_pending(vma->vm_mm) if MM_CP_UFFD_WP_ALL
>> is set and do an explicit (potentially spurious) tlb flush before
>> write-unprotect?
>=20
> There is a concrete scenario that I actually encountered and then =
there is a
> general problem.
>=20
> In general, the kernel code assumes that PTEs that are read from the
> page-tables are coherent across all the TLBs, excluding permission =
promotion
> (i.e., the PTE may have higher permissions in the page-tables than =
those
> that are cached in the TLBs).
>=20
> We therefore need to both: (a) protect change_protection_range() from =
the
> changes of others who might defer TLB flushes without taking mmap_sem =
for
> write (e.g., try_to_unmap_one()); and (b) to protect others (e.g.,
> page-fault handlers) from concurrent changes of change_protection().
>=20
> We have already encountered several similar bugs, and debugging such =
issues
> s time consuming and these bugs impact is substantial (memory =
corruption,
> security). So I think we should only stick to general solutions.
>=20
> So perhaps your the approach of your proposed solution is feasible, =
but it
> would have to be applied all over the place: we will need to add a =
check for
> mm_tlb_flush_pending() and conditionally flush the TLB in every case =
in
> which PTEs are read and there might be an assumption that the
> access-permission reflect what the TLBs hold. This includes page-fault
> handlers, but also NUMA migration code in change_protection(), =
softdirty
> cleanup in clear_refs_write() and maybe others.
>=20
> [ I have in mind another solution, such as keeping in each page-table =
a=20
> =E2=80=9Ctable-generation=E2=80=9D which is the mm-generation at the =
time of the change,
> and only flush if =E2=80=9Ctable-generation=E2=80=9D=3D=3D=E2=80=9Cmm-ge=
neration=E2=80=9D, but it requires
> some thought on how to avoid adding new memory barriers. ]
>=20
> IOW: I think the change that you suggest is insufficient, and a proper
> solution is too intrusive for =E2=80=9Cstable".
>=20
> As for performance, I can add another patch later to remove the TLB =
flush
> that is unnecessarily performed during change_protection_range() that =
does
> permission promotion. I know that your concern is about the =
=E2=80=9Cprotect=E2=80=9D case
> but I cannot think of a good immediate solution that avoids taking =
mmap_lock
> for write.
>=20
> Thoughts?

On a second thought (i.e., I don=E2=80=99t know what I was thinking), =
doing so =E2=80=94
checking mm_tlb_flush_pending() on every PTE read which is potentially
dangerous and flushing if needed - can lead to huge amount of TLB =
flushes
and shootodowns as the counter might be elevated for considerable amount =
of
time.

So this solution seems to me as a no-go.


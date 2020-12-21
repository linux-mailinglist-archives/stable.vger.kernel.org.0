Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 875E22E0233
	for <lists+stable@lfdr.de>; Mon, 21 Dec 2020 22:51:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726114AbgLUVuk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Dec 2020 16:50:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726080AbgLUVuj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Dec 2020 16:50:39 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67268C0613D3;
        Mon, 21 Dec 2020 13:49:59 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id q4so6307415plr.7;
        Mon, 21 Dec 2020 13:49:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=ENVx1TIFwWZDYQN4TlMQ6f05oWb+S//w/+xge1VzXRE=;
        b=ZnI7YCz6bvbcpuZHMNM3Pd25ADWmPny8PHFIMyqzH8pVMzkENwiACukAtcGCqw1MTo
         ZNARuDUW4LMOnzXuXqk5zRfcQ/7TQqUZ5//Wg7UlT85dMGYRZrvX75U7mdoOyqQ3r6VM
         sxrMDFYJ7tL/H3VHmDN76km+3DThwfm5YkJ0O58jn++vlribZh1CGcvSF3RXVBzwFiLh
         AT8wweAqJHTHRQ9hMRzFxVu7xhOSogL/Twr+N488veNpTBnQ2VxOQ6Q3f13u/mvEBO4R
         nb3jOQvj9YeHFpBs2vj1dct0obQKMXBXB6QT+MCfruWXOramElBoQtgPZAmXimjCdomk
         fuXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=ENVx1TIFwWZDYQN4TlMQ6f05oWb+S//w/+xge1VzXRE=;
        b=Uxe0BJWeo7ouJJByCRLkcuOt5aj9QPF+TX8+6c54CYS37THB70wp5ZwLprk8px6cVD
         J1I3ICN/txWZDjZkVQgU0GPhz5mhrdaB7YNefd3F21L13D9mFd641eVloITm6JW8xJ2r
         y0f3cHWtBUsA8898PjHQ2OJLRwmCl5MD4tXGQVZbd9/h34UccHBqpWvd+HqYCnOj4HFi
         feiMf+eCv5FmSeyJ/P9xSaNg+IN4fZy7zK2zQvGmlKLKKEPoUWyMKSQCa742/lZIJU7O
         W8UUk3eGaWpmZokpS2NfPMsj/3BeHm7zxZ7njI5sKaUiY/nOk6QdDoQkLnwhl98cWNPl
         UaeQ==
X-Gm-Message-State: AOAM530RXwYc7a/f9kODw203L+PpMdbpbAbNdW267iICf8th+XQsj007
        BNPY9P27h7VXqS/pQzxYaN4=
X-Google-Smtp-Source: ABdhPJzaluLsAc9JhO3pHoVTVI0q1cc75x5a8necdzKcNNfPjJO9k+kkJm+kbyxRttFnrmo0z1hKtQ==
X-Received: by 2002:a17:90a:c396:: with SMTP id h22mr19319869pjt.84.1608587398756;
        Mon, 21 Dec 2020 13:49:58 -0800 (PST)
Received: from ?IPv6:2601:647:4700:9b2:104c:8d35:de28:b8dc? ([2601:647:4700:9b2:104c:8d35:de28:b8dc])
        by smtp.gmail.com with ESMTPSA id 84sm18357779pfy.9.2020.12.21.13.49.56
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 21 Dec 2020 13:49:57 -0800 (PST)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.4\))
Subject: Re: [PATCH] mm/userfaultfd: fix memory corruption due to writeprotect
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <X+ESkna2z3WjjniN@google.com>
Date:   Mon, 21 Dec 2020 13:49:55 -0800
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Xu <peterx@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        linux-mm <linux-mm@kvack.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Pavel Emelyanov <xemul@openvz.org>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>,
        stable <stable@vger.kernel.org>,
        Minchan Kim <minchan@kernel.org>,
        Andy Lutomirski <luto@kernel.org>,
        Will Deacon <will@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <1FCC8F93-FF29-44D3-A73A-DF943D056680@gmail.com>
References: <X95RRZ3hkebEmmaj@redhat.com>
 <EDC00345-B46E-4396-8379-98E943723809@gmail.com>
 <X97pprdcRXusLGnq@google.com>
 <DDA15360-D6D4-46A8-95A4-5EE34107A407@gmail.com>
 <20201221172711.GE6640@xz-x1>
 <76B4F49B-ED61-47EA-9BE4-7F17A26B610D@gmail.com>
 <X+D0hTZCrWS3P5Pi@google.com>
 <CAHk-=wg_UBuo7ro1fpEGkMyFKA1+PxrE85f9J_AhUfr-nJPpLQ@mail.gmail.com>
 <9E301C7C-882A-4E0F-8D6D-1170E792065A@gmail.com>
 <CAHk-=wg-Y+svNy3CDkJjj0X_CJkSbpERLg64-Vqwq5u7SC4z0g@mail.gmail.com>
 <X+ESkna2z3WjjniN@google.com>
To:     Yu Zhao <yuzhao@google.com>
X-Mailer: Apple Mail (2.3608.120.23.2.4)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> On Dec 21, 2020, at 1:24 PM, Yu Zhao <yuzhao@google.com> wrote:
>=20
> On Mon, Dec 21, 2020 at 12:26:22PM -0800, Linus Torvalds wrote:
>> On Mon, Dec 21, 2020 at 12:23 PM Nadav Amit <nadav.amit@gmail.com> =
wrote:
>>> Using mmap_write_lock() was my initial fix and there was a strong =
pushback
>>> on this approach due to its potential impact on performance.
>>=20
>> =46rom whom?
>>=20
>> Somebody who doesn't understand that correctness is more important
>> than performance? And that userfaultfd is not the most important part
>> of the system?
>>=20
>> The fact is, userfaultfd is CLEARLY BUGGY.
>>=20
>>          Linus
>=20
> Fair enough.
>=20
> Nadav, for your patch (you might want to update the commit message).

Yes, the commit message is completely off. Will fix.

Thanks for your guidance and assistance.

>=20
> Reviewed-by: Yu Zhao <yuzhao@google.com>
>=20
> While we are all here, there is also clear_soft_dirty() that could
> use a similar fix=E2=80=A6

Let me try to build a small reproducer for clear_soft_dirty() and then =
I=E2=80=99ll
send another patch for it too.

BTW: In general, I think that you are right, and that changing of PTEs
should not require taking mmap_lock for write. However, I am not sure
cow_user_page() is not the only one that poses a problem and whether a =
more
systematic solution is needed. If cow_user_pages() is the only problem, =
do
you think it is possible to do the copying while holding the PTL? It =
works
for normal-pages, but I am not sure whether special-pages pose special
problems.

Anyhow, this is an enhancement that we can try later.

Thanks again,
Nadav=

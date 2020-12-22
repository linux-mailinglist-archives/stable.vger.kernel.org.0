Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4309D2E0F53
	for <lists+stable@lfdr.de>; Tue, 22 Dec 2020 21:21:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727409AbgLVUUe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 15:20:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727402AbgLVUUd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Dec 2020 15:20:33 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4FB2C0613D3;
        Tue, 22 Dec 2020 12:19:53 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id e2so7974885plt.12;
        Tue, 22 Dec 2020 12:19:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=j4sUJIy8wLuwpZsZfzIF114nw0eLg2dUa60AVRCoc8g=;
        b=SlSrm1Zf8I148uovJZ4yrLOIIiMXlHyoYYswc9MaAYCxM2v+qS//fKYPvao7/elQo9
         QPT7eIDI6IkiUT+z1qF1bRKgaclRQVMwD3XhSQ0Prj6JzYG7fg8MhFr4Y+tknVV5l0Oq
         AFUMYg6U6r4eexQY4rUeZF1OOKC6ZzTdcIyGrIKsWVHuGj7lVUyjGIMbVE3FbfFfiAZI
         J/KFi78UdE+isI8e0223fb/ieu4zoh/W8qIS4uL+hT5suTLarOkI61X4ZcaMaFzumFRD
         DxX1lPilLYAzmtQaXuJACeBrwQe0j2GHVhBg9WL7mw+f0OPj/adTmTi47rPZM0HxUi3P
         lnyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=j4sUJIy8wLuwpZsZfzIF114nw0eLg2dUa60AVRCoc8g=;
        b=KKWORjyqC8cXBWrbdW3w8Zcsg3hOHYFyEZJNNus71h0jDK4foEXaXUm6+WhlrTsLIj
         aH076vyul5ao0qBo4ODBp0gBitRcwhlqTtdnKr5xWB9sv2//yfYP6xEbNsiE9rMMZGzc
         XLDtCLPc6jQ8lBEoY3KEN2NwIGSH3OAJVd2y9JGmfss3en9xoniE6Qh6Tm7Q0DojFVTF
         sLQLCDh35aDaZRL/Vc9yTwZ2PfGiWNWrbR0A+cSQxFKjXEhy07XH0zlVHNqcddsVwUB5
         qtEkcWOeiyS3Jgs+p9mIz9pbbML9zGJAHSQCdObi5kgvLX60l8OR+pgYhSUk/umgMRyW
         ORog==
X-Gm-Message-State: AOAM533c1g+BU8ga2F2JFHIeuN07/QbTtTjtODuRe+n7XxdXAhS7OQqR
        Qn8t8QR599LbigbxBAvmN1c=
X-Google-Smtp-Source: ABdhPJzbbZJAZ9xswxx5s+dKtNYOGHbcK8PivtV62oYliLZktRGGHuObQH+oZ+72B+bmbjVVNeQfXg==
X-Received: by 2002:a17:90a:5782:: with SMTP id g2mr24259306pji.124.1608668393091;
        Tue, 22 Dec 2020 12:19:53 -0800 (PST)
Received: from ?IPv6:2601:647:4700:9b2:9423:6a08:cbd0:8220? ([2601:647:4700:9b2:9423:6a08:cbd0:8220])
        by smtp.gmail.com with ESMTPSA id bf3sm20719301pjb.45.2020.12.22.12.19.50
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 22 Dec 2020 12:19:51 -0800 (PST)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.4\))
Subject: Re: [PATCH] mm/userfaultfd: fix memory corruption due to writeprotect
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <X+JMiHv+EktzyZgr@redhat.com>
Date:   Tue, 22 Dec 2020 12:19:49 -0800
Cc:     Peter Xu <peterx@redhat.com>, Yu Zhao <yuzhao@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
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
Message-Id: <E9A1084A-30B3-4328-8B0D-31AD978375AD@gmail.com>
References: <20201221172711.GE6640@xz-x1>
 <76B4F49B-ED61-47EA-9BE4-7F17A26B610D@gmail.com>
 <X+D0hTZCrWS3P5Pi@google.com>
 <CAHk-=wg_UBuo7ro1fpEGkMyFKA1+PxrE85f9J_AhUfr-nJPpLQ@mail.gmail.com>
 <9E301C7C-882A-4E0F-8D6D-1170E792065A@gmail.com>
 <CAHk-=wg-Y+svNy3CDkJjj0X_CJkSbpERLg64-Vqwq5u7SC4z0g@mail.gmail.com>
 <X+ESkna2z3WjjniN@google.com>
 <1FCC8F93-FF29-44D3-A73A-DF943D056680@gmail.com>
 <20201221223041.GL6640@xz-x1>
 <B8095F3C-81E3-4AF9-A6A5-F597D51264BD@gmail.com>
 <X+JMiHv+EktzyZgr@redhat.com>
To:     Andrea Arcangeli <aarcange@redhat.com>
X-Mailer: Apple Mail (2.3608.120.23.2.4)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> On Dec 22, 2020, at 11:44 AM, Andrea Arcangeli <aarcange@redhat.com> =
wrote:
>=20
> On Mon, Dec 21, 2020 at 02:55:12PM -0800, Nadav Amit wrote:
>> wouldn=E2=80=99t mmap_write_downgrade() be executed before =
mprotect_fixup() (so
>=20
> I assume you mean "in" mprotect_fixup, after change_protection.
>=20
> If you would downgrade the mmap_lock to read there, then it'd severely
> slowdown the non contention case, if there's more than vma that needs
> change_protection.
>=20
> You'd need to throw away the prev->vm_next info and you'd need to do a
> new find_vma after droping the mmap_lock for reading and re-taking the
> mmap_lock for writing at every iteration of the loop.
>=20
> To do less harm to the non-contention case you could perhaps walk
> vma->vm_next and check if it's outside the mprotect range and only
> downgrade in such case. So let's assume we intend to optimize with
> mmap_write_downgrade only the last vma.
=E2=80=A6

I read in detail your response and you make great points. To be fair,
I did not think it through and just tried to make a point that not
taking mmap_lock for write is an unrelated optimization.

So you make a great point that it is actually related and can only(?)
benefit uffd and arguably soft-dirty, to which I am going to add
mmap_write_lock().

Yet, my confidence in doing the optimization that you suggested (keep =
using
mmap_read_lock()) as part of the bug fix is very low and just got lower
since we discussed. So I do want in the future to try to avoid the =
overheads
I introduce (sorry), but it requires a systematic solution and some =
thought.

Perhaps any change to PTE in a page-table should increase a page-table
generation that we would save in the page-table page-struct (next to the
PTL) and pte_same() would also look at the original and updated =
"page-table
generation=E2=80=9D when it checks if a PTE changed. So if a PTE went =
through
not-writable -> writable -> not-writable cycle without a TLB flush this =
can
go detected. Yet, there is still a question of how to detect pending TLB
flushes in finer granularity to avoid frequent unwarranted TLB flushes =
while
a TLB flush is pending.

It all requires some thought, and the fact that soft-dirty appears to be
broken too indicates that bugs can get unnoticed for some time.

Sorry for being a chicken, but I prefer to be safe than sorry.=

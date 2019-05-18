Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90149220DC
	for <lists+stable@lfdr.de>; Sat, 18 May 2019 02:12:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727313AbfERAM6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 May 2019 20:12:58 -0400
Received: from mail-ua1-f67.google.com ([209.85.222.67]:34244 "EHLO
        mail-ua1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726774AbfERAM6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 May 2019 20:12:58 -0400
Received: by mail-ua1-f67.google.com with SMTP id 7so3379209uah.1
        for <stable@vger.kernel.org>; Fri, 17 May 2019 17:12:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=jqgp/AAKfQLeMa+FXIn1qxTEO8Ap0fwZ5EF6f7NI8mA=;
        b=Fq1j7oUtiICi06u8iNXtEC7qmvh4syEHGr5Mq4/Lew78h6OigQR5ARlU7EvYQ1kZ1b
         pL3kxt3eZ7UdOQuTUE+p4ve4ydMeS6hXBKWqEwdqNnIkd1Rr3wyYoLcTvpmplMokWB28
         OPELO3mssUQpXGpzu3kunZn8XVNJpzRozv82BWhR0vf3erhTd6VTSbSlMLLXtI+S13qZ
         yUDWpfCmfM24aM8VIfyL7fxRJdB5lyVGAvFv3sgMQfQ0JN9lbYL2F2RelgkazWm2zF+/
         0saqM2rW5m5k25nZBX3FvdwFAc9BV1qF9ZtkOFM0ukKomQbAlTPw5T4WDVv6qGn/ABTI
         64cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=jqgp/AAKfQLeMa+FXIn1qxTEO8Ap0fwZ5EF6f7NI8mA=;
        b=PBW/I4qkz5wOlSA2aOce7TINI8uuNh/lydo3iQMp7sPJ7qGQLqOHIJgnl6atapZxbv
         maJFdHc8Uij2IdVZZrgLHo0NZ+pzG4T5LplZxtfpUUFZmQtegAAKnjog/oEadYW8EVFb
         qmtdGTm8HG5WMs1721imMavGXgb4JH4g5+/1ojH2ZnqGyuGj/PGAzGDbIcgG4scp7qE3
         YwmkKfqTg768OFwV68Rs0XnUIB1O0NRg/hyVjTIBKMtWa5R0USIzFpqaGjpXinRffyis
         uT5aKprdi6kQQg6BQId6bT6jC/Xci/APd94WChyEs8SpncQPzlCPRCzychGft8UoDo9q
         u0Uw==
X-Gm-Message-State: APjAAAW0Xf3CI5mc88DmFPRdR2jfwTRbvB9VwEK2SQHftZjaW/adRPvQ
        PTFyGfOk+KgKBxKbKRfRtALHKUF6TgL2azkaoLn5KA==
X-Google-Smtp-Source: APXvYqw6wAGTgIFK7xCUwoa4xEUAb53JdQRVmL0FhMGxX1gn9XVKTZuOFfV0bylHnx+sB3bG0oj/Kvochg+FbdGoYNk=
X-Received: by 2002:a9f:2246:: with SMTP id 64mr30748332uad.47.1558138376557;
 Fri, 17 May 2019 17:12:56 -0700 (PDT)
MIME-Version: 1.0
References: <1558073209-79549-1-git-send-email-chenjianhong2@huawei.com>
In-Reply-To: <1558073209-79549-1-git-send-email-chenjianhong2@huawei.com>
From:   Michel Lespinasse <walken@google.com>
Date:   Fri, 17 May 2019 17:12:43 -0700
Message-ID: <CANN689G6mGLSOkyj31ympGgnqxnJosPVc4EakW5gYGtA_45L7g@mail.gmail.com>
Subject: Re: [PATCH] mm/mmap: fix the adjusted length error
To:     jianhong chen <chenjianhong2@huawei.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, mhocko@suse.com,
        Vlastimil Babka <vbabka@suse.cz>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Yang Shi <yang.shi@linux.alibaba.com>, jannh@google.com,
        steve.capper@arm.com, tiny.windzz@gmail.com,
        LKML <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I worry that the proposed change turns the search from an O(log N)
worst case into a O(N) one.

To see why the current search is O(log N), it is easiest to start by
imagining a simplified search algorithm that wouldn't include the low
and high address limits. In that algorithm, backtracking through the
vma tree is never necessary - the tree walk can always know, prior to
going left or right, if a suitable gap will be found in the
corresponding subtree.

The code we have today does have to respect the low and high address
limits, so it does need to implement backtracking - but this
backtracking only occurs to back out of subtrees that include the low
address limit (the search went 'left' into a subtree that has a large
enough gap, but the gap turns out to be below the limit so it can't be
used and the search needs to go 'right' instead). Because of this, the
amount of backtracking that can occur is very limited, and the search
is still O(log N) in the worst case.

With your proposed change, backtracking could occur not only around
the low address limit, but also at any node within the search tree,
when it turns out that a gap that seemed large enough actually isn't
due to alignment constraints. So, the code should still work, but it
could backtrack more in the worst case, turning the worst case search
into an O(N) thing.

I am not sure what to do about this. First I would want to understand
more about your test case; is this something that you stumbled upon
without expecting it or was it an artificially constructed case to
show the limitations of the current search algorithm ? Also, if your
process does something unusual and expects to be able to map (close
to) the entirety of its address space, would it be reasonable for it
to manually manage the address space and pass explicit addresses to
mmap / shmat ?

On Thu, May 16, 2019 at 11:02 PM jianhong chen <chenjianhong2@huawei.com> w=
rote:
> In linux version 4.4, a 32-bit process may fail to allocate 64M hugepage
> memory by function shmat even though there is a 64M memory gap in
> the process.
>
> It is the adjusted length that causes the problem, introduced from
> commit db4fbfb9523c935 ("mm: vm_unmapped_area() lookup function").
> Accounting for the worst case alignment overhead, function unmapped_area
> and unmapped_area_topdown adjust the search length before searching
> for available vma gap. This is an estimated length, sum of the desired
> length and the longest alignment offset, which can cause misjudgement
> if the system has very few virtual memory left. For example, if the
> longest memory gap available is 64M, we can=E2=80=99t get it from the sys=
tem
> by allocating 64M hugepage memory via shmat function. The reason is
> that it requires a longger length, the sum of the desired length(64M)
> and the longest alignment offset.
>
> To fix this error ,we can calculate the alignment offset of
> gap_start or gap_end to get a desired gap_start or gap_end value,
> before searching for the available gap. In this way, we don't
> need to adjust the search length.
>
> Problem reproduces procedure:
> 1. allocate a lot of virtual memory segments via shmat and malloc
> 2. release one of the biggest memory segment via shmdt
> 3. attach the biggest memory segment via shmat
>
> e.g.
> process maps:
> 00008000-00009000 r-xp 00000000 00:12 3385    /tmp/memory_mmap
> 00011000-00012000 rw-p 00001000 00:12 3385    /tmp/memory_mmap
> 27536000-f756a000 rw-p 00000000 00:00 0
> f756a000-f7691000 r-xp 00000000 01:00 560     /lib/libc-2.11.1.so
> f7691000-f7699000 ---p 00127000 01:00 560     /lib/libc-2.11.1.so
> f7699000-f769b000 r--p 00127000 01:00 560     /lib/libc-2.11.1.so
> f769b000-f769c000 rw-p 00129000 01:00 560     /lib/libc-2.11.1.so
> f769c000-f769f000 rw-p 00000000 00:00 0
> f769f000-f76c0000 r-xp 00000000 01:00 583     /lib/libgcc_s.so.1
> f76c0000-f76c7000 ---p 00021000 01:00 583     /lib/libgcc_s.so.1
> f76c7000-f76c8000 rw-p 00020000 01:00 583     /lib/libgcc_s.so.1
> f76c8000-f76e5000 r-xp 00000000 01:00 543     /lib/ld-2.11.1.so
> f76e9000-f76ea000 rw-p 00000000 00:00 0
> f76ea000-f76ec000 rw-p 00000000 00:00 0
> f76ec000-f76ed000 r--p 0001c000 01:00 543     /lib/ld-2.11.1.so
> f76ed000-f76ee000 rw-p 0001d000 01:00 543     /lib/ld-2.11.1.so
> f7800000-f7a00000 rw-s 00000000 00:0e 0       /SYSV000000ea (deleted)
> fba00000-fca00000 rw-s 00000000 00:0e 65538   /SYSV000000ec (deleted)
> fca00000-fce00000 rw-s 00000000 00:0e 98307   /SYSV000000ed (deleted)
> fce00000-fd800000 rw-s 00000000 00:0e 131076  /SYSV000000ee (deleted)
> ff913000-ff934000 rw-p 00000000 00:00 0       [stack]
> ffff0000-ffff1000 r-xp 00000000 00:00 0       [vectors]
>
> from 0xf7a00000 to fba00000, it has 64M memory gap, but we can't get
> it from kernel.

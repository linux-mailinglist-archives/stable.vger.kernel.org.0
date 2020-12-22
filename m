Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A786B2E0A18
	for <lists+stable@lfdr.de>; Tue, 22 Dec 2020 13:41:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726291AbgLVMlR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 07:41:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725985AbgLVMlR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Dec 2020 07:41:17 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AE02C0613D3;
        Tue, 22 Dec 2020 04:40:37 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id c12so8384027pfo.10;
        Tue, 22 Dec 2020 04:40:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=TB4F60QO548pCqHomnEaCL5+ozw68NytWoP38NBnKCA=;
        b=MsREq1tExtJV2BAThYcxaf49OalulhowQcAw9CjEiAmzDCkyTr99T54YBESlUsfL62
         592K8hp+ZHbEPrvvdTNtNDQOjugc8a8SDR5nipb1SE8ansRqJ/cCx/2v7HMvf4puQrwQ
         Z6XfgVHi2obKxYzzmuGD4FLqrCZxBcrZfner7j0kVAm3Oi39KZHKrecBCAQ5eKI1/QaI
         R5UA6lxXwPts77gW+ODB2nUgo3GL0CFhVJM3uFtrqpQdDMQ8CVO9ev1x7UAKufQ5f8Ir
         uk0NfdJ919QtqwuoQgGqnZDFIebhiGssqQozElOXy2dCTqqx0UaI3Ly60OXgZLWQ0k7V
         I3sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=TB4F60QO548pCqHomnEaCL5+ozw68NytWoP38NBnKCA=;
        b=iKbTwRPGqJjgVhnAQSkBsClrfQQAixXJDBDvdTjrth2JWJo0U/+cshrxbFEvc1wvFt
         wUjwWYVtJNdvOo/9GxnGNck+uQXxM/n4wQIUJpuJX7D57e0jPEhicFw7FSyWV7yXBWrW
         b41cuK5Sf/nySbEUjqeSDI8kVenacyPYkG3lISEpfcaa/RKj2BKkI6C3TUuOVXBO254t
         qmFkYKJZmAgsRE2vwvuHPw5eqgIr6s4GCSlW12jtjs4zeFRyi7AyRs8x0XhCEz4+uwyO
         B16pnZ0fYW5x7nevnKaxPXwu72vAR3A/l4yknzN5rfSssbgvJWRAOelfCqDtDY4fGc92
         Gz4g==
X-Gm-Message-State: AOAM533Bc50Xv6riAhozah9iozKtY4XIMNi8FIRnq17a/0jQnOE16vZn
        8266NzjQTkqobwuXZqqDUL0=
X-Google-Smtp-Source: ABdhPJwjprE2TAyp1wE5q3AFxp4Fw9HXS0whMqpa8aqqpRtLkvBsQ+hzg92IXN/hqbV44unM9rAo5Q==
X-Received: by 2002:a63:3247:: with SMTP id y68mr19750692pgy.10.1608640836390;
        Tue, 22 Dec 2020 04:40:36 -0800 (PST)
Received: from ?IPv6:2601:647:4700:9b2:9423:6a08:cbd0:8220? ([2601:647:4700:9b2:9423:6a08:cbd0:8220])
        by smtp.gmail.com with ESMTPSA id b197sm15226113pfb.42.2020.12.22.04.40.33
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 22 Dec 2020 04:40:35 -0800 (PST)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.4\))
Subject: Re: [PATCH] mm/userfaultfd: fix memory corruption due to writeprotect
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <X+ESkna2z3WjjniN@google.com>
Date:   Tue, 22 Dec 2020 04:40:32 -0800
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Xu <peterx@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        linux-mm <linux-mm@kvack.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Pavel Emelyanov <xemul@openvz.org>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>,
        stable <stable@vger.kernel.org>,
        Andy Lutomirski <luto@kernel.org>,
        Will Deacon <will@kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <D4916F41-DE4A-42C6-8702-944382631A02@gmail.com>
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
To:     Yu Zhao <yuzhao@google.com>, Peter Zijlstra <peterz@infradead.org>,
        Minchan Kim <minchan@kernel.org>
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
>=20
> Reviewed-by: Yu Zhao <yuzhao@google.com>
>=20
> While we are all here, there is also clear_soft_dirty() that could
> use a similar fix=E2=80=A6

Just an update as for why I have still not sent v2: I fixed
clear_soft_dirty(), created a reproducer, and the reproducer kept =
failing.

So after some debugging, it appears that clear_refs_write() does not =
flush
the TLB. It indeed calls tlb_finish_mmu() but since 0758cd830494
("asm-generic/tlb: avoid potential double flush=E2=80=9D), =
tlb_finish_mmu() does not
flush the TLB since there is clear_refs_write() does not call to
__tlb_adjust_range() (unless there are nested TLBs are pending).

So I have a patch for this issue too: arguably the tlb_gather interface =
is
not the right one for clear_refs_write() that does not clear PTEs but
changes them.

Yet, sadly, my reproducer keeps falling (less frequently, but still). So =
I
will keep debugging to see what goes wrong. I will send v2 once I figure =
out
what the heck is wrong in the code or my reproducer.

For the reference, here is my reproducer:

-- >8 --

#define _GNU_SOURCE
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/mman.h>
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <fcntl.h>
#include <string.h>
#include <threads.h>
#include <stdatomic.h>

#define PAGE_SIZE	(4096)
#define TLB_SIZE	(2000)
#define N_PAGES		(300000)
#define ITERATIONS	(100)
#define N_THREADS	(2)

static int stop;
static char *m;

static int writer(void *argp)
{
	unsigned long t_idx =3D (unsigned long)argp;
	int i, cnt =3D 0;

	while (!atomic_load(&stop)) {
		cnt++;
		atomic_fetch_add((atomic_int *)m, 1);

		/*
		 * First thread only accesses the page to have it cached =
in the
		 * TLB.
		 */
		if (t_idx =3D=3D 0)
			continue;

		/*
		 * Other threads access enough entries to cause eviction =
from
		 * the TLB and trigger #PF upon the next access (before =
the TLB
		 * flush of clear_ref actually takes place).
		 */
		for (i =3D 1; i < TLB_SIZE; i++) {
			if (atomic_load((atomic_int *)(m + PAGE_SIZE * =
i))) {
				fprintf(stderr, "unexpected error\n");
				exit(1);
			}
		}
	}
	return cnt;
}

/*
 * Runs mlock/munlock in the background to raise the page-count of the =
page and
 * force copying instead of reusing the page.
 */
static int do_mlock(void *argp)
{
	while (!atomic_load(&stop)) {
		if (mlock(m, PAGE_SIZE) || munlock(m, PAGE_SIZE)) {
			perror("mlock/munlock");
			exit(1);
		}
	}
	return 0;
}

int main(void)
{
	int r, cnt, fd, total =3D 0;
	long i;
	thrd_t thr[N_THREADS];
	thrd_t mlock_thr[N_THREADS];

	fd =3D open("/proc/self/clear_refs", O_WRONLY, 0666);
	if (fd < 0) {
		perror("open");
		exit(1);
	}

	/*
	 * Have large memory for clear_ref, so there would be some time =
between
	 * the unmap and the actual deferred flush.
	 */
	m =3D mmap(NULL, PAGE_SIZE * N_PAGES, PROT_READ|PROT_WRITE,
			MAP_PRIVATE|MAP_ANONYMOUS|MAP_POPULATE, -1, 0);
	if (m =3D=3D MAP_FAILED) {
		perror("mmap");
		exit(1);
	}

	for (i =3D 0; i < N_THREADS; i++) {
		r =3D thrd_create(&thr[i], writer, (void *)i);
		assert(r =3D=3D thrd_success);
	}

	for (i =3D 0; i < N_THREADS; i++) {
		r =3D thrd_create(&mlock_thr[i], do_mlock, (void *)i);
		assert(r =3D=3D thrd_success);
	}

	for (i =3D 0; i < ITERATIONS; i++) {
		for (i =3D 0; i < ITERATIONS; i++) {
			r =3D pwrite(fd, "4", 1, 0);
			if (r < 0) {
				perror("pwrite");
				exit(1);
			}
		}
	}

	atomic_store(&stop, 1);

	for (i =3D 0; i < N_THREADS; i++) {
		r =3D thrd_join(mlock_thr[i], NULL);
		assert(r =3D=3D thrd_success);
	}

	for (i =3D 0; i < N_THREADS; i++) {
		r =3D thrd_join(thr[i], &cnt);
		assert(r =3D=3D thrd_success);
		total +=3D cnt;
	}

	r =3D atomic_load((atomic_int *)(m));
	if (r !=3D total) {
		fprintf(stderr, "failed - expected=3D%d actual=3D%d\n", =
total, r);
		exit(-1);
	}

	fprintf(stderr, "ok\n");
	return 0;
}=

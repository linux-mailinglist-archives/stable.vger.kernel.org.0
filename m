Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E527D3188A3
	for <lists+stable@lfdr.de>; Thu, 11 Feb 2021 11:53:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231177AbhBKKv5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Feb 2021 05:51:57 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:46652 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230285AbhBKKty (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Feb 2021 05:49:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613040508;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=R0teWV0bmw9KGc7LQPs2FazYpPfP/2lb4xoFRMFqLtg=;
        b=Yf/cnzxL/mi1KcY38T1a/9U2qMfYZxpHxGgvfD+vrF8PmJhduofOZTOCedg7/6Ji50BmIi
        sMyR2kUzebbcA/sMcsJZe+8ZIdU3Sa7LYufSu9Cv73Pw/euv6aelNf4CFY4tC1j3whWynt
        mBNCfctAUczv0u+X72lqK4YINdHNva0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-482-L4d7n19gMJe6KjiTGdmv4A-1; Thu, 11 Feb 2021 05:48:26 -0500
X-MC-Unique: L4d7n19gMJe6KjiTGdmv4A-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BB1A6427C3;
        Thu, 11 Feb 2021 10:48:24 +0000 (UTC)
Received: from oldenburg.str.redhat.com (ovpn-113-131.ams2.redhat.com [10.36.113.131])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6CD151F442;
        Thu, 11 Feb 2021 10:48:22 +0000 (UTC)
From:   Florian Weimer <fweimer@redhat.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org, lwn@lwn.net,
        jslaby@suse.cz, libc-alpha@sourceware.org,
        linux-api@vger.kernel.org
Subject: LINUX_VERSION_CODE overflow (was: Re: Linux 4.9.256)
References: <1612535085125226@kroah.com>
Date:   Thu, 11 Feb 2021 11:48:41 +0100
In-Reply-To: <1612535085125226@kroah.com> (Greg Kroah-Hartman's message of
        "Fri, 5 Feb 2021 15:26:18 +0100")
Message-ID: <87o8gqriba.fsf@oldenburg.str.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

* Greg Kroah-Hartman:

> I'm announcing the release of the 4.9.256 kernel.
>
> This, and the 4.4.256 release are a little bit "different" than normal.
>
> This contains only 1 patch, just the version bump from .255 to .256
> which ends up causing the userspace-visable LINUX_VERSION_CODE to
> behave a bit differently than normal due to the "overflow".
>
> With this release, KERNEL_VERSION(4, 9, 256) is the same as KERNEL_VERSIO=
N(4, 10, 0).
>
> Nothing in the kernel build itself breaks with this change, but given
> that this is a userspace visible change, and some crazy tools (like
> glibc and gcc) have logic that checks the kernel version for different
> reasons, I wanted to do this release as an "empty" release to ensure
> that everything still works properly.

As promised, I looked at this from the glibc perspective.

A dynamically linked glibc reads the LINUX_VERSION_CODE in the ELF note
in the vDSO.

Statically linked binaries use the uname system call and parse the
release field in struct utsname.  If the uname system call fails, there
is also /proc fallback, but I believe that path is unused.

The glibc dynamic linker falls back to uname if the vDSO cannot be
located.

The LINUX_VERSION_CODE format is also used in /etc/ld.so.cache.  This is
difficult to change because a newer ldconfig is supposed to build a
cache that is compatible with older glibc versions (two-way
compatibility).  The information in /etc/ld.so.cache is copied from the
ELF_NOTE_ABI/NT_GNU_ABI_TAG ELF note in the DSOs; the note format is not
subject to overflows because it uses 32-bit values for the component
versions.

glibc uses the current kernel's LINUX_VERSION_CODE for two purposes: for
its own =E2=80=9Ckernel too old=E2=80=9D check (glibc refuses to start in t=
his case),
and to skip loading DSOs which have an ELF_NOTE_ABI/NT_GNU_ABI_TAG that
indicates a higher kernel version than the current kernel.  glibc does
not use LINUX_VERSION_CODE to detect features or activate workarounds
for kernel bugs.

The overflow from 4.9.256 to 4.10.0 means that we might get spurious
passes on these checks.  Worst case, it can happen that if the system
has a DSO in two versions on the library search path, one for kernel
4.10 and one for kernel 4.9 or earlier (in that order), we now load the
4.10 version on a 4.9 kernel.  Previously, loading the 4.10 DSO failed,
and the fallback version for earlier kernels was used.  That would be
real breakage.

Our options in userspace are limited because whatever changes we make to
glibc today are unlikely to reach people running 4.4 or 4.9 kernels
anytime soon, if ever.  Clamping the sublevel field of
LINUX_VERSION_CODE in the vDSO to 255 only benefits dynamically linked
binaries, but it could be that this is sufficient to paper over this
issue.

There's also the question whether these glibc checks are valuable at
all.  It encourages kernel patching to lie about kernel versions, making
diagnostics harder (e.g., reporting 3.10 if it's really a 2.6.32 with
lots of system call backports).  The ELF_NOTE_ABI/NT_GNU_ABI_TAG DSO
selection is known to cause endless problems with Qt, basically the only
large-scale user of this feature.  Perhaps we should remove it, but it
would also break the fallback DSO approach mentioned above.

Thanks,
Florian
--=20
Red Hat GmbH, https://de.redhat.com/ , Registered seat: Grasbrunn,
Commercial register: Amtsgericht Muenchen, HRB 153243,
Managing Directors: Charles Cachera, Brian Klemm, Laurie Krebs, Michael O'N=
eill


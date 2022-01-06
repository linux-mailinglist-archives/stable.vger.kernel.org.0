Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F8F14862A7
	for <lists+stable@lfdr.de>; Thu,  6 Jan 2022 11:05:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237724AbiAFKFH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Jan 2022 05:05:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236677AbiAFKFG (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Jan 2022 05:05:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6A7EC061245;
        Thu,  6 Jan 2022 02:05:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 45A9361AC8;
        Thu,  6 Jan 2022 10:05:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 297FAC36AEB;
        Thu,  6 Jan 2022 10:05:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641463505;
        bh=G1MuhyzoSyiULxKWVRw7c76ypYM5BaPU7g3Y6YQRdKA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=xP8z0CL4w49MoSpddqTH9YCjd5+Gd9maQ3SMvFiWXT5rWBZoQ6kgkJ0KJ/uX0foUw
         lEETPoTfTsPgBkfPCdluBvNueXKfNEXkaJsgfmj0WXhpPb6LmO9RYKlsEruQqGOGTj
         ovIhGzkeT8nPCQhWbDKe9+14AW+YrgZelyVgi9Ho=
Date:   Thu, 6 Jan 2022 11:05:03 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     skhan@linuxfoundation.org, linux-stable <stable@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        lkft-triage@lists.linaro.org, X86 ML <x86@kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Jann Horn <jannh@google.com>,
        John Hubbard <jhubbard@nvidia.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Anders Roxell <anders.roxell@linaro.org>
Subject: Re: test_vsyscall.c:500:22: warning: '__builtin_memcmp_eq' specified
 bound 4096 exceeds source size 0
Message-ID: <Yda+z5aW+I8vR6Tp@kroah.com>
References: <CA+G9fYvUu9+68mkCT0S8L0gL28jc5MXGQqOGH6ObciK72FbD8A@mail.gmail.com>
 <Yda3L0givFBDZtXs@kroah.com>
 <CA+G9fYuRUsmsj+f3RXAKpvX2k=YJwxj4-_MqWzi1L-D9YdE5Cg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+G9fYuRUsmsj+f3RXAKpvX2k=YJwxj4-_MqWzi1L-D9YdE5Cg@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 06, 2022 at 03:19:59PM +0530, Naresh Kamboju wrote:
> On Thu, 6 Jan 2022 at 15:02, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > On Thu, Jan 06, 2022 at 02:55:53PM +0530, Naresh Kamboju wrote:
> > > While building selftests the following warnings were noticed for x86_64
> > > architecture on Linux stable v5.15.13 kernel.
> > >
> > > metadata:
> > >   git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
> > >   git commit: 734eb1fd2073f503f5c6b44f1c0d453ca6986b84
> > >   git describe: v5.15.13
> > >   toolchain":  gcc-11
> > >   kernel-config: https://builds.tuxbuild.com/23HFo8abXIL6i4FFfSYiJlqAYMW/config
> > >
> > > x86_64-linux-gnu-gcc -m64 -o \
> > > /home/tuxbuild/.cache/tuxmake/builds/current/kselftest/x86/test_vsyscall_64 \
> > >  -O2 -g -std=gnu99 -pthread -Wall -no-pie \
> > >  -DCAN_BUILD_64 test_vsyscall.c helpers.h -lrt -ldl
> > >
> > > test_vsyscall.c: In function 'test_process_vm_readv':
> > > test_vsyscall.c:500:22: warning: '__builtin_memcmp_eq' specified bound
> > > 4096 exceeds source size 0 [-Wstringop-overread]
> > >   500 |                 if (!memcmp(buf, (const void
> > > *)0xffffffffff600000, 4096)) {
> > >       |                      ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > >
> > > Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> > >
> > > Build link:
> > > https://builds.tuxbuild.com/23HFo8abXIL6i4FFfSYiJlqAYMW/
> > >
> > > # To install tuxmake on your system globally:
> > > # sudo pip3 install -U tuxmake
> > >
> > > tuxmake --runtime podman --target-arch x86_64 --toolchain gcc-11 \
> > >  --kconfig https://builds.tuxbuild.com/23HFo8abXIL6i4FFfSYiJlqAYMW/config \
> > >  cpupower headers kernel kselftest kselftest-merge modules
> >
> > Is this a new regression from 5.15.0?  Is it also present on Linus's tree?
> 
> This build warning is not present in Linus's tree.
> Following patch to be backported to 5.15.x
> 
> ---
> >From dd40f44eabe1e122c6852fabb298aac05b083fce Mon Sep 17 00:00:00 2001
> From: Shuah Khan <skhan@linuxfoundation.org>
> Date: Thu, 21 Oct 2021 15:33:33 -0600
> Subject: selftests: x86: fix [-Wstringop-overread] warn in
>  test_process_vm_readv()
> 
> Fix the following [-Wstringop-overread] by passing in the variable
> instead of the value.
> 
> test_vsyscall.c: In function ‘test_process_vm_readv’:
> test_vsyscall.c:500:22: warning: ‘__builtin_memcmp_eq’ specified bound
> 4096 exceeds source size 0 [-Wstringop-overread]
>   500 |                 if (!memcmp(buf, (const void
> *)0xffffffffff600000, 4096)) {
>       |                      ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>

Thanks, will go queue that up now.

greg k-h

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7B6E486226
	for <lists+stable@lfdr.de>; Thu,  6 Jan 2022 10:32:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237437AbiAFJcf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Jan 2022 04:32:35 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:53548 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236552AbiAFJcf (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Jan 2022 04:32:35 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0912961B13;
        Thu,  6 Jan 2022 09:32:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B921DC36AE5;
        Thu,  6 Jan 2022 09:32:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641461554;
        bh=ftjlVIE88difaa6YOW416g8IrMlFSVbJJ74FffwzjNg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OCsHU/ICJmjDVlFG0oUKGtRXwCPFqounhngvPBM+nR183prLmf3MsSxBjChc1IkJE
         9h58560a9all1SuCeHO5dH73N/J8tgzF0ENNo3to3Yy7aCUJg2FCaFObJvSDq2GKzq
         avsOHaik5aEo5uM59sRSZL/RE9NtZhz1UZd7uRFg=
Date:   Thu, 6 Jan 2022 10:32:31 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     linux-stable <stable@vger.kernel.org>,
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
Message-ID: <Yda3L0givFBDZtXs@kroah.com>
References: <CA+G9fYvUu9+68mkCT0S8L0gL28jc5MXGQqOGH6ObciK72FbD8A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYvUu9+68mkCT0S8L0gL28jc5MXGQqOGH6ObciK72FbD8A@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 06, 2022 at 02:55:53PM +0530, Naresh Kamboju wrote:
> While building selftests the following warnings were noticed for x86_64
> architecture on Linux stable v5.15.13 kernel.
> 
> metadata:
>   git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
>   git commit: 734eb1fd2073f503f5c6b44f1c0d453ca6986b84
>   git describe: v5.15.13
>   toolchain":  gcc-11
>   kernel-config: https://builds.tuxbuild.com/23HFo8abXIL6i4FFfSYiJlqAYMW/config
> 
> x86_64-linux-gnu-gcc -m64 -o \
> /home/tuxbuild/.cache/tuxmake/builds/current/kselftest/x86/test_vsyscall_64 \
>  -O2 -g -std=gnu99 -pthread -Wall -no-pie \
>  -DCAN_BUILD_64 test_vsyscall.c helpers.h -lrt -ldl
> 
> test_vsyscall.c: In function 'test_process_vm_readv':
> test_vsyscall.c:500:22: warning: '__builtin_memcmp_eq' specified bound
> 4096 exceeds source size 0 [-Wstringop-overread]
>   500 |                 if (!memcmp(buf, (const void
> *)0xffffffffff600000, 4096)) {
>       |                      ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> 
> Build link:
> https://builds.tuxbuild.com/23HFo8abXIL6i4FFfSYiJlqAYMW/
> 
> # To install tuxmake on your system globally:
> # sudo pip3 install -U tuxmake
> 
> tuxmake --runtime podman --target-arch x86_64 --toolchain gcc-11 \
>  --kconfig https://builds.tuxbuild.com/23HFo8abXIL6i4FFfSYiJlqAYMW/config \
>  cpupower headers kernel kselftest kselftest-merge modules

Is this a new regression from 5.15.0?  Is it also present on Linus's tree?

thanks,

greg k-h

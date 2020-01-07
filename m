Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46F511321D1
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 10:03:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726485AbgAGJCz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 04:02:55 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:46478 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726327AbgAGJCz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jan 2020 04:02:55 -0500
Received: from ip-109-41-1-227.web.vodafone.de ([109.41.1.227] helo=wittgenstein)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1ioklG-0004Nl-2G; Tue, 07 Jan 2020 09:02:50 +0000
Date:   Tue, 7 Jan 2020 10:02:27 +0100
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Amanieu d'Antras <amanieu@gmail.com>
Cc:     Will Deacon <will@kernel.org>, Will Deacon <will.deacon@arm.com>,
        linux-kernel@vger.kernel.org,
        Christian Brauner <christian@brauner.io>,
        "# 3.4.x" <stable@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        keescook@chromium.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH 2/7] arm64: Implement copy_thread_tls
Message-ID: <20200107090219.jl4py4u2zvofwnbh@wittgenstein>
References: <20200102172413.654385-1-amanieu@gmail.com>
 <20200102172413.654385-3-amanieu@gmail.com>
 <20200102180130.hmpipoiiu3zsl2d6@wittgenstein>
 <20200106173953.GB9676@willie-the-truck>
 <CA+y5pbSBYLvZ46nJP0pSYZnRohtPxHitOHPEaLXq23-QrPKk2g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CA+y5pbSBYLvZ46nJP0pSYZnRohtPxHitOHPEaLXq23-QrPKk2g@mail.gmail.com>
User-Agent: NeoMutt/20180716
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[Cc Kees in case he knows something about where arch specific tests live
 or whether we have a framework for this]

On Mon, Jan 06, 2020 at 07:03:32PM +0100, Amanieu d'Antras wrote:
> On Mon, Jan 6, 2020 at 6:39 PM Will Deacon <will@kernel.org> wrote:
> > I also ran the native and compat selftests but, unfortunately, they all
> > pass even without this patch. Do you reckon it would be possible to update
> > them to check the tls pointer?
> 
> Here's the program I used for testing on arm64. I considered adding it
> to the selftests but there is no portable way of reading the TLS
> register on all architectures.

I'm not saying you need to do this right now.
It feels like we must've run into the "this is architecture
specific"-and-we-want-to-test-this issue before... Do we have a place
where architecture specific selftests live?

> 
> #include <sys/syscall.h>
> #include <unistd.h>
> #include <stdio.h>
> #include <stdint.h>
> 
> #define __NR_clone3 435
> struct clone_args {
>     uint64_t flags;
>     uint64_t pidfd;
>     uint64_t child_tid;
>     uint64_t parent_tid;
>     uint64_t exit_signal;
>     uint64_t stack;
>     uint64_t stack_size;
>     uint64_t tls;
> };
> 
> #define USE_CLONE3
> 
> int main() {
>     printf("Before fork: tp = %p\n", __builtin_thread_pointer());
> #ifdef USE_CLONE3
>     struct clone_args args = {
>         .flags = CLONE_SETTLS,
>         .tls = (uint64_t)__builtin_thread_pointer(),
>     };
>     int ret = syscall(__NR_clone3, &args, sizeof(args));
> #else
>     int ret = syscall(__NR_clone, CLONE_SETTLS, 0, 0,
> __builtin_thread_pointer(), 0);
> #endif
>     printf("Fork returned %d, tp = %p\n", ret, __builtin_thread_pointer());
> }

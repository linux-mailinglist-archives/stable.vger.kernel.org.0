Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EE443C19B4
	for <lists+stable@lfdr.de>; Thu,  8 Jul 2021 21:17:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230196AbhGHTT4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Jul 2021 15:19:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229631AbhGHTTz (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Jul 2021 15:19:55 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFB4CC061574
        for <stable@vger.kernel.org>; Thu,  8 Jul 2021 12:17:13 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1625771832;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=O5mVXKM0EEnqbnrpLp7wGx7x3GsCcGo+hWmsiE8Lscs=;
        b=b6bgNBdGXR8wgvrL2swH+t7qGIgoih+MLBmhLgU+CPl9noFLhlnsqUF36k0qEfzlq8izBA
        eR+U5/EKQu7Fg81RgycIzbFFw6OWTMe8okfW5dRzyKxdUDGzqWhXG6lWEFAquQSO3H2L0d
        nlcHSSyaNV91a0lPkwnZw0e732wPy/c6mB8upXI0cEAscGcjxjhJ6HO29FP8/ZaNRSkgbV
        x0lVBd6IaNyAP48qPDZJwreKDEjtjjKwDpwrrMtpqcJ4J50w6/MjPwXEDauUGVxpGjCgIV
        FNL/kXhLs3Ki0pjzVphkzwIirrxZEJViiCiDfoARVWh43P9GArAm8JOMH4/g4g==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1625771832;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=O5mVXKM0EEnqbnrpLp7wGx7x3GsCcGo+hWmsiE8Lscs=;
        b=OzbFvaOrkxEFDkH/guB1+DVkcB2zakMt27JzjXdsvgtp5/8mX8q8miRw7yPENfQ2b+kVWw
        232m6TSj1luU3nCQ==
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     kernel test robot <lkp@intel.com>,
        Andy Lutomirski <luto@kernel.org>, kbuild-all@lists.01.org,
        Borislav Petkov <bp@suse.de>, x86@kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] x86/entry: Fix noinstr violation
In-Reply-To: <YOdLuAL6rRDzMPDX@kroah.com>
References: <202106291306.0c9aeGFw-lkp@intel.com> <87a6mxorjp.ffs@nanos.tec.linutronix.de> <87y2agodn9.ffs@nanos.tec.linutronix.de> <YOdLuAL6rRDzMPDX@kroah.com>
Date:   Thu, 08 Jul 2021 21:17:12 +0200
Message-ID: <87r1g8obt3.ffs@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 08 2021 at 21:02, Greg Kroah-Hartman wrote:
> On Thu, Jul 08, 2021 at 08:37:30PM +0200, Thomas Gleixner wrote:
>> On Thu, Jul 08 2021 at 15:37, Thomas Gleixner wrote:
>> > The recent commit which fixed the entry/exit mismatch on failed 32-bit
>> > syscalls got the ordering vs. instrumentation_end() wrong, which makes
>> > objtool complain about tracer invocation in an instrumentation disabled
>> > region.
>> >
>> > Stick the offending local_irq_disable() into the instrumentation enabled
>> > region so objtool stops complaining.
>> >
>> > Fixes: 5d5675df792f ("x86/entry: Fix entry/exit mismatch on failed fast 32-bit syscalls")
>> 
>> Bah. I looked at the wrong branch. It's fixed already in Linus tree:
>> 
>> commit 240001d4e3041832e8a2654adc3ccf1683132b92
>> Author: Peter Zijlstra <peterz@infradead.org>
>> Date:   Mon Jun 21 13:12:34 2021 +0200
>> 
>>     x86/entry: Fix noinstr fail in __do_fast_syscall_32()
>> 
>> Though that lacks a CC: stable tag, which would have been appropriate
>> because 5d5675df792f ("x86/entry: Fix entry/exit mismatch on failed fast
>> 32-bit syscalls") has been backported.
>> 
>> Can the stable folks pick this up please?
>
> It's already in 5.10.47 and 5.12.14.  Does it need to go further back to
> older kernels?

I was reacting on the syzbot report which was against 5.10.y and
completely missed that it had checked out exactly the offending commit.

So if it's already backported, nothing to see. The original commit which
got fixed by 5d5675df792f is 0b085e68f407 and that was introduced in 5.9
which is EOL.

Sorry for the noise.

Thanks,

        tglx


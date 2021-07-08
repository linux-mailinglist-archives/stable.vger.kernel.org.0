Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 918113C1944
	for <lists+stable@lfdr.de>; Thu,  8 Jul 2021 20:37:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229566AbhGHSkO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Jul 2021 14:40:14 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:53324 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbhGHSkO (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Jul 2021 14:40:14 -0400
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1625769450;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UpTKLxnXsqjOOyTIbtZrfsK2LSVfyAzDoUFfT4oC8mY=;
        b=PR0jrsaOjJZLxX5C3MT5p4EH/ecOvUJahT3BQTWK+RlVgNmm6zbluGCLAP7o7WdszhFLI3
        gC6Ba6t7R7bpjlpw1+PMrH3PIJIlmOLGzHpwJ0DW2/vZIC2iBh0FkQg3J0sMaYhf+BL6lD
        NOsou7q/ahxaaPSsqt7TaR2NRXwJ9QflMbz1tiP/sCJmqgPcG6W/WyIhzo3gA3bQWkeS4c
        Fsvgj/zBC3ptuD6yTg4abwuWhI6RsAZQbiMxsCKEq3HCXEv729pvjtNpShr20Y6XUENNLH
        WwXWtKzKkZKc7HGq0a58svkKGzfjf31985lPZL2Vwqy1sG3jIIAnV8jqy+NJoA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1625769451;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UpTKLxnXsqjOOyTIbtZrfsK2LSVfyAzDoUFfT4oC8mY=;
        b=CtdCze6Yxq9ZMg1bzlSdMzFsaL12E4ABCpUdOLaCUmwHeBRS/1dPT+OP0HNmioow7Tarey
        H7ZFquuuelF1niAg==
To:     kernel test robot <lkp@intel.com>,
        Andy Lutomirski <luto@kernel.org>
Cc:     kbuild-all@lists.01.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Borislav Petkov <bp@suse.de>, x86@kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] x86/entry: Fix noinstr violation
In-Reply-To: <87a6mxorjp.ffs@nanos.tec.linutronix.de>
References: <202106291306.0c9aeGFw-lkp@intel.com> <87a6mxorjp.ffs@nanos.tec.linutronix.de>
Date:   Thu, 08 Jul 2021 20:37:30 +0200
Message-ID: <87y2agodn9.ffs@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 08 2021 at 15:37, Thomas Gleixner wrote:
> The recent commit which fixed the entry/exit mismatch on failed 32-bit
> syscalls got the ordering vs. instrumentation_end() wrong, which makes
> objtool complain about tracer invocation in an instrumentation disabled
> region.
>
> Stick the offending local_irq_disable() into the instrumentation enabled
> region so objtool stops complaining.
>
> Fixes: 5d5675df792f ("x86/entry: Fix entry/exit mismatch on failed fast 32-bit syscalls")

Bah. I looked at the wrong branch. It's fixed already in Linus tree:

commit 240001d4e3041832e8a2654adc3ccf1683132b92
Author: Peter Zijlstra <peterz@infradead.org>
Date:   Mon Jun 21 13:12:34 2021 +0200

    x86/entry: Fix noinstr fail in __do_fast_syscall_32()

Though that lacks a CC: stable tag, which would have been appropriate
because 5d5675df792f ("x86/entry: Fix entry/exit mismatch on failed fast
32-bit syscalls") has been backported.

Can the stable folks pick this up please?

Thanks,

        tglx

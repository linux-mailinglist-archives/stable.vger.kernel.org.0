Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E863233AE78
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 10:18:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229599AbhCOJSS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 05:18:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:46268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229532AbhCOJRy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 05:17:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9736D60295;
        Mon, 15 Mar 2021 09:17:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615799874;
        bh=bObUlKsvuzKNv0YT409ZuH8UMOU+9GsEB7AUc0ogmTg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=yWOveoRP6mp3VzC2nTAjuIpwJKEpM7gqRaj/m2nX3358U9uAfFEvaOaEhoMEsAcI+
         cDrm9mN4/mo5+2T/21myL9vpmhfYJY69PLUBfy12Yg5+/g5lxPy3c16Ru6RPqwhy8J
         u9xJMszJavI/0h3ZLmF5RPdqVds0sopPzHtPAoLM=
Date:   Mon, 15 Mar 2021 10:17:51 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     stable <stable@vger.kernel.org>,
        Guenter Roeck <linux@roeck-us.net>,
        lkft-triage@lists.linaro.org
Subject: Re: v4.19.y-queue, v5.4.y-queue stable rc build failures
Message-ID: <YE8mP1WtTU8Qkrpu@kroah.com>
References: <be846d89-ab5a-f02a-c05e-1cd40acc5baa@roeck-us.net>
 <CA+G9fYv+46uD-RqW9ue5x_4_JF_iKYavd9PDnEFsrEUvvVZStg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYv+46uD-RqW9ue5x_4_JF_iKYavd9PDnEFsrEUvvVZStg@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 15, 2021 at 01:45:21PM +0530, Naresh Kamboju wrote:
> On Mon, 15 Mar 2021 at 05:56, Guenter Roeck <linux@roeck-us.net> wrote:
> >
> > Building arm:axm55xx_defconfig ... failed
> > --------------
> > Error log:
> > /tmp/cc2ylxxJ.s: Assembler messages:
> > /tmp/cc2ylxxJ.s:87: Error: co-processor register expected -- `mrc p10,7,r7,FPEXC,cr0,0'
> > /tmp/cc2ylxxJ.s:103: Error: co-processor register expected -- `mcr p10,7,r3,FPEXC,cr0,0'
> > /tmp/cc2ylxxJ.s:537: Error: co-processor register expected -- `mcr p10,7,r7,FPEXC,cr0,0'
> > make[3]: *** [arch/arm/kvm/hyp/switch.o] Error 1
> > make[2]: *** [arch/arm/kvm/hyp] Error 2
> > make[2]: *** Waiting for unfinished jobs....
> > make[1]: *** [arch/arm/kvm] Error 2
> > make[1]: *** Waiting for unfinished jobs....
> > make: *** [sub-make] Error 2
> 
> These issues were noticed on the stable rc 5.4 branch also while building for
> arm axm55xx_defconfig.
> 
> /tmp/ccKgdkaN.s: Assembler messages:
> /tmp/ccKgdkaN.s:87: Error: co-processor register expected -- `mrc
> p10,7,r7,FPEXC,cr0,0'
> /tmp/ccKgdkaN.s:103: Error: co-processor register expected -- `mcr
> p10,7,r3,FPEXC,cr0,0'
> /tmp/ccKgdkaN.s:556: Error: co-processor register expected -- `mcr
> p10,7,r7,FPEXC,cr0,0'
> make[3]: *** [/builds/1piRajjPILoGGDzi5cHI5ZMuCJZ/scripts/Makefile.build:261:
> arch/arm/kvm/hyp/switch.o] Error 1
> 
> 
> > --------------
> >
> > I didn't find an obvious candidate so I bisected it.
> >
> > # bad: [a233c6b3f6de88ca62da8fde45f330b104827851] Linux 4.19.181-rc1
> > # good: [030194a5b292bb7613407668d85af0b987bb9839] Linux 4.19.180
> > git bisect start 'HEAD' 'v4.19.180'
> > # good: [ecee76d4b15b8431827e910589edfb4c12a589f9] powerpc/perf: Record counter overflow always if SAMPLE_IP is unset
> > git bisect good ecee76d4b15b8431827e910589edfb4c12a589f9
> > # good: [722ce092b23ae91337694d40e6ac216b16962788] ARM: 8929/1: use APSR_nzcv instead of r15 as mrc operand
> > git bisect good 722ce092b23ae91337694d40e6ac216b16962788
> > # bad: [2e6919206bb0bcac507b7905fc7c9b3dd861ab4b] ARM: 9025/1: Kconfig: CPU_BIG_ENDIAN depends on !LD_IS_LLD
> > git bisect bad 2e6919206bb0bcac507b7905fc7c9b3dd861ab4b
> > # good: [831e354481111c30d68c980434e2cfe42590f189] kbuild: add CONFIG_LD_IS_LLD
> > git bisect good 831e354481111c30d68c980434e2cfe42590f189
> > # bad: [9b99f469087843c9216976865a97da96f9cdcbbc] ARM: 8991/1: use VFP assembler mnemonics if available
> > git bisect bad 9b99f469087843c9216976865a97da96f9cdcbbc
> > # good: [41ad45cb9ecb66f76abc77d938b3693839fb5e20] ARM: 8990/1: use VFP assembler mnemonics in register load/store macros
> > git bisect good 41ad45cb9ecb66f76abc77d938b3693839fb5e20
> > # first bad commit: [9b99f469087843c9216976865a97da96f9cdcbbc] ARM: 8991/1: use VFP assembler mnemonics if available
> >
> > Reverting the offending patch from v4.19.y-queue fixes the problem.
> > I didn't check v5.4.y-queue.
> 
> https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc/-/jobs/1095669013#L346

Thanks, both trees should now be fixed.

greg k-h

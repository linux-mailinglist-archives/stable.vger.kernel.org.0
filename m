Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23DF91EA813
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 19:02:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726110AbgFARCv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 13:02:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:48584 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726067AbgFARCv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 13:02:51 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 057D22074B;
        Mon,  1 Jun 2020 17:02:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591030970;
        bh=MnZaH4VryQ5aGxRZuCTxrcG5TdtBptDA6JmyUoM0b2Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fC+Vm4Fz2L3i5RSK0LWK8DGn3WM0jRZwx3kuRz2yXGYsbB1OOM0Sb32Nt5fyKed52
         z+cdyZJDKwRKGMByb2VjvEbwxF+34wUYvJk+eLXFe3jqSNbn4TfblHtzIJvq3VAQeH
         ZOfKdsq1g7M922ooo6RziLy9snLMtV425ADSq2BU=
Date:   Mon, 1 Jun 2020 19:02:48 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        linux- stable <stable@vger.kernel.org>,
        lkft-triage@lists.linaro.org, rmk+kernel@armlinux.org.uk
Subject: Re: stable-rc 4.9: arm: arch/arm/vfp/vfphw.S:158: Error: bad
 instruction `ldcleq p11,cr0,[r10],#32*4'
Message-ID: <20200601170248.GA1105493@kroah.com>
References: <CA+G9fYuwMbm2NUmSLohbUs+KzKcyY9rC0dc4kh9AD9hJi6+ePw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYuwMbm2NUmSLohbUs+KzKcyY9rC0dc4kh9AD9hJi6+ePw@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 01, 2020 at 09:18:34PM +0530, Naresh Kamboju wrote:
> stable-rc 4.9 arm architecture build failed due to
> following errors,
> 
> # make -sk KBUILD_BUILD_USER=TuxBuild -C/linux -j16 ARCH=arm
> CROSS_COMPILE=arm-linux-gnueabihf- HOSTCC=gcc CC="sccache
> arm-linux-gnueabihf-gcc" O=build zImage
> #
> ../arch/arm/vfp/vfphw.S: Assembler messages:
> ../arch/arm/vfp/vfphw.S:158: Error: bad instruction `ldcleq p11,cr0,[r10],#32*4'
> ../arch/arm/vfp/vfphw.S:233: Error: bad instruction `stcleq p11,cr0,[r0],#32*4'
> make[2]: *** [../scripts/Makefile.build:404: arch/arm/vfp/vfphw.o] Error 1
> make[2]: Target '__build' not remade because of errors.
> make[1]: *** [/linux/Makefile:1040: arch/arm/vfp] Error 2
> ../arch/arm/lib/changebit.S: Assembler messages:
> ../arch/arm/lib/changebit.S:15: Error: bad instruction `strbne r1,[ip]'
> make[2]: *** [../scripts/Makefile.build:404: arch/arm/lib/changebit.o] Error 1
> ../arch/arm/lib/clear_user.S: Assembler messages:
> ../arch/arm/lib/clear_user.S:33: Error: bad instruction `strbal r2,[r0],#1'
> ../arch/arm/lib/clear_user.S:34: Error: bad instruction `strble r2,[r0],#1'
> ../arch/arm/lib/clear_user.S:35: Error: bad instruction `strblt r2,[r0],#1'
> ../arch/arm/lib/clear_user.S:44: Error: bad instruction `strbne r2,[r0],#1'
> ../arch/arm/lib/clear_user.S:44: Error: bad instruction `strbne r2,[r0],#1'
> make[2]: *** [../scripts/Makefile.build:404: arch/arm/lib/clear_user.o] Error 1
> ../arch/arm/lib/clearbit.S: Assembler messages:
> ../arch/arm/lib/clearbit.S:15: Error: bad instruction `strbne r1,[ip]'
> make[2]: *** [../scripts/Makefile.build:404: arch/arm/lib/clearbit.o] Error 1
> ../arch/arm/lib/copy_from_user.S: Assembler messages:
> ../arch/arm/lib/copy_from_user.S:96: Error: bad instruction `subshs ip,ip,r2'
> ../arch/arm/lib/copy_template.S:168: Error: bad instruction `ldrbne r3,[r1],#1'
> ../arch/arm/lib/copy_template.S:169: Error: bad instruction `ldrbcs r4,[r1],#1'
> ../arch/arm/lib/copy_template.S:170: Error: bad instruction `ldrbcs ip,[r1],#1'
> ../arch/arm/lib/copy_template.S:179: Error: bad instruction `ldrbgt r3,[r1],#1'
> ../arch/arm/lib/copy_template.S:180: Error: bad instruction `ldrbge r4,[r1],#1'
> ../arch/arm/lib/copy_template.S:181: Error: bad instruction `ldrbal lr,[r1],#1'
> make[2]: *** [../scripts/Makefile.build:404:
> arch/arm/lib/copy_from_user.o] Error 1
> ../arch/arm/lib/copy_to_user.S: Assembler messages:
> ../arch/arm/lib/copy_to_user.S:100: Error: bad instruction `subshs ip,ip,r2'
> ../arch/arm/lib/copy_template.S:171: Error: bad instruction `strbne r3,[r0],#1'
> ../arch/arm/lib/copy_template.S:172: Error: bad instruction `strbcs r4,[r0],#1'
> ../arch/arm/lib/copy_template.S:173: Error: bad instruction `strbcs ip,[r0],#1'
> ../arch/arm/lib/copy_template.S:182: Error: bad instruction `strbgt r3,[r0],#1'
> ../arch/arm/lib/copy_template.S:183: Error: bad instruction `strbge r4,[r0],#1'
> ../arch/arm/lib/copy_template.S:185: Error: bad instruction `strbal lr,[r0],#1'
> make[2]: *** [../scripts/Makefile.build:404:
> arch/arm/lib/copy_to_user.o] Error 1
> ../arch/arm/lib/csumpartialcopygeneric.S: Assembler messages:
> ../arch/arm/lib/csumpartialcopygeneric.S:39: Error: bad instruction
> `ldrbal ip,[r0],#1'
> ../arch/arm/lib/csumpartialcopygeneric.S:46: Error: bad instruction
> `ldrbal r8,[r0],#1'
> ../arch/arm/lib/csumpartialcopygeneric.S:46: Error: bad instruction
> `ldrbal ip,[r0],#1'
> ../arch/arm/lib/csumpartialcopygeneric.S:66: Error: bad instruction
> `ldrbal ip,[r0],#1'
> ../arch/arm/lib/csumpartialcopygeneric.S:73: Error: bad instruction
> `ldrbal r8,[r0],#1'
> ../arch/arm/lib/csumpartialcopygeneric.S:73: Error: bad instruction
> `ldrbal ip,[r0],#1'
> ../arch/arm/lib/csumpartialcopygeneric.S:85: Error: bad instruction
> `ldrbal r8,[r0],#1'
> ../arch/arm/lib/csumpartialcopygeneric.S:277: Error: bad instruction
> `ldrbal r5,[r0],#1'
> make[2]: *** [../scripts/Makefile.build:404:
> arch/arm/lib/csumpartialcopyuser.o] Error 1
> ../arch/arm/lib/getuser.S: Assembler messages:
> ../arch/arm/lib/getuser.S:36: Error: bad instruction `sbcscc r2,r2,r1'
> ../arch/arm/lib/getuser.S:44: Error: bad instruction `sbcscc r2,r2,r1'
> ../arch/arm/lib/getuser.S:74: Error: bad instruction `sbcscc r2,r2,r1'
> ../arch/arm/lib/getuser.S:82: Error: bad instruction `sbcscc r2,r2,r1'
> make[2]: *** [../scripts/Makefile.build:404: arch/arm/lib/getuser.o] Error 1
> ../arch/arm/lib/putuser.S: Assembler messages:
> ../arch/arm/lib/putuser.S:36: Error: bad instruction `sbcscc ip,ip,r1'
> ../arch/arm/lib/putuser.S:43: Error: bad instruction `sbcscc ip,ip,r1'
> ../arch/arm/lib/putuser.S:65: Error: bad instruction `sbcscc ip,ip,r1'
> ../arch/arm/lib/putuser.S:72: Error: bad instruction `sbcscc ip,ip,r1'
> make[2]: *** [../scripts/Makefile.build:404: arch/arm/lib/putuser.o] Error 1
> ../arch/arm/lib/setbit.S: Assembler messages:
> ../arch/arm/lib/setbit.S:15: Error: bad instruction `strbne r1,[ip]'
> make[2]: *** [../scripts/Makefile.build:404: arch/arm/lib/setbit.o] Error 1
> ../arch/arm/lib/testchangebit.S: Assembler messages:
> ../arch/arm/lib/testchangebit.S:15: Error: bad instruction `strbne r1,[ip]'
> make[2]: *** [../scripts/Makefile.build:404:
> arch/arm/lib/testchangebit.o] Error 1
> ../arch/arm/lib/testclearbit.S: Assembler messages:
> ../arch/arm/lib/testclearbit.S:15: Error: bad instruction `strbne r1,[ip]'
> make[2]: *** [../scripts/Makefile.build:404:
> arch/arm/lib/testclearbit.o] Error 1
> ../arch/arm/lib/testsetbit.S: Assembler messages:
> ../arch/arm/lib/testsetbit.S:15: Error: bad instruction `strbne r1,[ip]'
> make[2]: *** [../scripts/Makefile.build:404: arch/arm/lib/testsetbit.o] Error 1
> make[2]: Target '__build' not remade because of errors.
> make[1]: *** [/linux/Makefile:1040: arch/arm/lib] Error 2
> make[1]: Target 'zImage' not remade because of errors.
> make: *** [Makefile:152: sub-make] Error 2
> make: Target 'zImage' not remade because of errors.

Caused by c001899a5d6c ("ARM: 8843/1: use unified assembler in headers")

Odd, I'll drop it from 4.9, but it's also in the 4.14 and 4.19 queues as
well, is it causing issues there too?

thanks,

greg k-h

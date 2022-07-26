Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 617E85817C5
	for <lists+stable@lfdr.de>; Tue, 26 Jul 2022 18:45:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229582AbiGZQpJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jul 2022 12:45:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234016AbiGZQpH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Jul 2022 12:45:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BB12E70
        for <stable@vger.kernel.org>; Tue, 26 Jul 2022 09:45:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2F15260522
        for <stable@vger.kernel.org>; Tue, 26 Jul 2022 16:45:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CC15C433D6;
        Tue, 26 Jul 2022 16:45:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658853904;
        bh=puIc4ImalRpNHhS+a2nFSk+3Ot4B11ypKXbTRGVmPuw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ncFB8Vm7J9bCU2vDYJO8RsxeCjvpWrOYgly4THav3STBgpsvthaJQeAxMnoDmm21W
         3EqzJFPvLD4V04fw5mgsjw2z3MyUkNJjJ4Dd/7RQ9/ZziQZdNwXGbmf5CuBawa0gcD
         +SsZHOxHaf8yKHxgIW+bqlhoCPJnIkAmhQlor99Q=
Date:   Tue, 26 Jul 2022 18:45:01 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        linux-stable <stable@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@suse.de>
Subject: Re: stable: queue/5.15: arch/x86/mm/extable.c:200:7: error:
 duplicate case value '12'
Message-ID: <YuAaDXkPLHA2pUsR@kroah.com>
References: <CA+G9fYuTWEUmMWgSC=SoVdf7YN2pochkxPqj2iXH7DUaA6n1=A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYuTWEUmMWgSC=SoVdf7YN2pochkxPqj2iXH7DUaA6n1=A@mail.gmail.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 26, 2022 at 07:50:40PM +0530, Naresh Kamboju wrote:
> x86 and i386 clang builds failed due this build warnings / errors on
> stable-rc queue/5.15
> 
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> 
> git_ref: queue/5.15
> git_describe: v5.15.56-266-gda50e215b6b1
> git_repo: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc-queues
> Build:   v5.15.56-266-gda50e215b6b1
> Details: https://qa-reports.linaro.org/lkft/linux-stable-rc-queues-queue_5.15/build/v5.15.56-266-gda50e215b6b1
> 
> Steps to reproduce:
> -------------------
> tuxmake --runtime podman \
>         --target-arch x86_64 \
>         --toolchain clang-14 \
>         --kconfig
> https://builds.tuxbuild.com/2CT2NoyYwejQUXoBcT1lYTHbhtT/config \
>           LLVM=1 \
>           LLVM_IAS=1
> 
> 
> Build error log:
> -----------------
> builds/linux/arch/x86/include/asm/extable_fixup_types.h:49:9: warning:
> 'EX_TYPE_DEFAULT_MCE_SAFE' macro redefined [-Wmacro-redefined]
> #define EX_TYPE_DEFAULT_MCE_SAFE        12
>         ^
> arch/x86/include/asm/extable_fixup_types.h:42:9: note: previous
> definition is here
> #define EX_TYPE_DEFAULT_MCE_SAFE        14
>         ^
> arch/x86/include/asm/extable_fixup_types.h:50:9: warning:
> 'EX_TYPE_FAULT_MCE_SAFE' macro redefined [-Wmacro-redefined]
> #define EX_TYPE_FAULT_MCE_SAFE          13
>         ^
> arch/x86/include/asm/extable_fixup_types.h:43:9: note: previous
> definition is here
> #define EX_TYPE_FAULT_MCE_SAFE          15
>         ^
> arch/x86/mm/extable.c:200:7: error: duplicate case value '12'
>         case EX_TYPE_WRMSR_IN_MCE:
>              ^
> arch/x86/include/asm/extable_fixup_types.h:40:31: note: expanded from
> macro 'EX_TYPE_WRMSR_IN_MCE'
> #define EX_TYPE_WRMSR_IN_MCE            12
>                                         ^
> arch/x86/mm/extable.c:177:7: note: previous case defined here
>         case EX_TYPE_DEFAULT_MCE_SAFE:
>              ^
> arch/x86/include/asm/extable_fixup_types.h:49:34: note: expanded from
> macro 'EX_TYPE_DEFAULT_MCE_SAFE'
> #define EX_TYPE_DEFAULT_MCE_SAFE        12
>                                         ^
> arch/x86/mm/extable.c:203:7: error: duplicate case value '13'
>         case EX_TYPE_RDMSR_IN_MCE:
>              ^
> arch/x86/include/asm/extable_fixup_types.h:41:31: note: expanded from
> macro 'EX_TYPE_RDMSR_IN_MCE'
> #define EX_TYPE_RDMSR_IN_MCE            13
>                                         ^
> arch/x86/mm/extable.c:180:7: note: previous case defined here
>         case EX_TYPE_FAULT_MCE_SAFE:
>              ^
> arch/x86/include/asm/extable_fixup_types.h:50:33: note: expanded from
> macro 'EX_TYPE_FAULT_MCE_SAFE'
> #define EX_TYPE_FAULT_MCE_SAFE          13
>                                         ^
> 2 warnings and 2 errors generated.
> make[3]: *** [scripts/Makefile.build:289: arch/x86/mm/extable.o] Error 1
> 
> Build link:
> https://builds.tuxbuild.com/2CT2NoyYwejQUXoBcT1lYTHbhtT/
> 

Thanks, offending patch now dropped.

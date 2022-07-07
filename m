Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8849356A93F
	for <lists+stable@lfdr.de>; Thu,  7 Jul 2022 19:18:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231540AbiGGRRJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Jul 2022 13:17:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236098AbiGGRRI (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Jul 2022 13:17:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AAD85A47C;
        Thu,  7 Jul 2022 10:17:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 980CD61147;
        Thu,  7 Jul 2022 17:17:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EE89C3411E;
        Thu,  7 Jul 2022 17:17:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657214227;
        bh=kr28mPaitT2hXZx987lyh9NyAySJXLUdOKVygYD27Oo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LLRdvuDrJUqZukDOtd4VwKGYbJakodGU28aqB7NORti+i68Ni0MSuktfoXMDjgm4A
         J4d2qxdecv4ucF3wTGKNSrJ4yBKitwVg9iD/dNHx78NZfAMBo5W3n7ddXm9Duuk9My
         GTRlzZKRiLLkthtHbxaKM5hCui7uLCnCte8HvDBa2VATdV/YhOKWAPzNLz1/RzUqyA
         uRYJ59NvG2JMQfiRWStd8yK11yWew8tQ18VvID5f1XRA51rHmKRteh6LSOJU4qGm2n
         n5fCtIAuDKncVzT2IfxwU5EgsEnMywxktn77JaGrp/VNhnVccJrTCRdKwJ+WN8HDeY
         +JRRxlu+LSqQw==
Date:   Thu, 7 Jul 2022 10:17:04 -0700
From:   Nathan Chancellor <nathan@kernel.org>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>,
        Daniel Kolesa <daniel@octaforge.org>,
        linux-kernel@vger.kernel.org, patches@lists.linux.dev,
        llvm@lists.linux.dev, stable@vger.kernel.org
Subject: Re: [PATCH] x86/Kconfig: Fix CONFIG_CC_HAS_SANE_STACKPROTECTOR when
 cross compiling with clang
Message-ID: <YscVEIBtyoX2jrBV@dev-arch.thelio-3990X>
References: <20220617180845.2788442-1-nathan@kernel.org>
 <842b718f-8207-1565-3373-61098a4c2d33@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <842b718f-8207-1565-3373-61098a4c2d33@intel.com>
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 06, 2022 at 03:25:51PM -0700, Dave Hansen wrote:
> On 6/17/22 11:08, Nathan Chancellor wrote:
> > When clang is invoked without a '--target' flag, code is generated for
> > the default target, which is usually the host (it is configurable via
> > cmake). As a result, the has-stack-protector scripts will generate code
> > for the default target but check for x86 specific segment registers,
> > which cannot succeed if the default target is not x86.
> 
> I guess the real root cause here is the direct use of '$(CC)' without
> any other flags.  Adding '$(CLANG_FLAGS)' seems like a pretty normal
> fix, like in scripts/Kconfig.include.

Right, also see the following commits for other areas where this was
addressed.

58d746c119df ("efi/libstub: Add $(CLANG_FLAGS) to x86 flags")
d5cbd80e302d ("x86/boot: Add $(CLANG_FLAGS) to compressed KBUILD_CFLAGS")
8abe7fc26ad8 ("x86/build: Propagate $(CLANG_FLAGS) to $(REALMODE_FLAGS)")

> I suspect there's another one of these here:
> 
> 	arch/x86/um/vdso/Makefile:      cmd_vdso = $(CC) -nostdlib -o $@
> 
> but I wouldn't be surprised if UML doesn't work with clang in the first
> place.

We have started testing UML with clang and it does work but I suspect
there is little value to cross compiling a UML kernel, as it has to run
in an x86 userland anyways, rather than through QEMU or other
virtualization solutions. That is not something I plan to do anyways.
If someone does and a fix similar to this one is needed, it can be done
at that time.

Thank you for picking up this change!

Cheers,
Nathan

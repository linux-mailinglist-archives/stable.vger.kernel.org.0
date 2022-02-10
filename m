Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 093A24B14B4
	for <lists+stable@lfdr.de>; Thu, 10 Feb 2022 18:56:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240671AbiBJR4P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Feb 2022 12:56:15 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:56394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245401AbiBJR4P (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Feb 2022 12:56:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FAFE115A;
        Thu, 10 Feb 2022 09:56:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 99B8661E30;
        Thu, 10 Feb 2022 17:56:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70648C004E1;
        Thu, 10 Feb 2022 17:56:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644515775;
        bh=mp2WY1Z07IUjp9Qk8J2PhJawFi/dDHvgiH8vGbexGRw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fFRSKpDwJ8tH9Ko3XvxybAcXr9GE36E4SzO+uwgbYhqIou6MC6C0tZ7JzQ7IRJBLy
         6PsshJNUi535eP4JUvCxtTY4i9W08ztaEQwOuI+BnpNyMyI5iF3jJkk2PECLtLZxFs
         MDPipXog5CPfVtQxG06kzrZ3qHlQd2TW4QarW0YI=
Date:   Thu, 10 Feb 2022 18:56:11 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Palmer Dabbelt <palmer@dabbelt.com>
Cc:     aurelien@aurel32.net, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Kito Cheng <kito.cheng@gmail.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        aou@eecs.berkeley.edu,
        "open list:RISC-V ARCHITECTURE" <linux-riscv@lists.infradead.org>
Subject: Re: [PATCH] riscv: fix build with binutils 2.38
Message-ID: <YgVRu9Z0BDyJdjR5@kroah.com>
References: <20220126171442.1338740-1-aurelien@aurel32.net>
 <mhng-f5101f2f-eb08-4e20-8cb3-b7d267ba25bc@palmer-ri-x1c9>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <mhng-f5101f2f-eb08-4e20-8cb3-b7d267ba25bc@palmer-ri-x1c9>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 10, 2022 at 09:40:22AM -0800, Palmer Dabbelt wrote:
> On Wed, 26 Jan 2022 09:14:42 PST (-0800), aurelien@aurel32.net wrote:
> > From version 2.38, binutils default to ISA spec version 20191213. This
> > means that the csr read/write (csrr*/csrw*) instructions and fence.i
> > instruction has separated from the `I` extension, become two standalone
> > extensions: Zicsr and Zifencei. As the kernel uses those instruction,
> > this causes the following build failure:
> > 
> >   CC      arch/riscv/kernel/vdso/vgettimeofday.o
> >   <<BUILDDIR>>/arch/riscv/include/asm/vdso/gettimeofday.h: Assembler messages:
> >   <<BUILDDIR>>/arch/riscv/include/asm/vdso/gettimeofday.h:71: Error: unrecognized opcode `csrr a5,0xc01'
> >   <<BUILDDIR>>/arch/riscv/include/asm/vdso/gettimeofday.h:71: Error: unrecognized opcode `csrr a5,0xc01'
> >   <<BUILDDIR>>/arch/riscv/include/asm/vdso/gettimeofday.h:71: Error: unrecognized opcode `csrr a5,0xc01'
> >   <<BUILDDIR>>/arch/riscv/include/asm/vdso/gettimeofday.h:71: Error: unrecognized opcode `csrr a5,0xc01'
> > 
> > The fix is to specify those extensions explicitely in -march. However as
> > older binutils version do not support this, we first need to detect
> > that.
> > 
> > Cc: stable@vger.kernel.org # 4.15+
> > Cc: Kito Cheng <kito.cheng@gmail.com>
> > Signed-off-by: Aurelien Jarno <aurelien@aurel32.net>
> > ---
> >  arch/riscv/Makefile | 6 ++++++
> >  1 file changed, 6 insertions(+)
> > 
> > diff --git a/arch/riscv/Makefile b/arch/riscv/Makefile
> > index 8a107ed18b0d..7d81102cffd4 100644
> > --- a/arch/riscv/Makefile
> > +++ b/arch/riscv/Makefile
> > @@ -50,6 +50,12 @@ riscv-march-$(CONFIG_ARCH_RV32I)	:= rv32ima
> >  riscv-march-$(CONFIG_ARCH_RV64I)	:= rv64ima
> >  riscv-march-$(CONFIG_FPU)		:= $(riscv-march-y)fd
> >  riscv-march-$(CONFIG_RISCV_ISA_C)	:= $(riscv-march-y)c
> > +
> > +# Newer binutils versions default to ISA spec version 20191213 which moves some
> > +# instructions from the I extension to the Zicsr and Zifencei extensions.
> > +toolchain-need-zicsr-zifencei := $(call cc-option-yn, -march=$(riscv-march-y)_zicsr_zifencei)
> > +riscv-march-$(toolchain-need-zicsr-zifencei) := $(riscv-march-y)_zicsr_zifencei
> > +
> >  KBUILD_CFLAGS += -march=$(subst fd,,$(riscv-march-y))
> >  KBUILD_AFLAGS += -march=$(riscv-march-y)
> 
> Thanks, this is on fixes.  It's CC stable, but doesn't have a "Fixes" tag --
> I did that on purpose as this isn't really fixing a bug in Linux so I'm not
> sure it's right to point at a particular patch, but I'm not sure how that
> will play with the stable tree.

I will backport it as far back as it easily goes to, and then forget
about it :)

If you have a Fixes: tag, and it doesn't properly backport that far,
then you will get a "FAILED:" email notifying you about it.

hope that helps explain things,

greg k-h

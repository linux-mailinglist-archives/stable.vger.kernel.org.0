Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57B7B5FFF4D
	for <lists+stable@lfdr.de>; Sun, 16 Oct 2022 14:56:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229594AbiJPM4F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Oct 2022 08:56:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229648AbiJPM4D (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Oct 2022 08:56:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98C9A34710
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 05:56:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 348AF60B5E
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 12:56:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DA25C433D6;
        Sun, 16 Oct 2022 12:56:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665924961;
        bh=StkAkNcdQ+zFOz0afCgnHsRcpdc9gPqXe15XLH7oAqg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DvACGCEZjD027TVP6lRW1aXaeuPZqskSJBNMigKVKMijbo+aa/+s+BTwqUt7Vdt24
         dU91gzXjYpDXXD92m/3HKEmfsmAcr9MZmiepaTjjonrB09sNorwnFekF4xRIxjnurv
         k60f2F69mzNdaUVUYWr7CNeo7iPnEqY3KbMo6LyY=
Date:   Sun, 16 Oct 2022 14:56:47 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Conor Dooley <conor@kernel.org>
Cc:     stable@vger.kernel.org, Aurelien Jarno <aurelien@aurel32.net>,
        Alexandre Ghiti <alexandre.ghiti@canonical.com>,
        Palmer Dabbelt <palmer@rivosinc.com>,
        Conor Dooley <conor.dooley@microchip.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        linux-riscv@lists.infradead.org
Subject: Re: [PATCH 4.19] riscv: fix build with binutils 2.38
Message-ID: <Y0v/j8iyR0aqZZeh@kroah.com>
References: <20221015111856.3869148-1-conor@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221015111856.3869148-1-conor@kernel.org>
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Oct 15, 2022 at 12:18:57PM +0100, Conor Dooley wrote:
> From: Aurelien Jarno <aurelien@aurel32.net>
> 
> commit 6df2a016c0c8a3d0933ef33dd192ea6606b115e3 upstream.
> 
> >From version 2.38, binutils default to ISA spec version 20191213. This
> means that the csr read/write (csrr*/csrw*) instructions and fence.i
> instruction has separated from the `I` extension, become two standalone
> extensions: Zicsr and Zifencei. As the kernel uses those instruction,
> this causes the following build failure:
> 
>   CC      arch/riscv/kernel/vdso/vgettimeofday.o
>   <<BUILDDIR>>/arch/riscv/include/asm/vdso/gettimeofday.h: Assembler messages:
>   <<BUILDDIR>>/arch/riscv/include/asm/vdso/gettimeofday.h:71: Error: unrecognized opcode `csrr a5,0xc01'
>   <<BUILDDIR>>/arch/riscv/include/asm/vdso/gettimeofday.h:71: Error: unrecognized opcode `csrr a5,0xc01'
>   <<BUILDDIR>>/arch/riscv/include/asm/vdso/gettimeofday.h:71: Error: unrecognized opcode `csrr a5,0xc01'
>   <<BUILDDIR>>/arch/riscv/include/asm/vdso/gettimeofday.h:71: Error: unrecognized opcode `csrr a5,0xc01'
> 
> The fix is to specify those extensions explicitly in -march. However as
> older binutils version do not support this, we first need to detect
> that.
> 
> Signed-off-by: Aurelien Jarno <aurelien@aurel32.net>
> Tested-by: Alexandre Ghiti <alexandre.ghiti@canonical.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
> [Conor: converted to the 4.19 style of march string generation]
> Signed-off-by: Conor Dooley <conor.dooley@microchip.com>
> ---
> CC: Palmer Dabbelt <palmer@dabbelt.com>
> CC: linux-riscv@lists.infradead.org
> CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> lkp has yet to complain, so here you go Greg..

Now queued up, thanks.

greg k-h

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D1784DDEB3
	for <lists+stable@lfdr.de>; Fri, 18 Mar 2022 17:22:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239037AbiCRQXS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Mar 2022 12:23:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239072AbiCRQW0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Mar 2022 12:22:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CD40E388C;
        Fri, 18 Mar 2022 09:19:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B06EBB824A7;
        Fri, 18 Mar 2022 16:18:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6346C340E8;
        Fri, 18 Mar 2022 16:18:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647620322;
        bh=RgoWd82TMVKvPEj2mnBFasnr1ktgCyI38ZWKS1kuPxg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=APZoUKBgMpBIwFM0bEG+PS2SzirGBi23hexZigjRmwDwwGzCkbwv9ZuJD4lNeIdNv
         xK3hW+2gO3tl28yY9flvMRxQbJVaRJ2q/2wrlQZzZook95jfPtVMedaofVZDgZx4d3
         HLaBuYixoz1U85AzJ5iYmWPHmyKfETwYnEAGJ3Co=
Date:   Fri, 18 Mar 2022 17:18:39 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     James Morse <james.morse@arm.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.4 18/43] arm64: entry: Add macro for reading symbol
 addresses from the trampoline
Message-ID: <YjSw3wfvbhtjWRSG@kroah.com>
References: <20220317124527.672236844@linuxfoundation.org>
 <20220317124528.180267687@linuxfoundation.org>
 <113e7675-4263-2a20-81d0-9634f03511d2@gmail.com>
 <bc35996d-ec18-1923-38f4-81d16ed98b7a@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bc35996d-ec18-1923-38f4-81d16ed98b7a@arm.com>
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 18, 2022 at 12:11:32PM +0000, James Morse wrote:
> Hi Florian,
> 
> On 3/17/22 8:48 PM, Florian Fainelli wrote:
> > On 3/17/22 5:45 AM, Greg Kroah-Hartman wrote:
> > > From: James Morse <james.morse@arm.com>
> > > 
> > > commit b28a8eebe81c186fdb1a0078263b30576c8e1f42 upstream.
> > > 
> > > The trampoline code needs to use the address of symbols in the wider
> > > kernel, e.g. vectors. PC-relative addressing wouldn't work as the
> > > trampoline code doesn't run at the address the linker expected.
> > > 
> > > tramp_ventry uses a literal pool, unless CONFIG_RANDOMIZE_BASE is
> > > set, in which case it uses the data page as a literal pool because
> > > the data page can be unmapped when running in user-space, which is
> > > required for CPUs vulnerable to meltdown.
> > > 
> > > Pull this logic out as a macro, instead of adding a third copy
> > > of it.
> > > 
> > > Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
> > > Signed-off-by: James Morse <james.morse@arm.com>
> > > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > 
> > This commit causes a linking failure with CONFIG_ARM_SDE_INTERFACE=y
> > enabled in the kernel:
> > 
> >    LD      .tmp_vmlinux.kallsyms1
> > /local/users/fainelli/buildroot/output/arm64/host/bin/aarch64-linux-ld:
> > arch/arm64/kernel/entry.o: in function `__sdei_asm_exit_trampoline':
> > /local/users/fainelli/buildroot/output/arm64/build/linux-custom/arch/arm64/kernel/entry.S:1352:
> > undefined reference to `__sdei_asm_trampoline_next_handler'
> > make[2]: *** [Makefile:1100: vmlinux] Error 1
> > make[1]: *** [package/pkg-generic.mk:295:
> > /local/users/fainelli/buildroot/output/arm64/build/linux-custom/.stamp_built]
> > Error 2
> > make: *** [Makefile:27: _all] Error 2
> 
> ... and with CONFIG_RANDOMIZE_BASE turned off, which is why allyesconfig didn't catch it.
> This is because I kept the next_handler bit of the label when it conflicted, which isn't needed
> because the __entry_tramp bit added by the macro serves the same purpose.
> 
> The below diff fixes it:
> ----------%<----------
> diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
> index e4b5a15c2e2e..cfc0bb6c49f7 100644
> --- a/arch/arm64/kernel/entry.S
> +++ b/arch/arm64/kernel/entry.S
> @@ -1190,7 +1190,7 @@ __entry_tramp_data_start:
>  __entry_tramp_data_vectors:
>         .quad   vectors
>  #ifdef CONFIG_ARM_SDE_INTERFACE
> -__entry_tramp_data___sdei_asm_trampoline_next_handler:
> +__entry_tramp_data___sdei_asm_handler:
>         .quad   __sdei_asm_handler
>  #endif /* CONFIG_ARM_SDE_INTERFACE */
>         .popsection                             // .rodata
> @@ -1319,7 +1319,7 @@ ENTRY(__sdei_asm_entry_trampoline)
>          */
>  1:     str     x4, [x1, #(SDEI_EVENT_INTREGS + S_ORIG_ADDR_LIMIT)]
> -       tramp_data_read_var     x4, __sdei_asm_trampoline_next_handler
> +       tramp_data_read_var     x4, __sdei_asm_handler
>         br      x4
>  ENDPROC(__sdei_asm_entry_trampoline)
>  NOKPROBE(__sdei_asm_entry_trampoline)
> ----------%<----------
> 
> Good news - this didn't happen with v5.10.
> 
> I don't see this in v5.4.185 yet.
> 
> Greg/Sasha, what is least work for you?:
> A new version of this patch,
> A fixup on top of the series,
> Reposting the series with this fixed.

Let me merge this into this commit.

thanks!

greg k-h

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B9924B7156
	for <lists+stable@lfdr.de>; Tue, 15 Feb 2022 17:40:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239863AbiBOQU3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Feb 2022 11:20:29 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235972AbiBOQU2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Feb 2022 11:20:28 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C80DAB8B4A;
        Tue, 15 Feb 2022 08:20:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6A67B617EE;
        Tue, 15 Feb 2022 16:20:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3ADD7C340EB;
        Tue, 15 Feb 2022 16:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644942017;
        bh=TzM3DKG6FBNX7TGNWIl9/g5UsdtHy8W1XfsqgglVlgY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KiFDVPazsXlRxFv20wkkiSnPhDI6pJQRNkedMkzesxEViXw3a7JYIF9aBTbBvEglr
         BX8hXrqK9cgIvXCapk/j1RLY9d5KBg3iv7xY98tAb4w6TAqz1Jb8oVA+qwd+6+Cwcw
         r8ExAH9v6Y64cMnLzTOJzxomua7IoGlRgqaWsPp4=
Date:   Tue, 15 Feb 2022 17:20:15 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Brian Geffon <bgeffon@google.com>
Cc:     Dave Hansen <dave.hansen@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Willis Kung <williskung@google.com>,
        Guenter Roeck <groeck@google.com>,
        Borislav Petkov <bp@suse.de>,
        Andy Lutomirski <luto@kernel.org>, stable@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86/fpu: Correct pkru/xstate inconsistency
Message-ID: <YgvSv4U9onBk16xF@kroah.com>
References: <20220215153644.3654582-1-bgeffon@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220215153644.3654582-1-bgeffon@google.com>
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 15, 2022 at 07:36:44AM -0800, Brian Geffon wrote:
> There are two issues with PKRU handling prior to 5.13. The first is that
> when eagerly switching PKRU we check that current is not a kernel
> thread as kernel threads will never use PKRU. It's possible that
> this_cpu_read_stable() on current_task (ie. get_current()) is returning
> an old cached value. By forcing the read with this_cpu_read() the
> correct task is used. Without this it's possible when switching from
> a kernel thread to a userspace thread that we'll still observe the
> PF_KTHREAD flag and never restore the PKRU. And as a result this
> issue only occurs when switching from a kernel thread to a userspace
> thread, switching from a non kernel thread works perfectly fine because
> all we consider in that situation is the flags from some other non
> kernel task and the next fpu is passed in to switch_fpu_finish().
> 
> Without reloading the value finish_fpu_load() after being inlined into
> __switch_to() uses a stale value of current:
> 
>   ba1:   8b 35 00 00 00 00       mov    0x0(%rip),%esi
>   ba7:   f0 41 80 4d 01 40       lock orb $0x40,0x1(%r13)
>   bad:   e9 00 00 00 00          jmp    bb2 <__switch_to+0x1eb>
>   bb2:   41 f6 45 3e 20          testb  $0x20,0x3e(%r13)
>   bb7:   75 1c                   jne    bd5 <__switch_to+0x20e>
> 
> By using this_cpu_read() and avoiding the cached value the compiler does
> insert an additional load instruction and observes the correct value now:
> 
>   ba1:   8b 35 00 00 00 00       mov    0x0(%rip),%esi
>   ba7:   f0 41 80 4d 01 40       lock orb $0x40,0x1(%r13)
>   bad:   e9 00 00 00 00          jmp    bb2 <__switch_to+0x1eb>
>   bb2:   65 48 8b 05 00 00 00    mov    %gs:0x0(%rip),%rax
>   bb9:   00
>   bba:   f6 40 3e 20             testb  $0x20,0x3e(%rax)
>   bbe:   75 1c                   jne    bdc <__switch_to+0x215>
> 
> The second issue is when using write_pkru() we only write to the
> xstate when the feature bit is set because get_xsave_addr() returns
> NULL when the feature bit is not set. This is problematic as the CPU
> is free to clear the feature bit when it observes the xstate in the
> init state, this behavior seems to be documented a few places throughout
> the kernel. If the bit was cleared then in write_pkru() we would happily
> write to PKRU without ever updating the xstate, and the FPU restore on
> return to userspace would load the old value agian.
> 
> Fixes: 0cecca9d03c9 ("x86/fpu: Eager switch PKRU state")
> Signed-off-by: Brian Geffon <bgeffon@google.com>
> Signed-off-by: Willis Kung <williskung@google.com>
> Tested-by: Willis Kung <williskung@google.com>
> ---
>  arch/x86/include/asm/fpu/internal.h |  2 +-
>  arch/x86/include/asm/pgtable.h      | 14 ++++++++++----
>  2 files changed, 11 insertions(+), 5 deletions(-)

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEE854B77ED
	for <lists+stable@lfdr.de>; Tue, 15 Feb 2022 21:51:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234521AbiBOTpM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Feb 2022 14:45:12 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235781AbiBOTpK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Feb 2022 14:45:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C1B046676;
        Tue, 15 Feb 2022 11:45:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 273EE6176A;
        Tue, 15 Feb 2022 19:45:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C77AAC340EC;
        Tue, 15 Feb 2022 19:44:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644954299;
        bh=IvBtOuBKJRkjWsCzqLuJQUQ4HwxeRxYRUYk6C1Y7qwE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=2tSqBkeZO6Oqn3vmQ3iYbfTJmx4u9cWNnk+yYaA5DWhGET4q0+GZ1Tzr92x+A85l5
         Nl5PU33/QkSFmyQnQddpQmcvi9xOZPc6WVAv6A7Ie643746w3H/PkY7TREobguku2Z
         bc6N48d1+EFaPv3rpq53GPEG9+7MhPukta7VW/x4=
Date:   Tue, 15 Feb 2022 20:44:56 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Brian Geffon <bgeffon@google.com>
Cc:     Dave Hansen <dave.hansen@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Willis Kung <williskung@google.com>,
        Guenter Roeck <groeck@google.com>,
        Borislav Petkov <bp@suse.de>,
        Andy Lutomirski <luto@kernel.org>, stable@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH stable 5.4,5.10] x86/fpu: Correct pkru/xstate
 inconsistency
Message-ID: <YgwCuGcg6adXAXIz@kroah.com>
References: <543efc25-9b99-53cd-e305-d8b4d917b64b@intel.com>
 <20220215192233.8717-1-bgeffon@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220215192233.8717-1-bgeffon@google.com>
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 15, 2022 at 11:22:33AM -0800, Brian Geffon wrote:
> When eagerly switching PKRU in switch_fpu_finish() it checks that
> current is not a kernel thread as kernel threads will never use PKRU.
> It's possible that this_cpu_read_stable() on current_task
> (ie. get_current()) is returning an old cached value. To resolve this
> reference next_p directly rather than relying on current.
> 
> As written it's possible when switching from a kernel thread to a
> userspace thread to observe a cached PF_KTHREAD flag and never restore
> the PKRU. And as a result this issue only occurs when switching
> from a kernel thread to a userspace thread, switching from a non kernel
> thread works perfectly fine because all that is considered in that
> situation are the flags from some other non kernel task and the next fpu
> is passed in to switch_fpu_finish().
> 
> This behavior only exists between 5.2 and 5.13 when it was fixed by a
> rewrite decoupling PKRU from xstate, in:
>   commit 954436989cc5 ("x86/fpu: Remove PKRU handling from switch_fpu_finish()")
> 
> Unfortunately backporting the fix from 5.13 is probably not realistic as
> it's part of a 60+ patch series which rewrites most of the PKRU handling.
> 
> Fixes: 0cecca9d03c9 ("x86/fpu: Eager switch PKRU state")
> Signed-off-by: Brian Geffon <bgeffon@google.com>
> Signed-off-by: Willis Kung <williskung@google.com>
> Tested-by: Willis Kung <williskung@google.com>
> Cc: <stable@vger.kernel.org> # v5.4.x
> Cc: <stable@vger.kernel.org> # v5.10.x
> ---
>  arch/x86/include/asm/fpu/internal.h | 13 ++++++++-----
>  arch/x86/kernel/process_32.c        |  6 ++----
>  arch/x86/kernel/process_64.c        |  6 ++----
>  3 files changed, 12 insertions(+), 13 deletions(-)

So this is ONLY for 5.4.y and 5.10.y?  I'm really really loath to take
non-upstream changes as 95% of the time (really) it goes wrong.

How was this tested, and what do the maintainers of this subsystem
think?  And will you be around to fix the bugs in this when they are
found?

And finally, what's wrong with 60+ patches to backport to fix a severe
issue?  What's preventing that from happening?  Did you try it and see
what exactly is involved?

thanks,

greg k-h

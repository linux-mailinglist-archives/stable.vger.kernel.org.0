Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90C7F18B0D4
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 11:04:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725767AbgCSKEI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 06:04:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:36724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725601AbgCSKEI (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 06:04:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 963AA20732;
        Thu, 19 Mar 2020 10:04:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584612248;
        bh=+goVqRbZc/x72YFYtm/vQYIyeZrE8cv3tu6hC/wj+7Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JOktONSwAEwD1JkYbHyBBeO6ef114Ck6PsJtSfgagysSsm56x566xk37mID+w4oLE
         8iSdkcZIti4dNKrrstbu/xmC7YpLSXIEB8bsGL9vlGB67CgkeVaGrGN1rVp5SLLz41
         mebVQmzAo/CEyReAq13Rk49lOvE6vynSrlitLe6Q=
Date:   Thu, 19 Mar 2020 11:04:05 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Chris Wilson <chris@chris-wilson.co.uk>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Bhupesh Sharma <bhsharma@redhat.com>,
        Matt Fleming <matt@codeblueprint.co.uk>,
        Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Wen Yang <wenyang@linux.alibaba.com>,
        Caspar Zhang <caspar@linux.alibaba.com>
Subject: Re: [PATCH 4.19 64/89] efi: Make efi_rts_work accessible to efi page
 fault handler
Message-ID: <20200319100405.GB3514624@kroah.com>
References: <20200317103259.744774526@linuxfoundation.org>
 <20200317103307.316400146@linuxfoundation.org>
 <158461093093.6873.1396457313254708957@build.alporthouse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <158461093093.6873.1396457313254708957@build.alporthouse.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 19, 2020 at 09:42:10AM +0000, Chris Wilson wrote:
> Quoting Greg Kroah-Hartman (2020-03-17 10:55:13)
> > From: Sai Praneeth <sai.praneeth.prakhya@intel.com>
> > 
> > commit 9dbbedaa6171247c4c7c40b83f05b200a117c2e0 upstream.
> > 
> > After the kernel has booted, if any accesses by firmware causes a page
> > fault, the efi page fault handler would freeze efi_rts_wq and schedules
> > a new process. To do this, the efi page fault handler needs
> > efi_rts_work. Hence, make it accessible.
> > 
> > There will be no race conditions in accessing this structure, because
> > all the calls to efi runtime services are already serialized.
> > 
> > Tested-by: Bhupesh Sharma <bhsharma@redhat.com>
> > Suggested-by: Matt Fleming <matt@codeblueprint.co.uk>
> > Based-on-code-from: Ricardo Neri <ricardo.neri@intel.com>
> > Signed-off-by: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
> > Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> > Fixes: 3eb420e70d87 (“efi: Use a work queue to invoke EFI Runtime Services”)
> > Signed-off-by: Wen Yang <wenyang@linux.alibaba.com>
> > Cc: Caspar Zhang <caspar@linux.alibaba.com>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> This requires the fix from
> 
> commit ef1491e791308317bb9851a0ad380c4a68b58d54
> Author: Waiman Long <longman@redhat.com>
> Date:   Wed Nov 14 09:55:40 2018 -0800
> 
>     efi: Fix debugobjects warning on 'efi_rts_work'
> 
>     The following commit:
> 
>       9dbbedaa6171 ("efi: Make efi_rts_work accessible to efi page fault handler")
> 
>     converted 'efi_rts_work' from an auto variable to a global variable.
>     However, when submitting the work, INIT_WORK_ONSTACK() was still used,
>     causing the following complaint from debugobjects:
> 
>       ODEBUG: object 00000000ed27b500 is NOT on stack 00000000c7d38760, but annotated.
> 
>     Change the macro to just INIT_WORK() to eliminate the warning.
> 
>     Signed-off-by: Waiman Long <longman@redhat.com>
>     Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
>     Acked-by: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
>     Cc: Linus Torvalds <torvalds@linux-foundation.org>
>     Cc: Peter Zijlstra <peterz@infradead.org>
>     Cc: Thomas Gleixner <tglx@linutronix.de>
>     Cc: linux-efi@vger.kernel.org
>     Fixes: 9dbbedaa6171 ("efi: Make efi_rts_work accessible to efi page fault handler")
>     Link: http://lkml.kernel.org/r/20181114175544.12860-2-ard.biesheuvel@linaro.org
>     Signed-off-by: Ingo Molnar <mingo@kernel.org>

Thanks for this, now queued up.

greg k-h
> 

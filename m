Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F114178C37
	for <lists+stable@lfdr.de>; Wed,  4 Mar 2020 09:04:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387611AbgCDIEd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Mar 2020 03:04:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:49254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387396AbgCDIEd (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Mar 2020 03:04:33 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 53C7D20866;
        Wed,  4 Mar 2020 08:04:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583309071;
        bh=67h2DTinS/+f1QaP16AfsZsGXYZf9bfX72/JflPKpoY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GGjShP4vAq7Xckxx9KUCp4A9X3ZWFOUAWiVNq512ZYHsCERjxFxFwc53RYQh5DD6o
         ssrfl6tsGaWq76mkvRgA/jO5JSc3mKdSAtOtg0mOeZxoPFpogMje8jRMfbTYe17Lsu
         z7RvD1ISA9faNX6spWW2dH8HRhFqOusUco5sVGs8=
Date:   Wed, 4 Mar 2020 09:04:28 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Wen Yang <wenyang@linux.alibaba.com>
Cc:     Sasha Levin <sashal@kernel.org>,
        Sai Praneeth <sai.praneeth.prakhya@intel.com>,
        Bhupesh Sharma <bhsharma@redhat.com>,
        Matt Fleming <matt@codeblueprint.co.uk>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Caspar Zhang <caspar@linux.alibaba.com>, stable@vger.kernel.org
Subject: Re: [PATCH] efi: Make efi_rts_work accessible to efi page fault
 handler
Message-ID: <20200304080428.GA1401372@kroah.com>
References: <20200304074444.7849-1-wenyang@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200304074444.7849-1-wenyang@linux.alibaba.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 04, 2020 at 03:44:44PM +0800, Wen Yang wrote:
> From: Sai Praneeth <sai.praneeth.prakhya@intel.com>
> 
> [ Upstream commit 9dbbedaa6171247c4c7c40b83f05b200a117c2e0 ]
> 
> After the kernel has booted, if any accesses by firmware causes a page
> fault, the efi page fault handler would freeze efi_rts_wq and schedules
> a new process. To do this, the efi page fault handler needs
> efi_rts_work. Hence, make it accessible.
> 
> There will be no race conditions in accessing this structure, because
> all the calls to efi runtime services are already serialized.
> 
> [ Wen: This patch also fixes a memory corruption:
>        #define efi_queue_work(_rts, _arg1, _arg2, _arg3, _arg4, _arg5)\
>        ({                                                             \
>         struct efi_runtime_work efi_rts_work;                           \
>        …
>         init_completion(&efi_rts_work.efi_rts_comp);                    \
>         INIT_WORK(&efi_rts_work.work, efi_call_rts);                    \
>        …
> 
>        efi_rts_work is on the stack, registering it to workqueue will cause
>        the following error:
> 
>        ODEBUG: object (____ptrval____) is on stack (____ptrval____),
>        but NOT annotated.
>        ------------[ cut here ]------------
>        WARNING: CPU: 6 PID: 1 at lib/debugobjects.c:368
>        __debug_object_init+0x218/0x538
>        Modules linked in:
>        CPU: 6 PID: 1 Comm: swapper/0 Tainted: G        W         4.19.91 #19
>        …
>        Call trace:
>        __debug_object_init+0x218/0x538
>        debug_object_init+0x20/0x28
>        __init_work+0x34/0x58
>        virt_efi_get_time.part.5+0x6c/0x12c
>        virt_efi_get_time+0x4c/0x58
>        efi_read_time+0x40/0x9c
>        __rtc_read_time+0x50/0x118
>        rtc_read_time+0x60/0x1f0
>        rtc_hctosys+0x74/0x124
>        do_one_initcall+0xac/0x3d4
>        kernel_init_freeable+0x49c/0x59c
>        kernel_init+0x18/0x110 ]
> 
> Tested-by: Bhupesh Sharma <bhsharma@redhat.com>
> Suggested-by: Matt Fleming <matt@codeblueprint.co.uk>
> Based-on-code-from: Ricardo Neri <ricardo.neri@intel.com>
> Signed-off-by: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> Fixes: 3eb420e70d87 (“efi: Use a work queue to invoke EFI Runtime Services”)
> Signed-off-by: Wen Yang <wenyang@linux.alibaba.com>
> Cc: Caspar Zhang <caspar@linux.alibaba.com>
> Cc: Sasha Levin <sashal@kernel.org>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: stable@vger.kernel.org
> ---
>  drivers/firmware/efi/runtime-wrappers.c | 53 +++++--------------------
>  include/linux/efi.h                     | 36 +++++++++++++++++
>  2 files changed, 45 insertions(+), 44 deletions(-)

What stable tree(s) do you wish to see this patch applied to?

thanks,

greg k-h

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44B322BE68
	for <lists+stable@lfdr.de>; Tue, 28 May 2019 06:48:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726789AbfE1Esm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 May 2019 00:48:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:35386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725904AbfE1Esm (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 May 2019 00:48:42 -0400
Received: from localhost (unknown [89.188.5.116])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C40E92070D;
        Tue, 28 May 2019 04:48:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559018921;
        bh=StXXJlO0vQ6VuS2BQayQC9RmOOwXuWbmGYdz3GpHAbQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bkrZ+rnACE7xDwL/gpt1ScDliREj0JTqy2mFZR+CRn4/5MHsPVwLgtcV4KuTtSHpH
         bTx4Lt+J4mXlCkx483ShwWulB9P3LGFzCfPdZJoDMZAHp6jfUOcwdUibNoZA8Z6xXb
         wEp2GREUsYCnIDNNKS6dOBJV1U2GK0/Bb9WIJvKg=
Date:   Tue, 28 May 2019 06:48:38 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     stable <stable@vger.kernel.org>
Subject: Re: Build failures in v4.14.y, v4.19.y, v5.0.y, v5.1.y
Message-ID: <20190528044838.GA2318@kroah.com>
References: <14854627-178c-ed40-d8cf-913035167df8@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <14854627-178c-ed40-d8cf-913035167df8@roeck-us.net>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 27, 2019 at 04:39:51PM -0700, Guenter Roeck wrote:
> The following build failure affects all stable releases starting with v4.14.y.
> v4.9.y and earlier are not affected.
> 
> Guenter
> 
> ---
> Build reference: v4.14.122
> gcc version: x86_64-linux-gcc.br_real (Buildroot 2017.02) 6.3.0
> 
> Building um:defconfig ... failed
> --------------
> Error log:
> In file included from /opt/buildbot/slave/stable-queue-4.14/build/arch/x86/um/../kernel/module.c:34:0:
> /opt/buildbot/slave/stable-queue-4.14/build/arch/x86/include/asm/text-patching.h: In function ‘int3_emulate_jmp’:
> /opt/buildbot/slave/stable-queue-4.14/build/arch/x86/include/asm/text-patching.h:43:6: error: ‘struct pt_regs’ has no member named ‘ip’
>   regs->ip = ip;
>       ^~
> /opt/buildbot/slave/stable-queue-4.14/build/arch/x86/include/asm/text-patching.h: In function ‘int3_emulate_push’:
> /opt/buildbot/slave/stable-queue-4.14/build/arch/x86/include/asm/text-patching.h:58:6: error: ‘struct pt_regs’ has no member named ‘sp’
>   regs->sp -= sizeof(unsigned long);
>       ^~
> /opt/buildbot/slave/stable-queue-4.14/build/arch/x86/include/asm/text-patching.h:59:24: error: ‘struct pt_regs’ has no member named ‘sp’
>   *(unsigned long *)regs->sp = val;
>                         ^~
> /opt/buildbot/slave/stable-queue-4.14/build/arch/x86/include/asm/text-patching.h: In function ‘int3_emulate_call’:
> /opt/buildbot/slave/stable-queue-4.14/build/arch/x86/include/asm/text-patching.h:64:30: error: ‘struct pt_regs’ has no member named ‘ip’
>   int3_emulate_push(regs, regs->ip - INT3_INSN_SIZE + CALL_INSN_SIZE);
>                               ^~
> make[2]: *** [arch/x86/um/../kernel/module.o] Error 1

This should already be fixed with 693713cbdb3a ("x86: Hide the
int3_emulate_call/jmp functions from UML") which is queued up in all of
these trees.

Sorry about the breakage.

thanks,

greg k-h

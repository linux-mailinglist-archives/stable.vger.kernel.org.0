Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFAB1454234
	for <lists+stable@lfdr.de>; Wed, 17 Nov 2021 08:59:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234287AbhKQICE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Nov 2021 03:02:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:47798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231967AbhKQICE (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Nov 2021 03:02:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0C6456128E;
        Wed, 17 Nov 2021 07:59:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637135946;
        bh=2IbVwvTd68aGyPhoOhA94dODTJPyh9DCFyAa6XiQ76k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QrxiN3GGDkt0nHwtVvSzRWqqLCcBK2QKJX/QfGp6v2XljTty+l2lrrapMj7iyKTaD
         ZWYbEhNHd4N76JFB3T6Tghn1aXJQ/hWfveBrggun7O+lM4TkpaKz9fLgkqcZKS6yT7
         EICURUhRfIXvWT5z/pvMxmF0xwRXEjEqxs1m09IM=
Date:   Wed, 17 Nov 2021 08:59:04 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.15 000/927] 5.15.3-rc2 review
Message-ID: <YZS2SPIMqu7Ura/2@kroah.com>
References: <20211116142631.571909964@linuxfoundation.org>
 <2861faf6-734f-a12a-6e07-e2a34ded994d@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2861faf6-734f-a12a-6e07-e2a34ded994d@roeck-us.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 16, 2021 at 10:18:28AM -0800, Guenter Roeck wrote:
> On 11/16/21 7:01 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.15.3 release.
> > There are 927 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu, 18 Nov 2021 14:24:22 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Building parisc:allmodconfig ... failed
> --------------
> Error log:
> In file included from include/linux/compiler_types.h:85,
>                  from <command-line>:
> arch/parisc/include/asm/jump_label.h: In function 'arch_static_branch':
> arch/parisc/include/asm/jump_label.h:18:18: error: expected ':' before '__stringify'
>    18 |                  __stringify(ASM_ULONG_INSN) " %c0 - .\n\t"
>       |                  ^~~~~~~~~~~
> include/linux/compiler-gcc.h:88:47: note: in definition of macro 'asm_volatile_goto'
>    88 | #define asm_volatile_goto(x...) do { asm goto(x); asm (""); } while (0)
>       |                                               ^
> In file included from include/linux/jump_label.h:117,
>                  from crypto/api.c:15:
> arch/parisc/include/asm/jump_label.h:23:1: error: label 'l_yes' defined but not used [-Werror=unused-label]
> 
> Caused by the crypto patches, which expose a missing include file in
> arch/parisc/include/asm/jump_label.h. The problem is also seen in the
> upstream kernel and (as of this writing) not yet fixed there.

I'm going to drop the crypto patches from the tree, they seem to not be
ready yet...

thanks,

greg k-h

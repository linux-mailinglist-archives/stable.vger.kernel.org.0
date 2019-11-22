Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3262110688E
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 10:03:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726364AbfKVJDT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 04:03:19 -0500
Received: from mail.skyhub.de ([5.9.137.197]:38452 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726100AbfKVJDT (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 04:03:19 -0500
Received: from zn.tnic (p200300EC2F0E97008857C615A913C712.dip0.t-ipconnect.de [IPv6:2003:ec:2f0e:9700:8857:c615:a913:c712])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 8312F1EC0CFE;
        Fri, 22 Nov 2019 10:03:17 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1574413397;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=liTKNvrJ2ArY+2xUErntrVevJruJzJ9WZm0VG8dwj9s=;
        b=YNzWh7XyrQ0NI2DDjQ16dJCETjVNhVBN4jP6V4zW9M4KyBN1UBEDMyFKicvloQHXOirnIO
        TS2H7wdIDXui61G/ViQ37bFdGQ0NKGR0sxY+MhopQVtNCAkLM8o6nFC7DNVkxN/cjuP6aw
        W6Ib6BtfBESxvQUgCoY3eeF9pBEvZZ0=
Date:   Fri, 22 Nov 2019 10:03:15 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     thor.thayer@linux.intel.com
Cc:     mchehab@kernel.org, tony.luck@intel.com, james.morse@arm.com,
        rrichter@marvell.com, Meng.Li@windriver.com,
        linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCHv2 1/3] EDAC/altera: Use fast register IO for S10 IRQs
Message-ID: <20191122090314.GC6289@zn.tnic>
References: <1574361048-17572-1-git-send-email-thor.thayer@linux.intel.com>
 <1574361048-17572-2-git-send-email-thor.thayer@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1574361048-17572-2-git-send-email-thor.thayer@linux.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 21, 2019 at 12:30:46PM -0600, thor.thayer@linux.intel.com wrote:
> From: Meng Li <Meng.Li@windriver.com>
> 
> When an irq occurs in altera edac driver, regmap_xxx() is invoked
> in atomic context. Regmap must indicate register IO is fast so
> that a spinlock is used instead of a mutex to avoid sleeping
> in atomic context.
> 
> Fixes mutex-lock error
>    lock_acquire+0xfc/0x288
>    __mutex_lock+0x8c/0x808
>    mutex_lock_nested+0x3c/0x50
>    regmap_lock_mutex+0x24/0x30
>    regmap_write+0x40/0x78
>    a10_eccmgr_irq_unmask+0x34/0x40
>    unmask_irq.part.0+0x30/0x50
>    irq_enable+0x74/0x80
>    __irq_startup+0x80/0xa8
>    irq_startup+0x70/0x150
>    __setup_irq+0x650/0x6d0
>    request_threaded_irq+0xe4/0x180
>    devm_request_threaded_irq+0x7c/0xf0
>    altr_sdram_probe+0x2c4/0x600
> <snip>
> 
> Upstream fix pending [1] (common code uses fast mode)
> [1] https://lkml.org/lkml/2019/11/7/1014
> 
> Fixes: 3dab6bd52687 ("EDAC, altera: Add support for Stratix10 SDRAM EDAC")
> Cc: stable@vger.kernel.org
> Reported-by: Meng Li <Meng.Li@windriver.com>
> Signed-off-by: Meng Li <Meng.Li@windriver.com>
> Reviewed-by: Thor Thayer <thor.thayer@linux.intel.com>
> ---
> v2 Change Author to Meng Li & Reviewed-by: Thor Thayer

You don't absolutely need to have Reviewed-by: you, when you send
someone else's patch. The fact that you send it, kinda implies you've
reviewed it. I sure hope so, at least :-)

What the patch must have is your SOB unterneath. I'll fix that up when
applying.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

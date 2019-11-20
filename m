Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 457FB1042F0
	for <lists+stable@lfdr.de>; Wed, 20 Nov 2019 19:07:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727955AbfKTSHl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Nov 2019 13:07:41 -0500
Received: from mail.skyhub.de ([5.9.137.197]:38438 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726999AbfKTSHl (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 20 Nov 2019 13:07:41 -0500
Received: from zn.tnic (p200300EC2F0D8C00F553B94F3FB99B80.dip0.t-ipconnect.de [IPv6:2003:ec:2f0d:8c00:f553:b94f:3fb9:9b80])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 88CD91EC0C0A;
        Wed, 20 Nov 2019 19:07:39 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1574273259;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=TAArlTdTZ4v075238vF++6Ru2UHuSjXj+LATF9NFC1U=;
        b=Wu7QkmA9EUtTMvpT566j3ZXn56dCrHXvv/mNZxjhKvTdiLGF/VZv6Yg9Neo89Ut+0uKC5p
        KzkteAlJiK5++ZKBikYyqhLDRtrmM6fYiFN+7zJ69b6EsM2jN2z+qvTe6e0zfKogDT5GJ3
        h5XdXQQ57sxl+tpCVKlzuM4m4cUlGLI=
Date:   Wed, 20 Nov 2019 19:07:33 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     thor.thayer@linux.intel.com
Cc:     stable@vger.kernel.org, mchehab@kernel.org, tony.luck@intel.com,
        james.morse@arm.com, rrichter@marvell.com,
        linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org,
        Meng Li <Meng.Li@windriver.com>
Subject: Re: [PATCH] EDAC/altera: Use fast register IO for S10 IRQs
Message-ID: <20191120180733.GJ2634@zn.tnic>
References: <1574271481-9310-1-git-send-email-thor.thayer@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1574271481-9310-1-git-send-email-thor.thayer@linux.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 20, 2019 at 11:38:01AM -0600, thor.thayer@linux.intel.com wrote:
> From: Thor Thayer <thor.thayer@linux.intel.com>
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

I don't understand - I picked those up and are already queued for 5.5:

https://git.kernel.org/pub/scm/linux/kernel/git/ras/ras.git/log/?h=edac-for-next

What is that patch for?

Are you saying, I should stick it before the two patches above so that
it gets backported to stable so that you have older kernels addressed?

But then the above ones won't apply anymore because

EDAC/altera: Use the Altera System Manager driver

removes s10_sdram_regmap_cfg.

What I can offer you is to remove the two patches and apply this one so
that it goes in next week. Then, you can send me the two rediffed after
5.5-rc1 is out. Ok?

> Fixes: 3dab6bd52687 ("EDAC, altera: Add support for Stratix10 SDRAM EDAC")
> Cc: stable@vger.kernel.org
> Reported-by: Meng Li <Meng.Li@windriver.com>
> Signed-off-by: Meng Li <Meng.Li@windriver.com>

What does Meng's SOB mean?

> Signed-off-by: Thor Thayer <thor.thayer@linux.intel.com>

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8411947E3EA
	for <lists+stable@lfdr.de>; Thu, 23 Dec 2021 14:04:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243523AbhLWNEo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Dec 2021 08:04:44 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:43766 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S243507AbhLWNEn (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Dec 2021 08:04:43 -0500
X-UUID: 69369d50f71d4276ad6f4de1521c3921-20211223
X-UUID: 69369d50f71d4276ad6f4de1521c3921-20211223
Received: from mtkmbs10n2.mediatek.inc [(172.21.101.183)] by mailgw02.mediatek.com
        (envelope-from <lecopzer.chen@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 1651115744; Thu, 23 Dec 2021 21:04:38 +0800
Received: from mtkexhb02.mediatek.inc (172.21.101.103) by
 mtkmbs07n1.mediatek.inc (172.21.101.16) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Thu, 23 Dec 2021 21:04:37 +0800
Received: from mtkcas11.mediatek.inc (172.21.101.40) by mtkexhb02.mediatek.inc
 (172.21.101.103) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 23 Dec
 2021 21:04:37 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas11.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 23 Dec 2021 21:04:37 +0800
From:   Lecopzer Chen <lecopzer.chen@mediatek.com>
To:     <ardb@kernel.org>
CC:     <dvyukov@google.com>, <f.fainelli@gmail.com>,
        <kasan-dev@googlegroups.com>, <lecopzer.chen@mediatek.com>,
        <linus.walleij@linaro.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <linux@armlinux.org.uk>,
        <liuwenliang@huawei.com>, <stable@vger.kernel.org>,
        <yj.chiang@mediatek.com>
Subject: Re: [PATCH] ARM: module: fix MODULE_PLTS not work for KASAN
Date:   Thu, 23 Dec 2021 21:04:37 +0800
Message-ID: <20211223130437.23313-1-lecopzer.chen@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <CAMj1kXGL++stjcuryn8zVwMgH4F05mONoU3Kca9Ch8N2dW-_bg@mail.gmail.com>
References: <CAMj1kXGL++stjcuryn8zVwMgH4F05mONoU3Kca9Ch8N2dW-_bg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> > Fixes: 421015713b306e47af9 ("ARM: 9017/2: Enable KASan for ARM")
> > Signed-off-by: Lecopzer Chen <lecopzer.chen@mediatek.com>
> > ---
> >  arch/arm/kernel/module.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/arch/arm/kernel/module.c b/arch/arm/kernel/module.c
> > index beac45e89ba6..c818aba72f68 100644
> > --- a/arch/arm/kernel/module.c
> > +++ b/arch/arm/kernel/module.c
> > @@ -46,7 +46,7 @@ void *module_alloc(unsigned long size)
> >         p = __vmalloc_node_range(size, 1, MODULES_VADDR, MODULES_END,
> >                                 gfp_mask, PAGE_KERNEL_EXEC, 0, NUMA_NO_NODE,
> >                                 __builtin_return_address(0));
> > -       if (!IS_ENABLED(CONFIG_ARM_MODULE_PLTS) || p)
> > +       if (!IS_ENABLED(CONFIG_ARM_MODULE_PLTS) || IS_ENABLED(CONFIG_KASAN) || p)
> 
> 
> Hello Lecopzer,
> 
> This is not the right place to fix this. If module PLTs are
> incompatible with KAsan, they should not be selectable in Kconfig at
> the same time.
> 
> But ideally, we should implement KASAN_VMALLOC for ARM as well - we
> also need this for the vmap'ed stacks.

Hi Ard,

Thanks a lots for your advice.

Of course, I just simulate how arm64 did, It's surrounded by a bunch of
IS_ENABLED(CONFIG_...). I think I could also send a patch for arm64 to
move out the IS_ENABLED() to Kconfig.

Actually I have a patch set support KASAN_VMALLOC for arm which is
similar with I did for arm64, this patch is regarded as the first patch
from the serise.

But It has problems that it's very easy to run out of vmalloc area
due to 32bit address space(balance between low and highmem),
so the serise is pending and I send this patch alone.

Anyway, I'll send v2 to move the conditioni-if to Kconfig.

thanks,

Lecopzer











Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCBD124AC97
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 03:24:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726617AbgHTBY1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Aug 2020 21:24:27 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:24068 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726482AbgHTBYZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Aug 2020 21:24:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597886664;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WjUMl2kvI2SWf67XAmHmBJUIFFn0OB41n2Xt50LZy2w=;
        b=XRYxVpr491Yb+bRHergebupGyr7KiJQ1UybOsljP8E4wHQT6Y5D/Yo76GghsP0ZfkYmWhZ
        Icp1sfzgc/QRsuz168LeeOPXiCpsDOocUpcBsupp/otyvFFPw9yKLJVBlk53PcujP17c1e
        o3Ur+jhJC97XwQMqUpNvU+RocaxADZs=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-535-JsofAvRqMXm9it43KLrquw-1; Wed, 19 Aug 2020 21:24:22 -0400
X-MC-Unique: JsofAvRqMXm9it43KLrquw-1
Received: by mail-pl1-f198.google.com with SMTP id o6so487020pll.9
        for <stable@vger.kernel.org>; Wed, 19 Aug 2020 18:24:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=WjUMl2kvI2SWf67XAmHmBJUIFFn0OB41n2Xt50LZy2w=;
        b=ntA35Y8W1FDS5rMmP+C1rSqc2tAbzVc32/KEEYptzS8awJDe+bUhjVVlQJMbfJkqO1
         qgIkOg3kDWtP67jGB5RrgcW8Qo2QbKKay6N0DKQuyf/K3F7KKBLE5b1tBtNqsUYbmUNf
         h2ie27cOfijapHVtF1wvuqilBDxygwu9URHKGQxwceUaGeV0dg4N+o+E1ninVabSCqCf
         w2MV1vPCPVuv6z5uRY06AIbTw7/0A5yfYKnephStvTPi2Aq7C8YVPxNpzCoVRwTeopbE
         Y2d6bMnEjmWvNV8kj+Rjy9cvd3NPYAXtn0JbZLeuDsYDQ9EFAZ4Q3frU1pUnq632iaI/
         hj1w==
X-Gm-Message-State: AOAM532vmy6q+UTzDWxuex0K22E5ZUQKlWZfyUf/Ktt3GMcHxbJJ7Cpc
        yKLGINUHohLb5ZRJmP5JC1KdZHZzSreaJMSu9QL0dQtA72LHWmMBR82h1gIiF2LyrKR6sVR43FG
        mYh6EnVyTzabhpQ2u
X-Received: by 2002:a17:90a:6d96:: with SMTP id a22mr464525pjk.165.1597886661324;
        Wed, 19 Aug 2020 18:24:21 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJznZQrOjFKArbT3Fe5xmkGGfKX9NSSvbVErYE0AQ15q2c+Bsrk3JIzM5qQom2dXOfnnMQ6c1g==
X-Received: by 2002:a17:90a:6d96:: with SMTP id a22mr464511pjk.165.1597886661025;
        Wed, 19 Aug 2020 18:24:21 -0700 (PDT)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id b185sm491513pfg.71.2020.08.19.18.24.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Aug 2020 18:24:20 -0700 (PDT)
Date:   Thu, 20 Aug 2020 09:24:09 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     Yang Shi <shy828301@gmail.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Linux MM <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rafael Aquini <aquini@redhat.com>,
        Carlos Maiolino <cmaiolino@redhat.com>,
        Eric Sandeen <esandeen@redhat.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH] mm, THP, swap: fix allocating cluster for swapfile by
 mistake
Message-ID: <20200820012409.GB5846@xiangao.remote.csb>
References: <20200819195613.24269-1-hsiangkao@redhat.com>
 <20200819130506.eea076dd618644cd7ff875b6@linux-foundation.org>
 <20200819201509.GA26216@xiangao.remote.csb>
 <CAHbLzkqr3Z0OuzjqrGjNX6kajr9J533FpqQd8zJYD4pjd+CGMg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHbLzkqr3Z0OuzjqrGjNX6kajr9J533FpqQd8zJYD4pjd+CGMg@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Yang,

On Wed, Aug 19, 2020 at 02:41:08PM -0700, Yang Shi wrote:
> On Wed, Aug 19, 2020 at 1:15 PM Gao Xiang <hsiangkao@redhat.com> wrote:
> >
> > Hi Andrew,
> >
> > On Wed, Aug 19, 2020 at 01:05:06PM -0700, Andrew Morton wrote:
> > > On Thu, 20 Aug 2020 03:56:13 +0800 Gao Xiang <hsiangkao@redhat.com> wrote:
> > >
> > > > SWP_FS doesn't mean the device is file-backed swap device,
> > > > which just means each writeback request should go through fs
> > > > by DIO. Or it'll just use extents added by .swap_activate(),
> > > > but it also works as file-backed swap device.
> > >
> > > This is very hard to understand :(
> >
> > Thanks for your reply...
> >
> > The related logic is in __swap_writepage() and setup_swap_extents(),
> > and also see e.g generic_swapfile_activate() or iomap_swapfile_activate()...
> 
> I think just NFS falls into this case, so you may rephrase it to:
> 
> SWP_FS is only used for swap files over NFS. So, !SWP_FS means non NFS
> swap, it could be either file backed or device backed.

Thanks for your suggestion...

That looks reasonable, and after I looked
bc4ae27d817a ("mm: split SWP_FILE into SWP_ACTIVATED and SWP_FS")

I think it could be rephrased into

"
The SWP_FS flag is used to make swap_{read,write}page() go
through the filesystem, and it's only used for swap files
over NFS. So, !SWP_FS means non NFS for now, it could be
either file backed or device backed. Something similar goes
with legacy SWP_FILE.
"

Does it look sane? And I will wait for further suggestion
about this for a while.

And IMO, SWP_FS flag might be useful for other uses later
(e.g. laterly for some CoW swapfile use, but I don't think
 carefully if it's practical or not...)

Thanks,
Gao Xiang


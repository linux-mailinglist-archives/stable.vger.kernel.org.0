Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 793B9103110
	for <lists+stable@lfdr.de>; Wed, 20 Nov 2019 02:23:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727417AbfKTBXw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 20:23:52 -0500
Received: from mail-ot1-f67.google.com ([209.85.210.67]:34528 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727403AbfKTBXw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Nov 2019 20:23:52 -0500
Received: by mail-ot1-f67.google.com with SMTP id 1so2924074otk.1
        for <stable@vger.kernel.org>; Tue, 19 Nov 2019 17:23:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Rxay+wCZQrFdqVqPfP8bGnBXwNi7j1uwxGcwoDzHOJg=;
        b=q62/J5T86M5j3XdVPvMCk5XFfbynZBXOrhy/Ulzi2Ak/SR66QjEV87taVb/sLBA3+A
         xuow/s/p3ytUdzNvEX9JK6w5BAbChtMtIdWvHxzGvtKRDb0o09QWid6OxNkq5gjnq/G/
         W9pefG+ABYaSiIFsz4jze3GC6XPZYvzkWIecsf8a7kJXP957iOMBXABs5xZkpQyObfZC
         20UrcGjV/aangfkzJUabO1neVqCgkWWylv3wBDriJ79L+WaoxIv8wxuG+AQk2JCxY8aL
         uh0dBa9zCXeFbI5rTF7c4ZKfCW6+uJrZfqCMvG1BobCRObtklhiOA8mUVwHPSQvieGb/
         JcxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Rxay+wCZQrFdqVqPfP8bGnBXwNi7j1uwxGcwoDzHOJg=;
        b=dsTV1grMRrZHdCctjdQy6OaK+BZwloGGr2boW0g5mXzw8xnEV/mQjTxMHpOtxp3yzR
         uvGN2dlynUEYjRDghvQmVV76CWsauQzAZ4u8B6YhsfUWOjJAd6GY13EJ8Oq7igb7OhtI
         VIEJW9pl7eIeih6J/+14yE9aOHOn30tKbsxam8yY5g+FBdaOJxq6U6Nqj+umSKsm7Xut
         JDUuq2akaxMmX0NwQrhWvpNpoz7C3zqU+eHuVC2nfeNZV8ozYAKKeJHQAySWtBlddkFS
         ZtYnfbF24EE4A3zwdmHOGH2eVmVIbIVd/Z1alK/Frmg+a8aBCtWT4ldb8iEYckJ6Qpo9
         v16A==
X-Gm-Message-State: APjAAAUt3KWz729r8Z9R8mt+/4qtP+uXsRxPqfEIlaykD0zOcfV433Nm
        AXN4VmnbGUEeyrvAF7gLjH/xgfSmL/Po2YJpyBKG90vuLbI=
X-Google-Smtp-Source: APXvYqwEGWXq68sgRrJB+WmFLAETfFi7R+3dBcf7IQikGC7DoTtMMrGt4WrK8ENVvUUMQa0NJRByGxVekHep/a33HMQ=
X-Received: by 2002:a05:6830:1af7:: with SMTP id c23mr5858337otd.247.1574213031135;
 Tue, 19 Nov 2019 17:23:51 -0800 (PST)
MIME-Version: 1.0
References: <157418493888.1639105.6922809760655305210.stgit@dwillia2-desk3.amr.corp.intel.com>
 <CAKgT0UfGCzfMqM_GdYsfsowAasW7-awYjSp=FBmB99rDuZpc8g@mail.gmail.com>
In-Reply-To: <CAKgT0UfGCzfMqM_GdYsfsowAasW7-awYjSp=FBmB99rDuZpc8g@mail.gmail.com>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Tue, 19 Nov 2019 17:23:40 -0800
Message-ID: <CAPcyv4hy_nNe8G0o8sMrz9A8HcdRzAuKgXmvdjKusAAA3Fow4g@mail.gmail.com>
Subject: Re: [PATCH] dma/debug: Fix dma vs cow-page collision detection
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Russell King <linux@armlinux.org.uk>,
        Don Dutile <ddutile@redhat.com>,
        stable <stable@vger.kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Robin Murphy <robin.murphy@arm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 19, 2019 at 4:02 PM Alexander Duyck
<alexander.duyck@gmail.com> wrote:
>
> On Tue, Nov 19, 2019 at 9:49 AM Dan Williams <dan.j.williams@intel.com> wrote:
> >
> > The debug_dma_assert_idle() infrastructure was put in place to catch a
> > data corruption scenario first identified by the now defunct NET_DMA
> > receive offload feature. It caught cases where dma was in flight to a
> > stale page because the dma raced the cpu writing the page, and the cpu
> > write triggered cow_user_page().
> >
> > However, the dma-debug tracking is overeager and also triggers in cases
> > where the dma device is reading from a page that is also undergoing
> > cow_user_page().
> >
> > The fix proposed was originally posted in 2016, and Russell reported
> > "Yes, that seems to avoid the warning for me from an initial test", and
> > now Don is also reporting that this fix is addressing a similar false
> > positive report that he is seeing.
> >
> > Link: https://lore.kernel.org/r/CAPcyv4j8fWqwAaX5oCdg5atc+vmp57HoAGT6AfBFwaCiv0RbAQ@mail.gmail.com
> > Reported-by: Russell King <linux@armlinux.org.uk>
> > Reported-by: Don Dutile <ddutile@redhat.com>
> > Fixes: 0abdd7a81b7e ("dma-debug: introduce debug_dma_assert_idle()")
> > Cc: <stable@vger.kernel.org>
> > Cc: Christoph Hellwig <hch@lst.de>
> > Cc: Marek Szyprowski <m.szyprowski@samsung.com>
> > Cc: Robin Murphy <robin.murphy@arm.com>
> > Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> > ---
> >  kernel/dma/debug.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/kernel/dma/debug.c b/kernel/dma/debug.c
> > index 099002d84f46..11a6db53d193 100644
> > --- a/kernel/dma/debug.c
> > +++ b/kernel/dma/debug.c
> > @@ -587,7 +587,7 @@ void debug_dma_assert_idle(struct page *page)
> >         }
> >         spin_unlock_irqrestore(&radix_lock, flags);
> >
> > -       if (!entry)
> > +       if (!entry || entry->direction != DMA_FROM_DEVICE)
> >                 return;
> >
> >         cln = to_cacheline_number(entry);
>
> If I am understanding right DMA_TO_DEVICE is fine, but won't  you also
> need to cover the DMA_BIDIRECTIONAL case since it is possible for a
> device to also write the memory in that case?

True, DMA_BIDIRECTIONAL and DMA_TO_DEVICE are being treated equally in
this case. Given this is the second time this facility needed to be
taught to be less eager [1], I'd be inclined to let the tie-break /
BIDIR case be treated like TO. This facility was always meant as a
"there might be a problem here", but not a definitive checker, and it
certainly loses value if the reports are ambiguous.

[1]: 3b7a6418c749 dma debug: account for cachelines and read-only
mappings in overlap tracking

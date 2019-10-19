Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85444DDB67
	for <lists+stable@lfdr.de>; Sun, 20 Oct 2019 01:11:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726146AbfJSXKQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 19 Oct 2019 19:10:16 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:35483 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726145AbfJSXKN (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 19 Oct 2019 19:10:13 -0400
Received: by mail-ot1-f66.google.com with SMTP id z6so8037697otb.2
        for <stable@vger.kernel.org>; Sat, 19 Oct 2019 16:10:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6V+goadp04lgp/6ouBZ08nnuiR9ZWMieowK64fMJJPo=;
        b=fvmToX7RhHX15J5XNflMsTcTNnjDjUc+03b9RJ9IzDfHKW+ha2Pvtrwen5Kj1hOVkI
         7IvzLMfYo5WOsYQPNi1pPjq83hd4BPzrAhD+byEiWhCrqKCHnBfBplkdJANy4Y4xfq9O
         F3MKgd81AdNmz99JPnxqi1dEPJFyfFURzhByULjZd/ddnWi4WsnzwkMfvQAwaCI/KUEQ
         Z/tWnSRMlDqgrueeSLcbfZ5u6IT3Fm3M0RHUENJiofrHx3m6DS6MUS1VXmTvZS+yvbtv
         WMnb9Tp1XzNtcPKkniBWTGF+U3d3aBQm2aSL/r2CtFbkVSW40/sMTmF22l/5SsbiKR38
         7oUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6V+goadp04lgp/6ouBZ08nnuiR9ZWMieowK64fMJJPo=;
        b=XBXs4R3KPjHLGKGXZ0mddxIrs8OgvXLxKjRSv2Xmfzh94dN7m5z7eokGnyAxkeCbHV
         zwrAuYkllNuzmvFyeumIoImrVXWz6Btvax0qS9yLRc5NdeWA1YlvK4Vg4G6xILKO7ALK
         DLe1IcuwZyekX4SuEsTFU0g1fEafKyQTzPCOjSnxhAVsIm2rOyLP4vtw56UFaikU7bxB
         yZP/HWLYyik3Yfb8SMOY1UrLF2LEFHwI0C9KX7h0gsGc5HdkOt6XmO8iAIgusF3ptBlW
         L92FJd26rBl2mW2KjNbE/CRoWWK54TjDfxGFyVozHGF1YHugvWrG7T1zPZtG3pfuL076
         zdzQ==
X-Gm-Message-State: APjAAAXkChUWiSIfFILJ/QEkMOqJS+hPn0/eoUplyf8aIwj8PPfrAubt
        9ja92aAoTJYUnIkEY16+e5mGy0U9wJgxDOLRNtu61A==
X-Google-Smtp-Source: APXvYqwVmgrM8/hkJM+rSC4kzo3Uext5IYl8OOxkbKEkTk91yIuX8Rv6+rZQ8op0qxcaadFmv/oFPnRqVJ8/JKRoTzw=
X-Received: by 2002:a9d:7843:: with SMTP id c3mr12157037otm.71.1571526612232;
 Sat, 19 Oct 2019 16:10:12 -0700 (PDT)
MIME-Version: 1.0
References: <157150237973.3940076.12626102230619807187.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20191019205003.GN32665@bombadil.infradead.org>
In-Reply-To: <20191019205003.GN32665@bombadil.infradead.org>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Sat, 19 Oct 2019 16:09:59 -0700
Message-ID: <CAPcyv4jj-BqhPj3vB5=G7YfGPvBgugEZ39gf+3Wwn6BC1fAUJw@mail.gmail.com>
Subject: Re: [PATCH] fs/dax: Fix pmd vs pte conflict detection
To:     Matthew Wilcox <willy@infradead.org>
Cc:     linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Jeff Smits <jeff.smits@intel.com>,
        Doug Nelson <doug.nelson@intel.com>,
        stable <stable@vger.kernel.org>, Jan Kara <jack@suse.cz>,
        linux-nvdimm <linux-nvdimm@lists.01.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Oct 19, 2019 at 1:50 PM Matthew Wilcox <willy@infradead.org> wrote:
>
> On Sat, Oct 19, 2019 at 09:26:19AM -0700, Dan Williams wrote:
> > Check for NULL entries before checking the entry order, otherwise NULL
> > is misinterpreted as a present pte conflict. The 'order' check needs to
> > happen before the locked check as an unlocked entry at the wrong order
> > must fallback to lookup the correct order.
> >
> > Reported-by: Jeff Smits <jeff.smits@intel.com>
> > Reported-by: Doug Nelson <doug.nelson@intel.com>
> > Cc: <stable@vger.kernel.org>
> > Fixes: 23c84eb78375 ("dax: Fix missed wakeup with PMD faults")
> > Cc: Jan Kara <jack@suse.cz>
> > Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
> > Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> > ---
> >  fs/dax.c |    5 +++--
> >  1 file changed, 3 insertions(+), 2 deletions(-)
> >
> > diff --git a/fs/dax.c b/fs/dax.c
> > index a71881e77204..08160011d94c 100644
> > --- a/fs/dax.c
> > +++ b/fs/dax.c
> > @@ -221,10 +221,11 @@ static void *get_unlocked_entry(struct xa_state *xas, unsigned int order)
> >
> >       for (;;) {
> >               entry = xas_find_conflict(xas);
> > +             if (!entry || WARN_ON_ONCE(!xa_is_value(entry)))
> > +                     return entry;
> >               if (dax_entry_order(entry) < order)
> >                       return XA_RETRY_ENTRY;
> > -             if (!entry || WARN_ON_ONCE(!xa_is_value(entry)) ||
> > -                             !dax_is_locked(entry))
> > +             if (!dax_is_locked(entry))
> >                       return entry;
>
> Yes, I think this works.  Should we also add:
>
>  static unsigned int dax_entry_order(void *entry)
>  {
> +       BUG_ON(!xa_is_value(entry));
>         if (xa_to_value(entry) & DAX_PMD)
>                 return PMD_ORDER;
>         return 0;
>  }
>
> which would have caught this logic error before it caused a performance
> regression?

Sounds good will add it to v2.

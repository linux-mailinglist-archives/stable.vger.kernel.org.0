Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6EE85EE81
	for <lists+stable@lfdr.de>; Wed,  3 Jul 2019 23:28:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726821AbfGCV2y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Jul 2019 17:28:54 -0400
Received: from mail-ot1-f65.google.com ([209.85.210.65]:43278 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726678AbfGCV2x (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Jul 2019 17:28:53 -0400
Received: by mail-ot1-f65.google.com with SMTP id q10so3887667otk.10
        for <stable@vger.kernel.org>; Wed, 03 Jul 2019 14:28:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8Oa5fyrgRSaS4/rlLU6Dg1I751HN6ZGGg3XuTeNEsyA=;
        b=EVDV2i92j6Oc8X9cDYFxw3faBgrvRgokearOh6hTInPcfDEF/9Dw3KaF4Zq6F/M1Po
         7PhktLMJwFP6nTQp9RrenWueYOGk2EVUa/0Qx0+hUltXSvdhvIuEHI+qKgYeF3B1eFlS
         5Y3swajWUyLDnwgyIA3axCIg+XMQUJMGQtIBwCbx1V1d//Itvxh9xcx753a7zTQU7G7q
         9Zf9F4ew3jdtrywY3ZSbzOZTGZe1X8L9mb5LB87Kgaj4vPdRVLpEenwZhPzX+x7S/pLI
         SKnQAFXjTLXqteyTAJ1slhEtrupPHQDbOkd7sNBcRXPLRfHg2/4qMUGQWkb8jOyatu6m
         VoNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8Oa5fyrgRSaS4/rlLU6Dg1I751HN6ZGGg3XuTeNEsyA=;
        b=FCZuvq9KQfvB8NWPsiReIZ9axhxPCvlQYC29l5jAkQqBtPkVQaeDYe98XJ+nH4J6rL
         PpRi5zVvUlXi8wOmy0TJyTOFZxHYWdDSH86GXTWa5GqaNr3QhrH5g4NlptL7fttPLsfu
         Okwx8HNOe/MfOZD+3hWTtdGlggelDoL7TpjPpmVIXYOWn/l8wWtnU9h8+wdGKgzQoPLs
         NEI3Rp2NBuOM8IfbBWEbU777i1PU/SZwOmi6XoIyp6fWNnGOJSr+AK4zRJfa42Y8mGl1
         8ySZIV7fBHC58n7BLCOOc/5dKWTFO+IH3RQYMtqa8YzX8PhhJ2BBsj3NhFUfORw6/OvH
         9B5w==
X-Gm-Message-State: APjAAAWBWhqQwyNYLijSFQ7QDdcO7QiW+yhrr5pHUg9zg5ya/egOXhu1
        z6N/z4J7BUv2c6a7x9jS6GOp9vucDwkFHJDqnuqHwg==
X-Google-Smtp-Source: APXvYqx/eeik3ZxIiy7z87X0O8OLG62WiPNdXk3FcnhR2wJoQDPQ4BqLvO7rM7/LGIyRCPcHEmicv2tHJYa45mbHcK0=
X-Received: by 2002:a9d:7248:: with SMTP id a8mr32385007otk.363.1562189332829;
 Wed, 03 Jul 2019 14:28:52 -0700 (PDT)
MIME-Version: 1.0
References: <156213869409.3910140.7715747316991468148.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20190703121743.GH1729@bombadil.infradead.org> <CAPcyv4jgs5LTtTXR+2CyfbjJE85B_eoPFuXQsGBDnVMo41Jawg@mail.gmail.com>
 <20190703195302.GJ1729@bombadil.infradead.org>
In-Reply-To: <20190703195302.GJ1729@bombadil.infradead.org>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Wed, 3 Jul 2019 14:28:41 -0700
Message-ID: <CAPcyv4iPNz=oJyc_EoE-mC11=gyBzwMKbmj1ZY_Yna54=cC=Mg@mail.gmail.com>
Subject: Re: [PATCH] dax: Fix missed PMD wakeups
To:     Matthew Wilcox <willy@infradead.org>
Cc:     linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Jan Kara <jack@suse.cz>, Boaz Harrosh <openosd@gmail.com>,
        stable <stable@vger.kernel.org>,
        Robert Barror <robert.barror@intel.com>,
        Seema Pandit <seema.pandit@intel.com>,
        linux-nvdimm <linux-nvdimm@lists.01.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 3, 2019 at 12:53 PM Matthew Wilcox <willy@infradead.org> wrote:
>
> On Wed, Jul 03, 2019 at 10:01:37AM -0700, Dan Williams wrote:
> > On Wed, Jul 3, 2019 at 5:17 AM Matthew Wilcox <willy@infradead.org> wrote:
> > >
> > > On Wed, Jul 03, 2019 at 12:24:54AM -0700, Dan Williams wrote:
> > > > This fix may increase waitqueue contention, but a fix for that is saved
> > > > for a larger rework. In the meantime this fix is suitable for -stable
> > > > backports.
> > >
> > > I think this is too big for what it is; just the two-line patch to stop
> > > incorporating the low bits of the PTE would be more appropriate.
> >
> > Sufficient, yes, "appropriate", not so sure. All those comments about
> > pmd entry size are stale after this change.
>
> But then they'll have to be put back in again.  This seems to be working
> for me, although I doubt I'm actually hitting the edge case that rocksdb
> hits:

Seems to be holding up under testing here, a couple comments...

>
> diff --git a/fs/dax.c b/fs/dax.c
> index 2e48c7ebb973..e77bd6aef10c 100644
> --- a/fs/dax.c
> +++ b/fs/dax.c
> @@ -198,6 +198,10 @@ static void dax_wake_entry(struct xa_state *xas, void *entry, bool wake_all)
>   * if it did.
>   *
>   * Must be called with the i_pages lock held.
> + *
> + * If the xa_state refers to a larger entry, then it may return a locked
> + * smaller entry (eg a PTE entry) without waiting for the smaller entry
> + * to be unlocked.
>   */
>  static void *get_unlocked_entry(struct xa_state *xas)
>  {
> @@ -211,7 +215,8 @@ static void *get_unlocked_entry(struct xa_state *xas)
>         for (;;) {
>                 entry = xas_find_conflict(xas);
>                 if (!entry || WARN_ON_ONCE(!xa_is_value(entry)) ||
> -                               !dax_is_locked(entry))
> +                               !dax_is_locked(entry) ||
> +                               dax_entry_order(entry) < xas_get_order(xas))

Doesn't this potentially allow a locked entry to be returned for a
caller that expects all value entries are unlocked?

>                         return entry;
>
>                 wq = dax_entry_waitqueue(xas, entry, &ewait.key);
> @@ -253,8 +258,12 @@ static void wait_entry_unlocked(struct xa_state *xas, void *entry)
>
>  static void put_unlocked_entry(struct xa_state *xas, void *entry)
>  {
> -       /* If we were the only waiter woken, wake the next one */
> -       if (entry)
> +       /*
> +        * If we were the only waiter woken, wake the next one.
> +        * Do not wake anybody if the entry is locked; that indicates
> +        * we weren't woken.
> +        */
> +       if (entry && !dax_is_locked(entry))
>                 dax_wake_entry(xas, entry, false);
>  }
>
> diff --git a/include/linux/xarray.h b/include/linux/xarray.h
> index 052e06ff4c36..b17289d92af4 100644
> --- a/include/linux/xarray.h
> +++ b/include/linux/xarray.h
> @@ -1529,6 +1529,27 @@ static inline void xas_set_order(struct xa_state *xas, unsigned long index,
>  #endif
>  }
>
> +/**
> + * xas_get_order() - Get the order of the entry being operated on.
> + * @xas: XArray operation state.
> + *
> + * Return: The order of the entry.
> + */
> +static inline unsigned int xas_get_order(const struct xa_state *xas)
> +{
> +       unsigned int order = xas->xa_shift;
> +
> +#ifdef CONFIG_XARRAY_MULTI
> +       unsigned int sibs = xas->xa_sibs;
> +
> +       while (sibs) {
> +               order++;
> +               sibs /= 2;
> +       }

Use ilog2() here?

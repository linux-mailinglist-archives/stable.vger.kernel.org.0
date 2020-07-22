Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98E45228FA4
	for <lists+stable@lfdr.de>; Wed, 22 Jul 2020 07:26:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726669AbgGVF0B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jul 2020 01:26:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726161AbgGVF0A (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Jul 2020 01:26:00 -0400
Received: from mail-oi1-x244.google.com (mail-oi1-x244.google.com [IPv6:2607:f8b0:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E02BC061794
        for <stable@vger.kernel.org>; Tue, 21 Jul 2020 22:26:00 -0700 (PDT)
Received: by mail-oi1-x244.google.com with SMTP id k22so849933oib.0
        for <stable@vger.kernel.org>; Tue, 21 Jul 2020 22:26:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Dz0PNWvUyA5bVwawo9dRFrBcMuGComXjKBNRW57uQgg=;
        b=gPtekxXwx5xoHX6xD+EB5QVJSdczVy9YPn9MQCfSKGHYw21MojiJ5s/CwN4esHCjaI
         sUCaRRd37tWCDsHp5NAM788cBt4cCLM6mISCsVmTepQ3OInoRXDVmX8b9U5fjQ+oMITR
         fwBFIOpWJ32fKnV4BAMojzUQn7DsFMGYuzPgg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Dz0PNWvUyA5bVwawo9dRFrBcMuGComXjKBNRW57uQgg=;
        b=EzqoFY15KCMNj7E8RUiRKc2tGJMOBBdotWv8+ebk8PdDt2fYsSUWrAv1FDtMvz3Eh6
         jePh8Z8eVb8sncpg9ngPCRlWbwcTRC/ZU5FqntzZVt9K9F/wdesLgPAMf55LXgmdDjk+
         pQIBJvJAzcm53Oz4LvrsrAaRHyQUn+0vxsaOFkDCYNehrmh765DQpJPjUsOnnztpQE0e
         VhmG5zP+Hh+F+Ub/XI32xAm9nYPH7bE8yMiCgAajoxRThD1u5kWG3Q6boPDjUsrLlDGZ
         jnNqr8MkG0/EOBKUvWAzBIV3L52qzr284b53FcQJ8RPQCgSjSNs3etuOIN8H8+63Vgq8
         OOcA==
X-Gm-Message-State: AOAM531D6E1BJcQOELt77Pv3e2TWr+YIfaOE0BagRoKv7foA2+SqT2s8
        9CSeek2a5JnCrNhgxMIa5ycaaROfn9E1QodtPWfryQ==
X-Google-Smtp-Source: ABdhPJycaRmTBcGABti42e3PKUTAQ34pmYikeYm6E7HWLcfVGdGx9DrGPj1mAOjJhuy0kvoLmA482wjfjEe6I5mW5iE=
X-Received: by 2002:a05:6808:88:: with SMTP id s8mr5502429oic.101.1595395559971;
 Tue, 21 Jul 2020 22:25:59 -0700 (PDT)
MIME-Version: 1.0
References: <20200721171936.81563-1-michael.j.ruhl@intel.com>
 <20200721135648.9603d924377825a7e6c0023b@linux-foundation.org>
 <14063C7AD467DE4B82DEDB5C278E866301245E046C@FMSMSX108.amr.corp.intel.com> <20200721142424.b8846cddf1efd48e45278a42@linux-foundation.org>
In-Reply-To: <20200721142424.b8846cddf1efd48e45278a42@linux-foundation.org>
From:   Daniel Vetter <daniel@ffwll.ch>
Date:   Wed, 22 Jul 2020 07:25:48 +0200
Message-ID: <CAKMK7uGNyEEZxsT8PB6X6-Ea-Z_oB498wuV4G8tO-b-ygNiwVQ@mail.gmail.com>
Subject: Re: [PATCH v2] io-mapping: Indicate mapping failure
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     "Ruhl, Michael J" <michael.j.ruhl@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Mike Rapoport <rppt@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 21, 2020 at 11:24 PM Andrew Morton
<akpm@linux-foundation.org> wrote:
>
> On Tue, 21 Jul 2020 21:02:44 +0000 "Ruhl, Michael J" <michael.j.ruhl@intel.com> wrote:
>
> > >--- a/include/linux/io-mapping.h~io-mapping-indicate-mapping-failure-fix
> > >+++ a/include/linux/io-mapping.h
> > >@@ -107,9 +107,12 @@ io_mapping_init_wc(struct io_mapping *io
> > >                resource_size_t base,
> > >                unsigned long size)
> > > {
> > >+    iomap->iomem = ioremap_wc(base, size);
> > >+    if (!iomap->iomem)
> > >+            return NULL;
> > >+
> >
> > This does make more sense.
> >
> > I am confused by the two follow up emails I just got.
>
> One was your original patch, the other is my suggested alteration.
>
> > Shall I resubmit, or is this path (if !iomap->iomem) return NULL)
> > now in the tree.
>
> All is OK.  If my alteration is acceptable (and, preferably, tested!)
> then when the time comes, I'll fold it into the base patch, add a
> note indicating this change and shall then send it to Linus.

Your alternative also matches the other implementation of
io_mapping_init_wc, I was kinda tempted to do that suggestion too just
because of that. But then didn't send out that email.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6183A45DD93
	for <lists+stable@lfdr.de>; Thu, 25 Nov 2021 16:37:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234047AbhKYPkl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Nov 2021 10:40:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242054AbhKYPik (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Nov 2021 10:38:40 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7493CC06139E
        for <stable@vger.kernel.org>; Thu, 25 Nov 2021 07:29:00 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id b12so12467991wrh.4
        for <stable@vger.kernel.org>; Thu, 25 Nov 2021 07:29:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=g/l/Zt6l//0WhpMp7/x9EgUSAEIcfRaNwbku+X50+d8=;
        b=kL6xrum/DEDA73kTZNeF8b01p/SYkUyXbvVTGDZ3CYjpeK0iL0pkTv1CS3CgTAPmDZ
         XNO2ozVnWnwIvOQWbKAhS3ez3/x8A1l+mv9JQ0hp1rk6OTrLgQj4aWR+99ycBb9JwgHn
         CobdWgSn4vyzbR2R1dKgbtf+4zeA3lVl/T6s7hqYGJnA/trS9UfMsx2qwL+4fKls1/mC
         x1g6R2rMLx6RE1QVWUrnGn67ky7uHveFqqX16EpilxgL+gPtymSL+EKRPlvYj1tjULld
         OHZOC9ih+8x8BnNVexChLyCsS+i2Y3LIdckHQqmvj0c3lT1yrWBL/OSLEZ3wriUPQ3qO
         ez0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=g/l/Zt6l//0WhpMp7/x9EgUSAEIcfRaNwbku+X50+d8=;
        b=jV8KB+61NGzQJ37okzCENC2MgAhp5eoT30Gk77F//N0OZ2lgcCqguZw+kkYPGYGWzC
         BHxcBCyLMOvIdvS/F2B26bJncIXp0MRWwnzmqaXijdLVjI5yFWcpVr6Y/8+B/ATB5tIR
         z4iEBuEQhj5bVaJZW3ysqshIR0DCgDYTGtUBgaRLfRWrflwRPiA7zeEsoyIPB7pAmTHf
         FNkXyVQL7fydUwdZucX7jVd4QCYdDoAQVwjq+RuLo+uEX7Cn6BlorEL8vu2c3NEntB1Q
         PH5dqomt6TFRqzePnhxUcwGhroxMQdl1+E4kHJGxiqBjs1wi8ZYPyttvgz5gAH6cPOD7
         VADg==
X-Gm-Message-State: AOAM533UKA7Ejp6wruoerCI2YpUlCkYKs+TPL4Xws40QMYpegXyzm9u3
        nXnTxRQZoX14hNR9e+cgMebyPQ==
X-Google-Smtp-Source: ABdhPJw5zmI4w9br8mbbXPWCWSoZ80q+2Yon2POY2SPv6nO1yLE9sFQLUUL8dbdBG4r9fKGuEz4f2Q==
X-Received: by 2002:adf:ce08:: with SMTP id p8mr7459591wrn.154.1637854139046;
        Thu, 25 Nov 2021 07:28:59 -0800 (PST)
Received: from google.com ([2.31.167.18])
        by smtp.gmail.com with ESMTPSA id d15sm4577839wri.50.2021.11.25.07.28.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Nov 2021 07:28:58 -0800 (PST)
Date:   Thu, 25 Nov 2021 15:28:56 +0000
From:   Lee Jones <lee.jones@linaro.org>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     devel@driverdev.osuosl.org, arve@android.com,
        stable@vger.kernel.org, riandrews@android.com, labbott@redhat.com,
        sumit.semwal@linaro.org
Subject: Re: [PATCH 1/1] staging: ion: Prevent incorrect reference counting
 behavour
Message-ID: <YZ+ruHBCp9zsXB/q@google.com>
References: <20211125142004.686650-1-lee.jones@linaro.org>
 <20211125145004.GN6514@kadam>
 <YZ+muS7vC5iNs/kq@google.com>
 <20211125151822.GJ18178@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211125151822.GJ18178@kadam>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 25 Nov 2021, Dan Carpenter wrote:

> On Thu, Nov 25, 2021 at 03:07:37PM +0000, Lee Jones wrote:
> > On Thu, 25 Nov 2021, Dan Carpenter wrote:
> > 
> > > On Thu, Nov 25, 2021 at 02:20:04PM +0000, Lee Jones wrote:
> > > > Supply additional checks in order to prevent unexpected results.
> > > > 
> > > > Fixes: b892bf75b2034 ("ion: Switch ion to use dma-buf")
> > > > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > > > ---
> > > > Should be back-ported from v4.9 and earlier.
> > > > 
> > > >  drivers/staging/android/ion/ion.c | 5 +++++
> > > >  1 file changed, 5 insertions(+)
> > > > 
> > > > diff --git a/drivers/staging/android/ion/ion.c b/drivers/staging/android/ion/ion.c
> > > > index 806e9b30b9dc8..402b74f5d7e69 100644
> > > > --- a/drivers/staging/android/ion/ion.c
> > > > +++ b/drivers/staging/android/ion/ion.c
> > > > @@ -29,6 +29,7 @@
> > > >  #include <linux/export.h>
> > > >  #include <linux/mm.h>
> > > >  #include <linux/mm_types.h>
> > > > +#include <linux/overflow.h>
> > > >  #include <linux/rbtree.h>
> > > >  #include <linux/slab.h>
> > > >  #include <linux/seq_file.h>
> > > > @@ -509,6 +510,10 @@ static void *ion_handle_kmap_get(struct ion_handle *handle)
> > > >  	void *vaddr;
> > > >  
> > > >  	if (handle->kmap_cnt) {
> > > > +		if (check_add_overflow(handle->kmap_cnt,
> > > > +				       (unsigned int) 1, &handle->kmap_cnt))
> > >                                                          ^^^^^^^^^^^^^^^^^
> > > 
> > > > +			return ERR_PTR(-EOVERFLOW);
> > > > +
> > > >  		handle->kmap_cnt++;
> > >                 ^^^^^^^^^^^^^^^^^^^
> > > This will not do what you want at all.  It's a double increment on the
> > > success path and it leave handle->kmap_cnt overflowed on failure path.
> > 
> > I read the helper to take copies of the original variables.
> > 
> > #define __unsigned_add_overflow(a, b, d) ({     \
> >         typeof(a) __a = (a);                    \
> >         typeof(b) __b = (b);                    \
> >         typeof(d) __d = (d);                    \
> >         (void) (&__a == &__b);                  \
> >         (void) (&__a == __d);                   \
> >         *__d = __a + __b;                       \
>           ^^^^^^^^^^^^^^^^
> This assignment sets handle->kmap_cnt to the overflowed value.
> 
> >         *__d < __a;                             \
> > })
> > 
> > Maybe I misread it.
> > 
> > So the original patch [0] was better?
> > 
> > [0] https://lore.kernel.org/stable/20211125120234.67987-1-lee.jones@linaro.org/ 
> 
> The original at least worked.  :P
> 
> You're catching me right as I'm knocking off for the day so I'm not
> sure how to write this code.  I had thought that ->kmap_cnt was a
> regular int and not an unsigned int, but I would have to pull a stable
> tree to see where I misread the code.
> 
> I'll look at this tomorrow Nairobi time, but I expect by then you'll
> already have it all figured out.

There's no rush.  This has been broken for a long time.

-- 
Lee Jones [李琼斯]
Senior Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog

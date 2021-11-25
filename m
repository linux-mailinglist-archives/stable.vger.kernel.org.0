Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD01545DAC4
	for <lists+stable@lfdr.de>; Thu, 25 Nov 2021 14:12:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354958AbhKYNPy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Nov 2021 08:15:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355045AbhKYNNx (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Nov 2021 08:13:53 -0500
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D066C0613ED
        for <stable@vger.kernel.org>; Thu, 25 Nov 2021 05:03:50 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id s13so11537307wrb.3
        for <stable@vger.kernel.org>; Thu, 25 Nov 2021 05:03:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=m73u2cjHd9EZWp0ZIr01RX/646HzY7RWPJjiwPZVB4U=;
        b=zJM4y0JT59cLU5umDl+Tg1f7auAJyqF0fRKA/nZrOqKwfIrPbxNAugd1ptwE80Bqwe
         LzuxPHnQZlEfceqghM74zfEKJmmlmizQSecUFXddlC1HiHQtTV7/9WMpk+9vNYGTFg6j
         /zgMexKumvdtwKWx+8Md3T3hPdqbr4rjFXPOOcMSyt5MJizJFZvCcWnTUqS6X9mizVOu
         9CZEKy9zvsFUxIHyojMOT1gLsp83Ec8Fct8HMVwu/kYzW2rYqNATlnL3nain8p7OyyAq
         yzaWcJxkk2hIyddFnalvVHQxMD2Slv/Qeu4i9IOjvWpWl9fWtotpnzKBGTxlZwnsOXwb
         VewA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=m73u2cjHd9EZWp0ZIr01RX/646HzY7RWPJjiwPZVB4U=;
        b=2w2Tt+riuI5cWsigRZppCY4pvBMKyJI6RczwkM8Kw+cXSZqeHUCthw6VQVDsfUQzYs
         /kT8oRYRCEldvsECzWj0kZUxoUjD/rkEVdxxKoBSjFItOSkFFYRo9P6yP5wh/YC68FQG
         Aggjn/vF03UsMhIjTlkLiLnrGc/2wwwsc1525AkLs67jAsKBTt8YJfG/Zsq1yd3NxI8t
         GzxxXHBG3A9TuNul7TA0z5dr9VK7hTupwPz1uvMFMILgZTLK6R9/tco8c9LZnDiAsd0V
         B1/bDK+VG7GNbzbSKWjBGrLkAh4Lwlt7vebWBJbruR/YRHVpHR64vJxwtRLG0LaTxsUi
         sLyQ==
X-Gm-Message-State: AOAM533Tlur2HgmtvWpOp3VW79mX/2TonGtlkhi+1OPr0ReJndH+dJVF
        GECb4W0lT3ulQasIV+UPxRKyzg==
X-Google-Smtp-Source: ABdhPJzaZYRUyWv/s7+lXxzFVMWjcK6Yt/LurrsBLbYzzEOBjwWxqZBkjL+HdnJDGUixN/kTec1MAQ==
X-Received: by 2002:adf:f10f:: with SMTP id r15mr5812006wro.553.1637845428750;
        Thu, 25 Nov 2021 05:03:48 -0800 (PST)
Received: from google.com ([2.31.167.18])
        by smtp.gmail.com with ESMTPSA id b197sm2924197wmb.24.2021.11.25.05.03.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Nov 2021 05:03:48 -0800 (PST)
Date:   Thu, 25 Nov 2021 13:03:46 +0000
From:   Lee Jones <lee.jones@linaro.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     devel@driverdev.osuosl.org, riandrews@android.com,
        stable@vger.kernel.org, arve@android.com, labbott@redhat.com,
        sumit.semwal@linaro.org
Subject: Re: [PATCH 1/1] staging: ion: Prevent incorrect reference counting
 behavour
Message-ID: <YZ+JsjZicl8jsRHM@google.com>
References: <20211125120234.67987-1-lee.jones@linaro.org>
 <YZ9+YPc7w9Z4xotR@kroah.com>
 <YZ+Fn0S1j4JzotGO@google.com>
 <YZ+HiBRUqLhSPwY0@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YZ+HiBRUqLhSPwY0@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 25 Nov 2021, Greg KH wrote:

> On Thu, Nov 25, 2021 at 12:46:23PM +0000, Lee Jones wrote:
> > On Thu, 25 Nov 2021, Greg KH wrote:
> > 
> > > On Thu, Nov 25, 2021 at 12:02:34PM +0000, Lee Jones wrote:
> > > > Supply additional checks in order to prevent unexpected results.
> > > > 
> > > > Fixes: b892bf75b2034 ("ion: Switch ion to use dma-buf")
> > > > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > > > ---
> > > >  drivers/staging/android/ion/ion.c | 3 +++
> > > >  1 file changed, 3 insertions(+)
> > > > 
> > > > diff --git a/drivers/staging/android/ion/ion.c b/drivers/staging/android/ion/ion.c
> > > > index 806e9b30b9dc8..30f359faba575 100644
> > > > --- a/drivers/staging/android/ion/ion.c
> > > > +++ b/drivers/staging/android/ion/ion.c
> > > > @@ -509,6 +509,9 @@ static void *ion_handle_kmap_get(struct ion_handle *handle)
> > > >  	void *vaddr;
> > > >  
> > > >  	if (handle->kmap_cnt) {
> > > > +		if (handle->kmap_cnt + 1 < handle->kmap_cnt)
> > > 
> > > What about using the nice helpers in overflow.h for this?
> > 
> > I haven't heard of these before.
> > 
> > Looks like they're not widely used.
> > 
> > I'll try them out and see how they go.
> > 
> > > > +			return ERR_PTR(-EOVERFLOW);
> > > > +
> > > >  		handle->kmap_cnt++;
> > > >  		return buffer->vaddr;
> > > >  	}
> > > 
> > > What stable kernel branch(es) is this for?
> > 
> > I assumed your magic scripts could determine this from the Fixes:
> > tag.  I'll be more explicit in v2.
> 
> The fixes tag says how far back for it to go, but not where to start
> that process from :)

What's your preferred method for identifying a start-point?

In the [PATCH] tag or appended on to Cc: stable ... # <here>?

I know both work, but what makes your life easier?

-- 
Lee Jones [李琼斯]
Senior Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog

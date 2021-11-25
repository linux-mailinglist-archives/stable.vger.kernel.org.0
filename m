Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 760D145DACF
	for <lists+stable@lfdr.de>; Thu, 25 Nov 2021 14:16:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355048AbhKYNTx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Nov 2021 08:19:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355129AbhKYNRx (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Nov 2021 08:17:53 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB985C06179E
        for <stable@vger.kernel.org>; Thu, 25 Nov 2021 05:11:38 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id a18so11538071wrn.6
        for <stable@vger.kernel.org>; Thu, 25 Nov 2021 05:11:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=CM02k8qgy8XwGEXwazxWflMqeYneK7YgPygQe224NhM=;
        b=OSPFnsRr1Jk3IiyXonNjDhS0on7XP1oLzT/pgduRTu7qw3hVk7oMTq2hSftImrMr9R
         l7/bPwtrpfzS/ksV+BsV3KTTI2GkErop3unaSGHUm0SiTsDsu6FrLvM1DThMvE4yxk5N
         eKXaIzVl11MWzfIXu1Zk9ON4lN+vMvf1WE62DloB1hUJWOtU9ErFCIRB46w5Sy+XqKmz
         aGJsXpPKR8w5F1NI93h3oyyTEvsl+Oi9ePXx2Hi5afwwWmbT/p2jmywzGkQct2ex3s3O
         cDwwaQR52ixMldXiEpbTn1AhQiXbRPJ15lWRMe1j1IoXZLoY/5G3grOwUrkMA2DYu0Nf
         LrHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=CM02k8qgy8XwGEXwazxWflMqeYneK7YgPygQe224NhM=;
        b=51yG/xnO2Wiy89D8IU+6g565AxpYiO9E5zPgykYDgGTtEzRsxYbbgSImFodSPKsiG9
         oW7qjpOfRF/uNGcB5aBjE7SjW8pCIq2L+RgXjsVJ/8J+mSeQ5u7oV8Bs/1pRTBZhvQYe
         TPAVG3uS5uEay8WmHDwE4F7qgUSmK8uiU2MrkFhlLOSESp3e9Z4FRSHa+9Xtkp2YvBaJ
         NKzaooFuMUknKCK4OF8oxz9ekP049COqxucQ1kz/G2gTY1bMIjjkiYE0dkkmsnGGFzpn
         4X0EoG8X7GL96v5GV37QMKuxxgNYolBn2TUHlonTRhoNRovSTFUY3s9yM8sb4Xq+UI4X
         tNEA==
X-Gm-Message-State: AOAM532KHC9mk2O+VDVuF9I19dHCL7dPUYqcLTDETXFQKOHERLBUrSx+
        Mzi/kG8VlrQeeZG4G0T26J3yI1DCTiMRXA==
X-Google-Smtp-Source: ABdhPJxZXDRFuGPJhEdUP3o9Tn+GqhTyva9sgO+SLTXtOJ69qvN5naWbLq26c7vuwIhqMS8SvcqTcg==
X-Received: by 2002:a5d:63ca:: with SMTP id c10mr6455262wrw.124.1637845897569;
        Thu, 25 Nov 2021 05:11:37 -0800 (PST)
Received: from google.com ([2.31.167.18])
        by smtp.gmail.com with ESMTPSA id h204sm3204233wmh.33.2021.11.25.05.11.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Nov 2021 05:11:37 -0800 (PST)
Date:   Thu, 25 Nov 2021 13:11:35 +0000
From:   Lee Jones <lee.jones@linaro.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     devel@driverdev.osuosl.org, arve@android.com,
        stable@vger.kernel.org, riandrews@android.com, labbott@redhat.com,
        sumit.semwal@linaro.org
Subject: Re: [PATCH 1/1] staging: ion: Prevent incorrect reference counting
 behavour
Message-ID: <YZ+LhzpwQ7RJtDSs@google.com>
References: <20211125120234.67987-1-lee.jones@linaro.org>
 <YZ9+YPc7w9Z4xotR@kroah.com>
 <YZ+Fn0S1j4JzotGO@google.com>
 <YZ+HiBRUqLhSPwY0@kroah.com>
 <YZ+JsjZicl8jsRHM@google.com>
 <YZ+Kc/M1qSaWfXPW@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YZ+Kc/M1qSaWfXPW@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 25 Nov 2021, Greg KH wrote:

> On Thu, Nov 25, 2021 at 01:03:46PM +0000, Lee Jones wrote:
> > On Thu, 25 Nov 2021, Greg KH wrote:
> > 
> > > On Thu, Nov 25, 2021 at 12:46:23PM +0000, Lee Jones wrote:
> > > > On Thu, 25 Nov 2021, Greg KH wrote:
> > > > 
> > > > > On Thu, Nov 25, 2021 at 12:02:34PM +0000, Lee Jones wrote:
> > > > > > Supply additional checks in order to prevent unexpected results.
> > > > > > 
> > > > > > Fixes: b892bf75b2034 ("ion: Switch ion to use dma-buf")
> > > > > > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > > > > > ---
> > > > > >  drivers/staging/android/ion/ion.c | 3 +++
> > > > > >  1 file changed, 3 insertions(+)
> > > > > > 
> > > > > > diff --git a/drivers/staging/android/ion/ion.c b/drivers/staging/android/ion/ion.c
> > > > > > index 806e9b30b9dc8..30f359faba575 100644
> > > > > > --- a/drivers/staging/android/ion/ion.c
> > > > > > +++ b/drivers/staging/android/ion/ion.c
> > > > > > @@ -509,6 +509,9 @@ static void *ion_handle_kmap_get(struct ion_handle *handle)
> > > > > >  	void *vaddr;
> > > > > >  
> > > > > >  	if (handle->kmap_cnt) {
> > > > > > +		if (handle->kmap_cnt + 1 < handle->kmap_cnt)
> > > > > 
> > > > > What about using the nice helpers in overflow.h for this?
> > > > 
> > > > I haven't heard of these before.
> > > > 
> > > > Looks like they're not widely used.
> > > > 
> > > > I'll try them out and see how they go.
> > > > 
> > > > > > +			return ERR_PTR(-EOVERFLOW);
> > > > > > +
> > > > > >  		handle->kmap_cnt++;
> > > > > >  		return buffer->vaddr;
> > > > > >  	}
> > > > > 
> > > > > What stable kernel branch(es) is this for?
> > > > 
> > > > I assumed your magic scripts could determine this from the Fixes:
> > > > tag.  I'll be more explicit in v2.
> > > 
> > > The fixes tag says how far back for it to go, but not where to start
> > > that process from :)
> > 
> > What's your preferred method for identifying a start-point?
> > 
> > In the [PATCH] tag or appended on to Cc: stable ... # <here>?
> > 
> > I know both work, but what makes your life easier?
> 
> Easiest is below the --- line say:
> ---
>  This is for kernel versions X.X and older.

Understood, thanks.

-- 
Lee Jones [李琼斯]
Senior Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A22B945DA4A
	for <lists+stable@lfdr.de>; Thu, 25 Nov 2021 13:48:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352866AbhKYMvj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Nov 2021 07:51:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352392AbhKYMti (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Nov 2021 07:49:38 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 883BEC06173E
        for <stable@vger.kernel.org>; Thu, 25 Nov 2021 04:46:27 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id a9so11373936wrr.8
        for <stable@vger.kernel.org>; Thu, 25 Nov 2021 04:46:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=+gncLq6zW+uaJXb12G46JXw6L/TdgNucdLmqfgrp0+o=;
        b=rVodE+/WNoi3Sfxs2jcd7569XzqUkSwJRQSvzGdzNymel1x2JaHWRq1fgKr7eF3A9Q
         RQfG/xGxSAKWtN4jiaZIsLePPV7uZo0m5qWSrRyDEbgATRYH0/dMZ1Aj7qqRpXfdPnFx
         1dWEDX8Jbq9RMkIXAb32vTtdUCkIQxS28TCzIMzmz1jxuXWxbCBE13Hz1YNUHsfAPa88
         6izLyPZ6u6oy4uaDAtR7DCfAQcJpX24x7aFIc8oRtd2c5h2Rb6QNMR4QBaK9DMJoCeag
         pPdaKnPHZ6oItc6bls2fxY/RbX1bGO239f3i7+X2ddbeEEUtJEbBE95ZIH0U0GICy2l2
         Yipg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=+gncLq6zW+uaJXb12G46JXw6L/TdgNucdLmqfgrp0+o=;
        b=sIkaIPm7MdXfzElWG1dJMWOMC9kR0PeGWiP6l5uO9t4bSZmOlPiKZBv9uDuRft1PgE
         3nhSpMQKp/8uucNXMEMwHvY9mfPM3wUF5J7eT2l0iNTFKEi30tjEcGgdoG1wyBLhf4Rr
         cDlCPT54B9BsE7xhOMV+PPiF0Xe2jRfkjkmUJMESuii2O1GU5OimW60fPQk28oXQ1WvK
         tUYgSBDtEWLHXE/+V5ReAvNONLWPGcTK0xprqt4rLJWv9jY6D/LeUAN8y0QwtuFzCU7O
         ujZz/1Kp33ml/1zqZZQILPyV8p1UEQcGvgfCFxoQxbg8GNo4yJOKklfl2Qc7HGSIs8W3
         puRw==
X-Gm-Message-State: AOAM532eoMm/QO9jgiV0wRO5cgE1VAp3AEAUZ0cC9N3Do1hArMDXPuu/
        MpDTHV6lAN4AmEeZP1Vj+0C4oQ==
X-Google-Smtp-Source: ABdhPJywL2FUFo74HYcfnZb781d5v7oT4P61QKWt5azK2yVdzqQXHeY2CdmiviPFB2uADOpu1K57ow==
X-Received: by 2002:adf:8b1e:: with SMTP id n30mr6166068wra.75.1637844386075;
        Thu, 25 Nov 2021 04:46:26 -0800 (PST)
Received: from google.com ([2.31.167.18])
        by smtp.gmail.com with ESMTPSA id x21sm7408221wmc.14.2021.11.25.04.46.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Nov 2021 04:46:25 -0800 (PST)
Date:   Thu, 25 Nov 2021 12:46:23 +0000
From:   Lee Jones <lee.jones@linaro.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     devel@driverdev.osuosl.org, arve@android.com,
        stable@vger.kernel.org, riandrews@android.com, labbott@redhat.com,
        sumit.semwal@linaro.org
Subject: Re: [PATCH 1/1] staging: ion: Prevent incorrect reference counting
 behavour
Message-ID: <YZ+Fn0S1j4JzotGO@google.com>
References: <20211125120234.67987-1-lee.jones@linaro.org>
 <YZ9+YPc7w9Z4xotR@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YZ9+YPc7w9Z4xotR@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 25 Nov 2021, Greg KH wrote:

> On Thu, Nov 25, 2021 at 12:02:34PM +0000, Lee Jones wrote:
> > Supply additional checks in order to prevent unexpected results.
> > 
> > Fixes: b892bf75b2034 ("ion: Switch ion to use dma-buf")
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > ---
> >  drivers/staging/android/ion/ion.c | 3 +++
> >  1 file changed, 3 insertions(+)
> > 
> > diff --git a/drivers/staging/android/ion/ion.c b/drivers/staging/android/ion/ion.c
> > index 806e9b30b9dc8..30f359faba575 100644
> > --- a/drivers/staging/android/ion/ion.c
> > +++ b/drivers/staging/android/ion/ion.c
> > @@ -509,6 +509,9 @@ static void *ion_handle_kmap_get(struct ion_handle *handle)
> >  	void *vaddr;
> >  
> >  	if (handle->kmap_cnt) {
> > +		if (handle->kmap_cnt + 1 < handle->kmap_cnt)
> 
> What about using the nice helpers in overflow.h for this?

I haven't heard of these before.

Looks like they're not widely used.

I'll try them out and see how they go.

> > +			return ERR_PTR(-EOVERFLOW);
> > +
> >  		handle->kmap_cnt++;
> >  		return buffer->vaddr;
> >  	}
> 
> What stable kernel branch(es) is this for?

I assumed your magic scripts could determine this from the Fixes:
tag.  I'll be more explicit in v2.

-- 
Lee Jones [李琼斯]
Senior Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47AA245EA35
	for <lists+stable@lfdr.de>; Fri, 26 Nov 2021 10:19:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353267AbhKZJWm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Nov 2021 04:22:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353755AbhKZJUl (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Nov 2021 04:20:41 -0500
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D7B6C06179E
        for <stable@vger.kernel.org>; Fri, 26 Nov 2021 01:12:23 -0800 (PST)
Received: by mail-wm1-x333.google.com with SMTP id az34-20020a05600c602200b0033bf8662572so6351991wmb.0
        for <stable@vger.kernel.org>; Fri, 26 Nov 2021 01:12:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=8WnwyWyMB/kYzpUzxfbbpOhOFDX9Ss7cnX/FubpG7VY=;
        b=qZx3FkJuR7AMG7yHgL+SBW4L6B3AJlOgKbylLtaCdil2WQupnRwVe50HGvTWJBNHwb
         b/qyb77tP3d4rHrjHksr72ObZtudziNvP/eZOIeq5Gvv04K2Gvob+T9PU2pAO9weUF7Y
         Gj2uEwktVM4/v/38y6MgErRQNPkgQ0heJbWkNNgJC3YdkElFYtCo842Fh002zCVOBy1I
         dpFdbON26z6qpeq94QXzcFQmenfYVxenhYP1jRXklt1YRAbzTYTzPHq8M6y5dakhPMSz
         ah5P1/7I4MSd7G11Cz5QaWsHraYpDTPziwsekK3VRhsBEKfwL5Dwkc2jvuK4VijKLKR5
         MblQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=8WnwyWyMB/kYzpUzxfbbpOhOFDX9Ss7cnX/FubpG7VY=;
        b=yDeueh0W+XrNYPJNoe93QwQqnjBM4fCWdzNM7O/i0EUHpEY4NbUq05naeOFa50QthA
         yOeuqDsbSkRxeripXoqX+k/+YOhe1UaRjCjWk8d4ukRIiL1kj5QrHbC4WNZVmmm9mggq
         AjyuV54qxd3ajgEIGp9v+coAE9MDtGEQugo50QDE0Rgw6mClL1vOPSc/tjPMnbcOJtuq
         2CZTJf7m3eW6WvitkIfABAEc2yNWbWMY4Cmx4u8yxMQId/6lITRy5YFSaThz3GnnQtLF
         SiL3iYWxgvXi0qV5nyv2xAHflaDYssCW4LQ8RWvA+4Pd4jng1ftcJVoncP51VkME2Q7z
         OYcw==
X-Gm-Message-State: AOAM532+2AZYFbrtExLmw8yOsEBhxRvJ8YohHVZfsG4yC1C1gajxrnRb
        jBAVGGluNSzLoewMpLd5zLYuaQ==
X-Google-Smtp-Source: ABdhPJxbKqKYs6WXhbSGGXCoKD+zbkwA08f7MeZUiX/u+RzpqOAKZaU+en+0c0sRIx+G4GD4KvDx4Q==
X-Received: by 2002:a7b:c752:: with SMTP id w18mr14375047wmk.96.1637917941648;
        Fri, 26 Nov 2021 01:12:21 -0800 (PST)
Received: from google.com ([2.31.167.18])
        by smtp.gmail.com with ESMTPSA id x4sm9889281wmi.3.2021.11.26.01.12.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Nov 2021 01:12:21 -0800 (PST)
Date:   Fri, 26 Nov 2021 09:12:19 +0000
From:   Lee Jones <lee.jones@linaro.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        devel@driverdev.osuosl.org, arve@android.com,
        stable@vger.kernel.org, riandrews@android.com, labbott@redhat.com,
        sumit.semwal@linaro.org
Subject: Re: [PATCH 1/1] staging: ion: Prevent incorrect reference counting
 behavour
Message-ID: <YaCk80uhsX8TU75X@google.com>
References: <20211125142004.686650-1-lee.jones@linaro.org>
 <20211125145004.GN6514@kadam>
 <YZ+muS7vC5iNs/kq@google.com>
 <20211125151822.GJ18178@kadam>
 <20211126071641.GO6514@kadam>
 <YaChOzfm2/3gY4o3@google.com>
 <YaCizHYteAeLT4yk@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YaCizHYteAeLT4yk@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 26 Nov 2021, Greg KH wrote:

> On Fri, Nov 26, 2021 at 08:56:27AM +0000, Lee Jones wrote:
> > On Fri, 26 Nov 2021, Dan Carpenter wrote:
> > 
> > > On Thu, Nov 25, 2021 at 06:18:22PM +0300, Dan Carpenter wrote:
> > > > I had thought that ->kmap_cnt was a regular int and not an unsigned
> > > > int, but I would have to pull a stable tree to see where I misread the
> > > > code.
> > > 
> > > I was looking at (struct ion_buffer)->kmap_cnt but this is
> > > (struct ion_handle)->kmap_cnt.  I'm not sure how those are related but
> > > it makes me nervous that one can go higher than the other.  Also both
> > > probably need overflow protection.
> > > 
> > > So I guess I would just do something like:
> > > 
> > > diff --git a/drivers/staging/android/ion/ion.c b/drivers/staging/android/ion/ion.c
> > > index 806e9b30b9dc8..e8846279b33b5 100644
> > > --- a/drivers/staging/android/ion/ion.c
> > > +++ b/drivers/staging/android/ion/ion.c
> > > @@ -489,6 +489,8 @@ static void *ion_buffer_kmap_get(struct ion_buffer *buffer)
> > >  	void *vaddr;
> > >  
> > >  	if (buffer->kmap_cnt) {
> > > +		if (buffer->kmap_cnt == INT_MAX)
> > > +			return ERR_PTR(-EOVERFLOW);
> > >  		buffer->kmap_cnt++;
> > >  		return buffer->vaddr;
> > >  	}
> > > @@ -509,6 +511,8 @@ static void *ion_handle_kmap_get(struct ion_handle *handle)
> > >  	void *vaddr;
> > >  
> > >  	if (handle->kmap_cnt) {
> > > +		if (handle->kmap_cnt == INT_MAX)
> > > +			return ERR_PTR(-EOVERFLOW);
> > >  		handle->kmap_cnt++;
> > >  		return buffer->vaddr;
> > >  	}
> > 
> > Which is all well and good until somebody changes the type.
> 
> That's hard to do on code that is removed from the kernel tree :)

That's a difficult stance to take when reviewing a patch which changes
the very code you base your argument on. :D

I'll do with Dan's PoV though - no sympathy given. :)

v3 to follow.

-- 
Lee Jones [李琼斯]
Senior Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog

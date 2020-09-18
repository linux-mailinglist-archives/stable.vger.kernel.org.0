Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A685126FD82
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 14:48:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726730AbgIRMsx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Sep 2020 08:48:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726154AbgIRMsw (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Sep 2020 08:48:52 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85D15C06174A
        for <stable@vger.kernel.org>; Fri, 18 Sep 2020 05:48:52 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id x23so5203971wmi.3
        for <stable@vger.kernel.org>; Fri, 18 Sep 2020 05:48:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=XApl2kYt9xUmRP5psUkQBhn2GDFKQJu7UH6yAt3QUWA=;
        b=A8p2oYFKY7zPaqTEiOXEd9EwjUjubmI5UxUmX2JaKANkCWPGfOgldA/C/f4mzKQQdw
         +SrkqGu42ESAhWYGb7V3XyrqV05qEXdsORrKto6EpEJhnyASo9U18DCOFcRiGzVCEsfc
         QYyq7gAb/SUs5vCrjYzg9O7R7k3hiAmZYAbso=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :content-transfer-encoding:in-reply-to;
        bh=XApl2kYt9xUmRP5psUkQBhn2GDFKQJu7UH6yAt3QUWA=;
        b=HXi11BrnMzWIzctWOOBYpEj7RYpE0G68q8SBx7HCHcWLjm3gf30ddHYeop5GfXx3nG
         X6h3UMSCcsp/wBPVEAgB/w9cygWsDk6gL3o3VMFHdpwNBEaCSBfNIcOu7jZh5INsmpTB
         sk38yBLWMFEe/3rv+5M4N05Wz6bBhzNcfSexRYny5m3tHrwckDbhOqbwylTPw0kGmWrb
         TTY15aCzSd+aTjXGEKwwulfTLqJuGRshK/yW6cRSjIxPpqS5MuV4rYbVUyqFMgoQ9BAy
         hdbW4wIO8cGVkTdSGRzWOGu1iI6eir7O7BLSVwZqSCgxvV/IDPGAoJuZ6fN8xT5OIXEp
         4AkQ==
X-Gm-Message-State: AOAM532T3YR2EuARAEI+v2z4qcag6Lmx43S2GfU5PGDnALu3+7FrRe1R
        jYEq5qOgr+6gPjNi+UMrdKmbWg==
X-Google-Smtp-Source: ABdhPJws4fdJlwAFRicyfASJ6sKqsyVx8I56ikTXgryM1sw8YM3g8WD8s8WEkijsL4e0bWaUa5+i4w==
X-Received: by 2002:a7b:cd05:: with SMTP id f5mr15140544wmj.116.1600433331211;
        Fri, 18 Sep 2020 05:48:51 -0700 (PDT)
Received: from phenom.ffwll.local ([2a02:168:57f4:0:efd0:b9e5:5ae6:c2fa])
        by smtp.gmail.com with ESMTPSA id p11sm4881656wma.11.2020.09.18.05.48.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Sep 2020 05:48:50 -0700 (PDT)
Date:   Fri, 18 Sep 2020 14:48:48 +0200
From:   Daniel Vetter <daniel@ffwll.ch>
To:     Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>
Cc:     Charan Teja Reddy <charante@codeaurora.org>,
        sumit.semwal@linaro.org, arnd@arndb.de,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        linaro-mm-sig@lists.linaro.org, vinmenon@codeaurora.org,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org
Subject: Re: [PATCH] dmabuf: fix NULL pointer dereference in dma_buf_release()
Message-ID: <20200918124848.GE438822@phenom.ffwll.local>
Mail-Followup-To: Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
        Charan Teja Reddy <charante@codeaurora.org>,
        sumit.semwal@linaro.org, arnd@arndb.de,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        linaro-mm-sig@lists.linaro.org, vinmenon@codeaurora.org,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org
References: <1600425151-27670-1-git-send-email-charante@codeaurora.org>
 <7a4a51fb-008b-cd64-35e7-2a2765b2c3a6@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7a4a51fb-008b-cd64-35e7-2a2765b2c3a6@amd.com>
X-Operating-System: Linux phenom 5.7.0-1-amd64 
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Sep 18, 2020 at 01:16:16PM +0200, Christian König wrote:
> Am 18.09.20 um 12:32 schrieb Charan Teja Reddy:
> > NULL pointer dereference is observed while exporting the dmabuf but
> > failed to allocate the 'struct file' which results into the dropping of
> > the allocated dentry corresponding to this file in the dmabuf fs, which
> > is ending up in dma_buf_release() and accessing the uninitialzed
> > dentry->d_fsdata.
> > 
> > Call stack on 5.4 is below:
> >   dma_buf_release+0x2c/0x254 drivers/dma-buf/dma-buf.c:88
> >   __dentry_kill+0x294/0x31c fs/dcache.c:584
> >   dentry_kill fs/dcache.c:673 [inline]
> >   dput+0x250/0x380 fs/dcache.c:859
> >   path_put+0x24/0x40 fs/namei.c:485
> >   alloc_file_pseudo+0x1a4/0x200 fs/file_table.c:235
> >   dma_buf_getfile drivers/dma-buf/dma-buf.c:473 [inline]
> >   dma_buf_export+0x25c/0x3ec drivers/dma-buf/dma-buf.c:585
> > 
> > Fix this by checking for the valid pointer in the dentry->d_fsdata.
> > 
> > Fixes: 4ab59c3c638c ("dma-buf: Move dma_buf_release() from fops to dentry_ops")
> > Cc: <stable@vger.kernel.org> [5.7+]
> > Signed-off-by: Charan Teja Reddy <charante@codeaurora.org>
> 
> Reviewed-by: Christian König <christian.koenig@amd.com>
> 
> Going to pick this up for inclusion into drm-misc-next as well.

drm-misc-fixes since this is a bugfix that needs to be backported.
-Daniel

> 
> > ---
> >   drivers/dma-buf/dma-buf.c | 2 ++
> >   1 file changed, 2 insertions(+)
> > 
> > diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
> > index 58564d82..844967f 100644
> > --- a/drivers/dma-buf/dma-buf.c
> > +++ b/drivers/dma-buf/dma-buf.c
> > @@ -59,6 +59,8 @@ static void dma_buf_release(struct dentry *dentry)
> >   	struct dma_buf *dmabuf;
> >   	dmabuf = dentry->d_fsdata;
> > +	if (unlikely(!dmabuf))
> > +		return;
> >   	BUG_ON(dmabuf->vmapping_counter);
> 
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> https://lists.freedesktop.org/mailman/listinfo/dri-devel

-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch

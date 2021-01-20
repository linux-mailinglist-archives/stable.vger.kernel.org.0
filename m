Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC2F52FCEAD
	for <lists+stable@lfdr.de>; Wed, 20 Jan 2021 12:02:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387777AbhATKwh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Jan 2021 05:52:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731346AbhATJ3k (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Jan 2021 04:29:40 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7435AC061575
        for <stable@vger.kernel.org>; Wed, 20 Jan 2021 01:28:58 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id a1so1058482wrq.6
        for <stable@vger.kernel.org>; Wed, 20 Jan 2021 01:28:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=EuMk1HsGvXG72o1sJuM2wmg5seWvbCU4qLLOVTwy0NE=;
        b=lBxxZ4GswSVInyIxok3oXd1n3ACnkplEL70CX7GL6vnjXBiD+YEwUhmwNtp6zJleUD
         3981xzipZZMKe5sQl5eU0/ArlERfH11VSDh4HQIYLAX0kdxsmCtrkP4FADpOP3bsomjs
         H6e0vNw6efvefo8rhalodYyz2U8LJegAtVrT0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=EuMk1HsGvXG72o1sJuM2wmg5seWvbCU4qLLOVTwy0NE=;
        b=cvjLigAV0XnlRuDzOjTxP0Rdy+ZVvi6ArKN/TFoggwpg8QGRubOsjZY8dFpGwuLBDx
         SH+ADlXUw9lCT+hn2AQ7Ccbi9mng1Dc6Hn/fWX4lQhqFYDkor9TkNuFEV/RmRDSXHosh
         1+2diz9xWOD1aYbkxU4nn6gyYwUoKgVt2F6oZxbgsW7wKGN9WemLAvIK+5a6xdYSbbMH
         krY5UdW6hOkG7okGg6jztG00Sb/3E0LDqJC7ipl0UFGxFk0gbYE3GVsBXiJybd4mXruR
         5V4Muf2hWnwEzavhslC0hh44xNkM4LKhQEP7cY6JEtpGZ0rLRuMwaxIHUCTRw+2fOc4p
         f4eQ==
X-Gm-Message-State: AOAM532B2Q0vbv89ltBJxiPOAR90vyzsMz8mwi257G9gfsQanRsLxSd0
        z58dT9m3bnhYUTo44C1ATZK8cQ==
X-Google-Smtp-Source: ABdhPJz+7b1bfqPP1JPo1hQ73zoaI4YvCSGRGRon/YOUXqz5kdYShnSsvNDKLimtcSvC2Nj5XgdHQw==
X-Received: by 2002:a5d:510f:: with SMTP id s15mr8211262wrt.21.1611134937140;
        Wed, 20 Jan 2021 01:28:57 -0800 (PST)
Received: from phenom.ffwll.local ([2a02:168:57f4:0:efd0:b9e5:5ae6:c2fa])
        by smtp.gmail.com with ESMTPSA id i59sm3215375wri.3.2021.01.20.01.28.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jan 2021 01:28:56 -0800 (PST)
Date:   Wed, 20 Jan 2021 10:28:54 +0100
From:   Daniel Vetter <daniel@ffwll.ch>
To:     Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>
Cc:     Daniel Vetter <daniel.vetter@ffwll.ch>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Lionel Landwerlin <lionel.g.landwerlin@intel.com>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>, stable@vger.kernel.org
Subject: Re: [PATCH] drm/syncobj: Fix use-after-free
Message-ID: <YAf31kUyABDlbEiL@phenom.ffwll.local>
References: <20210119130318.615145-1-daniel.vetter@ffwll.ch>
 <dd14c09f-acbe-3fa5-2088-a68951847707@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <dd14c09f-acbe-3fa5-2088-a68951847707@amd.com>
X-Operating-System: Linux phenom 5.7.0-1-amd64 
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 19, 2021 at 02:08:12PM +0100, Christian König wrote:
> Am 19.01.21 um 14:03 schrieb Daniel Vetter:
> > While reviewing Christian's annotation patch I noticed that we have a
> > user-after-free for the WAIT_FOR_SUBMIT case: We drop the syncobj
> > reference before we've completed the waiting.
> > 
> > Of course usually there's nothing bad happening here since userspace
> > keeps the reference, but we can't rely on userspace to play nice here!
> > 
> > Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
> > Fixes: bc9c80fe01a2 ("drm/syncobj: use the timeline point in drm_syncobj_find_fence v4")
> > Cc: Christian König <christian.koenig@amd.com>
> > Cc: Lionel Landwerlin <lionel.g.landwerlin@intel.com>
> > Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
> > Cc: Maxime Ripard <mripard@kernel.org>
> > Cc: Thomas Zimmermann <tzimmermann@suse.de>
> > Cc: David Airlie <airlied@linux.ie>
> > Cc: Daniel Vetter <daniel@ffwll.ch>
> > Cc: dri-devel@lists.freedesktop.org
> > Cc: <stable@vger.kernel.org> # v5.2+
> 
> Reviewed-by: Christian König <christian.koenig@amd.com>

Pushed to drm-misc-fixes, thanks for reviewing.
-Daniel

> 
> > ---
> >   drivers/gpu/drm/drm_syncobj.c | 8 +++++---
> >   1 file changed, 5 insertions(+), 3 deletions(-)
> > 
> > diff --git a/drivers/gpu/drm/drm_syncobj.c b/drivers/gpu/drm/drm_syncobj.c
> > index 6e74e6745eca..349146049849 100644
> > --- a/drivers/gpu/drm/drm_syncobj.c
> > +++ b/drivers/gpu/drm/drm_syncobj.c
> > @@ -388,19 +388,18 @@ int drm_syncobj_find_fence(struct drm_file *file_private,
> >   		return -ENOENT;
> >   	*fence = drm_syncobj_fence_get(syncobj);
> > -	drm_syncobj_put(syncobj);
> >   	if (*fence) {
> >   		ret = dma_fence_chain_find_seqno(fence, point);
> >   		if (!ret)
> > -			return 0;
> > +			goto out;
> >   		dma_fence_put(*fence);
> >   	} else {
> >   		ret = -EINVAL;
> >   	}
> >   	if (!(flags & DRM_SYNCOBJ_WAIT_FLAGS_WAIT_FOR_SUBMIT))
> > -		return ret;
> > +		goto out;
> >   	memset(&wait, 0, sizeof(wait));
> >   	wait.task = current;
> > @@ -432,6 +431,9 @@ int drm_syncobj_find_fence(struct drm_file *file_private,
> >   	if (wait.node.next)
> >   		drm_syncobj_remove_wait(syncobj, &wait);
> > +out:
> > +	drm_syncobj_put(syncobj);
> > +
> >   	return ret;
> >   }
> >   EXPORT_SYMBOL(drm_syncobj_find_fence);
> 

-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch

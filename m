Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E779A667970
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 16:36:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240471AbjALPgn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 10:36:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240378AbjALPft (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 10:35:49 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F0613D1C7
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 07:26:57 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id d15so20564022pls.6
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 07:26:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=WVlLxH2Rj+8QSEZoiILadbKJQqSAUcthH+jBOnJMZHA=;
        b=JftHModyBQyWOf9IbcHgv+wM+wAMjzeIgqay2Sc8xYfkI5JHsWwEEaR0BrMLIrDI0F
         yxykKOAvVOboJ8Q3inG5JiMM5zD9V4Wn648fS3KtICCIxD5uZqOMV4/KjWnV0Hk62u/K
         0g4zOe1NM3yXUlV8A36BJ7zUBJLOFJCN2pqMQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WVlLxH2Rj+8QSEZoiILadbKJQqSAUcthH+jBOnJMZHA=;
        b=WhJBwwt7Woi4aQS66q1DY08YUUlc+lsy7EHccmC5veZz4dDsLR+V9KzXRKqcbgh5CD
         FknkPu2d41d2Bt1E3q5o2I4H4VTPeHbyYDGBuH4IU25UiuRHlBch8xc+BitxWaBI5cUS
         Bjp8G4NqqP2VkPFgcD+o2sAoFq2vTW0x+k2e0Oat9uesaLPQ/c3G0sOSSSWaZb11wQE+
         7/IeM+z3zDkKkbRfM+iTA39RGk/DgcBAJwjhim47s1+ycgv6z0wnFEW3I+6NOoX0LKTI
         5zU6/ERcMxOi4D4Nnhz49Lfit4coUorfLjg3x/QiN+x+y0UUtOZElRAluZ8E7exnAzwq
         AwEA==
X-Gm-Message-State: AFqh2krMCqIaYJfmZp5auCatnchVd9YIRELDm68ZcbzSLQZrsw5HknXj
        QYAtJ+YdMLsk0kDw7OjgV5bUEqSxJkS1um6mBSld3Q==
X-Google-Smtp-Source: AMrXdXszpIuyfj/mHnCEnh6uhFgYKDm3M6iMpGAaIQNcUe0iGzTUPpaT/7EySwmrAqTumWdnNX0AssRqS0MYKX5qVxs=
X-Received: by 2002:a17:902:bf45:b0:189:505b:73dd with SMTP id
 u5-20020a170902bf4500b00189505b73ddmr5104347pls.143.1673537217363; Thu, 12
 Jan 2023 07:26:57 -0800 (PST)
MIME-Version: 1.0
References: <20230104175633.1420151-1-dragos.panait@windriver.com>
 <20230104175633.1420151-2-dragos.panait@windriver.com> <Y8ABeXQLzWdoaGAY@kroah.com>
In-Reply-To: <Y8ABeXQLzWdoaGAY@kroah.com>
From:   Daniel Vetter <daniel@ffwll.ch>
Date:   Thu, 12 Jan 2023 16:26:45 +0100
Message-ID: <CAKMK7uEgzJU8ukgR3sQtSUB5+wrD9VyMwCHOA-SReFWd0tKzzw@mail.gmail.com>
Subject: Re: [PATCH 5.10 1/1] drm/amdkfd: Check for null pointer after calling kmemdup
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Dragos-Marian Panait <dragos.panait@windriver.com>,
        stable@vger.kernel.org, Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Oded Gabbay <oded.gabbay@gmail.com>,
        =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
        Kent Russell <kent.russell@amd.com>,
        Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>,
        dri-devel@lists.freedesktop.org, amd-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 12 Jan 2023 at 13:47, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Wed, Jan 04, 2023 at 07:56:33PM +0200, Dragos-Marian Panait wrote:
> > From: Jiasheng Jiang <jiasheng@iscas.ac.cn>
> >
> > [ Upstream commit abfaf0eee97925905e742aa3b0b72e04a918fa9e ]
> >
> > As the possible failure of the allocation, kmemdup() may return NULL
> > pointer.
> > Therefore, it should be better to check the 'props2' in order to prevent
> > the dereference of NULL pointer.
> >
> > Fixes: 3a87177eb141 ("drm/amdkfd: Add topology support for dGPUs")
> > Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
> > Reviewed-by: Felix Kuehling <Felix.Kuehling@amd.com>
> > Signed-off-by: Felix Kuehling <Felix.Kuehling@amd.com>
> > Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
> > Signed-off-by: Dragos-Marian Panait <dragos.panait@windriver.com>
> > ---
> >  drivers/gpu/drm/amd/amdkfd/kfd_crat.c | 3 +++
> >  1 file changed, 3 insertions(+)
> >
> > diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_crat.c b/drivers/gpu/drm/amd/amdkfd/kfd_crat.c
> > index 86b4dadf772e..02e3c650ed1c 100644
> > --- a/drivers/gpu/drm/amd/amdkfd/kfd_crat.c
> > +++ b/drivers/gpu/drm/amd/amdkfd/kfd_crat.c
> > @@ -408,6 +408,9 @@ static int kfd_parse_subtype_iolink(struct crat_subtype_iolink *iolink,
> >                       return -ENODEV;
> >               /* same everything but the other direction */
> >               props2 = kmemdup(props, sizeof(*props2), GFP_KERNEL);
> > +             if (!props2)
> > +                     return -ENOMEM;
>
> Not going to queue this up as this is a bogus CVE.

Are we at the point where CVE presence actually contraindicates
backporting? At least I'm getting a bit the feeling there's a surge of
automated (security) fixes that just don't hold up to any scrutiny.
Last week I had to toss out an fbdev locking patch due to static
checker that has no clue at all how refcounting works, and so
complained that things need more locking ... (that was -fixes, but
would probably have gone to stable too if I didn't catch it).

Simple bugfixes from random people was nice when it was checkpatch
stuff and I was fairly happy to take these aggressively in drm. But my
gut feeling says things seem to be shifting towards more advanced
tooling, but without more advanced understanding by submitters. Does
that holder in other areas too?
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch

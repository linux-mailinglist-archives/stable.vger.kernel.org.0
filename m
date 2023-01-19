Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 090F967357D
	for <lists+stable@lfdr.de>; Thu, 19 Jan 2023 11:27:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230407AbjASK1d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Jan 2023 05:27:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbjASK1B (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Jan 2023 05:27:01 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57BB36D37C
        for <stable@vger.kernel.org>; Thu, 19 Jan 2023 02:26:39 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id y11so2186999edd.6
        for <stable@vger.kernel.org>; Thu, 19 Jan 2023 02:26:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:message-id:subject:cc:to:from:date:from:to:cc
         :subject:date:message-id:reply-to;
        bh=39SgUHKju2DkTVJDuCLF0GlqoNQjOGP2rscjucek0WY=;
        b=OYYE6KjfLMIIu6kvxFyNsRIlxJPTCtMRs2MqUjKnitJyJaghBNlaulIHD/vXm2dLLH
         0TRLTUE0apvKLCTbRagDBl8mUy+45M2YH1Ld4NRepymOa+3FmoL00iIYcPoL3hQYiQpG
         yTKA0HK9doDcpbWaUTu4iWL6WBOXjyByo7gXc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=39SgUHKju2DkTVJDuCLF0GlqoNQjOGP2rscjucek0WY=;
        b=PeRY1HhpXkHa9KRYT1r3Awkb5EkEPAu+z3WL/eRSleS5Ryk74GjZnylnn9PAFChLgx
         sW2FDz15KOiwv87h6kXp8OhW4NquHQye452TtH4nRbdKOkaPipTHlCSbZAF+zbt7MQAB
         /KQZpmHl7d0gzPld+v2flNMQc24rW+RUgHuTGma0jXP+giOJoaIf/5vxeev1EWKFwWpr
         NlH2MVrPXcLlrixNMv5MMUeTA+DZEW2oj87eKel8RKfjq4LrSOg0KbJ2oQ571xgTgQF1
         UXW6ibYG3PwL2pF9+hkBYp1ycrpK1N37i7SCvxtN5SZT/6fRbbVjnoVdK1+vIMyRmXfk
         nwKg==
X-Gm-Message-State: AFqh2krqhqQ5oys31Gcq2m+ubtaHWtSUK96ATCTQE/XAv69p0qpWyrke
        sQgAjoJvXsZABp9ePnJc1ePyLw==
X-Google-Smtp-Source: AMrXdXtSf8VW8Q/vL39YHAO5amRe9Z3IC59IA2VRhTytO9iyk7Mb4JVWli/JMWVsTPfw2LxTJyJ+LQ==
X-Received: by 2002:aa7:c845:0:b0:497:b6bc:b811 with SMTP id g5-20020aa7c845000000b00497b6bcb811mr9808530edt.33.1674123997712;
        Thu, 19 Jan 2023 02:26:37 -0800 (PST)
Received: from phenom.ffwll.local ([2a02:168:57f4:0:efd0:b9e5:5ae6:c2fa])
        by smtp.gmail.com with ESMTPSA id eo9-20020a056402530900b00463bc1ddc76sm7648926edb.28.2023.01.19.02.26.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Jan 2023 02:26:37 -0800 (PST)
Date:   Thu, 19 Jan 2023 11:26:34 +0100
From:   Daniel Vetter <daniel@ffwll.ch>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Daniel Vetter <daniel@ffwll.ch>,
        Dragos-Marian Panait <dragos.panait@windriver.com>,
        stable@vger.kernel.org, Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Oded Gabbay <oded.gabbay@gmail.com>,
        Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
        Kent Russell <kent.russell@amd.com>,
        Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>,
        dri-devel@lists.freedesktop.org, amd-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5.10 1/1] drm/amdkfd: Check for null pointer after
 calling kmemdup
Message-ID: <Y8ka2khSlK6E/XbF@phenom.ffwll.local>
Mail-Followup-To: Greg KH <gregkh@linuxfoundation.org>,
        Dragos-Marian Panait <dragos.panait@windriver.com>,
        stable@vger.kernel.org, Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Oded Gabbay <oded.gabbay@gmail.com>,
        Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
        Kent Russell <kent.russell@amd.com>,
        Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>,
        dri-devel@lists.freedesktop.org, amd-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
References: <20230104175633.1420151-1-dragos.panait@windriver.com>
 <20230104175633.1420151-2-dragos.panait@windriver.com>
 <Y8ABeXQLzWdoaGAY@kroah.com>
 <CAKMK7uEgzJU8ukgR3sQtSUB5+wrD9VyMwCHOA-SReFWd0tKzzw@mail.gmail.com>
 <Y8A5NgtGLDJv4sON@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y8A5NgtGLDJv4sON@kroah.com>
X-Operating-System: Linux phenom 5.19.0-2-amd64 
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 12, 2023 at 05:45:42PM +0100, Greg KH wrote:
> On Thu, Jan 12, 2023 at 04:26:45PM +0100, Daniel Vetter wrote:
> > On Thu, 12 Jan 2023 at 13:47, Greg KH <gregkh@linuxfoundation.org> wrote:
> > > On Wed, Jan 04, 2023 at 07:56:33PM +0200, Dragos-Marian Panait wrote:
> > > > From: Jiasheng Jiang <jiasheng@iscas.ac.cn>
> > > >
> > > > [ Upstream commit abfaf0eee97925905e742aa3b0b72e04a918fa9e ]
> > > >
> > > > As the possible failure of the allocation, kmemdup() may return NULL
> > > > pointer.
> > > > Therefore, it should be better to check the 'props2' in order to prevent
> > > > the dereference of NULL pointer.
> > > >
> > > > Fixes: 3a87177eb141 ("drm/amdkfd: Add topology support for dGPUs")
> > > > Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
> > > > Reviewed-by: Felix Kuehling <Felix.Kuehling@amd.com>
> > > > Signed-off-by: Felix Kuehling <Felix.Kuehling@amd.com>
> > > > Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
> > > > Signed-off-by: Dragos-Marian Panait <dragos.panait@windriver.com>
> > > > ---
> > > >  drivers/gpu/drm/amd/amdkfd/kfd_crat.c | 3 +++
> > > >  1 file changed, 3 insertions(+)
> > > >
> > > > diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_crat.c b/drivers/gpu/drm/amd/amdkfd/kfd_crat.c
> > > > index 86b4dadf772e..02e3c650ed1c 100644
> > > > --- a/drivers/gpu/drm/amd/amdkfd/kfd_crat.c
> > > > +++ b/drivers/gpu/drm/amd/amdkfd/kfd_crat.c
> > > > @@ -408,6 +408,9 @@ static int kfd_parse_subtype_iolink(struct crat_subtype_iolink *iolink,
> > > >                       return -ENODEV;
> > > >               /* same everything but the other direction */
> > > >               props2 = kmemdup(props, sizeof(*props2), GFP_KERNEL);
> > > > +             if (!props2)
> > > > +                     return -ENOMEM;
> > >
> > > Not going to queue this up as this is a bogus CVE.
> > 
> > Are we at the point where CVE presence actually contraindicates
> > backporting?
> 
> Some would say that that point passed a long time ago :)
> 
> > At least I'm getting a bit the feeling there's a surge of
> > automated (security) fixes that just don't hold up to any scrutiny.
> 
> That has been happening a lot more in the past 6-8 months than in years
> past with the introduction of more automated tools being present.

Ok, gut feeling confirmed, I'll try and keep more a lookout for these.

I guess next step is that people will use chatgpt to write the patches for
these bugs.

> > Last week I had to toss out an fbdev locking patch due to static
> > checker that has no clue at all how refcounting works, and so
> > complained that things need more locking ... (that was -fixes, but
> > would probably have gone to stable too if I didn't catch it).
> > 
> > Simple bugfixes from random people was nice when it was checkpatch
> > stuff and I was fairly happy to take these aggressively in drm. But my
> > gut feeling says things seem to be shifting towards more advanced
> > tooling, but without more advanced understanding by submitters. Does
> > that holder in other areas too?
> 
> Again, yes, I have seen that a lot recently, especially with regards to
> patches that purport to fix bugs yet obviously were never tested.
> 
> That being said, there are a few developers who are doing great things
> with fault-injection testing and providing good patches for that.  So we
> can't just say that everyone using these tools has no clue.

Oh yes there's definitely awesome stuff happening, which is why I do not
want to throw them all out. And waiting until the name is recognizeable
for individual maintainers like me that don't see the entire fixes flood
is also not really an approach.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch

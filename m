Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 555E61D2FD5
	for <lists+stable@lfdr.de>; Thu, 14 May 2020 14:32:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726073AbgENMcz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 May 2020 08:32:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725925AbgENMcz (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 May 2020 08:32:55 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D8D5C061A0C
        for <stable@vger.kernel.org>; Thu, 14 May 2020 05:32:55 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id m24so20549156wml.2
        for <stable@vger.kernel.org>; Thu, 14 May 2020 05:32:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Hs0b6CimQtwFi7aqQ0x2t0EfYjjIMEZ9m/N7F6YQDAY=;
        b=YgWHkQTYQPFppqYsLPN4O7w4lYivEAnsEzMA+LRaWDfv1qHjFZT7jJduso+EFh/hnh
         BmsjyF8UrLtntddw7ns7M8+fhWv+y4cDydxv3fKuQ73T16tDKeVw7qrfp+ced3x5ZpsD
         AkPmYBhTTcBPvfKZDxpbZ0iFajRNhq0rxkirk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Hs0b6CimQtwFi7aqQ0x2t0EfYjjIMEZ9m/N7F6YQDAY=;
        b=Plh8nWFCX6eEae+oeNh/92Ug2xAdXSiiF3CiiH6k9OJcMnDOV6vKzT/hoQIQpaj1Lb
         t/DfZCh8uFZ29o/wF/69w2UpCahmUY/u+/hI823/bo6cUaSVdu/SU3vzWYyXa+EZ0w4m
         5DXVB6I27ZyFpPBa1c1VO96B3Y+TrK5o37niSbHxLimnQWo0gR8m1lvZ0X1CDRDxET58
         9sUS8I84CcB809yr+cDnhqDN3sglaIqBWQHl+SV7pajDN6M0C1C8OqDSQxj6Lvpt8FcY
         /8jebpeAFmnnfCORIKu4LFIdG2N89z06gyad6s7110xV1njdAtM4Amd+rnmY2CCT2Zio
         rb7A==
X-Gm-Message-State: AGi0Pua7juiAmDey1+huMC7Nqsfn5htCxMXp+OoPEhgOVZ/iKccvbb+U
        nie9c7wEtWBCeQ1QpIdGpSdj17ySHoo=
X-Google-Smtp-Source: APiQypLwlYFf18uBo+jfC26cvoH7AqKeY4MEhPzSMIyKaNwga5O97X2GrG0P30+6HD8/aszlGaAbDg==
X-Received: by 2002:a1c:bbc5:: with SMTP id l188mr27784086wmf.163.1589459573864;
        Thu, 14 May 2020 05:32:53 -0700 (PDT)
Received: from phenom.ffwll.local ([2a02:168:57f4:0:efd0:b9e5:5ae6:c2fa])
        by smtp.gmail.com with ESMTPSA id x23sm38645260wmj.6.2020.05.14.05.32.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 May 2020 05:32:53 -0700 (PDT)
Date:   Thu, 14 May 2020 14:32:51 +0200
From:   Daniel Vetter <daniel@ffwll.ch>
To:     Daniel Stone <daniel@fooishbar.org>
Cc:     Daniel Vetter <daniel.vetter@ffwll.ch>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        Pekka Paalanen <pekka.paalanen@collabora.co.uk>,
        stable <stable@vger.kernel.org>,
        Daniel Stone <daniels@collabora.com>,
        Ville =?iso-8859-1?Q?Syrj=E4l=E4?= 
        <ville.syrjala@linux.intel.com>,
        Daniel Vetter <daniel.vetter@intel.com>
Subject: Re: [PATCH] drm: avoid spurious EBUSY due to nonblocking atomic
 modesets
Message-ID: <20200514123251.GR206103@phenom.ffwll.local>
References: <20200408162403.3616785-1-daniel.vetter@ffwll.ch>
 <CAPj87rMJNwp0t4B0KxH7J_2__4eT7+ZJeG-=_juLSDhPc2hLHQ@mail.gmail.com>
 <CAKMK7uFU7ST9LWmpfhTuk1-_ES6VU-cUogMnPjA15BWFsEVacw@mail.gmail.com>
 <CAPj87rNRLsGJcGEM3dYnitYMwjh7iMNjo9KT=xcDZ0hebRC9iw@mail.gmail.com>
 <CAKMK7uG6krmntPW6Mud7aouvM=NRspYHoBdKeSwxS8wDwDZRkQ@mail.gmail.com>
 <CAPj87rO1oG00ipUA57a1kGu7K2=-ugTreM7QXy_tWjbZ+KzkFg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPj87rO1oG00ipUA57a1kGu7K2=-ugTreM7QXy_tWjbZ+KzkFg@mail.gmail.com>
X-Operating-System: Linux phenom 5.6.0-1-amd64 
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 14, 2020 at 08:40:21AM +0100, Daniel Stone wrote:
> On Thu, 14 May 2020 at 08:25, Daniel Vetter <daniel.vetter@ffwll.ch> wrote:
> > On Thu, May 14, 2020 at 9:18 AM Daniel Stone <daniel@fooishbar.org> wrote:
> > > On Thu, 14 May 2020 at 08:08, Daniel Vetter <daniel.vetter@ffwll.ch> wrote:
> > > I'd be very much in favour of putting the blocking down in the kernel
> > > at least until the kernel can give us a clear indication to tell us
> > > what's going on, and ideally which other resources need to be dragged
> > > in, in a way which is distinguishable from your compositor having
> > > broken synchronisation.
> >
> > We know, the patch already computes that ... So would be a matter of
> > exporting that to userspace. We have a mask of all additional crtc
> > that will get an event and will -EBUSY until that's done.
> 
> Yep, but unless and until that happens, could we please get this in?
> Given it would require uAPI changes, we'd need to modify all the
> compositors to work with the old path (random EBUSY) and the new path
> (predictable and obvious), so at least preserving the promise that
> per-CRTC updates are really independent would be good.

I haven't found the time to look at the intel-gfx-ci fail in igt nor
really think about that. Nor care enough to just hammer this ignoring ci,
since I didn't even get around to understand why the igt now fails If
someone else takes this over, happy to see it land.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch

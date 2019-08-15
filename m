Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F6AE8E4FD
	for <lists+stable@lfdr.de>; Thu, 15 Aug 2019 08:47:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730450AbfHOGrM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Aug 2019 02:47:12 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:45038 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726865AbfHOGrM (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Aug 2019 02:47:12 -0400
Received: by mail-ed1-f65.google.com with SMTP id a21so1266695edt.11
        for <stable@vger.kernel.org>; Wed, 14 Aug 2019 23:47:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=/idpduwU3yD5MGOQLN6gjyI1d75hHNv0VgVkPg7YETw=;
        b=J207I9Z4SslLflfMR/XiSnmlB6tzNPwaIxRnAOejLFSgUOLlPVWp6OcNlR0KgTa6sl
         XpDlTYDrRFtA2pIH74aPdRnMYr6xzb8D2UK/ph4kKHAhmSq+1Kqwjq0PJ+93XyFy87x0
         tN+6091XBib5jq+ZtSPvgSp0zWTJ9Jhs3Ih/A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=/idpduwU3yD5MGOQLN6gjyI1d75hHNv0VgVkPg7YETw=;
        b=fSfZvQvdi4nxUKxjLe8KkerZyo7hSFgi1sd1UTS0swkQ8j15X+Tc22bo7mCe2qpTRT
         k+KrW7aLNsoYfiRqRE4rFHte3uyHWKAML6WmPsBEVc988YEtWGxIcKr75ziM6gBYav2D
         jhHUH6rkQ/A52kcj8sJZra0JmTPYIWzsEtGDGvm0ZaQ3G/qviLzcrvVnk/9LGvh/8oFm
         EqqcR1VgOwh8dx8FPMe5fiSl+W+uMfb4gK7BKprNoj7No+TsEXePc8HVYfNyReuBfI0E
         Mkpjtj0g2E0hM0NtH0fbynvV7tKzLS8sLoeDA1+OtotsT6FrgcloLL3E+KFxLN9Poi6P
         B33Q==
X-Gm-Message-State: APjAAAUuXTaXP1L4WfE/zCSor1cxM/Q1sYMuQ12U+ILEQAwP5SYqQsYQ
        9rTbZCyLjd+z6b+BVuiEkNOhJZezMkPt4g==
X-Google-Smtp-Source: APXvYqxFGwsM+EcdAlO9gCHLw0NIpBqHxiER+gQMaHy6Yf4506bh6Wm4Tl54o4hXSHxdHPO5jattrg==
X-Received: by 2002:a17:906:2401:: with SMTP id z1mr2992716eja.292.1565851630285;
        Wed, 14 Aug 2019 23:47:10 -0700 (PDT)
Received: from phenom.ffwll.local ([2a02:168:569e:0:3106:d637:d723:e855])
        by smtp.gmail.com with ESMTPSA id n42sm386177edd.31.2019.08.14.23.47.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Aug 2019 23:47:09 -0700 (PDT)
Date:   Thu, 15 Aug 2019 08:47:07 +0200
From:   Daniel Vetter <daniel@ffwll.ch>
To:     Sasha Levin <sashal@kernel.org>
Cc:     Daniel Vetter <daniel@ffwll.ch>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        dri-devel@lists.freedesktop.org,
        Gustavo Padovan <gustavo@padovan.org>,
        intel-gfx@lists.freedesktop.org, stable@vger.kernel.org,
        Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
        Sean Paul <seanpaul@chromium.org>
Subject: Re: [PATCH] dma-buf/sw_sync: Synchronize signal vs syncpt free
Message-ID: <20190815064707.GY7444@phenom.ffwll.local>
References: <20190812154247.20508-1-chris@chris-wilson.co.uk>
 <20190812190548.450CF20684@mail.kernel.org>
 <20190814172415.GN7444@phenom.ffwll.local>
 <20190815014641.GB31807@sasha-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190815014641.GB31807@sasha-vm>
X-Operating-System: Linux phenom 4.19.0-5-amd64 
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 14, 2019 at 09:46:41PM -0400, Sasha Levin wrote:
> On Wed, Aug 14, 2019 at 07:24:15PM +0200, Daniel Vetter wrote:
> > Hi Sasha,
> > 
> > On Mon, Aug 12, 2019 at 07:05:47PM +0000, Sasha Levin wrote:
> > > Hi,
> > > 
> > > [This is an automated email]
> > > 
> > > This commit has been processed because it contains a "Fixes:" tag,
> > > fixing commit: d3862e44daa7 dma-buf/sw-sync: Fix locking around sync_timeline lists.
> > > 
> > > The bot has tested the following trees: v5.2.8, v4.19.66, v4.14.138, v4.9.189.
> > > 
> > > v5.2.8: Build OK!
> > > v4.19.66: Build OK!
> > > v4.14.138: Build OK!
> > > v4.9.189: Failed to apply! Possible dependencies:
> > >     Unable to calculate
> > > 
> > > 
> > > NOTE: The patch will not be queued to stable trees until it is upstream.
> > > 
> > > How should we proceed with this patch?
> > 
> > The backporting instruction has an explicit # v4.14+ in there, so failure
> > to apply to older kernels is expected.
> > 
> > Can you perhaps teach this trick to your script perhaps? Iirc we're using
> > the official format even.
> 
> Hey Daniel,
> 
> The script knows how to read stable tags :)
> 
> It tested out 4.9 because the commit also has a fixes tag pointing to
> d3862e44daa7 ("dma-buf/sw-sync: Fix locking around sync_timeline
> lists."), which was backported to 4.9.

Ah makes sense, might be good to add a bit of output explaining that.

> Should this not be backported to 4.9, even though the commit it fixes is
> there?

I guess it might actually be needed there.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch

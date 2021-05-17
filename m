Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0342A382D19
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 15:16:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235507AbhEQNRU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 09:17:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235483AbhEQNRU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 May 2021 09:17:20 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF3D5C06175F
        for <stable@vger.kernel.org>; Mon, 17 May 2021 06:16:03 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id u4-20020a05600c00c4b02901774b80945cso1704099wmm.3
        for <stable@vger.kernel.org>; Mon, 17 May 2021 06:16:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=rcRjj0kSXaoUG+69UiGMoMFuPjntXCgBD6uppcpvNks=;
        b=lSTYoAxprm0avW4QjQOozjs5yBsqLn2q/rOyq4ZIh0s/uD1IWHh+lkKBgfXnZL920Z
         YIZ7pDGa2hn2nT9Z3fm2UPo+EwPk33GO8ecURuxVaf8v9D3vDpstRNXosUzz8WnVTGbo
         TDIAwRJqXufB+99sKOAcPEx2KUgNQ/HdYNUQ0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :content-transfer-encoding:in-reply-to;
        bh=rcRjj0kSXaoUG+69UiGMoMFuPjntXCgBD6uppcpvNks=;
        b=anogmnXeXg/DAjbi2h6NexS55JMf9XjxB4JbOuGRPsc05cnLVobB9QMYqDxcCGIKQL
         +H+SptKjaSR3HgNOQHfLg6iE8OmulqdzmyugLbO0y3SOqx+jcAdCdKvT+X30NbJw8cjQ
         sMn4mNxe4kEh9BNrOm515w2hhCK6KpV4F98oJtHiJK+5Y3FyxvrVsPQSJyLrr7xE5Fzu
         15CxoFORAttIx/ENSAXTUISQieHTIBF3rvuFsRN5oOTt0Rr98kNZiLp1KHQLmFn38DsU
         3yGArpXkS2UXvseWYpnJhOeNUB8TC3Z0Kz5a+qy9wUbYVT33OsLLSlKqaAzf3dCqenFC
         beUw==
X-Gm-Message-State: AOAM530WYNxA1js2p5U6sUAm+qJIEtiJWOQY/sZ0wgqu2fqT6qiLEMGb
        Cwp6gY+203qHb/4J6127Ke5gGg==
X-Google-Smtp-Source: ABdhPJyCiK0AWV7OegSOvUzl9QU2kA5OTz7BASeaDdFo3fnYrQzNotPW2rnw1TP3Oq5TswGW8xQItA==
X-Received: by 2002:a7b:cf23:: with SMTP id m3mr8515150wmg.24.1621257362543;
        Mon, 17 May 2021 06:16:02 -0700 (PDT)
Received: from phenom.ffwll.local ([2a02:168:57f4:0:efd0:b9e5:5ae6:c2fa])
        by smtp.gmail.com with ESMTPSA id v3sm9925105wrr.19.2021.05.17.06.16.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 May 2021 06:16:01 -0700 (PDT)
Date:   Mon, 17 May 2021 15:15:59 +0200
From:   Daniel Vetter <daniel@ffwll.ch>
To:     Paul Cercueil <paul@crapouillou.net>
Cc:     David Airlie <airlied@linux.ie>, Daniel Vetter <daniel@ffwll.ch>,
        Sam Ravnborg <sam@ravnborg.org>, od@zcrc.me,
        linux-mips@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] drm/ingenic: Fix pixclock rate for 24-bit serial panels
Message-ID: <YKJsj+dDUshm/ZiT@phenom.ffwll.local>
Mail-Followup-To: Paul Cercueil <paul@crapouillou.net>,
        David Airlie <airlied@linux.ie>, Sam Ravnborg <sam@ravnborg.org>,
        od@zcrc.me, linux-mips@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <20210323144008.166248-1-paul@crapouillou.net>
 <6DP1TQ.W6B9JRRW1OY5@crapouillou.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6DP1TQ.W6B9JRRW1OY5@crapouillou.net>
X-Operating-System: Linux phenom 5.10.32scarlett+ 
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 13, 2021 at 01:29:30PM +0100, Paul Cercueil wrote:
> Hi,
> 
> Almost two months later,

Since you're committer it's expected that you go actively out to look for
review or trade with someone else who has some patches that need a quick
look. It will not happen automatically, this is on you.

Also generally after 2 weeks the patch is lost and you need to ping it.
-Daniel

> 
> 
> Le mar., mars 23 2021 at 14:40:08 +0000, Paul Cercueil
> <paul@crapouillou.net> a écrit :
> > When using a 24-bit panel on a 8-bit serial bus, the pixel clock
> > requested by the panel has to be multiplied by 3, since the subpixels
> > are shifted sequentially.
> > 
> > The code (in ingenic_drm_encoder_atomic_check) already computed
> > crtc_state->adjusted_mode->crtc_clock accordingly, but clk_set_rate()
> > used crtc_state->adjusted_mode->clock instead.
> > 
> > Fixes: 28ab7d35b6e0 ("drm/ingenic: Properly compute timings when using a
> > 3x8-bit panel")
> > Cc: stable@vger.kernel.org # v5.10
> > Signed-off-by: Paul Cercueil <paul@crapouillou.net>
> 
> Can I get an ACK for my patch?
> 
> Thanks!
> -Paul
> 
> > ---
> >  drivers/gpu/drm/ingenic/ingenic-drm-drv.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/gpu/drm/ingenic/ingenic-drm-drv.c
> > b/drivers/gpu/drm/ingenic/ingenic-drm-drv.c
> > index d60e1eefc9d1..cba68bf52ec5 100644
> > --- a/drivers/gpu/drm/ingenic/ingenic-drm-drv.c
> > +++ b/drivers/gpu/drm/ingenic/ingenic-drm-drv.c
> > @@ -342,7 +342,7 @@ static void ingenic_drm_crtc_atomic_flush(struct
> > drm_crtc *crtc,
> >  	if (priv->update_clk_rate) {
> >  		mutex_lock(&priv->clk_mutex);
> >  		clk_set_rate(priv->pix_clk,
> > -			     crtc_state->adjusted_mode.clock * 1000);
> > +			     crtc_state->adjusted_mode.crtc_clock * 1000);
> >  		priv->update_clk_rate = false;
> >  		mutex_unlock(&priv->clk_mutex);
> >  	}
> > --
> > 2.30.2
> > 
> 
> 

-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch

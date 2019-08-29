Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0EC9A264B
	for <lists+stable@lfdr.de>; Thu, 29 Aug 2019 20:44:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727779AbfH2SoR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Aug 2019 14:44:17 -0400
Received: from mail-yw1-f66.google.com ([209.85.161.66]:46713 "EHLO
        mail-yw1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726518AbfH2SoR (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Aug 2019 14:44:17 -0400
Received: by mail-yw1-f66.google.com with SMTP id 201so1417014ywo.13
        for <stable@vger.kernel.org>; Thu, 29 Aug 2019 11:44:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=poorly.run; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Y0CIg3NVlgXeInnLw0PrlDfAySS6GEabvcH9ZTG2R7Q=;
        b=InpYZstdqbCIKyy+HjlkWYc66380kSdA6vXpPRrTKq4uXw9ekphazbrnIw6bwbzBzb
         7edoejK/7waY8exYn+JrLpcXUC2lSmNFM1G9y6iGb1z9Y2tDGJD/fpFffCEHzOT1YPDh
         u4ZXGF0g7yb7uvNEERKYPHPeyYqNOXNTpuDnNUuXwS7bLp6hVJMHIU6a8sJUgwNtx6SR
         rH5qehF9L9u75OwlCesmid2/lULlpcmdw9ICLW7lWBN/KjJHiEButiMjcjFjVIxUyG0a
         n7tEiYKvEfKsu0WMQmS6JFBZKWCOkGqONRs40SENLqdV0xvsR0k9gctaGL5Mwp4nvjyl
         OOUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Y0CIg3NVlgXeInnLw0PrlDfAySS6GEabvcH9ZTG2R7Q=;
        b=bDSk3Gtz98yBy+ZnK/E9LLJrd2C3KjbDJYDO80h5wCj8GITldMrrMfmlDJrr76XUsM
         H9ZinNAIU8tuDkpGpKwVGYIL3SF0/BDZoE0y7OTgqVD9bge/Pzf+1sIQRBWb0y210O3z
         p+WCpuA6dsfZe7B0F2Pk8aJFgQ7UBsEZ7i/uHfk1cwlfVJ1ReopwWYMak/HoL0f2JZs0
         T22pwoGLPAasz7Ti6ldpvPDj2mEYmJiG8DREwMTlwRCOu9S8G+Igpmy6zNjYy43fvK0J
         75cbi6b+313RYGZeYOjGA62QK4UeZUP4C5yv8MuU5ojplBTdOl1u1B4F1wsTSTFMHnPX
         t5cg==
X-Gm-Message-State: APjAAAXjbbWyhGyJWkw9Q31lgX0da7Vgu1ELZdOM1O7WJbiKBwaId9+l
        DKcIF6SqZvTWKGE4wxNv3NuZwA==
X-Google-Smtp-Source: APXvYqwfHTKwJ0mIS2bakEIGWA+OzHB1IgmPpfPQ6tDR80PPpVr+YxxDwDw0znbrJvYqp9p71/hDrQ==
X-Received: by 2002:a81:70c7:: with SMTP id l190mr7946781ywc.280.1567104256441;
        Thu, 29 Aug 2019 11:44:16 -0700 (PDT)
Received: from localhost ([2620:0:1013:11:89c6:2139:5435:371d])
        by smtp.gmail.com with ESMTPSA id i20sm638407ywg.96.2019.08.29.11.44.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Aug 2019 11:44:15 -0700 (PDT)
Date:   Thu, 29 Aug 2019 14:44:15 -0400
From:   Sean Paul <sean@poorly.run>
To:     Lyude Paul <lyude@redhat.com>
Cc:     Sean Paul <sean@poorly.run>, dri-devel@lists.freedesktop.org,
        Sean Paul <seanpaul@chromium.org>,
        Todd Previte <tprevite@gmail.com>,
        Dave Airlie <airlied@redhat.com>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>, stable@vger.kernel.org
Subject: Re: [PATCH] drm: mst: Fix query_payload ack reply struct
Message-ID: <20190829184415.GI218215@art_vandelay>
References: <20190829165223.129662-1-sean@poorly.run>
 <9927a099fc5f0140ea92e34f017186d9ffe0bb13.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9927a099fc5f0140ea92e34f017186d9ffe0bb13.camel@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 29, 2019 at 01:06:58PM -0400, Lyude Paul wrote:
> Is it worth actually CCing stable on this? This patch is certainly correct but
> I don't think we use this struct for anything quite yet.
> 
> Otherwise: Reviewed-by: Lyude Paul <lyude@redhat.com>

Thanks for the review! I've stripped the cc stable tag and pushed to
drm-misc-next. We'll have to keep an eye out for Sasha's stable AI bot, I'm
guessing it'll try to backport this to stable regardless.

Sean

> 
> On Thu, 2019-08-29 at 12:52 -0400, Sean Paul wrote:
> > From: Sean Paul <seanpaul@chromium.org>
> > 
> > Spec says[1] Allocated_PBN is 16 bits
> > 
> > [1]- DisplayPort 1.2 Spec, Section 2.11.9.8, Table 2-98
> > 
> > Fixes: ad7f8a1f9ced ("drm/helper: add Displayport multi-stream helper
> > (v0.6)")
> > Cc: Lyude Paul <lyude@redhat.com>
> > Cc: Todd Previte <tprevite@gmail.com>
> > Cc: Dave Airlie <airlied@redhat.com>
> > Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
> > Cc: Maxime Ripard <maxime.ripard@bootlin.com>
> > Cc: Sean Paul <sean@poorly.run>
> > Cc: David Airlie <airlied@linux.ie>
> > Cc: Daniel Vetter <daniel@ffwll.ch>
> > Cc: dri-devel@lists.freedesktop.org
> > Cc: <stable@vger.kernel.org> # v3.17+
> > Signed-off-by: Sean Paul <seanpaul@chromium.org>
> > ---
> >  include/drm/drm_dp_mst_helper.h | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/include/drm/drm_dp_mst_helper.h
> > b/include/drm/drm_dp_mst_helper.h
> > index 2ba6253ea6d3..fc349204a71b 100644
> > --- a/include/drm/drm_dp_mst_helper.h
> > +++ b/include/drm/drm_dp_mst_helper.h
> > @@ -334,7 +334,7 @@ struct drm_dp_resource_status_notify {
> >  
> >  struct drm_dp_query_payload_ack_reply {
> >  	u8 port_number;
> > -	u8 allocated_pbn;
> > +	u16 allocated_pbn;
> >  };
> >  
> >  struct drm_dp_sideband_msg_req_body {
> -- 
> Cheers,
> 	Lyude Paul
> 

-- 
Sean Paul, Software Engineer, Google / Chromium OS

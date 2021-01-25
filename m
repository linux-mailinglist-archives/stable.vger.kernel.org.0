Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C42D0302FBF
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 00:05:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732659AbhAYXEw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 18:04:52 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:59382 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732634AbhAYW4l (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Jan 2021 17:56:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611615308;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9e4FAvdLJ+vUpdO9XUnrNO0jrJiCmbRBqZ4RaWPWJDc=;
        b=R7utSaGaytxzSkKrtY688O1S9ry32/IR8CCR4p6mW4ZhMDsWmgQKebIsmnwzP+2eexUxKv
        1TQyJb/lW0FFT8FmHkGvaIipoaMQHPY6+xZccVEn51s4s8VnzbxKWAMeJlenoePiJWWr6l
        BEaxjWE5LIb4vyNx2z1Y241VW/XOiPw=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-343-JX0o7VgtNm651EpLUS6XLQ-1; Mon, 25 Jan 2021 17:55:05 -0500
X-MC-Unique: JX0o7VgtNm651EpLUS6XLQ-1
Received: by mail-qv1-f70.google.com with SMTP id j4so3539450qvi.8
        for <stable@vger.kernel.org>; Mon, 25 Jan 2021 14:55:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:reply-to:to:cc:date
         :in-reply-to:references:organization:user-agent:mime-version
         :content-transfer-encoding;
        bh=9e4FAvdLJ+vUpdO9XUnrNO0jrJiCmbRBqZ4RaWPWJDc=;
        b=ipPrm488qgNsdaptlmwKoHnLlYgIFV+NzA3coRYOKtZWsJos09to05GRwb3tbzzsAj
         mwd7oyhO7lB48ApEpJF/Rpwoh4ScpfxW9txc5EUtjv8TNtrytrhHDJIeTkWCzh8Ehzl9
         0+T0W50HYDWNhRzxLsOefuugx038OtOyuhAivr2/cH4NBiC63R6QGuaH9nZQ25cJsPaQ
         0r42vkbviB0hAjx1q/pKdFqq9X9RT6VD6TvpHTqVxAm6IFyBAz+BlQocv3l+oOsS0P5h
         LsNvOdhqO/Ox6HKgCWLihCH/9DC+535IgMe18fE/DJQ5MEx4sPsvhxOxSYrZmJEKY9Dx
         gvGQ==
X-Gm-Message-State: AOAM533tQx7RfEJQe8iqHT3kRR4PQhsQLu3o5hBS54ozo/BZKEUHHZUv
        OmGCBrkt1uyuLvEFKImrg2c63nZbIndB1IFH6FPaOGbJEK2huZwu39t7xxYwltzU5o5/jz7f2fy
        u/jR9Fi4lJAp0YM4p
X-Received: by 2002:a37:ba03:: with SMTP id k3mr1526320qkf.366.1611615304729;
        Mon, 25 Jan 2021 14:55:04 -0800 (PST)
X-Google-Smtp-Source: ABdhPJy8/GAHwGAKmqTyc789/Fm6Q0GnEm2ZQgcQRVN4akiaq6WX6NQk5Jw6mwLG1DJf22YaJcTU+A==
X-Received: by 2002:a37:ba03:: with SMTP id k3mr1526311qkf.366.1611615304484;
        Mon, 25 Jan 2021 14:55:04 -0800 (PST)
Received: from Whitewolf.lyude.net (pool-108-49-102-102.bstnma.fios.verizon.net. [108.49.102.102])
        by smtp.gmail.com with ESMTPSA id c17sm13208946qkb.13.2021.01.25.14.55.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jan 2021 14:55:03 -0800 (PST)
Message-ID: <f036f8aff9079d97c2997929478621d3be34a69d.camel@redhat.com>
Subject: Re: [PATCH 2/2] drm/i915: Fix the MST PBN divider calculation
From:   Lyude Paul <lyude@redhat.com>
Reply-To: lyude@redhat.com
To:     imre.deak@intel.com
Cc:     intel-gfx@lists.freedesktop.org,
        Ville Syrjala <ville.syrjala@intel.com>, stable@vger.kernel.org
Date:   Mon, 25 Jan 2021 17:55:03 -0500
In-Reply-To: <20210125210434.GA1756222@ideak-desk.fi.intel.com>
References: <20210125173636.1733812-1-imre.deak@intel.com>
         <20210125173636.1733812-2-imre.deak@intel.com>
         <2be72160accef04bf2ed7341b3619befc2121330.camel@redhat.com>
         <20210125210434.GA1756222@ideak-desk.fi.intel.com>
Organization: Red Hat
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.3 (3.38.3-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 2021-01-25 at 23:04 +0200, Imre Deak wrote:
> On Mon, Jan 25, 2021 at 02:24:58PM -0500, Lyude Paul wrote:
> > On Mon, 2021-01-25 at 19:36 +0200, Imre Deak wrote:
> > > Atm the driver will calculate a wrong MST timeslots/MTP (aka time unit)
> > > value for MST streams if the link parameters (link rate or lane count)
> > > are limited in a way independent of the sink capabilities (reported by
> > > DPCD).
> > > 
> > > One example of such a limitation is when a MUX between the sink and
> > > source connects only a limited number of lanes to the display and
> > > connects the rest of the lanes to other peripherals (USB).
> > > 
> > > Another issue is that atm MST core calculates the divider based on the
> > > backwards compatible DPCD (at address 0x0000) vs. the extended
> > > capability info (at address 0x2200). This can result in leaving some
> > > part of the MST BW unused (For instance in case of the WD19TB dock).
> > > 
> > > Fix the above two issues by calculating the PBN divider value based on
> > > the rate and lane count link parameters that the driver uses for all
> > > other computation.
> > > 
> > > Bugzilla: https://gitlab.freedesktop.org/drm/intel/-/issues/2977
> > > Cc: Lyude Paul <lyude@redhat.com>
> > > Cc: Ville Syrjala <ville.syrjala@intel.com>
> > > Cc: <stable@vger.kernel.org>
> > > Signed-off-by: Imre Deak <imre.deak@intel.com>
> > > ---
> > >  drivers/gpu/drm/i915/display/intel_dp_mst.c | 4 +++-
> > >  1 file changed, 3 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/drivers/gpu/drm/i915/display/intel_dp_mst.c
> > > b/drivers/gpu/drm/i915/display/intel_dp_mst.c
> > > index d6a1b961a0e8..b4621ed0127e 100644
> > > --- a/drivers/gpu/drm/i915/display/intel_dp_mst.c
> > > +++ b/drivers/gpu/drm/i915/display/intel_dp_mst.c
> > > @@ -68,7 +68,9 @@ static int intel_dp_mst_compute_link_config(struct
> > > intel_encoder *encoder,
> > >  
> > >                 slots = drm_dp_atomic_find_vcpi_slots(state, &intel_dp-
> > > > mst_mgr,
> > >                                                       connector->port,
> > > -                                                     crtc_state->pbn, 0);
> > > +                                                     crtc_state->pbn,
> > > +                                                    
> > > drm_dp_get_vc_payload_bw(crtc_state->port_clock,
> > > +                                                                      
> > 
> > This patch looks fine, however you should take care to also update the
> > documentation for drm_dp_atomic_find_vcpi_slots() so that it mentiones that
> > pbn_div should be DSC aware but also is not exclusive to systems supporting
> > DSC
> > over MST (see the docs for the @pbn_div parameter)
> 
> I thought (as a follow-up work) that drm_dp_atomic_find_vcpi_slots() and
> drm_dp_mst_allocate_vcpi() could be made more generic, requiring the
> drivers to always pass in pbn_div. By that we could remove
> mst_mgr::pbn_div, keeping only one copy of this value (the one passed to
> the above functions).

I'm fine with that! The only thing I ask is (even though it's taken forever) we
are eventually planning on making it so that we'll have MST helpers that can
suggest changing the PBN divisor in order to implement link fallback retraining.
As long as we're still able to make that work in the future, I'm totally fine
with this.

> 
> > Thank you for doing this! I've been meaning to fix the WD19 issues for a
> > while
> > now but have been too bogged down by other stuff to spend any time on MST
> > recently.
> > 
> > >         crtc_state->lane_count));
> > >                 if (slots == -EDEADLK)
> > >                         return slots;
> > >                 if (slots >= 0)
> > 
> > -- 
> > Sincerely,
> >    Lyude Paul (she/her)
> >    Software Engineer at Red Hat
> >    
> > Note: I deal with a lot of emails and have a lot of bugs on my plate. If
> > you've
> > asked me a question, are waiting for a review/merge on a patch, etc. and I
> > haven't responded in a while, please feel free to send me another email to
> > check
> > on my status. I don't bite!
> > 
> 

-- 
Sincerely,
   Lyude Paul (she/her)
   Software Engineer at Red Hat
   
Note: I deal with a lot of emails and have a lot of bugs on my plate. If you've
asked me a question, are waiting for a review/merge on a patch, etc. and I
haven't responded in a while, please feel free to send me another email to check
on my status. I don't bite!


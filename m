Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 513FB3E8487
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 22:45:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230419AbhHJUp3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 16:45:29 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:58829 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230338AbhHJUp2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Aug 2021 16:45:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628628306;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jm4hDlZW2+lt/+00DUA4vehj6I12Iwa0HYTtWzie7Uo=;
        b=bzJM5Yg3/sx+0F7w6ygH6DBC5/RZC47fNVGJZWQYA10VM8CiYWdxwZpCFBV9o/AkBmkxTY
        etxhX+p57EnpZDNLRSQXhWjrs6lOFdqQWTlFuKTZynSZbHg4fZZa3Ovtpbu3X/0QJgtqFo
        psvtmaAH14PdHzv0cZ7wLmMXDsLiyYk=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-571-AT2SvLh7NhS1bz8p4IKOGw-1; Tue, 10 Aug 2021 16:45:04 -0400
X-MC-Unique: AT2SvLh7NhS1bz8p4IKOGw-1
Received: by mail-qv1-f69.google.com with SMTP id n14-20020a0c9d4e0000b0290354a5f8c800so6517383qvf.17
        for <stable@vger.kernel.org>; Tue, 10 Aug 2021 13:45:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:organization:user-agent:mime-version
         :content-transfer-encoding;
        bh=jm4hDlZW2+lt/+00DUA4vehj6I12Iwa0HYTtWzie7Uo=;
        b=X7zKUUJLueSsodptBRnY8Ar7/xUUfYQEVJmZqFRlwIxSBDQcVQqh5X+XUD/mEE9sGA
         bOdMh3KlaH++xzPzL84TKNguenItqktWYKEJIc2UANmsFLBPHp22aQKHNN5DoOnXsio8
         /wSvRSQ/qsaOJdogz3y3QTRLMmdbyckjOQ3PUhioUQ1OoeBRwti/vLE7xRT1dKKQrTCk
         zdLZs4aDnCovdKkZsBlVtfT1KDms1V6qzj+VAKO/MSBLSl1O5Azs4oAsWo5PbrKWiNlB
         ONIY+M5/tiIEetoE2gWlG/N0Kx1yk5ye79iCsmFOcCVKsU1XoS0j4k1gbvF37fSfCnc1
         3n5w==
X-Gm-Message-State: AOAM5308NmVIwIloDmjAsK5S6UO2DDsNm3JutyhZXafoPMdAm8s/ThdX
        Vf+RuIUoLuW66C55aVq5cd5+AzhKp2HgVKgTYR0m/csL2Qp7hrsv1p0kmi0OfRDGqZaxutwP74Z
        QrfY3KBWW9LGvXPAX
X-Received: by 2002:a05:622a:305:: with SMTP id q5mr26310812qtw.154.1628628304539;
        Tue, 10 Aug 2021 13:45:04 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx6HnJP7hH696mP7ZotxnBEIMBZEbFiTUglmNYhZApY3y8z+Fq5g3ssaaRHk/L70d0QaJrbuw==
X-Received: by 2002:a05:622a:305:: with SMTP id q5mr26310790qtw.154.1628628304340;
        Tue, 10 Aug 2021 13:45:04 -0700 (PDT)
Received: from Ruby.lyude.net (pool-108-49-102-102.bstnma.fios.verizon.net. [108.49.102.102])
        by smtp.gmail.com with ESMTPSA id f11sm3824174qtf.45.2021.08.10.13.45.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Aug 2021 13:45:03 -0700 (PDT)
Message-ID: <2012d26bb2bece43e65ce435e6ba03f1d8767f61.camel@redhat.com>
Subject: Re: [PATCH 2/4] drm/dp_mst: Only create connector for connected end
 device
From:   Lyude Paul <lyude@redhat.com>
To:     "Lin, Wayne" <Wayne.Lin@amd.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>
Cc:     "Kazlauskas, Nicholas" <Nicholas.Kazlauskas@amd.com>,
        "Wentland, Harry" <Harry.Wentland@amd.com>,
        "Zuo, Jerry" <Jerry.Zuo@amd.com>,
        "Wu, Hersen" <hersenxs.wu@amd.com>,
        Juston Li <juston.li@intel.com>,
        Imre Deak <imre.deak@intel.com>,
        Ville =?ISO-8859-1?Q?Syrj=E4l=E4?= 
        <ville.syrjala@linux.intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Sean Paul <sean@poorly.run>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        "Deucher, Alexander" <Alexander.Deucher@amd.com>,
        "Siqueira, Rodrigo" <Rodrigo.Siqueira@amd.com>,
        "Pillai, Aurabindo" <Aurabindo.Pillai@amd.com>,
        Eryk Brol <eryk.brol@amd.com>,
        Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>,
        "Cornij, Nikola" <Nikola.Cornij@amd.com>,
        Jani Nikula <jani.nikula@intel.com>,
        Manasi Navare <manasi.d.navare@intel.com>,
        Ankit Nautiyal <ankit.k.nautiyal@intel.com>,
        =?ISO-8859-1?Q?Jos=E9?= Roberto de Souza 
        <jose.souza@intel.com>, Sean Paul <seanpaul@chromium.org>,
        Ben Skeggs <bskeggs@redhat.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Date:   Tue, 10 Aug 2021 16:45:01 -0400
In-Reply-To: <SJ0PR12MB550410E529057F59023153D9FCF19@SJ0PR12MB5504.namprd12.prod.outlook.com>
References: <20210720160342.11415-1-Wayne.Lin@amd.com>
         <20210720160342.11415-3-Wayne.Lin@amd.com>
         <69a5f39580f0d3519468f45ecbfd50d7ad1b3036.camel@redhat.com>
         <292d6ead03d6afe54f81d52f705e38bbf9feb7bd.camel@redhat.com>
         <SJ0PR12MB550410E529057F59023153D9FCF19@SJ0PR12MB5504.namprd12.prod.outlook.com>
Organization: Red Hat
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 2021-08-04 at 07:13 +0000, Lin, Wayne wrote:
> [Public]
> 
> > -----Original Message-----
> > From: Lyude Paul <lyude@redhat.com>
> > Sent: Wednesday, August 4, 2021 8:09 AM
> > To: Lin, Wayne <Wayne.Lin@amd.com>; dri-devel@lists.freedesktop.org
> > Cc: Kazlauskas, Nicholas <Nicholas.Kazlauskas@amd.com>; Wentland, Harry <
> > Harry.Wentland@amd.com>; Zuo, Jerry
> > <Jerry.Zuo@amd.com>; Wu, Hersen <hersenxs.wu@amd.com>; Juston Li <
> > juston.li@intel.com>; Imre Deak <imre.deak@intel.com>;
> > Ville Syrjälä <ville.syrjala@linux.intel.com>; Wentland, Harry <
> > Harry.Wentland@amd.com>; Daniel Vetter <daniel.vetter@ffwll.ch>;
> > Sean Paul <sean@poorly.run>; Maarten Lankhorst <
> > maarten.lankhorst@linux.intel.com>; Maxime Ripard <mripard@kernel.org>;
> > Thomas Zimmermann <tzimmermann@suse.de>; David Airlie <airlied@linux.ie>;
> > Daniel Vetter <daniel@ffwll.ch>; Deucher,
> > Alexander <Alexander.Deucher@amd.com>; Siqueira, Rodrigo <
> > Rodrigo.Siqueira@amd.com>; Pillai, Aurabindo
> > <Aurabindo.Pillai@amd.com>; Eryk Brol <eryk.brol@amd.com>; Bas
> > Nieuwenhuizen <bas@basnieuwenhuizen.nl>; Cornij, Nikola
> > <Nikola.Cornij@amd.com>; Jani Nikula <jani.nikula@intel.com>; Manasi
> > Navare <manasi.d.navare@intel.com>; Ankit Nautiyal
> > <ankit.k.nautiyal@intel.com>; José Roberto de Souza
> > <jose.souza@intel.com>; Sean Paul <seanpaul@chromium.org>; Ben Skeggs
> > <bskeggs@redhat.com>; stable@vger.kernel.org
> > Subject: Re: [PATCH 2/4] drm/dp_mst: Only create connector for connected
> > end device
> > 
> > On Tue, 2021-08-03 at 19:58 -0400, Lyude Paul wrote:
> > > On Wed, 2021-07-21 at 00:03 +0800, Wayne Lin wrote:
> > > > [Why]
> > > > Currently, we will create connectors for all output ports no matter
> > > > it's connected or not. However, in MST, we can only determine
> > > > whether an output port really stands for a "connector" till it is
> > > > connected and check its peer device type as an end device.
> > > 
> > > What is this commit trying to solve exactly? e.g. is AMD currently
> > > running into issues with there being too many DRM connectors or
> > > something like that?
> > > Ideally this is behavior I'd very much like us to keep as-is unless
> > > there's good reason to change it.
> Hi Lyude,
> Really appreciate for your time to elaborate in such detail. Thanks!
> 
> I come up with this commit because I observed something confusing when I was
> analyzing
> MST connectors' life cycle. Take the topology instance you mentioned below
> 
> Root MSTB -> Output_Port 1 -> MSTB 1.1 ->Output_Port 1(Connected w/ display)
>                     |                                                    -
> >Output_Port 2 (Disconnected)
>                     -> Output_Port 2 -> MSTB 2.1 ->Output_Port 1
> (Disconnected)
>                                                                           ->
> Output_Port 2 (Disconnected)
> Which is exactly the topology of Startech DP 1-to-4 hub. There are 3 1-to-2
> branch chips
> within this hub. With our MST implementation today, we'll create drm
> connectors for all
> output ports. Hence, we totally create 6 drm connectors here. However,
> Output ports of
> Root MSTB are not connected to a stream sink. They are connected with branch
> devices.
> Thus, creating drm connector for such port looks a bit strange to me and
> increases
> complexity to tracking drm connectors.  My thought is we only need to create
> drm
> connector for those connected end device. Once output port is connected then
> we can
> determine whether to add on a drm connector for this port based on the peer
> device type.
> Hence, this commit doesn't try to break the locking logic but add more
> constraints when
> We try to add drm connector. Please correct me if I misunderstand anything
> here. Thanks!

Sorry-I will respond to this soon, some more stuff came up at work so it might
take me a day or two

> > > 
> > > Some context here btw - there's a lot of subtleties with MST locking
> > > that isn't immediately obvious. It's been a while since I wrote this
> > > code, but if I recall correctly one of those subtleties is that trying
> > > to create/destroy connectors on the fly when ports change types
> > > introduces a lot of potential issues with locking and some very
> > > complicated state transitions. Note that because we maintain the
> > > topology as much as possible across suspend/resumes this means there's
> > > a lot of potential state transitions with drm_dp_mst_port and
> > > drm_dp_mst_branch we need to handle that would typically be impossible
> > > to run into otherwise.
> > > 
> > > An example of this, if we were to try to prune connectors based on PDT
> > > on the fly: assume we have a simple topology like this
> > > 
> > > Root MSTB -> Port 1 -> MSTB 1.1 (Connected w/ display)
> > >           -> Port 2 -> MSTB 2.1
> > > 
> > > We suspend the system, unplug MSTB 1.1, and then resume. Once the
> > > system starts reprobing, it will notice that MSTB 1.1 has been
> > > disconnected. Since we no longer have a PDT, we decide to unregister
> > > our connector. But there's a catch! We had a display connected to MSTB
> > > 1.1, so even after unregistering the connector it's going to stay
> > > around until userspace has committed a new mode with the connector
> > > disabled.
> > > 
> > > Now - assuming we're still in the same spot in the resume processs,
> > > let's assume somehow MSTB 1.1 is suddenly plugged back in. Once we've
> > > finished responding to the hotplug event, we will have created a
> > > connector for it. Now we've hit a bug - userspace hasn't removed the
> > > previous zombie connector which means we have references to the
> > > drm_dp_mst_port in our atomic state and potentially also our payload
> > > tables (?? unsure about this one).
> > 
> > Whoops. One thing I totally forgot to mention here: the reason this is a
> > problem is because we'd now have two drm_connectors
> > which both have the same drm_dp_mst_port pointer.
> > 
> > > 
> > > So then how do we manage to add/remove connectors for input connectors
> > > on the fly? Well, that's one of the fun normally-impossible state
> > > transitions I mentioned before. According to the spec input ports are
> > > always disconnected, so we'll never receive a CSN for them. This means
> I think input ports' DisplayPort_Device_Plug_Status field is still set to 1?
> But yes,
> according to DP1.4 spec 2.11.9.3, when MST device whose DPRX detected the
> connection status change shall broadcast CSN downstream only. Hence, we'll
> never
> receive a CSN for this case.
> > > in theory the only possible way we could have a connector go from
> > > being an input connector to an output connector connector would be if
> > > the entire topology was swapped out during suspend/resume, and the
> > > input/output ports in the two topologies topology happen to be in
> > > different places.
> > > Since we only have to reprobe once during resume before we get
> > > hotplugging enabled, we're guaranteed this state transition will only
> > > happen once in this state - which means the second replug I described
> > > in the previous paragraph can never happen.
> > > 
> > > Note that while I don't actually know if there's topologies with input
> > > ports at indexes other than 0, since the specification isn't super
> > > clear on this bit we play it safe and assume it is possible.
> Based on DP1.4 spec 2.5.1. Physical input ports are assigned smaller port
> numbers than physical output ports. For concentrator product, if there are 2
> input ports of it's branch device, then their port numbers are port 0 & port
> 1
> which can refer to figure 2-122 of DP1.4.
> > > 
> > > Anyway-this is -all- based off my memory, so please point out anything
> > > here that I've explained that doesn't make sense or doesn't seem
> > > correct :). It's totally possible I might have misremembered something.
> Thanks again Lyude! Much appreciated for your time and help! And please
> correct me if I misunderstand anything here : )
> > > 
> > > > 
> > > > In current code, we have chance to create connectors for output
> > > > ports connected with branch device and these are redundant connectors.
> > > > e.g.
> > > > StarTech 1-to-4 DP hub is constructed by internal 2 layer 1-to-2
> > > > branch devices. Creating connectors for such internal output ports
> > > > are redundant.
> > > > 
> > > > [How]
> > > > Put constraint on creating connector for connected end device only.
> > > > 
> > > > Fixes: 6f85f73821f6 ("drm/dp_mst: Add basic topology reprobing when
> > > > resuming")
> > > > Cc: Juston Li <juston.li@intel.com>
> > > > Cc: Imre Deak <imre.deak@intel.com>
> > > > Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
> > > > Cc: Harry Wentland <hwentlan@amd.com>
> > > > Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
> > > > Cc: Sean Paul <sean@poorly.run>
> > > > Cc: Lyude Paul <lyude@redhat.com>
> > > > Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
> > > > Cc: Maxime Ripard <mripard@kernel.org>
> > > > Cc: Thomas Zimmermann <tzimmermann@suse.de>
> > > > Cc: David Airlie <airlied@linux.ie>
> > > > Cc: Daniel Vetter <daniel@ffwll.ch>
> > > > Cc: Alex Deucher <alexander.deucher@amd.com>
> > > > Cc: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
> > > > Cc: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
> > > > Cc: Aurabindo Pillai <aurabindo.pillai@amd.com>
> > > > Cc: Eryk Brol <eryk.brol@amd.com>
> > > > Cc: Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>
> > > > Cc: Nikola Cornij <nikola.cornij@amd.com>
> > > > Cc: Wayne Lin <Wayne.Lin@amd.com>
> > > > Cc: "Ville Syrjälä" <ville.syrjala@linux.intel.com>
> > > > Cc: Jani Nikula <jani.nikula@intel.com>
> > > > Cc: Manasi Navare <manasi.d.navare@intel.com>
> > > > Cc: Ankit Nautiyal <ankit.k.nautiyal@intel.com>
> > > > Cc: "José Roberto de Souza" <jose.souza@intel.com>
> > > > Cc: Sean Paul <seanpaul@chromium.org>
> > > > Cc: Ben Skeggs <bskeggs@redhat.com>
> > > > Cc: dri-devel@lists.freedesktop.org
> > > > Cc: <stable@vger.kernel.org> # v5.5+
> > > > Signed-off-by: Wayne Lin <Wayne.Lin@amd.com>
> > > > ---
> > > >  drivers/gpu/drm/drm_dp_mst_topology.c | 7 ++++++-
> > > >  1 file changed, 6 insertions(+), 1 deletion(-)
> > > > 
> > > > diff --git a/drivers/gpu/drm/drm_dp_mst_topology.c
> > > > b/drivers/gpu/drm/drm_dp_mst_topology.c
> > > > index 51cd7f74f026..f13c7187b07f 100644
> > > > --- a/drivers/gpu/drm/drm_dp_mst_topology.c
> > > > +++ b/drivers/gpu/drm/drm_dp_mst_topology.c
> > > > @@ -2474,7 +2474,8 @@ drm_dp_mst_handle_link_address_port(struct
> > > > drm_dp_mst_branch *mstb,
> > > > 
> > > >         if (port->connector)
> > > >                 drm_modeset_unlock(&mgr->base.lock);
> > > > -       else if (!port->input)
> > > > +       else if (!port->input && port->pdt != DP_PEER_DEVICE_NONE &&
> > > > +                drm_dp_mst_is_end_device(port->pdt, port->mcs))
> > > >                 drm_dp_mst_port_add_connector(mstb, port);
> > > > 
> > > >         if (send_link_addr && port->mstb) { @@ -2557,6 +2558,10 @@
> > > > drm_dp_mst_handle_conn_stat(struct
> > > > drm_dp_mst_branch
> > > > *mstb,
> > > >                 dowork = false;
> > > >         }
> > > > 
> > > > +       if (!port->input && !port->connector && new_pdt !=
> > > > DP_PEER_DEVICE_NONE &&
> > > > +           drm_dp_mst_is_end_device(new_pdt, new_mcs))
> > > > +               create_connector = true;
> > > > +
> > > >         if (port->connector)
> > > >                 drm_modeset_unlock(&mgr->base.lock);
> > > >         else if (create_connector)
> > > 
> > 
> > --
> > Cheers,
> >  Lyude Paul (she/her)
> >  Software Engineer at Red Hat
> Regards,
> Wayne Lin
> 

-- 
Cheers,
 Lyude Paul (she/her)
 Software Engineer at Red Hat


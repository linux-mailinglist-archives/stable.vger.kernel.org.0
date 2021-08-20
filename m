Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B22F73F3584
	for <lists+stable@lfdr.de>; Fri, 20 Aug 2021 22:47:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240600AbhHTUsc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Aug 2021 16:48:32 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:32143 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240524AbhHTUsa (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Aug 2021 16:48:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629492471;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3BJYc130oTC8QtDd1ovu41mdKO7/AK1tsEe9aBuI94I=;
        b=LWejCq/EZj9H/sGNIUzNteRYVYWFmjJKnkTQjPtsm9vPBZTnhmzMcn39hHXtI0U/Uaq/Em
        712/tSKo9b054E4lDtFVJxGxhD14g6F9j8Gl9Ni1sXTVP903TRE09xk+kshWhxFUTkF3Nr
        sDm2zdOPXpN9YU3l69vV05oZByAXI/I=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-75-xmVwDPXuNj2txFOijAhgmA-1; Fri, 20 Aug 2021 16:47:49 -0400
X-MC-Unique: xmVwDPXuNj2txFOijAhgmA-1
Received: by mail-qv1-f69.google.com with SMTP id m10-20020a056214158ab029035a6c1e5f3eso7753738qvw.7
        for <stable@vger.kernel.org>; Fri, 20 Aug 2021 13:47:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:organization:user-agent:mime-version
         :content-transfer-encoding;
        bh=3BJYc130oTC8QtDd1ovu41mdKO7/AK1tsEe9aBuI94I=;
        b=thwl0cbQbojhDAs8jL57kFaWCTLoDJ83dmnQVFuZhHOfYKJ1bmzvFj/elcabv2ULdT
         iSd2navDHkMvrGMeQxmARSdFi/H0l4tsA5rXlKRGWmoyp0aNJEyLbDyzR0MXawdzXid8
         XUq2gP69Yl8b8F6gLahNnmUzs9zqfszGv5nyrGOSQSUDa/tFwtPdtz0+GDWLwGSe87xu
         pjL9+j4s9cZegcEnvStY0Tl6ehfGmK3IT1lTRoqdHYaIvPGDfb168YxsW9IRtBASqztx
         PSx/PopPVzLVqtRz++xzH4RGmsNvrxFIzMo44trXsG8meIqfr5Zka+HxUfbqYEknv2p9
         AJrg==
X-Gm-Message-State: AOAM530uQNbyj95CNJOZ8t5UTgWSfG6gwae+kv9oSlYTmBtNoSc/WJE+
        LzwlOR+b8Oig5OtQH37M/odSQ/jF52HdVAA11RkOf9TzkJQcPHlGjaM0qzYJJVRoO5i8ZiRjSjn
        K6gS+B8pfEkEZ+wzT
X-Received: by 2002:a05:620a:cd5:: with SMTP id b21mr10467194qkj.271.1629492469203;
        Fri, 20 Aug 2021 13:47:49 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwpOCycSKzTZ9KuC/poSwoKoeq/Xl+jNTFw4GNR8hFic1JdPXXiju56dIRYJJPh77Ge2xQOig==
X-Received: by 2002:a05:620a:cd5:: with SMTP id b21mr10467174qkj.271.1629492468937;
        Fri, 20 Aug 2021 13:47:48 -0700 (PDT)
Received: from Ruby.lyude.net (pool-108-49-102-102.bstnma.fios.verizon.net. [108.49.102.102])
        by smtp.gmail.com with ESMTPSA id 19sm3367312qkf.127.2021.08.20.13.47.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Aug 2021 13:47:48 -0700 (PDT)
Message-ID: <db10eb95b1ec7e822c7379d310c54975810acd2b.camel@redhat.com>
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
        Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>,
        "Cornij, Nikola" <Nikola.Cornij@amd.com>,
        Jani Nikula <jani.nikula@intel.com>,
        Manasi Navare <manasi.d.navare@intel.com>,
        Ankit Nautiyal <ankit.k.nautiyal@intel.com>,
        =?ISO-8859-1?Q?Jos=E9?= Roberto de Souza 
        <jose.souza@intel.com>, Sean Paul <seanpaul@chromium.org>,
        Ben Skeggs <bskeggs@redhat.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Date:   Fri, 20 Aug 2021 16:47:46 -0400
In-Reply-To: <CO6PR12MB548965A84DF69BAC30F74AC5FCC19@CO6PR12MB5489.namprd12.prod.outlook.com>
References: <20210720160342.11415-1-Wayne.Lin@amd.com>
         <20210720160342.11415-3-Wayne.Lin@amd.com>
         <69a5f39580f0d3519468f45ecbfd50d7ad1b3036.camel@redhat.com>
         <292d6ead03d6afe54f81d52f705e38bbf9feb7bd.camel@redhat.com>
         <SJ0PR12MB550410E529057F59023153D9FCF19@SJ0PR12MB5504.namprd12.prod.outlook.com>
         <2012d26bb2bece43e65ce435e6ba03f1d8767f61.camel@redhat.com>
         <CO6PR12MB5489274038BFF71A80EA9ECEFCF89@CO6PR12MB5489.namprd12.prod.outlook.com>
         <cd24fffcbda28ffc6734fb6d6d28b39e8782e0dd.camel@redhat.com>
         <CO6PR12MB548965A84DF69BAC30F74AC5FCC19@CO6PR12MB5489.namprd12.prod.outlook.com>
Organization: Red Hat
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 2021-08-20 at 11:20 +0000, Lin, Wayne wrote:
> [Public]
> 
> > -----Original Message-----
> > From: Lyude Paul <lyude@redhat.com>
> > Sent: Thursday, August 19, 2021 2:59 AM
> > To: Lin, Wayne <Wayne.Lin@amd.com>; dri-devel@lists.freedesktop.org
> > Cc: Kazlauskas, Nicholas <Nicholas.Kazlauskas@amd.com>; Wentland, Harry <
> > Harry.Wentland@amd.com>; Zuo, Jerry
> > <Jerry.Zuo@amd.com>; Wu, Hersen <hersenxs.wu@amd.com>; Juston Li <
> > juston.li@intel.com>; Imre Deak <imre.deak@intel.com>;
> > Ville Syrjälä <ville.syrjala@linux.intel.com>; Daniel Vetter <
> > daniel.vetter@ffwll.ch>; Sean Paul <sean@poorly.run>; Maarten Lankhorst
> > <maarten.lankhorst@linux.intel.com>; Maxime Ripard <mripard@kernel.org>;
> > Thomas Zimmermann <tzimmermann@suse.de>;
> > David Airlie <airlied@linux.ie>; Daniel Vetter <daniel@ffwll.ch>; Deucher,
> > Alexander <Alexander.Deucher@amd.com>; Siqueira,
> > Rodrigo <Rodrigo.Siqueira@amd.com>; Pillai, Aurabindo <
> > Aurabindo.Pillai@amd.com>; Eryk Brol <eryk.brol@amd.com>; Bas
> > Nieuwenhuizen <bas@basnieuwenhuizen.nl>; Cornij, Nikola <
> > Nikola.Cornij@amd.com>; Jani Nikula <jani.nikula@intel.com>; Manasi
> > Navare <manasi.d.navare@intel.com>; Ankit Nautiyal <
> > ankit.k.nautiyal@intel.com>; José Roberto de Souza <jose.souza@intel.com>;
> > Sean Paul <seanpaul@chromium.org>; Ben Skeggs <bskeggs@redhat.com>; 
> > stable@vger.kernel.org
> > Subject: Re: [PATCH 2/4] drm/dp_mst: Only create connector for connected
> > end device
> > 
> > On Wed, 2021-08-11 at 09:49 +0000, Lin, Wayne wrote:
> > > [Public]
> > > 
> > > > -----Original Message-----
> > > > From: Lyude Paul <lyude@redhat.com>
> > > > Sent: Wednesday, August 11, 2021 4:45 AM
> > > > To: Lin, Wayne <Wayne.Lin@amd.com>; dri-devel@lists.freedesktop.org
> > > > Cc: Kazlauskas, Nicholas <Nicholas.Kazlauskas@amd.com>; Wentland,
> > > > Harry < Harry.Wentland@amd.com>; Zuo, Jerry <Jerry.Zuo@amd.com>; Wu,
> > > > Hersen <hersenxs.wu@amd.com>; Juston Li < juston.li@intel.com>; Imre
> > > > Deak <imre.deak@intel.com>; Ville Syrjälä
> > > > <ville.syrjala@linux.intel.com>; Daniel Vetter <
> > > > daniel.vetter@ffwll.ch>; Sean Paul <sean@poorly.run>; Maarten
> > > > Lankhorst <maarten.lankhorst@linux.intel.com>; Maxime Ripard
> > > > <mripard@kernel.org>; Thomas Zimmermann <tzimmermann@suse.de>; David
> > > > Airlie <airlied@linux.ie>; Daniel Vetter <daniel@ffwll.ch>; Deucher,
> > > > Alexander <Alexander.Deucher@amd.com>; Siqueira, Rodrigo
> > > > <Rodrigo.Siqueira@amd.com>; Pillai, Aurabindo <
> > > > Aurabindo.Pillai@amd.com>; Eryk Brol <eryk.brol@amd.com>; Bas
> > > > Nieuwenhuizen <bas@basnieuwenhuizen.nl>; Cornij, Nikola <
> > > > Nikola.Cornij@amd.com>; Jani Nikula <jani.nikula@intel.com>; Manasi
> > > > Navare <manasi.d.navare@intel.com>; Ankit Nautiyal <
> > > > ankit.k.nautiyal@intel.com>; José Roberto de Souza
> > > > <jose.souza@intel.com>; Sean Paul <seanpaul@chromium.org>; Ben
> > > > Skeggs <bskeggs@redhat.com>; stable@vger.kernel.org
> > > > Subject: Re: [PATCH 2/4] drm/dp_mst: Only create connector for
> > > > connected end device
> > > > 
> > > > On Wed, 2021-08-04 at 07:13 +0000, Lin, Wayne wrote:
> > > > > [Public]
> > > > > 
> > > > > > -----Original Message-----
> > > > > > From: Lyude Paul <lyude@redhat.com>
> > > > > > Sent: Wednesday, August 4, 2021 8:09 AM
> > > > > > To: Lin, Wayne <Wayne.Lin@amd.com>;
> > > > > > dri-devel@lists.freedesktop.org
> > > > > > Cc: Kazlauskas, Nicholas <Nicholas.Kazlauskas@amd.com>;
> > > > > > Wentland, Harry < Harry.Wentland@amd.com>; Zuo, Jerry
> > > > > > <Jerry.Zuo@amd.com>; Wu, Hersen <hersenxs.wu@amd.com>; Juston Li
> > > > > > < juston.li@intel.com>; Imre Deak <imre.deak@intel.com>; Ville
> > > > > > Syrjälä <ville.syrjala@linux.intel.com>; Wentland, Harry <
> > > > > > Harry.Wentland@amd.com>; Daniel Vetter <daniel.vetter@ffwll.ch>;
> > > > > > Sean Paul <sean@poorly.run>; Maarten Lankhorst <
> > > > > > maarten.lankhorst@linux.intel.com>; Maxime Ripard
> > > > > > <mripard@kernel.org>; Thomas Zimmermann <tzimmermann@suse.de>;
> > > > > > David Airlie <airlied@linux.ie>; Daniel Vetter
> > > > > > <daniel@ffwll.ch>; Deucher, Alexander
> > > > > > <Alexander.Deucher@amd.com>; Siqueira, Rodrigo <
> > > > > > Rodrigo.Siqueira@amd.com>; Pillai, Aurabindo
> > > > > > <Aurabindo.Pillai@amd.com>; Eryk Brol <eryk.brol@amd.com>; Bas
> > > > > > Nieuwenhuizen <bas@basnieuwenhuizen.nl>; Cornij, Nikola
> > > > > > <Nikola.Cornij@amd.com>; Jani Nikula <jani.nikula@intel.com>;
> > > > > > Manasi Navare <manasi.d.navare@intel.com>; Ankit Nautiyal
> > > > > > <ankit.k.nautiyal@intel.com>; José Roberto de Souza
> > > > > > <jose.souza@intel.com>; Sean Paul <seanpaul@chromium.org>; Ben
> > > > > > Skeggs <bskeggs@redhat.com>; stable@vger.kernel.org
> > > > > > Subject: Re: [PATCH 2/4] drm/dp_mst: Only create connector for
> > > > > > connected end device
> > > > > > 
> > > > > > On Tue, 2021-08-03 at 19:58 -0400, Lyude Paul wrote:
> > > > > > > On Wed, 2021-07-21 at 00:03 +0800, Wayne Lin wrote:
> > > > > > > > [Why]
> > > > > > > > Currently, we will create connectors for all output ports no
> > > > > > > > matter it's connected or not. However, in MST, we can only
> > > > > > > > determine whether an output port really stands for a
> > > > > > > > "connector"
> > > > > > > > till it is connected and check its peer device type as an
> > > > > > > > end device.
> > > > > > > 
> > > > > > > What is this commit trying to solve exactly? e.g. is AMD
> > > > > > > currently running into issues with there being too many DRM
> > > > > > > connectors or something like that?
> > > > > > > Ideally this is behavior I'd very much like us to keep as-is
> > > > > > > unless there's good reason to change it.
> > > > > Hi Lyude,
> > > > > Really appreciate for your time to elaborate in such detail. Thanks!
> > > > > 
> > > > > I come up with this commit because I observed something confusing
> > > > > when I was analyzing MST connectors' life cycle. Take the topology
> > > > > instance you mentioned below
> > > > > 
> > > > > Root MSTB -> Output_Port 1 -> MSTB 1.1 ->Output_Port 1(Connected
> > > > > w/
> > > > > display)
> > > > >                     |
> > > > > -
> > > > > > Output_Port 2 (Disconnected)
> > > > >                     -> Output_Port 2 -> MSTB 2.1 ->Output_Port 1
> > > > > (Disconnected)
> > > > > 
> > > > > -> Output_Port 2 (Disconnected) Which is exactly the topology of
> > > > > Startech DP 1-to-4 hub. There are 3 1-to-2 branch chips within
> > > > > this hub. With our MST implementation today, we'll create drm
> > > > > connectors for all output ports. Hence, we totally create 6 drm
> > > > > connectors here.
> > > > > However, Output ports of Root MSTB are not connected to a stream
> > > > > sink.
> > > > > They are connected with branch devices.
> > > > > Thus, creating drm connector for such port looks a bit strange to
> > > > > me and increases complexity to tracking drm connectors.  My
> > > > > thought is we only need to create drm connector for those
> > > > > connected end device. Once output port is connected then we can
> > > > > determine whether to add on a drm connector for this port based on
> > > > > the peer device type.
> > > > > Hence, this commit doesn't try to break the locking logic but add
> > > > > more constraints when We try to add drm connector. Please correct
> > > > > me if I misunderstand anything here. Thanks!
> > > > 
> > > > Sorry-I will respond to this soon, some more stuff came up at work
> > > > so it might take me a day or two
> > > No worries. Much appreciated for your time!
> > > > 
> > 
> > Alright - finally got some time to respond to this. So this change still
> > doesn't really seem correct to me (if anyone watching this thread
> > wants to chime in to correct me btw feel free).
> > 
> > JFYI - I don't think the commit is trying to break anything intentionally,
> > it's just that there's a lot of moving pieces with the locking here
> > that are easy to trip over. That being said though, besides the locking
> > issues after thinking about this I'm still a bit skeptical on how
> > much this would work or even if we would want it.
> > 
> > To start off - my main issue with this is that it sounds like we're
> > basically entirely getting rid of the disconnected state for MST
> > connectors, and then only exposing the connector when something is
> > connected. Unless I'm missing something here, the PDT can
> > pretty much change whenever something is connected/disconnected or across
> > suspend/resume reprobes. To do this with the
> > connector API would be very different from connector probing behavior for
> > other connector types, which already seems like an issue
> > to me. This would also break the ability to force a connector to be
> > connected/disconnected, as there would no longer be a way to
> > force a disconnected MST connector on.
> > 
> > The other thing is I'm not entirely clear still on what's trying to be
> > accomplished here. If you're trying to identify DRM connectors,
> > there's already no guaranteed consistency with connector names which means
> > that having less connectors doesn't really make things
> > any easier to identify. For actually trying to figure out more details on
> > connectors, if this is somethig userspace needs, this seems like
> > something we should just be adding in the form of connector props.
> > 
> > With all of this being said, this ends up just seeming like we're adding
> > potentially a lot of complexity to how we create connectors and
> > the suspend/resume reprobing code. I think it'd be good to know what the
> > precise usecase for this actually is, if this is something you
> > still think is needed.
> Hi Lyude,
> 
> Really thankful for willing to explain in such details. Really appreciate.
> 
> I'm trying to fix some problems that observed after these 2 patches
> * 09b974e8983 drm/amd/amdgpu_dm/mst: Remove ->destroy_connector() callback
> * 72dc0f51591 drm/dp_mst: Remove drm_dp_mst_topology_cbs.destroy_connector
> 
> With above patches, we now change to remove dc_sink when connector is about
> to be destroyed. However, we found out that
> connectors won't get destroyed after hotplugs. Thus, after few times
> hotplugs, we won't create any new dc_sink since number of
> sink is exceeding our limitation. As the result of that, I'm trying to
> figure out why the refcount of connectors won't get zero.
> 
> Based on my analysis, I found out that if we connect a sst monitor to a mst
> hub then connect the hub to the system, and then unplug
> the sst monitor from the hub. E.g.
> src - mst hub - sst monitor => src - mst hub  (unplug) sst monitor
> 
> Within this case, we won't try to put refcount of the sst monitor. Which is
> what I tried to resolve by [PATCH 3/4].
> But here comes a problem which is confusing me that if I can destroy
> connector in this case. By comparing to another case, if now
> mst hub is connected with a mst monitor like this:
> src - mst hub - mst monitor => src - mst hub  (unplug) mst monitor
> 
> We will put the topology refcount of mst monitor's branching unit in and 
> drm_dp_port_set_pdt() and eventually call
> drm_dp_delayed_destroy_port() to unregister the connector of the logical
> port. So following the same rule, I think to dynamically
> unregister a mst connector is what we want and should be reasonable to also
> destroy sst connectors in my case. But this conflicts the
> idea what we have here. We want to create connectors for all output ports.
> So if dynamically creating/destroying connectors is what we
> want, when is the appropriate time for us to create one is what I'm
> considering.
> 
> Take the StartTech hub DP 1to4 DP output ports for instance. This hub,
> internally, is constructed by  3 1-to-2 mst branch chips. 2 output
> ports of 1st chip are hardwired to another 2 chips. It's how it makes it to
> support 1-to-4 mst branching. So within this case, the internal 2
> output ports of 1st chip is not connecting to a stream sink and will never
> get connected to one.  Thus, I'm thinking maybe the best timing
> to attach a connector to a port is when the port is connected, and the
> connected PDT is determined as a stream sink.
> 
> Sorry if I misunderstand anything here and really thanks for your time to
> shed light on this : ) Thanks Lyude.

It's no problem, it is my job after all! Sorry for how long my responses have
been taking, but my plate seems to be finally clearing up for the foreseeable
future.

That being said - it sounds like with this we still aren't actually clear on
where the topology refcount leak is happening - only when it's happening,
which says to me that's the issue we really need to be figuring out the cause
of as opposed to trying to workaround it.

Actually - refcount leaks is an issue I've ran into a number of times before
in the past, so a while back I actually added some nice debugging features to
assist with debugging leaks. If you enable the following options in your
kernel config:

CONFIG_EXPERT=y # This must be set first before the next option
CONFIG_DRM_DEBUG_DP_MST_TOPOLOGY_REFS=y

Unfortunately, I'm suddenly realizing after typing this that apparently I
never bothered adding a way for us to debug the refcounts of ports/mstbs that
haven't been released yet - only the ones for ones that have. This shouldn't
be difficult at all for me to add, so I'll send you a patch either today or at
the start of next week to try debugging with using this, and then we can
figure out where this leak is really coming from.

> > 
> > > > > > > 
> > > > > > > Some context here btw - there's a lot of subtleties with MST
> > > > > > > locking that isn't immediately obvious. It's been a while
> > > > > > > since I wrote this code, but if I recall correctly one of
> > > > > > > those subtleties is that trying to create/destroy connectors
> > > > > > > on the fly when ports change types introduces a lot of
> > > > > > > potential issues with locking and some very complicated state
> > > > > > > transitions. Note that because we maintain the topology as
> > > > > > > much as possible across suspend/resumes this means there's a
> > > > > > > lot of potential state transitions with drm_dp_mst_port and
> > > > > > > drm_dp_mst_branch we need to handle that would typically be
> > > > > > > impossible to run into otherwise.
> > > > > > > 
> > > > > > > An example of this, if we were to try to prune connectors
> > > > > > > based on PDT on the fly: assume we have a simple topology like
> > > > > > > this
> > > > > > > 
> > > > > > > Root MSTB -> Port 1 -> MSTB 1.1 (Connected w/ display)
> > > > > > >           -> Port 2 -> MSTB 2.1
> > > > > > > 
> > > > > > > We suspend the system, unplug MSTB 1.1, and then resume. Once
> > > > > > > the system starts reprobing, it will notice that MSTB 1.1 has
> > > > > > > been disconnected. Since we no longer have a PDT, we decide to
> > > > > > > unregister our connector. But there's a catch! We had a
> > > > > > > display connected to MSTB 1.1, so even after unregistering the
> > > > > > > connector it's going to stay around until userspace has
> > > > > > > committed a new mode with the connector disabled.
> > > > > > > 
> > > > > > > Now - assuming we're still in the same spot in the resume
> > > > > > > processs, let's assume somehow MSTB 1.1 is suddenly plugged
> > > > > > > back in. Once we've finished responding to the hotplug event,
> > > > > > > we will have created a connector for it. Now we've hit a bug -
> > > > > > > userspace hasn't removed the previous zombie connector which
> > > > > > > means we have references to the drm_dp_mst_port in our atomic
> > > > > > > state and potentially also our payload tables (?? unsure about
> > > > > > > this one).
> > > > > > 
> > > > > > Whoops. One thing I totally forgot to mention here: the reason
> > > > > > this is a problem is because we'd now have two drm_connectors
> > > > > > which both have the same drm_dp_mst_port pointer.
> > > > > > 
> > > > > > > 
> > > > > > > So then how do we manage to add/remove connectors for input
> > > > > > > connectors on the fly? Well, that's one of the fun
> > > > > > > normally-impossible state transitions I mentioned before.
> > > > > > > According to the spec input ports are always disconnected, so
> > > > > > > we'll never receive a CSN for them. This means
> > > > > I think input ports' DisplayPort_Device_Plug_Status field is still
> > > > > set to 1?
> > > > > But yes,
> > > > > according to DP1.4 spec 2.11.9.3, when MST device whose DPRX
> > > > > detected the connection status change shall broadcast CSN downstream
> > > > > only.
> > > > > Hence, we'll never receive a CSN for this case.
> > > > > > > in theory the only possible way we could have a connector go
> > > > > > > from being an input connector to an output connector connector
> > > > > > > would be if the entire topology was swapped out during
> > > > > > > suspend/resume, and the input/output ports in the two
> > > > > > > topologies topology happen to be in different places.
> > > > > > > Since we only have to reprobe once during resume before we get
> > > > > > > hotplugging enabled, we're guaranteed this state transition
> > > > > > > will only happen once in this state - which means the second
> > > > > > > replug I described in the previous paragraph can never happen.
> > > > > > > 
> > > > > > > Note that while I don't actually know if there's topologies
> > > > > > > with input ports at indexes other than 0, since the
> > > > > > > specification isn't super clear on this bit we play it safe and
> > > > > > > assume it is possible.
> > > > > Based on DP1.4 spec 2.5.1. Physical input ports are assigned
> > > > > smaller port numbers than physical output ports. For concentrator
> > > > > product, if there are 2 input ports of it's branch device, then
> > > > > their port numbers are port 0 & port
> > > > > 1
> > > > > which can refer to figure 2-122 of DP1.4.
> > > > > > > 
> > > > > > > Anyway-this is -all- based off my memory, so please point out
> > > > > > > anything here that I've explained that doesn't make sense or
> > > > > > > doesn't seem correct :). It's totally possible I might have
> > > > > > > misremembered something.
> > > > > Thanks again Lyude! Much appreciated for your time and help! And
> > > > > please correct me if I misunderstand anything here : )
> > > > > > > 
> > > > > > > > 
> > > > > > > > In current code, we have chance to create connectors for
> > > > > > > > output ports connected with branch device and these are
> > > > > > > > redundant connectors.
> > > > > > > > e.g.
> > > > > > > > StarTech 1-to-4 DP hub is constructed by internal 2 layer
> > > > > > > > 1-to-2 branch devices. Creating connectors for such internal
> > > > > > > > output ports are redundant.
> > > > > > > > 
> > > > > > > > [How]
> > > > > > > > Put constraint on creating connector for connected end
> > > > > > > > device only.
> > > > > > > > 
> > > > > > > > Fixes: 6f85f73821f6 ("drm/dp_mst: Add basic topology
> > > > > > > > reprobing when
> > > > > > > > resuming")
> > > > > > > > Cc: Juston Li <juston.li@intel.com>
> > > > > > > > Cc: Imre Deak <imre.deak@intel.com>
> > > > > > > > Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
> > > > > > > > Cc: Harry Wentland <hwentlan@amd.com>
> > > > > > > > Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
> > > > > > > > Cc: Sean Paul <sean@poorly.run>
> > > > > > > > Cc: Lyude Paul <lyude@redhat.com>
> > > > > > > > Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
> > > > > > > > Cc: Maxime Ripard <mripard@kernel.org>
> > > > > > > > Cc: Thomas Zimmermann <tzimmermann@suse.de>
> > > > > > > > Cc: David Airlie <airlied@linux.ie>
> > > > > > > > Cc: Daniel Vetter <daniel@ffwll.ch>
> > > > > > > > Cc: Alex Deucher <alexander.deucher@amd.com>
> > > > > > > > Cc: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
> > > > > > > > Cc: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
> > > > > > > > Cc: Aurabindo Pillai <aurabindo.pillai@amd.com>
> > > > > > > > Cc: Eryk Brol <eryk.brol@amd.com>
> > > > > > > > Cc: Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>
> > > > > > > > Cc: Nikola Cornij <nikola.cornij@amd.com>
> > > > > > > > Cc: Wayne Lin <Wayne.Lin@amd.com>
> > > > > > > > Cc: "Ville Syrjälä" <ville.syrjala@linux.intel.com>
> > > > > > > > Cc: Jani Nikula <jani.nikula@intel.com>
> > > > > > > > Cc: Manasi Navare <manasi.d.navare@intel.com>
> > > > > > > > Cc: Ankit Nautiyal <ankit.k.nautiyal@intel.com>
> > > > > > > > Cc: "José Roberto de Souza" <jose.souza@intel.com>
> > > > > > > > Cc: Sean Paul <seanpaul@chromium.org>
> > > > > > > > Cc: Ben Skeggs <bskeggs@redhat.com>
> > > > > > > > Cc: dri-devel@lists.freedesktop.org
> > > > > > > > Cc: <stable@vger.kernel.org> # v5.5+
> > > > > > > > Signed-off-by: Wayne Lin <Wayne.Lin@amd.com>
> > > > > > > > ---
> > > > > > > >  drivers/gpu/drm/drm_dp_mst_topology.c | 7 ++++++-
> > > > > > > >  1 file changed, 6 insertions(+), 1 deletion(-)
> > > > > > > > 
> > > > > > > > diff --git a/drivers/gpu/drm/drm_dp_mst_topology.c
> > > > > > > > b/drivers/gpu/drm/drm_dp_mst_topology.c
> > > > > > > > index 51cd7f74f026..f13c7187b07f 100644
> > > > > > > > --- a/drivers/gpu/drm/drm_dp_mst_topology.c
> > > > > > > > +++ b/drivers/gpu/drm/drm_dp_mst_topology.c
> > > > > > > > @@ -2474,7 +2474,8 @@
> > > > > > > > drm_dp_mst_handle_link_address_port(struct
> > > > > > > > drm_dp_mst_branch *mstb,
> > > > > > > > 
> > > > > > > >         if (port->connector)
> > > > > > > >                 drm_modeset_unlock(&mgr->base.lock);
> > > > > > > > -       else if (!port->input)
> > > > > > > > +       else if (!port->input && port->pdt !=
> > > > > > > > +DP_PEER_DEVICE_NONE &&
> > > > > > > > +                drm_dp_mst_is_end_device(port->pdt,
> > > > > > > > +port->mcs))
> > > > > > > >                 drm_dp_mst_port_add_connector(mstb, port);
> > > > > > > > 
> > > > > > > >         if (send_link_addr && port->mstb) { @@ -2557,6
> > > > > > > > +2558,10 @@ drm_dp_mst_handle_conn_stat(struct
> > > > > > > > drm_dp_mst_branch
> > > > > > > > *mstb,
> > > > > > > >                 dowork = false;
> > > > > > > >         }
> > > > > > > > 
> > > > > > > > +       if (!port->input && !port->connector && new_pdt !=
> > > > > > > > DP_PEER_DEVICE_NONE &&
> > > > > > > > +           drm_dp_mst_is_end_device(new_pdt, new_mcs))
> > > > > > > > +               create_connector = true;
> > > > > > > > +
> > > > > > > >         if (port->connector)
> > > > > > > >                 drm_modeset_unlock(&mgr->base.lock);
> > > > > > > >         else if (create_connector)
> > > > > > > 
> > > > > > 
> > > > > > --
> > > > > > Cheers,
> > > > > >  Lyude Paul (she/her)
> > > > > >  Software Engineer at Red Hat
> > > > > Regards,
> > > > > Wayne Lin
> > > > > 
> > > > 
> > > > --
> > > > Cheers,
> > > >  Lyude Paul (she/her)
> > > >  Software Engineer at Red Hat
> > > --
> > > Regards,
> > > Wayne Lin
> > > 
> > 
> > --
> > Cheers,
> >  Lyude Paul (she/her)
> >  Software Engineer at Red Hat
> Best regards,
> Wayne Lin
> 

-- 
Cheers,
 Lyude Paul (she/her)
 Software Engineer at Red Hat


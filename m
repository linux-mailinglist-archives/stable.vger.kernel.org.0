Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D01F42AE9F
	for <lists+stable@lfdr.de>; Tue, 12 Oct 2021 23:17:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232542AbhJLVTY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Oct 2021 17:19:24 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:27265 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235396AbhJLVTT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Oct 2021 17:19:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634073436;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BhPquvEYBnEPVShNSaZAj/bV0Vx/QMHymRBU4hHIGF4=;
        b=Q9guvQ83xtALibG7MHHZTUiT+8yhoYQJClW9q3v5OXNmlghIKoHFUviaMKwMF0LYiYTssw
        E+RUAjBMj4L6KOQI1ZtHabNVGvnU4bv8+ZtbuqinjQSOU6km0gcOeWPsySlnmrqTIY+QmG
        OrOgqtm3S+kQHrd2IRaYSE3TspY1tR4=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-582-pC6VHMonN_K4eg4lCmIopw-1; Tue, 12 Oct 2021 17:17:15 -0400
X-MC-Unique: pC6VHMonN_K4eg4lCmIopw-1
Received: by mail-qk1-f198.google.com with SMTP id x3-20020a05620a448300b0045e3e24de82so314886qkp.3
        for <stable@vger.kernel.org>; Tue, 12 Oct 2021 14:17:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:organization:user-agent:mime-version
         :content-transfer-encoding;
        bh=BhPquvEYBnEPVShNSaZAj/bV0Vx/QMHymRBU4hHIGF4=;
        b=HkBE7oAV4GT/RX/jeR1l5hxjFzRBNMdOGk1Jw20mta8g6F5u5dUOczP9EpQWbCE5RZ
         O1JuPOoQOn0J3K0mmmf59p9rxuM7chDRxomQ1E1nD22P6dO2ZyIsjixxGCmsNJswPJ0B
         LNKcUNQDwxJZWsQBf2Nhg78I4aw0NDumxboCOBsbusK742IFtvjfEUgQT2PKiWGTtbu9
         i00cINHB5sPCSJeeNipCRVSA8tqwx3FXf3n+6O4vd6pq5pq+CZihK7SP0jNxxLciPiXq
         8OYtTmy7xc9jrYFKl3fOKhANCTW1/+yKhRq/mqMX6iNfqS7CxaGIJlvKVUgA0Nnes2LB
         AhwQ==
X-Gm-Message-State: AOAM533A6qvNQh2DkY8dWU4OsNiy8BsdmJ9U3tpjsGJBA4uazd9xs4P8
        LW20I13C25B5nMW8N49dFCl+DhiWHtOKo+lF5f3N1XKWLG378SqlcX9eZaKw5J/BttmcPsPBz+t
        wXOR4WLw2psT+44he
X-Received: by 2002:a05:622a:1312:: with SMTP id v18mr25768027qtk.332.1634073435247;
        Tue, 12 Oct 2021 14:17:15 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwQReTTVDOPt6xtAGa+1Va9qBnLFmMl+qOa+02+tZqDAp0oBwcgzAl0Cv8UyNr291jE1OcGpA==
X-Received: by 2002:a05:622a:1312:: with SMTP id v18mr25768000qtk.332.1634073434968;
        Tue, 12 Oct 2021 14:17:14 -0700 (PDT)
Received: from [192.168.8.206] (pool-96-230-249-157.bstnma.fios.verizon.net. [96.230.249.157])
        by smtp.gmail.com with ESMTPSA id z6sm6325829qke.24.2021.10.12.14.17.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Oct 2021 14:17:14 -0700 (PDT)
Message-ID: <a4353e03be096ccf2a78c89035054a1a7343a306.camel@redhat.com>
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
Date:   Tue, 12 Oct 2021 17:17:12 -0400
In-Reply-To: <CO6PR12MB54899D4044882C1D7CA4B765FCDA9@CO6PR12MB5489.namprd12.prod.outlook.com>
References: <20210720160342.11415-1-Wayne.Lin@amd.com>
         <20210720160342.11415-3-Wayne.Lin@amd.com>
         <69a5f39580f0d3519468f45ecbfd50d7ad1b3036.camel@redhat.com>
         <292d6ead03d6afe54f81d52f705e38bbf9feb7bd.camel@redhat.com>
         <SJ0PR12MB550410E529057F59023153D9FCF19@SJ0PR12MB5504.namprd12.prod.outlook.com>
         <2012d26bb2bece43e65ce435e6ba03f1d8767f61.camel@redhat.com>
         <CO6PR12MB5489274038BFF71A80EA9ECEFCF89@CO6PR12MB5489.namprd12.prod.outlook.com>
         <cd24fffcbda28ffc6734fb6d6d28b39e8782e0dd.camel@redhat.com>
         <CO6PR12MB548965A84DF69BAC30F74AC5FCC19@CO6PR12MB5489.namprd12.prod.outlook.com>
         <db10eb95b1ec7e822c7379d310c54975810acd2b.camel@redhat.com>
         <CO6PR12MB548913A9CC63A199BBBD6545FCC49@CO6PR12MB5489.namprd12.prod.outlook.com>
         <6a0868a8ce6befd5f7ddea3481e70285079fcb6a.camel@redhat.com>
         <CO6PR12MB5489987336A4D5DF83C4FD3CFCC69@CO6PR12MB5489.namprd12.prod.outlook.com>
         <a0a8ce9d25cc5b68e14384329e8c635e546cee90.camel@redhat.com>
         <f3d1df941d36a2772f317973dd3dc1d7a666957e.camel@redhat.com>
         <CO6PR12MB54899D4044882C1D7CA4B765FCDA9@CO6PR12MB5489.namprd12.prod.outlook.com>
Organization: Red Hat
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.4 (3.40.4-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

OK - got sidetracked by an issue at work but I just resumed working on this
today, should hopefully have it done at the start of next week at the latest
(hooray for having time to do things upstream again! :).

On Tue, 2021-09-14 at 08:46 +0000, Lin, Wayne wrote:
> [Public]
> 
> > -----Original Message-----
> > From: Lyude Paul <lyude@redhat.com>
> > Sent: Thursday, September 2, 2021 6:00 AM
> > To: Lin, Wayne <Wayne.Lin@amd.com>; dri-devel@lists.freedesktop.org
> > Cc: Kazlauskas, Nicholas <Nicholas.Kazlauskas@amd.com>; Wentland, Harry
> > <Harry.Wentland@amd.com>; Zuo, Jerry
> > <Jerry.Zuo@amd.com>; Wu, Hersen <hersenxs.wu@amd.com>; Juston Li
> > <juston.li@intel.com>; Imre Deak <imre.deak@intel.com>;
> > Ville Syrjälä <ville.syrjala@linux.intel.com>; Daniel Vetter
> > <daniel.vetter@ffwll.ch>; Sean Paul <sean@poorly.run>; Maarten Lankhorst
> > <maarten.lankhorst@linux.intel.com>; Maxime Ripard <mripard@kernel.org>;
> > Thomas Zimmermann <tzimmermann@suse.de>;
> > David Airlie <airlied@linux.ie>; Daniel Vetter <daniel@ffwll.ch>; Deucher,
> > Alexander <Alexander.Deucher@amd.com>; Siqueira,
> > Rodrigo <Rodrigo.Siqueira@amd.com>; Pillai, Aurabindo
> > <Aurabindo.Pillai@amd.com>; Bas Nieuwenhuizen
> > <bas@basnieuwenhuizen.nl>; Cornij, Nikola <Nikola.Cornij@amd.com>; Jani
> > Nikula <jani.nikula@intel.com>; Manasi Navare
> > <manasi.d.navare@intel.com>; Ankit Nautiyal <ankit.k.nautiyal@intel.com>;
> > José Roberto de Souza <jose.souza@intel.com>; Sean
> > Paul <seanpaul@chromium.org>; Ben Skeggs <bskeggs@redhat.com>;
> > stable@vger.kernel.org
> > Subject: Re: [PATCH 2/4] drm/dp_mst: Only create connector for connected
> > end device
> > 
> > Actually - did some more thinking, and I think we shouldn't try to make
> > changes like this until we actually know what the problem is
> > here. I could try to figure out what the actual race conditions I was
> > facing before with trying to add/destroy connectors based on PDT,
> > but we still don't even actually have a clear idea of what's broken here.
> > I'd much rather us figure out exactly how this leak is
> > happening before considering making changes like this, because we have no
> > way of knowing if we've properly fixed it or not if we
> > don't know what the problem is in the first place.
> > 
> > I'm still happy to write up the topology debugging stuff I mentioned to
> > you if you think that would help you debug this issue - since
> > that would make it a lot easier for you to track down what references are
> > keeping a connector alive (and additkionally, where those
> > references were taken in code. thanks
> > stack_depot!)
> Hi Lyude,
> Sorry for late response. A bit busy on other stuff recently..
> 
> Really really thankful for all your help : ) I'm also glad to have the
> debugging tool if it won’t bother you too much. But before debugging,
> I need to have consensus with you about where do we expect to release
> resource allocated for a stream sink when it's reported as
> disconnected. Previous patch suggests releasing resource when connector is
> destroyed which will happen when topology refcount
> reaches zero (i.e. unplug mstb from topology). But when the case is
> receiving CSN notifying connection change, we don't try to destroy
> connector in this case now. And this is not caused by topology/malloc
> refcount leak since I don't expect neither one of them get
> decrease to zero under this case (topology of mstbs and ports is not
> changed). Hence, my plan was to also try to destroy connector under
> this case and the reason is reasonable to me as described in previous mail.
> With this patch set, I can see connectors eventually get
> successfully destroyed after userspace committing set_crtc() to free
> connectors (although also need a fix on the connector refcount
> grabbed by drm_client_modeset_probe() under specific scenario).
> 
> I think the main problem I encountered here is that I couldn't find a place
> that notify us to release resource allocated for a disconnected
> stream sink when receive CSN. If we decide not to destroy connector under
> this case, then I probably need some guidance about where
> to do the release work.
> 
> Thanks again Lyude!
> > 
> > On Tue, 2021-08-31 at 18:47 -0400, Lyude Paul wrote:
> > > (I am going to try responding to this tomorrow btw. I haven't been
> > > super busy this week, but this has been a surprisingly difficult email
> > > to respond to because I need to actually need to do a deep dive some
> > > of the MST helpers tomorrow to figure out more of the specifics on why
> > > I realized we couldn't just hot add/remove port->connector here).
> > > 
> > > On Wed, 2021-08-25 at 03:35 +0000, Lin, Wayne wrote:
> > > > [Public]
> > > > 
> > > > > -----Original Message-----
> > > > > From: Lyude Paul <lyude@redhat.com>
> > > > > Sent: Tuesday, August 24, 2021 5:18 AM
> > > > > To: Lin, Wayne <Wayne.Lin@amd.com>;
> > > > > dri-devel@lists.freedesktop.org
> > > > > Cc: Kazlauskas, Nicholas <Nicholas.Kazlauskas@amd.com>; Wentland,
> > > > > Harry <Harry.Wentland@amd.com>; Zuo, Jerry <Jerry.Zuo@amd.com>;
> > > > > Wu, Hersen <hersenxs.wu@amd.com>; Juston Li <juston.li@intel.com>;
> > > > > Imre Deak <imre.deak@intel.com>; Ville Syrjälä
> > > > > <ville.syrjala@linux.intel.com>; Daniel Vetter
> > > > > <daniel.vetter@ffwll.ch>; Sean Paul <sean@poorly.run>; Maarten
> > > > > Lankhorst <maarten.lankhorst@linux.intel.com>; Maxime Ripard
> > > > > <mripard@kernel.org>; Thomas Zimmermann <tzimmermann@suse.de>;
> > > > > David Airlie <airlied@linux.ie>; Daniel Vetter <daniel@ffwll.ch>;
> > > > > Deucher, Alexander <Alexander.Deucher@amd.com>; Siqueira, Rodrigo
> > > > > <Rodrigo.Siqueira@amd.com>; Pillai, Aurabindo
> > > > > <Aurabindo.Pillai@amd.com>; Bas Nieuwenhuizen
> > > > > <bas@basnieuwenhuizen.nl>; Cornij, Nikola <Nikola.Cornij@amd.com>;
> > > > > Jani Nikula <jani.nikula@intel.com>; Manasi Navare
> > > > > <manasi.d.navare@intel.com>; Ankit Nautiyal
> > > > > <ankit.k.nautiyal@intel.com>; José Roberto de Souza
> > > > > <jose.souza@intel.com>; Sean Paul <seanpaul@chromium.org>; Ben
> > > > > Skeggs <bskeggs@redhat.com>; stable@vger.kernel.org
> > > > > Subject: Re: [PATCH 2/4] drm/dp_mst: Only create connector for
> > > > > connected end device
> > > > > 
> > > > > [snip]
> > > > > 
> > > > > I think I might still be misunderstanding something, some comments
> > > > > below
> > > > > 
> > > > > On Mon, 2021-08-23 at 06:33 +0000, Lin, Wayne wrote:
> > > > > > > > Hi Lyude,
> > > > > > > > 
> > > > > > > > Really thankful for willing to explain in such details.
> > > > > > > > Really appreciate.
> > > > > > > > 
> > > > > > > > I'm trying to fix some problems that observed after these 2
> > > > > > > > patches
> > > > > > > > * 09b974e8983 drm/amd/amdgpu_dm/mst: Remove
> > > > > > > > ->destroy_connector() callback
> > > > > > > > * 72dc0f51591 drm/dp_mst: Remove
> > > > > > > > drm_dp_mst_topology_cbs.destroy_connector
> > > > > > > > 
> > > > > > > > With above patches, we now change to remove dc_sink when
> > > > > > > > connector is about to be destroyed. However, we found out
> > > > > > > > that connectors won't get destroyed after hotplugs. Thus,
> > > > > > > > after few times hotplugs, we won't create any new dc_sink
> > > > > > > > since number of sink is exceeding our limitation. As the
> > > > > > > > result of that, I'm trying to figure out why the refcount of
> > > > > > > > connectors won't get zero.
> > > > > > > > 
> > > > > > > > Based on my analysis, I found out that if we connect a sst
> > > > > > > > monitor to a mst hub then connect the hub to the system, and
> > > > > > > > then unplug the sst monitor from the hub. E.g.
> > > > > > > > src - mst hub - sst monitor => src - mst hub  (unplug) sst
> > > > > > > > monitor
> > > > > > > > 
> > > > > > > > Within this case, we won't try to put refcount of the sst
> > > > > > > > monitor.
> > > > > > > > Which is what I tried to resolve by [PATCH 3/4].
> > > > > > > > But here comes a problem which is confusing me that if I can
> > > > > > > > destroy connector in this case. By comparing to another
> > > > > > > > case, if now mst hub is connected with a mst monitor like
> > > > > > > > this:
> > > > > > > > src - mst hub - mst monitor => src - mst hub  (unplug) mst
> > > > > > > > monitor
> > > > > > > > 
> > > > > > > > We will put the topology refcount of mst monitor's branching
> > > > > > > > unit in and
> > > > > > > > drm_dp_port_set_pdt() and eventually call
> > > > > > > > drm_dp_delayed_destroy_port() to unregister the connector of
> > > > > > > > the logical port. So following the same rule, I think to
> > > > > > > > dynamically unregister a mst connector is what we want and
> > > > > > > > should be reasonable to also destroy sst connectors in my
> > > > > > > > case. But this conflicts the idea what we have here. We want
> > > > > > > > to create connectors for all output ports.
> > > > > > > > So if dynamically creating/destroying connectors is what we
> > > > > > > > want, when is the appropriate time for us to create one is
> > > > > > > > what I'm considering.
> > > > > > > > 
> > > > > > > > Take the StartTech hub DP 1to4 DP output ports for instance.
> > > > > > > > This hub, internally, is constructed by  3 1-to-2 mst branch
> > > > > > > > chips. 2 output ports of 1st chip are hardwired to another 2
> > > > > > > > chips. It's how it makes it to support 1-to-4 mst branching.
> > > > > > > > So within this case, the internal
> > > > > > > > 2 output ports of 1st chip is not connecting to a stream
> > > > > > > > sink and will never get connected to one.  Thus, I'm
> > > > > > > > thinking maybe the best timing to attach a connector to a
> > > > > > > > port is when the port is connected, and the connected PDT is
> > > > > > > > determined as a stream sink.
> > > > > > > > 
> > > > > > > > Sorry if I misunderstand anything here and really thanks for
> > > > > > > > your time to shed light on this : ) Thanks Lyude.
> > > > > > > 
> > > > > > > It's no problem, it is my job after all! Sorry for how long my
> > > > > > > responses have been taking, but my plate seems to be finally
> > > > > > > clearing up for the foreseeable future.
> > > > > > > 
> > > > > > > That being said - it sounds like with this we still aren't
> > > > > > > actually clear on where the topology refcount leak is
> > > > > > > happening - only when it's happening, which says to me that's
> > > > > > > the issue we really need to be figuring out the cause of as
> > > > > > > opposed to trying to workaround it.
> > > > > > > 
> > > > > > > Actually - refcount leaks is an issue I've ran into a number
> > > > > > > of times before in the past, so a while back I actually added
> > > > > > > some nice debugging features to assist with debugging leaks.
> > > > > > > If you enable the following options in your kernel config:
> > > > > > > 
> > > > > > > CONFIG_EXPERT=y # This must be set first before the next
> > > > > > > option CONFIG_DRM_DEBUG_DP_MST_TOPOLOGY_REFS=y
> > > > > > > 
> > > > > > > Unfortunately, I'm suddenly realizing after typing this that
> > > > > > > apparently I never bothered adding a way for us to debug the
> > > > 
> > > > > > > refcounts of ports/mstbs that haven't been released yet - only
> > > > > > > the ones for ones that have. This shouldn't be difficult at
> > > > > > > all for me to add, so I'll send you a patch either today or at
> > > > > > > the start of next week to try debugging with using this, and
> > > > > > > then we can figure out where this leak is really coming from.
> > > > > > 
> > > > > > Thanks Lyude!
> > > > > > 
> > > > > > Sorry to bother you, but I would like to clarify this again.  So
> > > > > > it sounds
> > > > > 
> > > > > It's no problem! It's my job and I'm happy to help :).
> > > > 
> > > > Thanks!
> > > > I would like to learn more from you as below : p
> > > > > 
> > > > > > like you also agree that we should destroy associated connector
> > > > > 
> > > > > Not quite. I think a better way of explaining this might be to
> > > > > point out that the lifetime of an MST port and its connector isn't
> > > > > supposed to be determined by whether or not it has something
> > > > > plugged into it - its lifetime is supposed to depend on whether
> > > > > there's a valid path from us down the MST topology to the port
> > > > > we're trying to reach. So an MSTB with ports that is unplugged
> > > > > would destroy all of its ports - but an unplugged port should just
> > > > > be the same as a disconnected DRM connector - even if the port
> > > > > itself is just hosting a branching device.
> > > > 
> > > > This is the part a bit difficult to me. I treat DRM connector as the
> > > > place where we associate with a stream sink. So if the statement is
> > > > "All DP mst output ports are places we connect with stream sink", I
> > > > would say false to this since I can find the negative example when
> > > > output port is connected with mst branch device. Thus, looks like we
> > > > could only determine whether to create a connector for an output
> > > > port when the peer device type is known?
> > > > > 
> > > > > Additionally - we don't want to try "delaying" connector creation
> > > > > either.
> > > > > In the modern world hotplugging is almost always reliable in
> > > > > normal situations, but even so there's still use cases for wanting
> > > > > force probing for analog devices on DP converters and just in
> > > > > general as it's a feature commonly used by developers or users
> > > > > working around monitors with problematic HPD issues or EDID issues.
> > > > 
> > > > I think I understand that why we want to create connectors for all
> > > > output ports here. But under these mentioned use cases, aren't we
> > > > still capable to force connector to enable stream? MST hub with
> > > > muti-functon capability, it will enumerate connected virtual DP peer
> > > > device.
> > > > For problematic HPD issues or EDID issues, their connection status
> > > > is also connected.
> > > > 
> > > > My understanding of output port is it is an internal node to help
> > > > construct an end-to-end virtual channel between a stream source
> > > > device and a stream sink device. Creating connectors for internal
> > > > nodes within a virtual channel is a bit hard for me to get the idea.
> > > > Please correct me if I misunderstand anything here. Thanks Lyude!
> > > > > 
> > > > > > when we unplug sst monitor from a mst hub in the case that I
> > > > > > described? In the case I described (unplug sst monitor), we only
> > > > > > receive CSN from the hub that notifying us the connection status
> > > > > > of one of its downstream output ports is changed to
> > > > > > disconnected. There is no topology refcount needed to be
> > > > > > decreased on this disconnected port but the malloc refcount.
> > > > > > Since the output port is still declared by
> > > > > 
> > > > > Apologies - I misunderstood your original mail as implying that
> > > > > topology refcounts were being leaked - but it sounds like it's
> > > > > actually malloc refcounts being leaked instead? In any case - that
> > > > > means we're still tracing down a leak, just a malloc ref leak.
> > > > > 
> > > > > But, this still doesn't totally make sense to me. Malloc refs only
> > > > > keep the actual drm_dp_mst_port/drm_dp_mst_branch struct alive in
> > > > > memory.
> > > > > Nothing else is kept around, meaning the DRM connector (and I
> > > > > assume by proxy, the dc_sink) should both be getting dropped still
> > > > > and the only thing that should be leaked is a memory allocation.
> > > > > These things should instead be dropped once there's no longer any
> > > > > topology references around. So, are we _sure_ that the problem
> > > > > here is a missing
> > > > > drm_dp_mst_port_put_malloc() or drm_dp_mst_mstb_put_malloc()?
> > > > 
> > > > Just my two cents, I don't think it's leak of malloc ref neither. As
> > > > you said, malloc ref is dealing with the last step to free port/mstb.
> > > > If there is still topology refcount on port/mstb in my case, we
> > > > won't free port/mstb.
> > > > > 
> > > > > If we are unfortunately we don't have equivalent tools for
> > > > > malloc() tracing. I'm totally fine with trying to add some if we
> > > > > have trouble figuring out this issue, but I'm a bit suspicious of
> > > > > the commits you mentioned that introduced this problem. If the
> > > > > problem doesn't happen until those two commits, then it's
> > > > > something in the code changes there that are causing this problem.
> > > > 
> > > > I think we probably also have the problem before these commits, but
> > > > we didn't notice this before. Just when we change to clean up all
> > > > things in dm_dp_mst_connector_destroy(), I start to try to figure
> > > > out all these things out.
> > > > > 
> > > > > The main thing I'm suspicious of just from looking at changes in
> > > > > 09b974e8983a4b163d4a406b46d50bf869da3073 is that the call to
> > > > > amdgpu_dm_update_freesync_caps() that was previously in
> > > > > dm_dp_destroy_mst_connector() appears to be dropped and not
> > > > > re-added in (oh dear, this is a /very/ confusingly similar
> > > > > function
> > > > 
> > > > Lol. I also have hard time on this..
> > > > > name!!!) dm_dp_mst_connector_destroy(). I don't remember if this
> > > > > was intentional on my part, but does adding a call back to
> > > > > amdgpu_dm_update_freesync_caps() into
> > > > > dm_dp_destroy_mst_connector() right before the
> > > > > dc_link_remove_remote_sink() call fix anything?
> > > > > 
> > > > > As well, I'm far less suspicious of this one but does re-adding
> > > > > this
> > > > > hunk:
> > > > > 
> > > > >       aconnector->dc_sink = NULL;
> > > > >       aconnector->dc_link->cur_link_settings.lane_count = 0;
> > > > > 
> > > > > After dc_sink_release() fix anything either?
> > > > 
> > > > So the main problem is we don't have chance to call
> > > > dc_link_remove_remote_sink() in the unplugging SST case. We only
> > > > have chance to remove the remote sink of a link when unplug a mstb.
> > > > > 
> > > > > > the mst hub,  I think we shouldn't destroy the port. Actually,
> > > > > > no ports nor mst branch devices should get destroyed in this
> > > > > > case I think.
> > > > > > The result of LINK_ADDRESS is still the same before/after
> > > > > > removing the sst monitor except the
> > > > > > DisplayPort_Device_Plug_Status/ Legacy_Device_Plug_Status.
> > > > > > 
> > > > > > Hence, if you agree that we should put refcount of the connector
> > > > > > of the disconnected port within the unplugging sst monitor case
> > > > > > to release the allocated resource, it means we don't want to
> > > > > > create connectors for those disconnected ports. Which conflicts
> > > > > > current flow to create connectors for all declared output ports.
> > > > > > 
> > > > > > Thanks again for your time Lyude!
> > > > > 
> > > > > --
> > > > > Cheers,
> > > > >  Lyude Paul (she/her)
> > > > >  Software Engineer at Red Hat
> > > > --
> > > > Regards,
> > > > Wayne
> > > > 
> > > 
> > 
> > --
> > Cheers,
> >  Lyude Paul (she/her)
> >  Software Engineer at Red Hat
> --
> Regards,
> Wayne Lin
> 

-- 
Cheers,
 Lyude Paul (she/her)
 Software Engineer at Red Hat


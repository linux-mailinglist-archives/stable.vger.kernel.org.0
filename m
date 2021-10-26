Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0375243BB01
	for <lists+stable@lfdr.de>; Tue, 26 Oct 2021 21:35:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239031AbhJZThm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Oct 2021 15:37:42 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:56644 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238911AbhJZThK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Oct 2021 15:37:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635276883;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=806TcNM+Hz99xDOcQJ5MWA6hID/DT3c1rcg2peQKnro=;
        b=Q4aRu0QuAoCAZ38/MouzFZQ7nwUpNMQob6kxhHF81P0g0TBhQELwNojHPO11BBVE/inFx9
        PBNzIKB8WntUzbdRyl4+Acy2oRk/T1uDKAdfN9N7k6NlipEi00VJQHuUYWHMM+NTc1/1S6
        Nlj0mpTx6UeQjZYsA0+3jOtPpisIHuI=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-414-ybdLdZzPOMuIE1Fy_TWJMQ-1; Tue, 26 Oct 2021 15:34:42 -0400
X-MC-Unique: ybdLdZzPOMuIE1Fy_TWJMQ-1
Received: by mail-qv1-f71.google.com with SMTP id if11-20020a0562141c4b00b0038317257571so254664qvb.3
        for <stable@vger.kernel.org>; Tue, 26 Oct 2021 12:34:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:organization:user-agent:mime-version
         :content-transfer-encoding;
        bh=806TcNM+Hz99xDOcQJ5MWA6hID/DT3c1rcg2peQKnro=;
        b=APGo1R78OtCCcbb/9NZB/uez1KPaqsjpTG2LlnsG2CL5avdD1Fa0yLY+kYu/oc/MCI
         AJbej0Mnho0NZyzDNaqRhWWajYqXq7LISVIS24Ka0kVHAz+uCwzO7lv6jhGBH/pidQ2S
         MDTFKKlVBW8AaAWPSz1xYZoXhL9dIIu3JN2Br8DM/gm6jBot1H79DHJG5z59OcQ9/IGW
         B7cFJvFFdtsy8jDsD+INUVYrMtlWgtyvWmPJXmiiYZLzJuocDqiho1eTkCsdoZbCt17e
         f/lBkEYCOqWO9WGqsVcLP8QxuPrect9nc24IjKp7VJbe2XpnZzk0rP3584ESOB1bEDgy
         wfVw==
X-Gm-Message-State: AOAM531dhaT9/5xnIQmSYaQtqi6j+sPLkaeE7xyt7Aqh7IrhPL+L1BAu
        qkUnu9ZFlVpVdQvqvUtfZvGZqGMJL9z9jrSzqcBum8ldUoMyIJOLPknWEZylwPwpfxYqRFSbhgz
        Mu9GkVttw7QL1Mu31
X-Received: by 2002:a05:620a:45a4:: with SMTP id bp36mr21040905qkb.51.1635276882241;
        Tue, 26 Oct 2021 12:34:42 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx6sLWpfnkveL351q3j2kLvOSssL78X0Wn3GwGlhWSCohfVnnoZrUow+2iI/zz7GgU9bYPI7Q==
X-Received: by 2002:a05:620a:45a4:: with SMTP id bp36mr21040863qkb.51.1635276881976;
        Tue, 26 Oct 2021 12:34:41 -0700 (PDT)
Received: from [192.168.8.138] (pool-96-230-249-157.bstnma.fios.verizon.net. [96.230.249.157])
        by smtp.gmail.com with ESMTPSA id bp9sm11692056qkb.94.2021.10.26.12.34.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Oct 2021 12:34:41 -0700 (PDT)
Message-ID: <d91dbbc0f686e11e97c985713c65c8a35e575590.camel@redhat.com>
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
Date:   Tue, 26 Oct 2021 15:34:39 -0400
In-Reply-To: <SJ0PR12MB55046A57E424305A608C17A1FC849@SJ0PR12MB5504.namprd12.prod.outlook.com>
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
         <5282ad02ecd3fde8ab78fe798f066a5c03153815.camel@redhat.com>
         <SJ0PR12MB55046A57E424305A608C17A1FC849@SJ0PR12MB5504.namprd12.prod.outlook.com>
Organization: Red Hat
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.4 (3.40.4-2.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Comments below

On Tue, 2021-10-26 at 03:50 +0000, Lin, Wayne wrote:
> [Public]
> 
> Hi Lyude!
> Apologize for replying late and really thanks for elaborating in such
> details!
> Following are some of my thoughts : )
> 
> > -----Original Message-----
> > From: Lyude Paul <lyude@redhat.com>
> > Sent: Saturday, September 18, 2021 1:48 AM
> > To: Lin, Wayne <Wayne.Lin@amd.com>; dri-devel@lists.freedesktop.org
> > Cc: Kazlauskas, Nicholas <Nicholas.Kazlauskas@amd.com>; Wentland, Harry
> > <Harry.Wentland@amd.com>; Zuo, Jerry
> > <Jerry.Zuo@amd.com>; Wu, Hersen <hersenxs.wu@amd.com>; Juston Li
> > <juston.li@intel.com>; Imre Deak <imre.deak@intel.com>; Ville
> > Syrjälä <ville.syrjala@linux.intel.com>; Daniel Vetter
> > <daniel.vetter@ffwll.ch>; Sean Paul <sean@poorly.run>; Maarten Lankhorst
> > <maarten.lankhorst@linux.intel.com>; Maxime Ripard <mripard@kernel.org>;
> > Thomas Zimmermann <tzimmermann@suse.de>; David Airlie
> > <airlied@linux.ie>; Daniel Vetter <daniel@ffwll.ch>; Deucher, Alexander
> > <Alexander.Deucher@amd.com>; Siqueira, Rodrigo
> > <Rodrigo.Siqueira@amd.com>; Pillai, Aurabindo <Aurabindo.Pillai@amd.com>;
> > Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>; Cornij,
> > Nikola <Nikola.Cornij@amd.com>; Jani Nikula <jani.nikula@intel.com>;
> > Manasi Navare <manasi.d.navare@intel.com>; Ankit Nautiyal
> > <ankit.k.nautiyal@intel.com>; José Roberto de Souza
> > <jose.souza@intel.com>; Sean Paul <seanpaul@chromium.org>; Ben Skeggs
> > <bskeggs@redhat.com>; stable@vger.kernel.org
> > Subject: Re: [PATCH 2/4] drm/dp_mst: Only create connector for connected
> > end device
> > 
> > Sorry about the slow response, this week XDC has been going on and I've
> > been mostly paying attention to that.
> > 
> > On Tue, 2021-09-14 at 08:46 +0000, Lin, Wayne wrote:
> > > [Public]
> > > 
> > > > -----Original Message-----
> > > > From: Lyude Paul <lyude@redhat.com>
> > > > Sent: Thursday, September 2, 2021 6:00 AM
> > > > To: Lin, Wayne <Wayne.Lin@amd.com>; dri-devel@lists.freedesktop.org
> > > > Cc: Kazlauskas, Nicholas <Nicholas.Kazlauskas@amd.com>; Wentland,
> > > > Harry <Harry.Wentland@amd.com>; Zuo, Jerry <Jerry.Zuo@amd.com>; Wu,
> > > > Hersen <hersenxs.wu@amd.com>; Juston Li <juston.li@intel.com>; Imre
> > > > Deak <imre.deak@intel.com>; Ville Syrjälä
> > > > <ville.syrjala@linux.intel.com>; Daniel Vetter
> > > > <daniel.vetter@ffwll.ch>; Sean Paul <sean@poorly.run>; Maarten
> > > > Lankhorst <maarten.lankhorst@linux.intel.com>; Maxime Ripard
> > > > <mripard@kernel.org>; Thomas Zimmermann <tzimmermann@suse.de>; David
> > > > Airlie <airlied@linux.ie>; Daniel Vetter <daniel@ffwll.ch>; Deucher,
> > > > Alexander <Alexander.Deucher@amd.com>; Siqueira, Rodrigo
> > > > <Rodrigo.Siqueira@amd.com>; Pillai, Aurabindo
> > > > <Aurabindo.Pillai@amd.com>; Bas Nieuwenhuizen
> > > > <bas@basnieuwenhuizen.nl>; Cornij, Nikola <Nikola.Cornij@amd.com>;
> > > > Jani Nikula <jani.nikula@intel.com>; Manasi Navare
> > > > <manasi.d.navare@intel.com>; Ankit Nautiyal
> > > > <ankit.k.nautiyal@intel.com>; José Roberto de Souza
> > > > <jose.souza@intel.com>; Sean Paul <seanpaul@chromium.org>; Ben
> > > > Skeggs <bskeggs@redhat.com>; stable@vger.kernel.org
> > > > Subject: Re: [PATCH 2/4] drm/dp_mst: Only create connector for
> > > > connected end device
> > > > 
> > > > Actually - did some more thinking, and I think we shouldn't try to
> > > > make changes like this until we actually know what the problem is
> > > > here. I could try to figure out what the actual race conditions I
> > > > was facing before with trying to add/destroy connectors based on
> > > > PDT, but we still don't even actually have a clear idea of what's
> > > > broken here.
> > > > I'd much rather us figure out exactly how this leak is happening
> > > > before considering making changes like this, because we have no way
> > > > of knowing if we've properly fixed it or not if we don't know what
> > > > the problem is in the first place.
> > > > 
> > > > I'm still happy to write up the topology debugging stuff I mentioned
> > > > to you if you think that would help you debug this issue - since
> > > > that would make it a lot easier for you to track down what
> > > > references are keeping a connector alive (and additkionally, where
> > > > those references were taken in code. thanks
> > > > stack_depot!)
> > > Hi Lyude,
> > > Sorry for late response. A bit busy on other stuff recently..
> > > 
> > > Really really thankful for all your help : ) I'm also glad to have the
> > > debugging tool if it won’t bother you too much. But before debugging,
> > 
> > no problem! I will get to it early next week then
> > 
> > > I need to have consensus with you about where do we expect to release
> > > resource allocated for a stream sink when it's reported as
> > > disconnected. Previous patch suggests releasing resource when
> > > connector is destroyed which will happen when topology refcount
> > > reaches zero (i.e. unplug mstb from topology). But when the case is
> > > receiving CSN notifying connection change, we don't try to destroy
> > > connector in this case now. And this is not caused by topology/malloc
> > > refcount leak since I don't expect neither one of them get decrease to
> > > zero under this case (topology of mstbs and ports is not changed).
> > > Hence, my plan was to also try to destroy connector under
> > 
> > Ah - I wonder if this might have been where some of the confusion here
> > came from. So-both mstbs and ports (assume I'm talking the actual
> > drm_dp_mst_port and drm_dp_mst_branch structs here) are supposed to have
> > non-zero topology refcounts as long as there is a valid path
> > between the port or mstb, and our source. This also means that for ports,
> > the drm_connector associated with these ports should stay
> > around as long as the port is reachable from the sink
> > - regardless of whether anything is actually plugged into the port or not.
> 
> This concept is the place where a bit hard for me to get through.
> I was thinking that we don’t have to associate a drm connector with a MST
> port whenever the port exists, since MST port is not always connected
> to a stream sink. I treat MST port as an intermediate node of a virtual
> channel, which is an end-to-end direct virtual connection between a
> stream source and a stream sink. Virtual channel could be constructed by
> multiple link count and stream sink is connected at end port. Hence,

Just to clarify I'm understanding you correctly, when you say multiple link
count do you just mean VCPI slots or do you mean two separate DP links? I
haven't dealt with the former, but IIRC that is how certain high resolutions
displays are handled over TB correct?

Regardless though, I would think that we could just handle this mostly from
the atomic state even with a connector for every port. For instance, i915
already has something called "big joiner" for supporting display
configurations where one display can take up two separate display pipes
(CRTCs). We could likely do something similar but with connectors if we end up
having to deal with a display driven by two DP links.

> I was thinking to associate a drm connector for end stream sink only.
> I think we probably won't want to attach a connector to a
> relay/retimer/redriver within a stream path? I treat MST port as the similar
> role when
> It's fixed to connect to a MST branch device.

If it's a fixed connection, this might actually be OK to avoid attaching
connectors on. Currently with input ports where we know we can never receive a
CSN for them during runtime, we're able to avoid creating a connector because
no potential for CSN during runtime means the only possible time an input port
could transition would be suspend/resume. So if we detect we're on another
topology where something that was previously an output port that is an input
port on the new topology, we get rid of the connector by removing the
drm_dp_mst_port it's associated with from the topology and replace it with a
new one. This works pretty well, as it avoids doing any actual connector
destruction from the suspend/resume codepath and ensures that any pointer
references to the now non-existent output port remain valid for as long as
needed. So I might actually be open to expanding this for fixed connections
like relays, retimers and redrivers if we handle things in a similar manner.
For anything that can receive a CSN though, a drm_connector is unconditionally
needed even if nothing's connected.

> 
> I think it's a bit different to SST case. For legacy DP (before DP 1.2), we
> can attach a connector to its physical end output port since it's dedicated
> for a stream sink. But MST port is not. However, I understand if there is
> any implementation requirement for us to associate drm connector
> for all MST ports.
> 
> > 
> > So - a CSN on it's own shouldn't really get rid of the port it was
> > notifying us about. But if that CSN results in an MSTB -with- its own
> > ports
> > being removed, this would mean there would no longer be a valid path
> > between our source and the ports on said MSTB and as such - the
> > connector for each one of those ports is removed from the topology.
> > Remember however, when I say "removed from the topology" what
> > I'm referring to is the fact that the MST helpers have dropped the main
> > topology reference for a given mstb or port.
> > Since various MST helpers retrieve temporary topology references to
> > connectors they work on in order to simplify handling I/O errors, the
> > operations from those helpers would potentially keep the port or mstb
> > around in the topology until those helpers have had a chance to
> > abort and drop their refs. And then once all the topology references are
> > released, a destruction worker gets scheduled which handles
> > unregistering the drm_connector (not destroying it).
> > The drm_connector stays around unregistered, up until the point at which
> > all malloc references to the drm_dp_mst_port have been
> > released.
> > 
> > I think it may also be worth clarifying the lifetime of drm_connector
> > itself here as well, since that also actually has a refcount. Basically,
> > as
> > long as userspace has a mode committed which references a drm_connector -
> > that drm_connector will still exist in memory, and its mode
> > object ID will remain valid. This means if we were to have a MST topology
> > hooked up with one display turned on and then suddenly
> > unplugged it, keeping in mind that the port with said display now becomes
> > inaccessible from the topology, the drm_connector associated
> > with that display would continue to have a valid mode object ID up until
> > the point at which userspace has committed a new mode which
> > disables it.
> > The sysfs paths for the connector however, will disappear immediately once
> > the connector is unregistered so as to ensure that userspace
> > applications cannot try to reuse it later or attempt to reprobe it.
> > 
> > Any resource releases beyond this (streams on the driver side, for
> > instance) are up to the driver, but typically I would expect them to
> > happen
> > in the same places as they would with an SST connector. Does that answer
> > your question?
> 
> Unplug event of SST sink and MST remote sink is a bit different. SST unplug
> event relies on long HPD IRQ but MST CSN relies on short HPD IRQ.
> Now we use MST helper function drm_dp_mst_handle_conn_stat() to deal with
> CSN short HPD IRQ. But within this function, driver won't
> get notification of disconnection event to release associated allocated
> resource. So, by not changing the drm connector association logic
> here, should we add a new call back function here?
> 
> Sorry Lyude, I don't understand as well as you on this and would like to
> learn more from you. Please correct me if I misunderstand anything
> here. Much appreciate!

It's no problem at all! I'm always glad to help :). This still sounds a lot
like a bug to me in amdgpu, because we actually do send a hotplug event here.
Basically, the only function that calls this; drm_dp_mst_process_up_req(),
will assume it needs to request a hotplug if we ever call
drm_dp_mst_handle_conn_stat(). From there we pass this information up to
drm_dp_mst_up_req_work(). Then once we've finished handling all pending up
requests, we send a single hotplug to indicate to userspace it needs to
reprobe everything.

Also, I'm still working on the debugging stuff btw!

-- 
Cheers,
 Lyude Paul (she/her)
 Software Engineer at Red Hat


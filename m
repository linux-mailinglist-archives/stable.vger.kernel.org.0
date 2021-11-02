Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39BC0443879
	for <lists+stable@lfdr.de>; Tue,  2 Nov 2021 23:31:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229736AbhKBWe3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Nov 2021 18:34:29 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:36553 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229685AbhKBWe3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Nov 2021 18:34:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635892313;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=s7LptIgu+syWserQTVVGwm5xGU03s5Ksw96xU5k2+b0=;
        b=CsBIGMpp198JmXtnLNTNsG2OnnUizzxONN7lb6UX0/7PEsXArmHvIzShxpsVSAkjkMzFIx
        Bal422pmoC+Yg8r2+AAFGdXdVOJXI+6KQD5JcczTjy95uNWx23tdTWfO2X+HR3WYa53YpG
        n3IMwClEYnviXZ9XBBw7ZoYv1SAqCZQ=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-569-otMI0ScHO-2SIb8q10TwDg-1; Tue, 02 Nov 2021 18:31:52 -0400
X-MC-Unique: otMI0ScHO-2SIb8q10TwDg-1
Received: by mail-qv1-f70.google.com with SMTP id hf12-20020a0562140e8c00b00382cdfe644eso426238qvb.23
        for <stable@vger.kernel.org>; Tue, 02 Nov 2021 15:31:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:organization:user-agent:mime-version
         :content-transfer-encoding;
        bh=s7LptIgu+syWserQTVVGwm5xGU03s5Ksw96xU5k2+b0=;
        b=1I9Ui/E4CCPzD8R2bvWf9I+qE72dZPU7lb6WEwRsCkTMkTvmA7rvm/FqdRH1q5fxzq
         vQMz15YADR1s1Tc0xlt7xb1Dw9bC16jWM6lRKvzMWFTL15SgKZ/9Sz+8HecLSaEmbW8I
         KFJYHedVjCoin7jTGwyLvTz1/4wxsyaFwvCFwCFNqY1Rk/br8B2qWzJw8Lqg6DRwnWBB
         KcL1eUuT7uQqjmFrwKrciDqpWqfCQAT6zWuzh5dL0ov/mpRmzFySZ6Qa1NG6wxEr13Ba
         Byn0vRUVJx6sQpSUz/Qwt8hR/otyofO4QAtKeenhW25jZOL/U6bJuMrRGV4N3rszwzDT
         yNlg==
X-Gm-Message-State: AOAM532ptm5slG/pdroqZeoT3LmyjSvt493+/XmpXi3tO1VLgeEMhGls
        xe9GyBzjC0OJQ58FV0w/QkRafgjVz2Lt1JW92T3Qyr3KOpg6mc8FBTdCtJQX5qquD5wVSos6jC6
        AblGu78U4KA4tPP6y
X-Received: by 2002:a05:620a:25c8:: with SMTP id y8mr31292608qko.42.1635892311475;
        Tue, 02 Nov 2021 15:31:51 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz4Mn2/N4/VkaTugW1IbEV+gcQbmtzqiNbmi541UL6/BSzvvYeXqRyvJXZucZIrbqNTBihSRA==
X-Received: by 2002:a05:620a:25c8:: with SMTP id y8mr31292576qko.42.1635892311148;
        Tue, 02 Nov 2021 15:31:51 -0700 (PDT)
Received: from [192.168.8.138] (pool-96-230-249-157.bstnma.fios.verizon.net. [96.230.249.157])
        by smtp.gmail.com with ESMTPSA id n18sm244365qtk.91.2021.11.02.15.31.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Nov 2021 15:31:50 -0700 (PDT)
Message-ID: <0badd704d7014481cc87a42e58c96a84205f1ca3.camel@redhat.com>
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
Date:   Tue, 02 Nov 2021 18:31:48 -0400
In-Reply-To: <CO6PR12MB548935F6AE8DA89C965A2A58FC879@CO6PR12MB5489.namprd12.prod.outlook.com>
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
         <d91dbbc0f686e11e97c985713c65c8a35e575590.camel@redhat.com>
         <CO6PR12MB548935F6AE8DA89C965A2A58FC879@CO6PR12MB5489.namprd12.prod.outlook.com>
Organization: Red Hat
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.4 (3.40.4-2.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 2021-10-29 at 12:11 +0000, Lin, Wayne wrote:
> [Public]
> 
> Thanks Lyude for patiently guiding on this : )
> Would like to learn more as following

I do follow your bit about connectors only being created when a virtual path
is instantiated, but that still doesn't follow how connectors in DRM typically
behave though as this idea still comes down to "we don't have disconnected
connectors, only connected ones". Which still breaks force probing (if the
connector doesn't exist in userspace because we destroyed it, how do we get to
it's force sysfs file?), and also just makes hides information from userspace
that it might actually care about (what if for instance, a GUI wanted to display
the topology layout of an MST hub -including- all of the currently disconnected
ports on it? Considering we allow this for things like USB, it doesn't make
sense to hide them for MST.

As well, while your idea for what an MST connector is honestly does make a lot
more sense then what we have, that's not really the issue here. The problem is
that connector creation/destruction is already quite racy, and requires a _lot_
of care to get right. We've already had tons of bugs in the past that lead to us
resorting to all of the tricks we're currently using, for instance:
Which just seems to add a lot of
complication to the current MST code, without much reason here besides trying
to reduce the amount of connectors along with a potential bug with leaking
connectors that we still don't know the cause of. Trying to solve problems
without understanding exactly what's causing them 
something around a bug that could be entirely unrelated to how we create
connectors, because then it's not even really guaranteed we've fixed anything
if we don't know what caused the problem in the first place. Working around
problems might temporarily fix the ones we're dealing with right now, but
without understanding what's causing it there's no guarantee it won't just pop
up again in the future or that we won't introduce new problems in the process.

> 
> > 
> > Regardless though, I would think that we could just handle this mostly
> > from the atomic state even with a connector for every port. For
> > instance, i915 already has something called "big joiner" for supporting
> > display configurations where one display can take up two
> > separate display pipes (CRTCs). We could likely do something similar but
> > with connectors if we end up having to deal with a display
> > driven by two DP links.
> > 
> > > I was thinking to associate a drm connector for end stream sink only.
> > > I think we probably won't want to attach a connector to a
> > > relay/retimer/redriver within a stream path? I treat MST port as the
> > > similar role when It's fixed to connect to a MST branch device.
> > 
> > If it's a fixed connection, this might actually be OK to avoid attaching
> > connectors on. Currently with input ports where we know we can
> > never receive a CSN for them during runtime, we're able to avoid creating
> > a connector because no potential for CSN during runtime
> > means the only possible time an input port could transition would be
> > suspend/resume. So if we detect we're on another topology
> > where something that was previously an output port that is an input port
> > on the new topology, we get rid of the connector by
> > removing the drm_dp_mst_port it's associated with from the topology and
> > replace it with a new one. This works pretty well, as it
> > avoids doing any actual connector destruction from the suspend/resume
> > codepath and ensures that any pointer references to the
> > now non-existent output port remain valid for as long as needed. So I
> > might actually be open to expanding this for fixed connections
> > like relays, retimers and redrivers if we handle things in a similar
> > manner.
> > For anything that can receive a CSN though, a drm_connector is
> > unconditionally needed even if nothing's connected.
> 
> Want to deepen my knowledge here. Sorry Lyude could you explain more on this
> please?
> Are you saying that if we change to associate drm connector as what I
> proposed in this patch, we will create actual connector destruction
> from the suspend/resume codepath and which is a problem here? I thought once
> the connection status changed from connected to
> disconnected during suspend/resume, we still use the same way as what we did
> in drm_dp_delayed_destroy_port():
> i.e.
> if (port->connector) {
>         drm_connector_unregister(port->connector);
>         drm_connector_put(port->connector);
> }
> We won't directly destruct the drm connector?

Something like that, I'd need to to go look further into the details because I
very vividly remember most of the tricks we do in the MST helpers regarding
delayed connector destruction and when/how we change various members of the
drm_dp_mst_port/drm_dp_mst_branch structures. I vaguely remember the problem
with trying to hot add/remove connectors (I -did- actually try to do this once
I believe! but not as thoroughly as you have) being some kind of lockdep
issue. I started trying to dig into the MST code a bit deeper to get a clear
answer on this, but I actually decided to take that time and just finish up
the debug helpers I mentioned (I'll send the WIP patch I've got to you in a
moment, and will send it off the mailing list once I finish hooking things up
in i915) because it really just doesn't seem to me like we actually have a
clear understanding of how this issue is being caused - and it's not a good
idea for us to make any kind of API change like this to attempt (and
inevitably fail or break something else) to fix an issue we don't fully
understand.

[snip...]

> > 
> Right! I might not recall correctly, but I think that's why I want this
> patch. I probably encountered that userspace doesn’t explicitly
> try to react to this unplug event. Instead, it tries to react when we plug
> in monitor next time. And the problem is when we plug in
> monitor next time, stale resources are not released yet. It then hits the
> limitation within our HW. Which let me want to explicitly
> release resource once driver detect the unplug event (just like sst long HPD
> event I think).  By the way, just out of curiosity, when
> do you think is the timing to release sink related resource if we rely on
> hotplug event notifying userspace? When userspace frees the
> associated pipe of the connector? Won't it be a transient state that
> userspace just free the pipe temporarily?

The timing of releasing resources should be done at the same time that we
disable the connector. In general, MST modesetting shouldn't be much different
from anything else - except for having to maintain a payload table and
bandwidth limitations across a shared connection. So pretty much everything
related to enabling or disabling streams should be in the atomic commit phase
(with any bandwidth calculations done beforehand, WIP...). I'm going to say,
let's figure out where this is happening first. I've got the debugging patches
for this ready and will send them to you now.

> 
> > Also, I'm still working on the debugging stuff btw!
> Much appreciate Lyude! Thanks!
> 
> > 
> > --
> > Cheers,
> >  Lyude Paul (she/her)
> >  Software Engineer at Red Hat
> --
> Regards,
> Wayne Lin

-- 
Cheers, Lyude Paul (she/her) Software Engineer at Red Hat

-- 
Cheers,
 Lyude Paul (she/her)
 Software Engineer at Red Hat


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B148E40B590
	for <lists+stable@lfdr.de>; Tue, 14 Sep 2021 19:04:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229612AbhINRGF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Sep 2021 13:06:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:53690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231254AbhINREO (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Sep 2021 13:04:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5CF3060698;
        Tue, 14 Sep 2021 17:02:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631638976;
        bh=2mSZTdP0BNLmKplJq/9Fcdy5a8GoOixboIbKNaUupKA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=N94KAi0pH6opX5OjRabtQ5FPknCEwz42rNNl8c95huyvFzPQK+rYpNK5okCNjvgUZ
         c/0KU5OHUk6gM4ZGpa1JV2e8tO+YRm6gJjKC5fryaq1Hipj4UgX1587YB+tnns0gIB
         byiO4pORKbiH2pYJT3dujNBad2hJ3d43ynDkNdd7A2S6DbM73HSCSazJK/VKnVPnlj
         i0nhfkULlDR6FscEY0esgjRZ6fX3EoUWJz5/z91vsGAjfaAGnD7EJJ/pmrPIbCIV5w
         wuVPfvby+7qcQmwSybVxcwx4OY25j5hO2XE4fKhdIiQjeDWhIygQlvdHk8gQJdQuMr
         AXdHW7YGr1a1g==
Date:   Tue, 14 Sep 2021 13:02:55 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Doug Anderson <dianders@chromium.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "# 4.0+" <stable@vger.kernel.org>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>
Subject: Re: [PATCH 5.14 147/334] drm/bridge: ti-sn65dsi86: Dont read EDID
 blob over DDC
Message-ID: <YUDVv8ZuJvekbeN2@sashalap>
References: <20210913131113.390368911@linuxfoundation.org>
 <20210913131118.330293390@linuxfoundation.org>
 <CAD=FV=UhovUSmvbpc3q9=J_NSU0mcvQ3Fv8r4hi1ZNO=cMteuA@mail.gmail.com>
 <YT93qkd8B7jy6AzV@kroah.com>
 <CAD=FV=WPkVGTUmx2+Egt+ryO02n4cNGjN3S8gkBJP-WW3jPLWw@mail.gmail.com>
 <YUDNXAVHfsrM7sR6@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <YUDNXAVHfsrM7sR6@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 14, 2021 at 06:27:08PM +0200, Greg Kroah-Hartman wrote:
>On Mon, Sep 13, 2021 at 09:31:03AM -0700, Doug Anderson wrote:
>> Hi,
>>
>> On Mon, Sep 13, 2021 at 9:09 AM Greg Kroah-Hartman
>> <gregkh@linuxfoundation.org> wrote:
>> >
>> > On Mon, Sep 13, 2021 at 06:57:20AM -0700, Doug Anderson wrote:
>> > > Hi,
>> > >
>> > > On Mon, Sep 13, 2021 at 6:51 AM Greg Kroah-Hartman
>> > > <gregkh@linuxfoundation.org> wrote:
>> > > >
>> > > > From: Douglas Anderson <dianders@chromium.org>
>> > > >
>> > > > [ Upstream commit a70e558c151043ce46a5e5999f4310e0b3551f57 ]
>> > > >
>> > > > This is really just a revert of commit 58074b08c04a ("drm/bridge:
>> > > > ti-sn65dsi86: Read EDID blob over DDC"), resolving conflicts.
>> > > >
>> > > > The old code failed to read the EDID properly in a very important
>> > > > case: before the bridge's pre_enable() was called. The way things need
>> > > > to work:
>> > > > 1. Read the EDID.
>> > > > 2. Based on the EDID, decide on video settings and pixel clock.
>> > > > 3. Enable the bridge w/ the desired settings.
>> > > >
>> > > > The way things were working:
>> > > > 1. Try to read the EDID but fail; fall back to hardcoded values.
>> > > > 2. Based on hardcoded values, decide on video settings and pixel clock.
>> > > > 3. Enable the bridge w/ the desired settings.
>> > > > 4. Try again to read the EDID, it works now!
>> > > > 5. Realize that the hardcoded settings weren't quite right.
>> > > > 6. Disable / reenable the bridge w/ the right settings.
>> > > >
>> > > > The reasons for the failures were twofold:
>> > > > a) Since we never ran the bridge chip's pre-enable then we never set
>> > > >    the bit to ignore HPD. This meant the bridge chip didn't even _try_
>> > > >    to go out on the bus and communicate with the panel.
>> > > > b) Even if we fixed things to ignore HPD, the EDID still wouldn't read
>> > > >    if the panel wasn't on.
>> > > >
>> > > > Instead of reverting the code, we could fix it to set the HPD bit and
>> > > > also power on the panel. However, it also works nicely to just let the
>> > > > panel code read the EDID. Now that we've split the driver up we can
>> > > > expose the DDC AUX channel bus to the panel node. The panel can take
>> > > > charge of reading the EDID.
>> > > >
>> > > > NOTE: in order for things to work, anyone that needs to read the EDID
>> > > > will need to instantiate their panel using the new DP AUX bus (AKA by
>> > > > listing their panel under the "aux-bus" node of the bridge chip in the
>> > > > device tree).
>> > > >
>> > > > In the future if we want to use the bridge chip to provide a full
>> > > > external DP port (which won't have a panel) then we will have to
>> > > > conditinally add EDID reading back in.
>> > > >
>> > > > Suggested-by: Andrzej Hajda <a.hajda@samsung.com>
>> > > > Signed-off-by: Douglas Anderson <dianders@chromium.org>
>> > > > Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
>> > > > Link: https://patchwork.freedesktop.org/patch/msgid/20210611101711.v10.9.I9330684c25f65bb318eff57f0616500f83eac3cc@changeid
>> > > > Signed-off-by: Sasha Levin <sashal@kernel.org>
>> > > > ---
>> > > >  drivers/gpu/drm/bridge/ti-sn65dsi86.c | 22 ----------------------
>> > > >  1 file changed, 22 deletions(-)
>> > >
>> > > I guess it's not a huge deal, but I did respond to Sasha and request
>> > > that this patch be dropped from the stable queue unless the whole big
>> > > pile of patches was being backported. See:
>> > >
>> > > https://lore.kernel.org/lkml/CAD=FV=U2dGjeEzp+K1vnLTj8oPJ-GKBTTKz2XQ1OZ7QF_sTHuw@mail.gmail.com/
>> > >
>> > > I said:
>> > >
>> > > > I would suggest against backporting this one unless you're going to
>> > > > backport the whole pile of DP AUX bus patches, which probably doesn't
>> > > > make sense for stable. Even though the old EDID reading was broken for
>> > > > the first read, it still worked for later reads. ...and the first read
>> > > . didn't crash or anything--it just timed out.
>> >
>> > I see a "bunch" of patches for this driver in this -rc, did Sasha not
>> > get them all?  If not, I can drop this one, but maybe it was needed for
>> > the follow-on patches?
>>
>> It's been a long journey trying to make this bridge work better. I
>> think the easiest way to say it is that if you don't have the parent
>> of ${SUBJECT} patch, AKA:
>>
>> e0bbcc6233f7 drm/bridge: ti-sn65dsi86: Add support for the DP AUX bus
>>
>> ...then you don't have DP AUX bus support and you shouldn't take
>> ${SUBJECT} patch. If you have that patch and it compiles / builds then
>> it means that you have all the proper dependencies. However, there are
>> _a lot_ of dependencies and I wouldn't suggest picking them all to
>> stable unless it's critical for someone.
>
>I tried to drop this one, and it turned out to be a depandancy for
>another patch for this driver.  And that was another dependancy.  So
>I've now dropped all of these from the queue.
>
>Here are the commits I dropped.  If you think any should be added back,
>please let us know:
>
>05a7f4a8dff1 ("devlink: Break parameter notification sequence to be before/after unload/load driver")
>e183bf31cf0d ("drm/bridge: ti-sn65dsi86: Add some 100 us delays")
>c7782443a889 ("drm/bridge: ti-sn65dsi86: Avoid creating multiple connectors")
>a70e558c1510 ("drm/bridge: ti-sn65dsi86: Don't read EDID blob over DDC")
>acb06210b096 ("drm/bridge: ti-sn65dsi86: Fix power off sequence")
>4c1b3d94bf63 ("drm/bridge: ti-sn65dsi86: Improve probe errors with dev_err_probe()")
>4e5763f03e10 ("drm/bridge: ti-sn65dsi86: Wrap panel with panel-bridge")

Thanks! And yes, I dropped the patch based on the request but it snuck
in as a dependency for a few patches with a Fixes tag.

-- 
Thanks,
Sasha

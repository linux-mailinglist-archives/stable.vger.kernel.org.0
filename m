Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9836740986A
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 18:09:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245040AbhIMQKd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 12:10:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:44282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235546AbhIMQKc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 12:10:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4AE25604D1;
        Mon, 13 Sep 2021 16:09:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631549356;
        bh=MDC4CdstYZFwgRAmMGslyg8XtdsQPBHzlq8pVMP5A+A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KEf+n7YYrhGpogj+xis9XzGpEN6bMp+cNGv1jggMwXbWDtrh3g05mEJ0hpJsgowqE
         s/AL5gDPASImA+NLkmo8N7fDmuC5WC1YXJ/jR5FH57GmELzcyKm3rfQxJkF1B6kN08
         6ObO4eZawbVZocctMAJK5JFAQ8ho5xtDGZu8YumM=
Date:   Mon, 13 Sep 2021 18:09:14 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Doug Anderson <dianders@chromium.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        "# 4.0+" <stable@vger.kernel.org>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.14 147/334] drm/bridge: ti-sn65dsi86: Dont read EDID
 blob over DDC
Message-ID: <YT93qkd8B7jy6AzV@kroah.com>
References: <20210913131113.390368911@linuxfoundation.org>
 <20210913131118.330293390@linuxfoundation.org>
 <CAD=FV=UhovUSmvbpc3q9=J_NSU0mcvQ3Fv8r4hi1ZNO=cMteuA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAD=FV=UhovUSmvbpc3q9=J_NSU0mcvQ3Fv8r4hi1ZNO=cMteuA@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 13, 2021 at 06:57:20AM -0700, Doug Anderson wrote:
> Hi,
> 
> On Mon, Sep 13, 2021 at 6:51 AM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > From: Douglas Anderson <dianders@chromium.org>
> >
> > [ Upstream commit a70e558c151043ce46a5e5999f4310e0b3551f57 ]
> >
> > This is really just a revert of commit 58074b08c04a ("drm/bridge:
> > ti-sn65dsi86: Read EDID blob over DDC"), resolving conflicts.
> >
> > The old code failed to read the EDID properly in a very important
> > case: before the bridge's pre_enable() was called. The way things need
> > to work:
> > 1. Read the EDID.
> > 2. Based on the EDID, decide on video settings and pixel clock.
> > 3. Enable the bridge w/ the desired settings.
> >
> > The way things were working:
> > 1. Try to read the EDID but fail; fall back to hardcoded values.
> > 2. Based on hardcoded values, decide on video settings and pixel clock.
> > 3. Enable the bridge w/ the desired settings.
> > 4. Try again to read the EDID, it works now!
> > 5. Realize that the hardcoded settings weren't quite right.
> > 6. Disable / reenable the bridge w/ the right settings.
> >
> > The reasons for the failures were twofold:
> > a) Since we never ran the bridge chip's pre-enable then we never set
> >    the bit to ignore HPD. This meant the bridge chip didn't even _try_
> >    to go out on the bus and communicate with the panel.
> > b) Even if we fixed things to ignore HPD, the EDID still wouldn't read
> >    if the panel wasn't on.
> >
> > Instead of reverting the code, we could fix it to set the HPD bit and
> > also power on the panel. However, it also works nicely to just let the
> > panel code read the EDID. Now that we've split the driver up we can
> > expose the DDC AUX channel bus to the panel node. The panel can take
> > charge of reading the EDID.
> >
> > NOTE: in order for things to work, anyone that needs to read the EDID
> > will need to instantiate their panel using the new DP AUX bus (AKA by
> > listing their panel under the "aux-bus" node of the bridge chip in the
> > device tree).
> >
> > In the future if we want to use the bridge chip to provide a full
> > external DP port (which won't have a panel) then we will have to
> > conditinally add EDID reading back in.
> >
> > Suggested-by: Andrzej Hajda <a.hajda@samsung.com>
> > Signed-off-by: Douglas Anderson <dianders@chromium.org>
> > Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
> > Link: https://patchwork.freedesktop.org/patch/msgid/20210611101711.v10.9.I9330684c25f65bb318eff57f0616500f83eac3cc@changeid
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > ---
> >  drivers/gpu/drm/bridge/ti-sn65dsi86.c | 22 ----------------------
> >  1 file changed, 22 deletions(-)
> 
> I guess it's not a huge deal, but I did respond to Sasha and request
> that this patch be dropped from the stable queue unless the whole big
> pile of patches was being backported. See:
> 
> https://lore.kernel.org/lkml/CAD=FV=U2dGjeEzp+K1vnLTj8oPJ-GKBTTKz2XQ1OZ7QF_sTHuw@mail.gmail.com/
> 
> I said:
> 
> > I would suggest against backporting this one unless you're going to
> > backport the whole pile of DP AUX bus patches, which probably doesn't
> > make sense for stable. Even though the old EDID reading was broken for
> > the first read, it still worked for later reads. ...and the first read
> . didn't crash or anything--it just timed out.

I see a "bunch" of patches for this driver in this -rc, did Sasha not
get them all?  If not, I can drop this one, but maybe it was needed for
the follow-on patches?

thanks,

greg k-h

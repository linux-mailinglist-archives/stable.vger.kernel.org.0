Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACFCB3474FD
	for <lists+stable@lfdr.de>; Wed, 24 Mar 2021 10:48:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232353AbhCXJsI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Mar 2021 05:48:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232500AbhCXJrl (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Mar 2021 05:47:41 -0400
Received: from perceval.ideasonboard.com (perceval.ideasonboard.com [IPv6:2001:4b98:dc2:55:216:3eff:fef7:d647])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D762C061763;
        Wed, 24 Mar 2021 02:47:41 -0700 (PDT)
Received: from pendragon.ideasonboard.com (62-78-145-57.bb.dnainternet.fi [62.78.145.57])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 93237580;
        Wed, 24 Mar 2021 10:47:39 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1616579259;
        bh=wLh0dNKS1ILGqvP0VCIsZ7hKHEUOMfmlKCOjleuCMJA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=wI7Y8X7TfRF1ZoB2T+gB0A5vcHHx3ExQ3OdhFn4VonJLepPeDGTMYp3MQkh12V/fR
         TZHCrSe41+85nN7Aro28V9201ZVRw5E/M+M1doPI5IkjIvPnOLilpcHAgcQzEJOOgi
         GKMyKE6oIaZMY88TwlJKZjIYk9YgaxXCYMJtW9r4=
Date:   Wed, 24 Mar 2021 11:46:57 +0200
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     Daniel Vetter <daniel@ffwll.ch>
Cc:     Paul Cercueil <paul@crapouillou.net>,
        Jernej Skrabec <jernej.skrabec@siol.net>,
        Neil Armstrong <narmstrong@baylibre.com>,
        David Airlie <airlied@linux.ie>,
        Jonas Karlman <jonas@kwiboo.se>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Andrzej Hajda <a.hajda@samsung.com>, od@zcrc.me,
        stable <stable@vger.kernel.org>, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH v2 1/3] drm: bridge/panel: Cleanup connector on bridge
 detach
Message-ID: <YFsKkf7ioL57TiAl@pendragon.ideasonboard.com>
References: <20210120123535.40226-1-paul@crapouillou.net>
 <20210120123535.40226-2-paul@crapouillou.net>
 <CAKMK7uGGDe8bZpeTnyCkF7g_2gC1nixOzWe4FWYXPRWi-q5y7A@mail.gmail.com>
 <4YQ8NQ.HNQ7IMBKVEBV2@crapouillou.net>
 <CAKMK7uFHYPvJm46f-LXBO=nERGBBO3i_=YXZyAUi0ZXJFLmXVw@mail.gmail.com>
 <YFqgyTNt42vBe+w+@pendragon.ideasonboard.com>
 <YFsI6OA+jmyiPyv6@phenom.ffwll.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YFsI6OA+jmyiPyv6@phenom.ffwll.local>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 24, 2021 at 10:39:52AM +0100, Daniel Vetter wrote:
> On Wed, Mar 24, 2021 at 04:15:37AM +0200, Laurent Pinchart wrote:
> > On Wed, Jan 20, 2021 at 06:38:03PM +0100, Daniel Vetter wrote:
> > > On Wed, Jan 20, 2021 at 6:12 PM Paul Cercueil wrote:
> > > > Le mer. 20 janv. 2021 à 17:03, Daniel Vetter a écrit :
> > > > > On Wed, Jan 20, 2021 at 1:35 PM Paul Cercueil wrote:
> > > > >>
> > > > >>  If we don't call drm_connector_cleanup() manually in
> > > > >>  panel_bridge_detach(), the connector will be cleaned up with the other
> > > > >>  DRM objects in the call to drm_mode_config_cleanup(). However, since our
> > > > >>  drm_connector is devm-allocated, by the time drm_mode_config_cleanup()
> > > > >>  will be called, our connector will be long gone. Therefore, the
> > > > >>  connector must be cleaned up when the bridge is detached to avoid
> > > > >>  use-after-free conditions.
> > > > >
> > > > > For -fixes this sounds ok, but for -next I think switching to drmm_
> > > > > would be much better.
> > > >
> > > > The API would need to change to have access to the drm_device struct,
> > > > though. That would be quite a big patch, there are a few dozens source
> > > > files that use this API already.
> > > 
> > > Hm right pure drmm_ doesn't work for panel or bridge since it's
> > > usually a separate driver. But devm_ also doesn't work. I think what
> > > we need here is two-stage: first kmalloc the panel (or bridge, it's
> > > really the same) in the panel/bridge driver load. Then when we bind it
> > > to the drm_device we can tie it into the managed resources with
> > > drmm_add_action_or_reset. Passing the drm_device to the point where we
> > > allocate the panel/bridge doesn't work for these.
> > > 
> > > I think minimally we need a FIXME here and ack from Laurent on how
> > > this should be solved at least, since panel bridge is used rather
> > > widely.
> > 
> > Bridge removal is completely broken. If you unbind a bridge driver from
> > the device, the bridge will be unregistered and resources freed, without
> > the display driver knowing about this. The lifetime of the drm_bridge
> > structure itself isn't the only issue to be addressed here, it's broader
> > than that, and needs to consider that the display driver could be
> > calling the bridge operations concurrently to the removal.
> 
> So for the "unloading bridge should first unload display" problem that was
> supposed to get fixed with device links. There was at least a patch for
> that, and I Rafel from pm side did all the core changes to make it work.
> But it didn't land I think, so things keep on sucking.
> 
> Ofc the lifetime of the bridge structure is then an additional problem on
> top here.

There's a set of interesting problems. I don't think it's impossible,
but it will require someone with a good understanding of the problem (as
that person would really need to see the big picture, and take all use
cases into account), and a large amount of time and motivation.

> > We need a volunteer with enough motivation to solve this subsystem-wide
> > :-) In the meantime, whatever shortcut addresses immediate issues is
> > probably fine, as yak-shaving in this area would definitely not be
> > reasonable.
> 
> I guess drm/bridge keeps on disappointing :-/

I usually blame the x86 folks for not caring enough about bridges
initially, resulting in it being a second class citizen ;-)

> > > > >> v2: Cleanup connector only if it was created
> > > > >>
> > > > >> Fixes: 13dfc0540a57 ("drm/bridge: Refactor out the panel wrapper from the lvds-encoder bridge.")
> > > > >> Cc: <stable@vger.kernel.org> # 4.12+
> > > > >> Cc: Andrzej Hajda <a.hajda@samsung.com>
> > > > >> Cc: Neil Armstrong <narmstrong@baylibre.com>
> > > > >> Cc: Laurent Pinchart <Laurent.pinchart@ideasonboard.com>
> > > > >> Cc: Jonas Karlman <jonas@kwiboo.se>
> > > > >> Cc: Jernej Skrabec <jernej.skrabec@siol.net>
> > > > >> Signed-off-by: Paul Cercueil <paul@crapouillou.net>
> > > > >> ---
> > > > >>  drivers/gpu/drm/bridge/panel.c | 6 ++++++
> > > > >>  1 file changed, 6 insertions(+)
> > > > >>
> > > > >> diff --git a/drivers/gpu/drm/bridge/panel.c b/drivers/gpu/drm/bridge/panel.c
> > > > >> index 0ddc37551194..df86b0ee0549 100644
> > > > >> --- a/drivers/gpu/drm/bridge/panel.c
> > > > >> +++ b/drivers/gpu/drm/bridge/panel.c
> > > > >> @@ -87,6 +87,12 @@ static int panel_bridge_attach(struct drm_bridge *bridge,
> > > > >>
> > > > >>  static void panel_bridge_detach(struct drm_bridge *bridge)
> > > > >>  {
> > > > >> +	struct panel_bridge *panel_bridge = drm_bridge_to_panel_bridge(bridge);
> > > > >> +	struct drm_connector *connector = &panel_bridge->connector;
> > > > >> +
> > > > >> +	/* Cleanup the connector if we know it was initialized */
> > > > >> +	if (!!panel_bridge->connector.dev)
> > > > >> +		drm_connector_cleanup(connector);
> > > > >>  }
> > > > >>
> > > > >>  static void panel_bridge_pre_enable(struct drm_bridge *bridge)

-- 
Regards,

Laurent Pinchart

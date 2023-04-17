Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A55406E443F
	for <lists+stable@lfdr.de>; Mon, 17 Apr 2023 11:46:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230032AbjDQJqM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Apr 2023 05:46:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbjDQJqL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Apr 2023 05:46:11 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6DC35FD8
        for <stable@vger.kernel.org>; Mon, 17 Apr 2023 02:45:28 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1poLQC-0005sy-RR; Mon, 17 Apr 2023 11:45:16 +0200
Received: from sha by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1poLQC-00080t-D4; Mon, 17 Apr 2023 11:45:16 +0200
Date:   Mon, 17 Apr 2023 11:45:16 +0200
From:   Sascha Hauer <s.hauer@pengutronix.de>
To:     Paul Kocialkowski <paul.kocialkowski@bootlin.com>
Cc:     Chris Morgan <macroalpha82@gmail.com>,
        =?iso-8859-15?Q?K=F6ry?= Maincent <kory.maincent@bootlin.com>,
        Sandy Huang <hjc@rock-chips.com>,
        dri-devel@lists.freedesktop.org,
        linux-rockchip@lists.infradead.org,
        Michael Riesch <michael.riesch@wolfvision.net>,
        kernel@pengutronix.de, stable@vger.kernel.org
Subject: Re: [PATCH] drm/rockchip: vop2: fix suspend/resume
Message-ID: <20230417094516.GM15436@pengutronix.de>
References: <20230413144347.3506023-1-s.hauer@pengutronix.de>
 <64381f5b.050a0220.1533e.41e2@mx.google.com>
 <ZDlhGv0seSoxFlJ5@aptenodytes>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZDlhGv0seSoxFlJ5@aptenodytes>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: stable@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Apr 14, 2023 at 04:20:10PM +0200, Paul Kocialkowski wrote:
> Hi,
> 
> On Thu 13 Apr 23, 10:27, Chris Morgan wrote:
> > On Thu, Apr 13, 2023 at 04:43:47PM +0200, Sascha Hauer wrote:
> > > During a suspend/resume cycle the VO power domain will be disabled and
> > > the VOP2 registers will reset to their default values. After that the
> > > cached register values will be out of sync and the read/modify/write
> > > operations we do on the window registers will result in bogus values
> > > written. Fix this by re-initializing the register cache each time we
> > > enable the VOP2. With this the VOP2 will show a picture after a
> > > suspend/resume cycle whereas without this the screen stays dark.
> 
> I was actually tracking the very same bug this week!
> 
> Thanks a lot for fixing this, it would certainly have taken me a while to
> think about regmap cache maintenance. Good thinking :)
> 
> Your patch fixes the issue on my side but I have a suggestion below:
> 
> > > Fixes: 604be85547ce4 ("drm/rockchip: Add VOP2 driver")
> > > Cc: stable@vger.kernel.org
> > > Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
> > > ---
> > >  drivers/gpu/drm/rockchip/rockchip_drm_vop2.c | 8 ++++++++
> > >  1 file changed, 8 insertions(+)
> > > 
> > > diff --git a/drivers/gpu/drm/rockchip/rockchip_drm_vop2.c b/drivers/gpu/drm/rockchip/rockchip_drm_vop2.c
> > > index ba3b817895091..d9daa686b014d 100644
> > > --- a/drivers/gpu/drm/rockchip/rockchip_drm_vop2.c
> > > +++ b/drivers/gpu/drm/rockchip/rockchip_drm_vop2.c
> > > @@ -215,6 +215,8 @@ struct vop2 {
> > >  	struct vop2_win win[];
> > >  };
> > >  
> > > +static const struct regmap_config vop2_regmap_config;
> > > +
> > >  static struct vop2_video_port *to_vop2_video_port(struct drm_crtc *crtc)
> > >  {
> > >  	return container_of(crtc, struct vop2_video_port, crtc);
> > > @@ -839,6 +841,12 @@ static void vop2_enable(struct vop2 *vop2)
> > >  		return;
> > >  	}
> > >  
> > > +	ret = regmap_reinit_cache(vop2->map, &vop2_regmap_config);
> > > +	if (ret) {
> > > +		drm_err(vop2->drm, "failed to reinit cache: %d\n", ret);
> > > +		return;
> > > +	}
> 
> It seems that regmap has regcache_mark_dirty() for this purpose, which is
> perhaps more adapted than reinitializing cache (unless I'm missing something).
> Note that I haven't tested it at this point.

I wasn't aware of this function. regcache_mark_dirty() alone is not
enough, we need regcache_sync() as well. This looks better, I just sent
a v2.

Sascha

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

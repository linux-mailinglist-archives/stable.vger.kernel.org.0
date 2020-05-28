Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 825431E5BEA
	for <lists+stable@lfdr.de>; Thu, 28 May 2020 11:31:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728392AbgE1Jbr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 May 2020 05:31:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727981AbgE1Jbr (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 May 2020 05:31:47 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF70EC05BD1E
        for <stable@vger.kernel.org>; Thu, 28 May 2020 02:31:46 -0700 (PDT)
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mfe@pengutronix.de>)
        id 1jeEt7-0004v6-F9; Thu, 28 May 2020 11:31:45 +0200
Received: from mfe by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <mfe@pengutronix.de>)
        id 1jeEt7-0003cW-4F; Thu, 28 May 2020 11:31:45 +0200
Date:   Thu, 28 May 2020 11:31:45 +0200
From:   Marco Felsch <m.felsch@pengutronix.de>
To:     Liu Ying <victor.liu@nxp.com>
Cc:     dri-devel@lists.freedesktop.org, stable@vger.kernel.org,
        s.hauer@pengutronix.de, kernel@pengutronix.de, linux-imx@nxp.com
Subject: Re: [PATCH] drm/imx: imx-ldb: Disable both channels for split mode
 in enc->disable()
Message-ID: <20200528093145.kmpzbnesv25k7wvc@pengutronix.de>
References: <1589268718-29837-1-git-send-email-victor.liu@nxp.com>
 <ce17fb3798b208e63eabee6c1e1197bfce6b77a9.camel@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ce17fb3798b208e63eabee6c1e1197bfce6b77a9.camel@nxp.com>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 11:30:15 up 195 days, 48 min, 196 users,  load average: 0.21, 0.18,
 0.10
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: mfe@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: stable@vger.kernel.org
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Liu

On 20-05-28 10:58, Liu Ying wrote:
> Gentle ping...

Please check my "spring cleanup series" [1] which do the split:

[1] https://www.spinics.net/lists/arm-kernel/msg789309.html

Regards,
  Marco

> On Tue, 2020-05-12 at 15:31 +0800, Liu Ying wrote:
> > Both of the two LVDS channels should be disabled for split mode
> > in the encoder's ->disable() callback, because they are enabled
> > in the encoder's ->enable() callback.
> > 
> > Fixes: 6556f7f82b9c ("drm: imx: Move imx-drm driver out of staging")
> > Cc: Philipp Zabel <p.zabel@pengutronix.de>
> > Cc: Sascha Hauer <s.hauer@pengutronix.de>
> > Cc: Pengutronix Kernel Team <kernel@pengutronix.de>
> > Cc: NXP Linux Team <linux-imx@nxp.com>
> > Cc: <stable@vger.kernel.org>
> > Signed-off-by: Liu Ying <victor.liu@nxp.com>
> > ---
> >  drivers/gpu/drm/imx/imx-ldb.c | 7 ++++---
> >  1 file changed, 4 insertions(+), 3 deletions(-)
> > 
> > diff --git a/drivers/gpu/drm/imx/imx-ldb.c b/drivers/gpu/drm/imx/imx-
> > ldb.c
> > index 4da22a9..af4d0d8 100644
> > --- a/drivers/gpu/drm/imx/imx-ldb.c
> > +++ b/drivers/gpu/drm/imx/imx-ldb.c
> > @@ -303,18 +303,19 @@ static void imx_ldb_encoder_disable(struct
> > drm_encoder *encoder)
> >  {
> >  	struct imx_ldb_channel *imx_ldb_ch =
> > enc_to_imx_ldb_ch(encoder);
> >  	struct imx_ldb *ldb = imx_ldb_ch->ldb;
> > +	int dual = ldb->ldb_ctrl & LDB_SPLIT_MODE_EN;
> >  	int mux, ret;
> >  
> >  	drm_panel_disable(imx_ldb_ch->panel);
> >  
> > -	if (imx_ldb_ch == &ldb->channel[0])
> > +	if (imx_ldb_ch == &ldb->channel[0] || dual)
> >  		ldb->ldb_ctrl &= ~LDB_CH0_MODE_EN_MASK;
> > -	else if (imx_ldb_ch == &ldb->channel[1])
> > +	if (imx_ldb_ch == &ldb->channel[1] || dual)
> >  		ldb->ldb_ctrl &= ~LDB_CH1_MODE_EN_MASK;
> >  
> >  	regmap_write(ldb->regmap, IOMUXC_GPR2, ldb->ldb_ctrl);
> >  
> > -	if (ldb->ldb_ctrl & LDB_SPLIT_MODE_EN) {
> > +	if (dual) {
> >  		clk_disable_unprepare(ldb->clk[0]);
> >  		clk_disable_unprepare(ldb->clk[1]);
> >  	}
> 
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> https://lists.freedesktop.org/mailman/listinfo/dri-devel
> 

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

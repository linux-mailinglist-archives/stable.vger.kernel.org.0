Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5E816E47F6
	for <lists+stable@lfdr.de>; Mon, 17 Apr 2023 14:39:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230158AbjDQMjD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Apr 2023 08:39:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231182AbjDQMjA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Apr 2023 08:39:00 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F31540D1
        for <stable@vger.kernel.org>; Mon, 17 Apr 2023 05:38:55 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1poO88-0006IW-KR; Mon, 17 Apr 2023 14:38:48 +0200
Received: from sha by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1poO88-0001gy-2e; Mon, 17 Apr 2023 14:38:48 +0200
Date:   Mon, 17 Apr 2023 14:38:48 +0200
From:   Sascha Hauer <s.hauer@pengutronix.de>
To:     Heiko =?iso-8859-15?Q?St=FCbner?= <heiko@sntech.de>
Cc:     dri-devel@lists.freedesktop.org, Sandy Huang <hjc@rock-chips.com>,
        linux-rockchip@lists.infradead.org, kernel@pengutronix.de,
        Chris Morgan <macroalpha82@gmail.com>,
        =?iso-8859-15?Q?K=F6ry?= Maincent <kory.maincent@bootlin.com>,
        Michael Riesch <michael.riesch@wolfvision.net>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH] drm/rockchip: vop2: fix suspend/resume
Message-ID: <20230417123848.GN15436@pengutronix.de>
References: <20230417094215.2049231-1-s.hauer@pengutronix.de>
 <7404631.18pcnM708K@diego>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7404631.18pcnM708K@diego>
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

On Mon, Apr 17, 2023 at 12:46:05PM +0200, Heiko Stübner wrote:
> Hi Sascha,
> 
> Am Montag, 17. April 2023, 11:42:15 CEST schrieb Sascha Hauer:
> > During a suspend/resume cycle the VO power domain will be disabled and
> > the VOP2 registers will reset to their default values. After that the
> > cached register values will be out of sync and the read/modify/write
> > operations we do on the window registers will result in bogus values
> > written. Fix this by marking the regcache as dirty each time we disable
> > the VOP2 and call regcache_sync() each time we enable it again. With
> > this the VOP2 will show a picture after a suspend/resume cycle whereas
> > without this the screen stays dark.
> > 
> > Fixes: 604be85547ce4 ("drm/rockchip: Add VOP2 driver")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
> 
> somehow we overlapped with this v2 and me applying the original one [0]
> to drm-misc. With drm-misc being a shared tree there is also no way back.
> 
> So if this v2 is better suited, could do a follow-up patch instead - on
> top of your original one?

Alright, just did that. You should find it in your inbox.

Sascha

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

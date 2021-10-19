Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B75743339E
	for <lists+stable@lfdr.de>; Tue, 19 Oct 2021 12:35:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235235AbhJSKhu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Oct 2021 06:37:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235150AbhJSKht (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Oct 2021 06:37:49 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB210C061745
        for <stable@vger.kernel.org>; Tue, 19 Oct 2021 03:35:36 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1mcmSt-0004vM-Dr; Tue, 19 Oct 2021 12:35:27 +0200
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1mcmSr-0007we-QY; Tue, 19 Oct 2021 12:35:25 +0200
Date:   Tue, 19 Oct 2021 12:35:25 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Petr Benes <petrben@gmail.com>
Cc:     Daniel Lezcano <daniel.lezcano@linaro.org>,
        Michal =?utf-8?B?Vm9rw6HEjQ==?= <michal.vokac@ysoft.com>,
        Andrzej Pietrasiewicz <andrzej.p@collabora.com>,
        linux-pm@vger.kernel.org, Shawn Guo <shawnguo@kernel.org>,
        Amit Kucheria <amitk@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Petr =?utf-8?B?QmVuZcWh?= <petr.benes@ysoft.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH] thermal: imx: Fix temperature measurements on i.MX6
 after alarm
Message-ID: <20211019103525.GB16320@pengutronix.de>
References: <20211008081137.1948848-1-michal.vokac@ysoft.com>
 <20211018112820.qkebjt2gk2w53lp5@pengutronix.de>
 <37bc3702-bc98-dc54-e9c7-bf9bc92432f0@linaro.org>
 <CAPwXO5YguJtSFSqnA_aGPch2NswmrP1EzOs0QH5O_iOdtn5W1A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAPwXO5YguJtSFSqnA_aGPch2NswmrP1EzOs0QH5O_iOdtn5W1A@mail.gmail.com>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 12:31:56 up 243 days, 13:55, 126 users,  load average: 0.16, 0.21,
 0.22
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: stable@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Petr,

On Tue, Oct 19, 2021 at 09:24:44AM +0200, Petr Benes wrote:
> On Mon, 18 Oct 2021 at 13:38, Daniel Lezcano <daniel.lezcano@linaro.org> wrote:
> >
> > On 18/10/2021 13:28, Oleksij Rempel wrote:
> > > Hi Michal,
> > >
> > > I hope you have seen this patch:
> > > https://lore.kernel.org/all/20210924115032.29684-1-o.rempel@pengutronix.de/
> > >
> > > Are there any reason why this was ignored?
> >
> > No reasons, I was waiting for some tags before merging it. But I forget
> > about it when reviewing the current patch.
> 
> Tested Oleksij's patch. It works OK. A question arose. Does it require
> CONFIG_PM=y?
> If this condition is mandatory and the requirement is valid, Kconfig
> should be changed accordingly.
> I'm not able to verify it works without PM, seems it doesn't.

If CONFIG_PM=n, all pm_runtime_* will do nothing and the imx_thermal core
will stay enabled, see:
 
+/* the core was configured and enabled just before */
+pm_runtime_set_active(&pdev->dev);
+pm_runtime_enable(data->dev);

Regards,
Oleksij
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

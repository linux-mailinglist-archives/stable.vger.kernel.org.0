Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25ED5149D03
	for <lists+stable@lfdr.de>; Sun, 26 Jan 2020 22:29:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726294AbgAZV23 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Jan 2020 16:28:29 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:59587 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726695AbgAZV23 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Jan 2020 16:28:29 -0500
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1ivpSD-0004z0-Kq; Sun, 26 Jan 2020 22:28:25 +0100
Received: from ukl by ptx.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <ukl@pengutronix.de>)
        id 1ivpSB-0003RP-Ky; Sun, 26 Jan 2020 22:28:23 +0100
Date:   Sun, 26 Jan 2020 22:28:23 +0100
From:   Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
        <u.kleine-koenig@pengutronix.de>
To:     Pavel Machek <pavel@denx.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 177/639] rtc: ds1307: rx8130: Fix alarm handling
Message-ID: <20200126212823.63nnwytrwup5uim6@pengutronix.de>
References: <20200124093047.008739095@linuxfoundation.org>
 <20200124093109.349854130@linuxfoundation.org>
 <20200125133036.GD14064@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200125133036.GD14064@duo.ucw.cz>
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: stable@vger.kernel.org
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jan 25, 2020 at 02:30:36PM +0100, Pavel Machek wrote:
> Hi!
> 
> > When the EXTENSION.WADA bit is set, register 0x19 contains a bitmap of
> > week days, not a day of month. As Linux only handles a single alarm
> > without repetition using day of month is more flexible, so clear this
> > bit. (Otherwise a value depending on time.tm_wday would have to be
> > written to register 0x19.)
> 
> So the comment explains why WADA bit needs to be clear.
> 
> > @@ -749,8 +749,8 @@ static int rx8130_set_alarm(struct device *dev, struct rtc_wkalrm *t)
> >  	if (ret < 0)
> >  		return ret;
> >  
> > -	ctl[0] &= ~RX8130_REG_EXTENSION_WADA;
> > +	ctl[0] &= RX8130_REG_EXTENSION_WADA;
> 
> But then code is changed to preserve WADA bit while it was clearing it
> before.

This looks broken indeed. The new code clears all flags but WADA. Will
take a look tomorrow.
 
Best regards
Uwe



-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | https://www.pengutronix.de/ |

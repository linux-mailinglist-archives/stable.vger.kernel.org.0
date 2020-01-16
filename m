Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A29F13F80D
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 20:17:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733214AbgAPTOo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 14:14:44 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:36639 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733209AbgAPQ4T (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Jan 2020 11:56:19 -0500
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1is8RL-0003ja-2D; Thu, 16 Jan 2020 17:56:15 +0100
Received: from ukl by ptx.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <ukl@pengutronix.de>)
        id 1is8RK-0003vs-9c; Thu, 16 Jan 2020 17:56:14 +0100
Date:   Thu, 16 Jan 2020 17:56:14 +0100
From:   Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
        <u.kleine-koenig@pengutronix.de>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Ondrej Jirman <megous@megous.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        linux-pwm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH AUTOSEL 5.4 053/205] pwm: sun4i: Fix incorrect
 calculation of duty_cycle/period
Message-ID: <20200116165614.a3u5x7g4qxxrm6s4@pengutronix.de>
References: <20200116164300.6705-1-sashal@kernel.org>
 <20200116164300.6705-53-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200116164300.6705-53-sashal@kernel.org>
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: stable@vger.kernel.org
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 16, 2020 at 11:40:28AM -0500, Sasha Levin wrote:
> From: Ondrej Jirman <megous@megous.com>
> 
> [ Upstream commit 50cc7e3e4f26e3bf5ed74a8d061195c4d2161b8b ]
> 
> Since 5.4-rc1, pwm_apply_state calls ->get_state after ->apply
> if available, and this revealed an issue with integer precision
> when calculating duty_cycle and period for the currently set
> state in ->get_state callback.
> 
> This issue manifested in broken backlight on several Allwinner
> based devices.
> 
> Previously this worked, because ->apply updated the passed state
> directly.
> 
> Fixes: deb9c462f4e53 ("pwm: sun4i: Don't update the state for the caller of pwm_apply_state")
> Signed-off-by: Ondrej Jirman <megous@megous.com>
> Acked-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> Signed-off-by: Thierry Reding <thierry.reding@gmail.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

Note that while the patch is still correct, the problem isn't that bad
any more since commit 01ccf903edd65f6421612321648fa5a7f4b7cb10 was
reverted.

So .get_state is only called once during boot where the breakage doesn't
hurt that much.

I let you decide if you still want to apply this patch.

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | https://www.pengutronix.de/ |

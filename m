Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4F986EBA1F
	for <lists+stable@lfdr.de>; Sat, 22 Apr 2023 18:00:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229642AbjDVQAX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Apr 2023 12:00:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229663AbjDVQAW (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Apr 2023 12:00:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7448E1FEB
        for <stable@vger.kernel.org>; Sat, 22 Apr 2023 09:00:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EB5C2611C1
        for <stable@vger.kernel.org>; Sat, 22 Apr 2023 16:00:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA3ECC433EF;
        Sat, 22 Apr 2023 16:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1682179220;
        bh=ixZaYltQkP1Wtn2aJI1La0+GQQqOjwbo95aEe1P8Z+E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=d3qwRXpkx1cESgAYEnj4z/ukcZGp5OjIy/08Ayuj9k6WFkbmnEpaCKLuACQ4hkGKI
         ktl9cNHbtpnDcc3CF5LY+E8C4cj1044wBsqcyRXm6NS8002NEzHl77srSRme4TBQ7W
         6uVTUB1EJExtcoylmYzLoKegSECgufA+xNzdvIho=
Date:   Sat, 22 Apr 2023 18:00:17 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
        <u.kleine-koenig@pengutronix.de>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        Guenter Roeck <groeck@chromium.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 003/124] pwm: cros-ec: Explicitly set .polarity in
 .get_state()
Message-ID: <2023042200-glade-morale-1c08@gregkh>
References: <20230418120309.539243408@linuxfoundation.org>
 <20230418120309.688458749@linuxfoundation.org>
 <20230418130121.rx2zfwkzjyasghkg@pengutronix.de>
 <2023042239-sloping-sprite-7c24@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2023042239-sloping-sprite-7c24@gregkh>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Apr 22, 2023 at 05:05:08PM +0200, Greg Kroah-Hartman wrote:
> On Tue, Apr 18, 2023 at 03:01:21PM +0200, Uwe Kleine-König wrote:
> > On Tue, Apr 18, 2023 at 02:20:22PM +0200, Greg Kroah-Hartman wrote:
> > > From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> > > 
> > > [ Upstream commit 30006b77c7e130e01d1ab2148cc8abf73dfcc4bf ]
> > > 
> > > The driver only supports normal polarity. Complete the implementation of
> > > .get_state() by setting .polarity accordingly.
> > > 
> > > Reviewed-by: Guenter Roeck <groeck@chromium.org>
> > > Fixes: 1f0d3bb02785 ("pwm: Add ChromeOS EC PWM driver")
> > > Link: https://lore.kernel.org/r/20230228135508.1798428-3-u.kleine-koenig@pengutronix.de
> > > Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> > > Signed-off-by: Thierry Reding <thierry.reding@gmail.com>
> > > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > 
> > I see you picked this one and the similar sprd patch, but not
> > 
> > 	8caa81eb950c pwm: meson: Explicitly set .polarity in .get_state()
> > 	b20b097128d9 pwm: iqs620a: Explicitly set .polarity in .get_state()
> > 	6f5793798014 pwm: hibvt: Explicitly set .polarity in .get_state()
> > 
> > (At least I didn't get a mail about these). These should qualify in the same way.
> 
> They didn't all apply very well (one did).

Nope, that one broke the build, so none of these applied, which is
probably why Sasha didn't do it :)

thanks,

greg k-h

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42AF41F76DB
	for <lists+stable@lfdr.de>; Fri, 12 Jun 2020 12:44:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726362AbgFLKoV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jun 2020 06:44:21 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:33119 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726304AbgFLKoU (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Jun 2020 06:44:20 -0400
Received: by mail-ed1-f68.google.com with SMTP id o26so6086540edq.0;
        Fri, 12 Jun 2020 03:44:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=SOdvZcfgq0T/N/xg8rXOaGi/fRghIZcBnPCYUJJXVXo=;
        b=lN9tGzxr3YmtuWp24Dr9YCyTSryAX4UAb3RgpgyX2dCi6guOdbLwrw78Si0qYrq3YY
         hW2voO/mCFgE8ObifW2GJQ830jxnHScp3E8qsTNuJf7cbrOMU6smr6hkLkhxfM0wpnBg
         cQuTA3aRhEIw0MkUjiQ4T3TU2VowdzXaXmOwFoxWtIfokwh30MtSX8PEm5f5kTOhDxb5
         nudUwRM/07xiunG0oyBP9aUaJP6hPqldUjNSF+knItexBfA1hE8xGaSsIo+NMRzSiCNW
         XqpsqoKOG/JJJBr/5EwMncc1qxDgXWUv0eyZWL/rpoDjFR8VGY5TQ0N4FMrwmithSxB5
         8d9w==
X-Gm-Message-State: AOAM533YPrIMJCRBC0PpeMg4rF19rQpx1Y5IYlfVRlV/M2K66vFzLQWF
        6+Tdd3s5XJw0q8xH+JKDjCo=
X-Google-Smtp-Source: ABdhPJyw3kA/fGMFrQUC6hcemwafnWF3BI1uel/lQVb1PPosuNiApnhc+TX5NqRonlyy8zcCJJHFfQ==
X-Received: by 2002:a05:6402:1285:: with SMTP id w5mr11232244edv.73.1591958657053;
        Fri, 12 Jun 2020 03:44:17 -0700 (PDT)
Received: from pi3 ([194.230.155.184])
        by smtp.googlemail.com with ESMTPSA id oq28sm3429888ejb.12.2020.06.12.03.44.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Jun 2020 03:44:16 -0700 (PDT)
Date:   Fri, 12 Jun 2020 12:44:13 +0200
From:   Krzysztof Kozlowski <krzk@kernel.org>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Oleksij Rempel <linux@rempel-privat.de>,
        Wolfram Sang <wsa@kernel.org>,
        NXP Linux Team <linux-imx@nxp.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Shawn Guo <shawnguo@kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-i2c@vger.kernel.org
Subject: Re: [PATCH] i2c: imx: Fix external abort on early interrupt
Message-ID: <20200612104413.GC26056@pi3>
References: <1591796802-23504-1-git-send-email-krzk@kernel.org>
 <20200612090517.GA3030@ninjato>
 <20200612092941.GA25990@pi3>
 <20200612095604.GA17763@ninjato>
 <20200612102113.GA26056@pi3>
 <20200612103149.2onoflu5qgwaooli@pengutronix.de>
 <2bc70a44-8b98-0da5-9408-15d6fa0c20fe@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <2bc70a44-8b98-0da5-9408-15d6fa0c20fe@pengutronix.de>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 12, 2020 at 12:34:47PM +0200, Marc Kleine-Budde wrote:
> On 6/12/20 12:31 PM, Oleksij Rempel wrote:
> > On Fri, Jun 12, 2020 at 12:21:13PM +0200, Krzysztof Kozlowski wrote:
> >> On Fri, Jun 12, 2020 at 11:56:04AM +0200, Wolfram Sang wrote:
> >>> On Fri, Jun 12, 2020 at 11:29:41AM +0200, Krzysztof Kozlowski wrote:
> >>>> On Fri, Jun 12, 2020 at 11:05:17AM +0200, Wolfram Sang wrote:
> >>>>> On Wed, Jun 10, 2020 at 03:46:42PM +0200, Krzysztof Kozlowski wrote:
> >>>>>> If interrupt comes early (could be triggered with CONFIG_DEBUG_SHIRQ),
> >>>>>
> >>>>> That code is disabled since 2011 (6d83f94db95c ("genirq: Disable the
> >>>>> SHIRQ_DEBUG call in request_threaded_irq for now"))? So, you had this
> >>>>> without fake injection, I assume?
> >>>>
> >>>> No, I observed it only after enabling DEBUG_SHIRQ (to a kernel with
> >>>> some debugging options already).
> >>>
> >>> Interesting. Maybe probe was deferred and you got the extra irq when
> >>> deregistering?
> >>
> >> Yes, good catch. The abort happens right after deferred probe exit.  It
> >> could be then different reason than I thought - the interrupt is freed
> >> through devm infrastructure quite late.  At this time, the clock might
> >> be indeed disabled (error path of probe()).
> 
> From my point of view, the clocks are disabled as Oleksij pointed out, due to
> RUNTIME_PM at the end of probe():
> 
> > 	pm_runtime_mark_last_busy(&pdev->dev);
> > 	pm_runtime_put_autosuspend(&pdev->dev);

These lines come from regular successful probe path, not deferred error path.

The clock is indeed disabled but not because of runtime PM, but:
clk_disable:
	clk_disable_unprepare(i2c_imx->clk);


Best regards,
Krzysztof


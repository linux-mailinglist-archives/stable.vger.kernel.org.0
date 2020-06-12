Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85FED1F7884
	for <lists+stable@lfdr.de>; Fri, 12 Jun 2020 15:09:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726338AbgFLNJV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jun 2020 09:09:21 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:37066 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726112AbgFLNJU (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Jun 2020 09:09:20 -0400
Received: by mail-ed1-f68.google.com with SMTP id k8so6390441edq.4;
        Fri, 12 Jun 2020 06:09:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=W6pdgl2PLO28Quo1DrifG6f4mzYJJhuViqwZMRjapYc=;
        b=AP3Hcy8L+zzUSNaWB3Q1J7i8Hf0rMALuw1egau3JlyZSY67JK//9wf8mZLWOTyO40a
         ESk+bYdsj33dfbOFtvJ3E9jciv7HGHN46s4F9LKi2mzrancbV/KN9gXfyMnHXSTH4M9r
         0+fW65qkJ0kIIpdiEl3934dBJAksoeSdHWrCtswCIVidAho+gYm/9H7LoEc5RmkvgQOt
         +lFTcisnQg/Y8csWKHFjgMSA+7tMwT94IlUxPsqlyxbxf+gEKgl+lXSnW+rxCLPxVdVl
         4uhJyhYqBor/B7rS0J/d5/B8kppDz7hFb/KDW7+hFhiQgaRXHF7nOZSq0+h/InROPznp
         D7qA==
X-Gm-Message-State: AOAM532cQjN0UyNFKAvTR+GagL/H3EqC4gVB+u58TcKaxvUiG+VVDib4
        HFqz3sUQLC2O/kQQ9Psxu9Y=
X-Google-Smtp-Source: ABdhPJw2FHzo7NNJNvXCM5/NTxYsQrs4+yzO9DeAX0Qa3/zidsZXMTnnAP95p3AzhjAz2Ichf6M24g==
X-Received: by 2002:a50:f145:: with SMTP id z5mr12174687edl.78.1591967358525;
        Fri, 12 Jun 2020 06:09:18 -0700 (PDT)
Received: from pi3 ([194.230.155.184])
        by smtp.googlemail.com with ESMTPSA id p13sm3114724edx.69.2020.06.12.06.09.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Jun 2020 06:09:17 -0700 (PDT)
Date:   Fri, 12 Jun 2020 15:09:15 +0200
From:   Krzysztof Kozlowski <krzk@kernel.org>
To:     Wolfram Sang <wsa@kernel.org>
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Oleksij Rempel <linux@rempel-privat.de>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        NXP Linux Team <linux-imx@nxp.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Shawn Guo <shawnguo@kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-i2c@vger.kernel.org
Subject: Re: [PATCH] i2c: imx: Fix external abort on early interrupt
Message-ID: <20200612130915.GA26279@pi3>
References: <1591796802-23504-1-git-send-email-krzk@kernel.org>
 <20200612090517.GA3030@ninjato>
 <20200612092941.GA25990@pi3>
 <20200612095604.GA17763@ninjato>
 <20200612102113.GA26056@pi3>
 <20200612103149.2onoflu5qgwaooli@pengutronix.de>
 <20200612103949.GB26056@pi3>
 <20200612115116.GA18557@ninjato>
 <859e8211-2c56-8dd5-d6fb-33e4358e4128@pengutronix.de>
 <20200612130003.GB18557@ninjato>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200612130003.GB18557@ninjato>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 12, 2020 at 03:00:03PM +0200, Wolfram Sang wrote:
> On Fri, Jun 12, 2020 at 02:18:06PM +0200, Marc Kleine-Budde wrote:
> > On 6/12/20 1:51 PM, Wolfram Sang wrote:
> > > 
> > >> This basically kills the concept of devm for interrupts. Some other
> > > 
> > > It only works when you can ensure you have all interrupts disabled (and
> > > none pending) in remove() or the error paths of probe() etc.
> > 
> > But when requesting the interrupt as shared the interrupt handler can get called
> > any time, even if you have disabled the IRQ source in your IP core....The shared
> > IRQ debug code tests this.
> 
> Yes, so you'd need something like
> 
> 	if (clks_are_off)
> 		return IRQ_NONE;

Maybe then:
	if (pm_runtime_enabled())?

The device structure should be valid at this point so the call should
work.


> 
> or skip devm_ for interrupts and handle it manually. (IIRC the input
> subsystem really frowns upon devm + irqs for such reasons)
> 
> D'accord?

I guess dream of managing every resource automatically is an utopia :)

Best regards,
Krzysztof



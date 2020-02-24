Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D362E16AF7F
	for <lists+stable@lfdr.de>; Mon, 24 Feb 2020 19:43:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727709AbgBXSn0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Feb 2020 13:43:26 -0500
Received: from mail-lf1-f68.google.com ([209.85.167.68]:42844 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726652AbgBXSn0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Feb 2020 13:43:26 -0500
Received: by mail-lf1-f68.google.com with SMTP id 83so7520248lfh.9;
        Mon, 24 Feb 2020 10:43:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uCmCqGkBSNCRTaEPKViwOJ/762o19mpcQcrckJGGFEA=;
        b=k2mwXkvdmgi8pr7kvr78v5r1c+AnLoKifDlTcCs/ZSikAZfhL088/hZVAQ1V1srjUW
         adK/hdF1CUFI0dDf+hlDbEPRtlSXcL2zxq95AAYfEpOO3eQVdUf6EvX6rChQV8hQbo8v
         8riLPA0EsHRca0FXC9j8nsopqWH1As4UIhBuVffez4KsHgxuWIUp19NXeLhknVrRe9+N
         Sp+7x/eT/OC8u0VhApIAdQrx/AVHnjtYqgZrVQAlEAT/ebn/eqX6kf+7Fv8zELrAO9uZ
         EYLmQ5qTINJfnaSl40WMelswQ70B8cmZf+d4kRok2h07fXkML/ilqbhADPJoekdqgL9f
         sAGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uCmCqGkBSNCRTaEPKViwOJ/762o19mpcQcrckJGGFEA=;
        b=dJm9Fgpy1bQ+KGzcl6iMNXaP68RSmMxvacWkPTUHaa4ye0Y10Kc6++tMEZc71AAmbv
         bxWw6RZXVx0Z2qrXF4PZvvv9FOCD4Zy7EKOsqe+rAhCYns+g8otab1oNQR+vMmSpKKwy
         Tv3G3YAaLBs+VrKDiJNyydUdxFt/OG6IHDWD6prKyrFkFqvMQr7AvgdnnXH7/lE9kkGA
         z3Gqxct5NFEUH+5aZ/aU+C3gANnrnDRcZS3j4+IX4AkPjNfcAhLcHLHjGE8ARvebR4Ko
         TI9m5dcoMxmreDW8ZnMJV6rwl7+d32Zstz/Wl04TRgwvgtkGhTCm9O0Clz5AJLT3ILMG
         nJng==
X-Gm-Message-State: APjAAAWeTyhvaF6/RlrdZHMq4gIdynLni+Rr3WleD+1VtMYKB91VhYNL
        WPRzpxP8NR2WIBGmERFBpgBOryI8ZnJAv6V1uJw=
X-Google-Smtp-Source: APXvYqxVfNaWgGUCHRkeDD7FAEMlSi7VmD5rdHw5mtCFT9xR0L3S4D33CNY+Hp391gODfjB72gHp7oBEt0X4O41lZ/o=
X-Received: by 2002:a05:6512:10d4:: with SMTP id k20mr11537422lfg.70.1582569803984;
 Mon, 24 Feb 2020 10:43:23 -0800 (PST)
MIME-Version: 1.0
References: <20200224172236.22478-1-frieder.schrempf@kontron.de>
In-Reply-To: <20200224172236.22478-1-frieder.schrempf@kontron.de>
From:   Fabio Estevam <festevam@gmail.com>
Date:   Mon, 24 Feb 2020 15:43:13 -0300
Message-ID: <CAOMZO5CyYbAZRZrGLJNJXNJiekJXptUTu8tOfVw6y7-n-CXesg@mail.gmail.com>
Subject: Re: [PATCH] dma: imx-sdma: Fix the event id check to include RX event
 for UART6
To:     Schrempf Frieder <frieder.schrempf@kontron.de>
Cc:     Dan Williams <dan.j.williams@intel.com>,
        Linus Walleij <linus.ml.walleij@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Shawn Guo <shawnguo@kernel.org>, Vinod Koul <vkoul@kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Frieder,

On Mon, Feb 24, 2020 at 2:22 PM Schrempf Frieder
<frieder.schrempf@kontron.de> wrote:
>
> From: Frieder Schrempf <frieder.schrempf@kontron.de>
>
> On i.MX6 the DMA event for the RX channel of UART6 is '0'. To fix

I would suggest being a bit more specific than saying i.MX6.

I see UART6 is present on i.MX6UL/i.MX6SX, but not on i.MX6Q/i.MX6DL,
so it would be better to specify it in the commit log.

imx6ul.dtsi does not have dma nodes under uart6, so I guess you fixed
it for imx6sx.

> the broken DMA support for UART6, we change the check for event_id0
> to include '0' as a valid id.
>
> Fixes: 1ec1e82f2510 ("dmaengine: Add Freescale i.MX SDMA support")
> Cc: stable@vger.kernel.org
> Signed-off-by: Frieder Schrempf <frieder.schrempf@kontron.de>

Reviewed-by: Fabio Estevam <festevam@gmail.com>

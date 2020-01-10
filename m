Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36BA9136804
	for <lists+stable@lfdr.de>; Fri, 10 Jan 2020 08:13:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725881AbgAJHNb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Jan 2020 02:13:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:32908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725835AbgAJHNb (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 10 Jan 2020 02:13:31 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B58732073A;
        Fri, 10 Jan 2020 07:13:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578640410;
        bh=u3nc95r1jFTqR3hP2067iUtba3cgdved2A2t1XDWrfE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AkJi4eIokl+gNJwTiX5L2s1jG52dPvA6Jgftv8vlJJE5IuPr77FpapwCggwQGjNBo
         Lc0xGT2B6tpVICrV2wlunZa2Te4JDR3hhMlVY2bVtYkAn52knN+iraay07u7eZGKjt
         FQGPESEPyb1w3Ih9YAIsyu1MxcWPmabID1Su8r4E=
Date:   Fri, 10 Jan 2020 08:13:28 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     =?iso-8859-1?Q?S=E9bastien?= Szymanski 
        <sebastien.szymanski@armadeus.com>
Cc:     Lucas Stach <l.stach@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        Fabio Estevam <festevam@gmail.com>
Subject: Re: [PATCH AUTOSEL 4.19 102/177] nvmem: imx-ocotp: reset error
 status on probe
Message-ID: <20200110071328.GA100095@kroah.com>
References: <20191210213221.11921-1-sashal@kernel.org>
 <20191210213221.11921-102-sashal@kernel.org>
 <dd048e02-81f7-8aed-34a7-f95a70859391@armadeus.com>
 <2dc7001f362358dfdcbef080118b23cabaa03a40.camel@pengutronix.de>
 <CF40B493-27C8-4DF4-BB43-624CC797B12C@armadeus.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CF40B493-27C8-4DF4-BB43-624CC797B12C@armadeus.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 07, 2020 at 08:29:12PM +0100, Sébastien Szymanski wrote:
> Hi Lucas,
> 
> > On 7 Jan 2020, at 18:53, Lucas Stach <l.stach@pengutronix.de> wrote:
> > 
> > Hi Sébastien,
> > 
> > On Di, 2020-01-07 at 15:50 +0100, Sébastien Szymanski wrote:
> >> On 12/10/19 10:31 PM, Sasha Levin wrote:
> >>> From: Lucas Stach <l.stach@pengutronix.de>
> >>> 
> >>> [ Upstream commit c33c585f1b3a99d53920bdac614aca461d8db06f ]
> >>> 
> >>> If software running before the OCOTP driver is loaded left the
> >>> controller with the error status pending, the driver will never
> >>> be able to complete the read timing setup. Reset the error status
> >>> on probe to make sure the controller is in usable state.
> >>> 
> >>> Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
> >>> Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
> >>> Link: https://lore.kernel.org/r/20191029114240.14905-6-srinivas.kandagatla@linaro.org
> >>> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> >>> Signed-off-by: Sasha Levin <sashal@kernel.org>
> >>> ---
> >>> drivers/nvmem/imx-ocotp.c | 4 ++++
> >>> 1 file changed, 4 insertions(+)
> >>> 
> >>> diff --git a/drivers/nvmem/imx-ocotp.c b/drivers/nvmem/imx-ocotp.c
> >>> index afb429a417fe0..926d9cc080cf4 100644
> >>> --- a/drivers/nvmem/imx-ocotp.c
> >>> +++ b/drivers/nvmem/imx-ocotp.c
> >>> @@ -466,6 +466,10 @@ static int imx_ocotp_probe(struct platform_device *pdev)
> >>> 	if (IS_ERR(priv->clk))
> >>> 		return PTR_ERR(priv->clk);
> >>> 
> >>> +	clk_prepare_enable(priv->clk);
> >>> +	imx_ocotp_clr_err_if_set(priv->base);
> >>> +	clk_disable_unprepare(priv->clk);
> >>> +
> >>> 	priv->params = of_device_get_match_data(&pdev->dev);
> >>> 	imx_ocotp_nvmem_config.size = 4 * priv->params->nregs;
> >>> 	imx_ocotp_nvmem_config.dev = dev;
> >>> 
> >> 
> >> Hi,
> >> 
> >> This patch makes kernel 4.19.{92,93} hang at boot on my i.MX6ULL based
> >> board. It hanks at
> >> 
> >> [    3.730078] cpu cpu0: Linked as a consumer to regulator.2
> >> [    3.737760] cpu cpu0: Linked as a consumer to regulator.3
> >> 
> >> Full boot log is here: https://pastebin.com/TS8EFxkr
> >> 
> >> The config is imx_v6_v7_defconfig.
> >> 
> >> Reverting it makes the kernels boot again.
> > 
> > Can you check if it actually hangs in imx_ocotp_clr_err_if_set(), or if
> > the clk_disable_unprepare() is the culprit?
> > 
> > If the clock disable hangs the system there is a missing clock
> > reference somewhere else that we need to track down.
> 
> Yes, the system hangs in the imx6q-cpufreq driver, here:
> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/tree/drivers/cpufreq/imx6q-cpufreq.c?h=v4.19.93#n322
> 
> Kernel 5.4.8 works thanks to commits:
> 
> 2733fb0d0699 (“cpufreq: imx6q: read OCOTP through nvmem for imx6ul/imx6ull”)
> 92f0eb08c66a ("ARM: dts: imx6ul: use nvmem-cells for cpu speed grading”)

I've now queued both of these up for 4.19, hopefully that should resolve
this issue, thanks!

greg k-h

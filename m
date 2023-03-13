Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DB526B70F1
	for <lists+stable@lfdr.de>; Mon, 13 Mar 2023 09:17:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229827AbjCMIRt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Mar 2023 04:17:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229591AbjCMIRr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Mar 2023 04:17:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDB2E2B9F3;
        Mon, 13 Mar 2023 01:17:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8602F6114C;
        Mon, 13 Mar 2023 08:17:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0AA9C433EF;
        Mon, 13 Mar 2023 08:17:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678695465;
        bh=jzyrPeuPJwvGuYEX291gbAHZu85wfusV8HgesMnJlyI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nSK0sRt5aC3BDLSctPPKTY+COy70tLVrdKzFQnlo0qamNPCLzvZc8oRmkJDEwYPSl
         6BgGS0bRyj3gcESUSnsOG5FUTc2rU+xJCo9rnqg3SxO7Zarcz8DVINr3xtUCO9Sqdi
         SVPgfbGNXm8VYVNfIBEgimi/MdKvuwdFVz7pBI2aRf2JLV7OUvd9Ds3xxNj0y2kj6s
         B0nE4D79AivGr9tqx4NEQAOaCn249kmw3hG4gDjOpHfCyakL6zjx4As2g6VIRit6EW
         ioL4/eMZsyuxoeSwv0Bb1BoyPPliaahIAlY+pKqIVb946pbW1SVYix7k770NJXXkGJ
         otKhSHWLmb+aQ==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1pbdOG-0004Yv-VH; Mon, 13 Mar 2023 09:18:45 +0100
Date:   Mon, 13 Mar 2023 09:18:44 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     johan+linaro@kernel.org, a.swigon@samsung.com, agross@kernel.org,
        alim.akhtar@samsung.com, andersson@kernel.org, djakov@kernel.org,
        festevam@gmail.com, jonathanh@nvidia.com, kernel@pengutronix.de,
        konrad.dybcio@linaro.org, krzysztof.kozlowski@linaro.org,
        linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-imx@nxp.com,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-tegra@vger.kernel.org,
        s.hauer@pengutronix.de, s.nawrocki@samsung.com,
        shawnguo@kernel.org, stable@vger.kernel.org,
        thierry.reding@gmail.com, y.oudjana@protonmail.com
Subject: Re: [PATCH 07/23] interconnect: qcom: rpm: fix probe PM domain error
 handling
Message-ID: <ZA7cZBF58yMSjG/+@hovoldconsulting.com>
References: <20230201101559.15529-1-johan+linaro@kernel.org>
 <20230201101559.15529-8-johan+linaro@kernel.org>
 <641d04a3-9236-fe76-a20f-11466a01460e@wanadoo.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <641d04a3-9236-fe76-a20f-11466a01460e@wanadoo.fr>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Mar 11, 2023 at 07:17:50PM +0100, Christophe JAILLET wrote:
> Le 01/02/2023 à 11:15, Johan Hovold a écrit :
> > Make sure to disable clocks also in case attaching the power domain
> > fails.
> > 
> > Fixes: 7de109c0abe9 ("interconnect: icc-rpm: Add support for bus power domain")
> > Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org      # 5.17
> > Cc: Yassine Oudjana <y.oudjana-g/b1ySJe57IN+BqQ9rBEUg@public.gmane.org>
> > Signed-off-by: Johan Hovold <johan+linaro-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> > ---
> >   drivers/interconnect/qcom/icc-rpm.c | 9 ++++-----
> >   1 file changed, 4 insertions(+), 5 deletions(-)
> > 
> > diff --git a/drivers/interconnect/qcom/icc-rpm.c b/drivers/interconnect/qcom/icc-rpm.c
> > index 91778cfcbc65..da595059cafd 100644
> > --- a/drivers/interconnect/qcom/icc-rpm.c
> > +++ b/drivers/interconnect/qcom/icc-rpm.c
> > @@ -498,8 +498,7 @@ int qnoc_probe(struct platform_device *pdev)
> >   
> >   	if (desc->has_bus_pd) {
> >   		ret = dev_pm_domain_attach(dev, true);
> > -		if (ret)
> > -			return ret;
> > +		goto err_disable_clks;
> 
> Hi,
> this change looks strange because we now skip the rest of the function.
> 
> Is it really intended?

No, this was definitely not intentional. Thanks for catching this. I'll
send a follow up fix for Georgi to fold in or apply on top.

> Also, should dev_pm_domain_detach() be called somewhere in the error 
> handling path and remove function ?

In principle, yes. (I think read the above as being another device
managed resource.)

It turns out, however, that this code is totally bogus as any power
domain would already have been attached by the platform bus code and the
above call would always just succeed. The platform code would also
handle detach on errors. 

I'll send a patch to remove this.

Johan

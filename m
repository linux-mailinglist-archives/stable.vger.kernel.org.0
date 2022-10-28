Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F93761187A
	for <lists+stable@lfdr.de>; Fri, 28 Oct 2022 18:59:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229920AbiJ1Q7L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Oct 2022 12:59:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230413AbiJ1Q6y (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Oct 2022 12:58:54 -0400
Received: from relay6-d.mail.gandi.net (relay6-d.mail.gandi.net [217.70.183.198])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23EFFDAC57;
        Fri, 28 Oct 2022 09:58:51 -0700 (PDT)
Received: from booty (unknown [77.244.183.192])
        (Authenticated sender: luca.ceresoli@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id DD13EC0007;
        Fri, 28 Oct 2022 16:58:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1666976330;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LySexlPUtzLuiqijp03u4qPQFZvUnwDE7D7mZqts+BI=;
        b=gBrCAOhUwLUGsvMweUyfoN8BdOVVq8XipO6tM3tckCusB3+p5Bb5QLW3LLvVzCNiHSq9iK
        zfMsafSKiKtLbbDrm74Uw7IBCEysdFaqaltS/jDrWPTbYSjuByeNCsJDmiIjkxiBQjYPBa
        uG+fCs7yBVYyCNQ+24ThievHvkpC/GthSm76c5IpWX4dRANvk2twPYVtw/CRZ+vTPL01d+
        /FlbIoitf9IZCbBPfYAHeEtIa1xBOWtTJt1PMz2GwHA7OZHOx9IU+TtZ/O9tg8d5rpTf0n
        8jAkD2X+SUt4BKERIBmBeagazD3niMfwFiNbuWWgfylEdYZltoEmfZHRllVlIQ==
Date:   Fri, 28 Oct 2022 18:58:47 +0200
From:   Luca Ceresoli <luca.ceresoli@bootlin.com>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Thierry Reding <thierry.reding@gmail.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Sowjanya Komatineni <skomatineni@nvidia.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        stable@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-media@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-staging@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: media: tegra-video: fix device_node use after
 free
Message-ID: <20221028185847.5454a98d@booty>
In-Reply-To: <Y1vMX/Zciz/XQ+4p@kadam>
References: <20221028081926.2320663-1-luca.ceresoli@bootlin.com>
        <Y1vMX/Zciz/XQ+4p@kadam>
Organization: Bootlin
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Dan,

On Fri, 28 Oct 2022 15:34:39 +0300
Dan Carpenter <dan.carpenter@oracle.com> wrote:

> On Fri, Oct 28, 2022 at 10:19:26AM +0200, luca.ceresoli@bootlin.com wrote:
> > From: Luca Ceresoli <luca.ceresoli@bootlin.com>
> > 
> > At probe time this code path is followed:
> > 
> >  * tegra_csi_init
> >    * tegra_csi_channels_alloc
> >      * for_each_child_of_node(node, channel) -- iterates over channels
> >        * automatically gets 'channel'
> >          * tegra_csi_channel_alloc()
> >            * saves into chan->of_node a pointer to the channel OF node
> >        * automatically gets and puts 'channel'
> >        * now the node saved in chan->of_node has refcount 0, can disappear
> >    * tegra_csi_channels_init
> >      * iterates over channels
> >        * tegra_csi_channel_init -- uses chan->of_node
> > 
> > After that, chan->of_node keeps storing the node until the device is
> > removed.
> > 
> > of_node_get() the node and of_node_put() it during teardown to avoid any
> > risk.
> > 
> > Fixes: 1ebaeb09830f ("media: tegra-video: Add support for external sensor capture")
> > Cc: stable@vger.kernel.org
> > Cc: Sowjanya Komatineni <skomatineni@nvidia.com>
> > Signed-off-by: Luca Ceresoli <luca.ceresoli@bootlin.com>
> > ---
> >  drivers/staging/media/tegra-video/csi.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/staging/media/tegra-video/csi.c b/drivers/staging/media/tegra-video/csi.c
> > index b26e44adb2be..1b05f620b476 100644
> > --- a/drivers/staging/media/tegra-video/csi.c
> > +++ b/drivers/staging/media/tegra-video/csi.c
> > @@ -433,7 +433,7 @@ static int tegra_csi_channel_alloc(struct tegra_csi *csi,
> >  	for (i = 0; i < chan->numgangports; i++)
> >  		chan->csi_port_nums[i] = port_num + i * CSI_PORTS_PER_BRICK;
> >  
> > -	chan->of_node = node;
> > +	chan->of_node = of_node_get(node);
> >  	chan->numpads = num_pads;
> >  	if (num_pads & 0x2) {
> >  		chan->pads[0].flags = MEDIA_PAD_FL_SINK;
> > @@ -640,6 +640,7 @@ static void tegra_csi_channels_cleanup(struct tegra_csi *csi)
> >  			media_entity_cleanup(&subdev->entity);
> >  		}
> >  
> > +		of_node_put(chan->of_node);
> >  		list_del(&chan->list);
> >  		kfree(chan);  
> 
> Not related to your patch, but this kind of "one function cleans up
> everything" style is always buggy.  For example, here it should be:
> 
> -		if (chan->mipi)
> +		if (!IS_ERR_OR_NULL(chan->mipi))
> 			tegra_mipi_free(chan->mipi);

I sort of agree the code could be clearer here, but looking at the code
in detail, this cannot happen. chan->mipi is set in one place only, and
if it is an error the whole probe fails. So it can be either NULL or a
valid pointer here.

Regarding my patch, do you think it is valid?

Best regards.
-- 
Luca Ceresoli, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com

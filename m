Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F44C615FED
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 10:36:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230046AbiKBJgG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Nov 2022 05:36:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229713AbiKBJgE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Nov 2022 05:36:04 -0400
Received: from relay1-d.mail.gandi.net (relay1-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::221])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 649C46589;
        Wed,  2 Nov 2022 02:36:01 -0700 (PDT)
Received: from booty (unknown [77.244.183.192])
        (Authenticated sender: luca.ceresoli@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id B6BC1240004;
        Wed,  2 Nov 2022 09:35:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1667381759;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Fxxn1EtGefbBmnWxZ8XrxEIUXbiJwyzDeE5y9WnF5dA=;
        b=PtXD1S/+PYPuTw+0ABw0LDMREsiFR8UIk9Rt+urGLzui62MyUwWUmpQ0TGuc0oOJlrvEcR
        HKCCoSQDA1vC2gq8eVHDUmrPtp6VIuEtEB/nLGQJqcAJ2LWxhc05PoyWr5wZF8gMmbHTM2
        ADuYsLLkMSWr3yX/j/Z5v0yDa+Tp2q1cABNreOV+QTrHtOPP6SXc8Ske81OELMNWVvR613
        /ahgljVxTG2akxnhZXa9Soj/ZlujC2ECgzl9Usa7qzJyJ3G5/be3YU0/4qSX7UPvAQ8Uxc
        jnYoyijD3fep9LEncAlhn7lSZpKYbKljWydwwp1XQbXjlxduzu81XWZT/j+pFA==
Date:   Wed, 2 Nov 2022 10:35:56 +0100
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
Message-ID: <20221102103556.4f556d6c@booty>
In-Reply-To: <Y1wMGpthKxr2egtY@kadam>
References: <20221028081926.2320663-1-luca.ceresoli@bootlin.com>
        <Y1vMX/Zciz/XQ+4p@kadam>
        <20221028185847.5454a98d@booty>
        <Y1wMGpthKxr2egtY@kadam>
Organization: Bootlin
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Dan,

On Fri, 28 Oct 2022 20:06:34 +0300
Dan Carpenter <dan.carpenter@oracle.com> wrote:

> On Fri, Oct 28, 2022 at 06:58:47PM +0200, Luca Ceresoli wrote:
> > Hello Dan,
> > 
> > On Fri, 28 Oct 2022 15:34:39 +0300
> > Dan Carpenter <dan.carpenter@oracle.com> wrote:
> >   
> > > On Fri, Oct 28, 2022 at 10:19:26AM +0200, luca.ceresoli@bootlin.com wrote:  
> > > > From: Luca Ceresoli <luca.ceresoli@bootlin.com>
> > > > 
> > > > At probe time this code path is followed:
> > > > 
> > > >  * tegra_csi_init
> > > >    * tegra_csi_channels_alloc
> > > >      * for_each_child_of_node(node, channel) -- iterates over channels
> > > >        * automatically gets 'channel'
> > > >          * tegra_csi_channel_alloc()
> > > >            * saves into chan->of_node a pointer to the channel OF node
> > > >        * automatically gets and puts 'channel'
> > > >        * now the node saved in chan->of_node has refcount 0, can disappear
> > > >    * tegra_csi_channels_init
> > > >      * iterates over channels
> > > >        * tegra_csi_channel_init -- uses chan->of_node
> > > > 
> > > > After that, chan->of_node keeps storing the node until the device is
> > > > removed.
> > > > 
> > > > of_node_get() the node and of_node_put() it during teardown to avoid any
> > > > risk.
> > > > 
> > > > Fixes: 1ebaeb09830f ("media: tegra-video: Add support for external sensor capture")
> > > > Cc: stable@vger.kernel.org
> > > > Cc: Sowjanya Komatineni <skomatineni@nvidia.com>
> > > > Signed-off-by: Luca Ceresoli <luca.ceresoli@bootlin.com>
> > > > ---
> > > >  drivers/staging/media/tegra-video/csi.c | 3 ++-
> > > >  1 file changed, 2 insertions(+), 1 deletion(-)
> > > > 
> > > > diff --git a/drivers/staging/media/tegra-video/csi.c b/drivers/staging/media/tegra-video/csi.c
> > > > index b26e44adb2be..1b05f620b476 100644
> > > > --- a/drivers/staging/media/tegra-video/csi.c
> > > > +++ b/drivers/staging/media/tegra-video/csi.c
> > > > @@ -433,7 +433,7 @@ static int tegra_csi_channel_alloc(struct tegra_csi *csi,
> > > >  	for (i = 0; i < chan->numgangports; i++)
> > > >  		chan->csi_port_nums[i] = port_num + i * CSI_PORTS_PER_BRICK;
> > > >  
> > > > -	chan->of_node = node;
> > > > +	chan->of_node = of_node_get(node);
> > > >  	chan->numpads = num_pads;
> > > >  	if (num_pads & 0x2) {
> > > >  		chan->pads[0].flags = MEDIA_PAD_FL_SINK;
> > > > @@ -640,6 +640,7 @@ static void tegra_csi_channels_cleanup(struct tegra_csi *csi)
> > > >  			media_entity_cleanup(&subdev->entity);
> > > >  		}
> > > >  
> > > > +		of_node_put(chan->of_node);
> > > >  		list_del(&chan->list);
> > > >  		kfree(chan);    
> > > 
> > > Not related to your patch, but this kind of "one function cleans up
> > > everything" style is always buggy.  For example, here it should be:
> > > 
> > > -		if (chan->mipi)
> > > +		if (!IS_ERR_OR_NULL(chan->mipi))
> > > 			tegra_mipi_free(chan->mipi);  
> > 
> > I sort of agree the code could be clearer here, but looking at the code
> > in detail, this cannot happen. chan->mipi is set in one place only, and
> > if it is an error the whole probe fails. So it can be either NULL or a
> > valid pointer here.  
> 
> I assumed that tegra_csi_channels_cleanup() would clean up if
> tegra_csi_channel_alloc() fails.  Otherwise then that's several
> different even worse bugs.
> 
> HINT: Let's all hope my initial analysis was correct.

Indeed you have a point. Apologies for having replied in a hurry and for
the resulting noise.

I'm going to send a patch to fix the chan->mipi mess. However I think
the best way to do so would be a oneliner:

@@ -491,6 +491,7 @@ static int tegra_csi_channel_alloc(struct tegra_csi *csi,
        chan->mipi = tegra_mipi_request(csi->dev, node);
        if (IS_ERR(chan->mipi)) {
                ret = PTR_ERR(chan->mipi);
+               chan->mipi = NULL;
                dev_err(csi->dev, "failed to get mipi device: %d\n", ret);
        }

This would be a correct implementation of the initial intent as it can
be inferred from the code, i.e. chan->mipi being either NULL or a valid
pointer. This makes sense as chan->mipi is assigned in a single place.

-- 
Luca Ceresoli, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4985A5637C0
	for <lists+stable@lfdr.de>; Fri,  1 Jul 2022 18:22:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232063AbiGAQWl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Jul 2022 12:22:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232070AbiGAQW1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Jul 2022 12:22:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F40B13F8B1;
        Fri,  1 Jul 2022 09:22:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 582B46253E;
        Fri,  1 Jul 2022 16:22:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65E5AC3411E;
        Fri,  1 Jul 2022 16:22:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656692539;
        bh=lFbPb5+FqcYrOK1uW5XpecMCGdgJybKgfEFre34Au4s=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Zzp2gxzcPbyzz5AMjHlYWFC5yMv9RLrECQxN3zoX6hKozMnXameh4C/SSlXJ7Rdcg
         T1JkIzzpDPsnjmHOfz4kbOlW8+vluoDwgg7ty70Im5kBknZJ74eJoSomdSGmvkJORS
         Cej9YoQN3Ie+iufHVsuGEuz+7GsbTju3sNmPTSmGKIaF2JF8h3HexwViUtipna6dak
         NGLiRmIlZ7YDSL08TCDZyYOB/LwmB51I7sop7gxMUThdGtfsPa6toxL2O1k5dGi4ZZ
         r7W16x4ToFtZt02cb5ymKvDcPOmU5wYB2y908kFArDQEsLRvGw6USyEe4+aZfEUXvK
         IEny7cqVqwVdw==
Date:   Fri, 1 Jul 2022 17:31:53 +0100
From:   Jonathan Cameron <jic23@kernel.org>
To:     Andy Shevchenko <andy.shevchenko@gmail.com>
Cc:     Nishanth Menon <nm@ti.com>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        Nuno =?UTF-8?B?U8Oh?= <nuno.sa@analog.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Alexandru Ardelean <ardeleanalex@gmail.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-iio <linux-iio@vger.kernel.org>,
        Stable <stable@vger.kernel.org>
Subject: Re: [PATCH] iio: adc: ti-adc128s052: Fix number of channels when
 device tree is used
Message-ID: <20220701173153.04711237@jic23-huawei>
In-Reply-To: <CAHp75Vfm+NDzZEB1Qp-3+mbj=NOko=5jjcHr_A4J6-jMpTykhg@mail.gmail.com>
References: <20220630230107.13438-1-nm@ti.com>
        <CAHp75Vfm+NDzZEB1Qp-3+mbj=NOko=5jjcHr_A4J6-jMpTykhg@mail.gmail.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 1 Jul 2022 12:13:24 +0200
Andy Shevchenko <andy.shevchenko@gmail.com> wrote:

> On Fri, Jul 1, 2022 at 1:02 AM Nishanth Menon <nm@ti.com> wrote:
> >
> > When device_match_data is called - with device tree, of_match list is  
> 
> device_get_match_data() ?
> 
> > looked up to find the data, which by default is 0. So, no matter which
> > kind of device compatible we use, we match with config 0 which implies
> > we enable 8 channels even on devices that do not have 8 channels.
> >
> > Solve it by providing the match data similar to what we do with the ACPI
> > lookup information.
> >
> > Fixes: 9e611c9e5a20 ("iio: adc128s052: Add OF match table")
> > Cc: <stable@vger.kernel.org> # 5.0+
> > Signed-off-by: Nishanth Menon <nm@ti.com>  
> 
> ...
> 
> > +       { .compatible = "ti,adc128s052", .data = 0},  
> 
> No assignment, 0 _is_ the default here.
> 
> > +       { .compatible = "ti,adc122s021", .data = 1},
> > +       { .compatible = "ti,adc122s051", .data = 1},
> > +       { .compatible = "ti,adc122s101", .data = 1},
> > +       { .compatible = "ti,adc124s021", .data = 2},
> > +       { .compatible = "ti,adc124s051", .data = 2},
> > +       { .compatible = "ti,adc124s101", .data = 2},  
> 
> What you need _ideally_ is rather use pointers to data structure where
> each of that chip is defined, then it will be as simple as
> 
> 
> const struct my_custom_drvdata *data;
> 
> data = device_get_match_data(dev);
> 
> Where my_custom_drvdata::num_of_channels will be already assigned to
> whatever you want on a per chip basis.

Agreed. That's much nicer and a not a lot larger change so still suitable as a fix.

> 
> If the number of channels is the only data you have, then yes, cast it
> to void * in the OF ID table and

It's not just the number of channels.  This is an index into an array of chip
type specific structures. Hence the driver is half way to what you suggested.
Using a pointer for the ACPI and DT paths is the right way to do this.
For the spi_device_id table, you could stick with an index, or move to casting
a pointer to an integer, I don't really mind.

Thanks,

Jonathan

> 
> num = (uintptr_t)device_get_match_data(dev);
> 
> will suffice.
> 


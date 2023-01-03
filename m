Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D20F65C37D
	for <lists+stable@lfdr.de>; Tue,  3 Jan 2023 17:03:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233135AbjACQDj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Jan 2023 11:03:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230397AbjACQDe (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Jan 2023 11:03:34 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA62C112C;
        Tue,  3 Jan 2023 08:03:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=fxpXgnZwZOvzoJ655io/8wieYC6m5OZtZxEHi2BztSk=; b=Ybnfgp3O3ucnrfrTgPRsAdD4HD
        /l+4pneoWtKNsJDRAC9QmIReHEsETLEphSDUgWrmwqPlnbKFrZ4cUEx6yrk8C46BjEuynvHl6wm7g
        Jkc7bQCZcbnqq+I+RnJILnNDl/65hry+Tni0Gkbwi/ZPBZb7Mkrj3xFM68oVLkg99N6h9Yq4QWEEw
        H9QPVYCPvC0P/LySG5qWe23tcywTjYRlE6D5YcUwEGKLE44qxry+tnFCzczetS7v1Orw+r7lmVvMd
        BR7ALrZg3nHIZsA+mdjvn4QL7Ova9N5uvjB1lZ2uQpRxc2E7m7ZLh1KPJP6lgI4zdBofFRpZvgYtG
        U7zvvsxw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:35946)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pCjlC-0005YC-5j; Tue, 03 Jan 2023 16:03:29 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pCjl9-0002Co-Hd; Tue, 03 Jan 2023 16:03:27 +0000
Date:   Tue, 3 Jan 2023 16:03:27 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Hector Martin <marcan@marcan.st>
Cc:     Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Sven Peter <sven@svenpeter.dev>,
        Alyssa Rosenzweig <alyssa@rosenzweig.io>,
        asahi@lists.linux.dev, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Eric Curtin <ecurtin@redhat.com>
Subject: Re: [PATCH v2] nvmem: core: Fix race in nvmem_register()
Message-ID: <Y7RRz6nPwYlgwFk4@shell.armlinux.org.uk>
References: <20230103114427.1825-1-marcan@marcan.st>
 <ff77ba1c-8b67-4697-d713-0392d3b1d77a@linaro.org>
 <95a4cfde-490f-d26d-163e-7ab1400e7380@marcan.st>
 <b118af4c-e4cc-c50b-59aa-d768f1ec69ff@linaro.org>
 <b98e313d-8875-056b-4b64-bb7528f2670a@marcan.st>
 <Y7RHTXZ60zuExeMA@shell.armlinux.org.uk>
 <03514845-dfd6-a117-83c8-ab3abc402229@marcan.st>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <03514845-dfd6-a117-83c8-ab3abc402229@marcan.st>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 04, 2023 at 12:33:33AM +0900, Hector Martin wrote:
> On 04/01/2023 00.18, Russell King (Oracle) wrote:
> > On Tue, Jan 03, 2023 at 11:56:21PM +0900, Hector Martin wrote:
> >> On 03/01/2023 23.22, Srinivas Kandagatla wrote:
> >>>>>>    drivers/nvmem/core.c | 32 +++++++++++++++++---------------
> >>>>>>    1 file changed, 17 insertions(+), 15 deletions(-)
> >>>>>>
> >>>>>> diff --git a/drivers/nvmem/core.c b/drivers/nvmem/core.c
> >>>>>> index 321d7d63e068..606f428d6292 100644
> >>>>>> --- a/drivers/nvmem/core.c
> >>>>>> +++ b/drivers/nvmem/core.c
> >>>>>> @@ -822,11 +822,8 @@ struct nvmem_device *nvmem_register(const struct nvmem_config *config)
> >>>>>>    		break;
> >>>>>>    	}
> >>>>>>
> >>>>>> -	if (rval) {
> >>>>>> -		ida_free(&nvmem_ida, nvmem->id);
> >>>>>> -		kfree(nvmem);
> >>>>>> -		return ERR_PTR(rval);
> >>>>>> -	}
> >>>>>> +	if (rval)
> >>>>>> +		goto err_gpiod_put;
> >>>>>
> >>>>> Why was gpiod changes added to this patch, that should be a separate
> >>>>> patch/discussion, as this is not relevant to the issue that you are
> >>>>> reporting.
> >>>>
> >>>> Because freeing the device also does a gpiod_put in the destructor, so
> >>> This are clearly untested, And I dont want this to be in the middle to 
> >>> fix to the issue you are hitting.
> >>
> >> I somehow doubt you tested any of these error paths either. Nobody tests
> >> initialization error paths. That's why there was a gpio leak here to
> >> begin with.
> > 
> > Sadly, this is one of the biggest problems with error paths, they get
> > very little proper testing - and in most cases we're reliant on
> > reviewers spotting errors. That's why we much prefer the devm_* stuff,
> > but even that can be error-prone.
> > 
> >>> We should always be careful about untested changes, in this case gpiod 
> >>> has some conditions to check before doing a put. So the patch is 
> >>> incorrect as it is.
> >>
> >> Then the existing code is also incorrect as it is, because the device
> >> release callback is doing the same gpiod_put() already. I just moved it
> >> out since we are now registering the device later.
> > 
> > At the point where this change is being made (checking rval after
> > dev_set_name()) the struct device has not been initialised, so the
> > release callback will not be called. nvmem->wp_gpio will be leaked.
> 
> But later in the code where device_put() was being called would will be,
> and that callback is calling gpiod_put() unconditionally, which is why I
> am doing the same after moving the device registration later.
> 
> Is this wrong? Well,

I'm not going to read the rest of your rant, honestly it's really not
worth it. Let's just concentrate on trying to work out how best to fix
this crud.

Not only is there the issue with wp_gpio, but the whole IDA handling
is fscked as well, so there's many problems to be sorted out here,
and if we lump them all into one patch, we'll probably be getting to
the point of completely rewriting nvmem_register() making backports
extremely difficult.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!

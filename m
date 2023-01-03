Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46F3765C2DB
	for <lists+stable@lfdr.de>; Tue,  3 Jan 2023 16:18:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237742AbjACPSo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Jan 2023 10:18:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237560AbjACPSn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Jan 2023 10:18:43 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74EC6117D;
        Tue,  3 Jan 2023 07:18:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=w7EptUE+1pYwLJrjAPt57i48t7KkBjKC/pDt3vwzoQA=; b=xAteWS2AfpTJiQU/+/VqjzldDu
        ErFYqC04p8VjZCcLR4VsOPeOtJiqPfZfDVe1zC9u3V1hSck1T5ZHL/ZGBmJaxClyJA22H/Rwfg18+
        o1fm4/FQ7ddyn5nVu26ST/YAQKzSj124PFGjji7EQSZ+l3eTldqOlk1NKcgk6yVwlsIQmJeF4e2Sw
        6AvpAqr5TrX3pJtCnw1ugMID7cGFKxwf7fiZEET8F4G8Iel3YoyRAfuwx7zkjy+T++i52o2BxR2Fo
        hMJKnLyAhQVwLhLK7o1B6XOE27qu5bCl76ij2kFxzC/mKE1Q2IjNYqeNKesT8v2IWuZ1JrOYdkNlh
        Xle/xEqg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:35938)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pCj3n-0005UJ-9n; Tue, 03 Jan 2023 15:18:38 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pCj3l-0002AP-Rw; Tue, 03 Jan 2023 15:18:37 +0000
Date:   Tue, 3 Jan 2023 15:18:37 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Hector Martin <marcan@marcan.st>
Cc:     Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Sven Peter <sven@svenpeter.dev>,
        Alyssa Rosenzweig <alyssa@rosenzweig.io>,
        asahi@lists.linux.dev, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Eric Curtin <ecurtin@redhat.com>
Subject: Re: [PATCH v2] nvmem: core: Fix race in nvmem_register()
Message-ID: <Y7RHTXZ60zuExeMA@shell.armlinux.org.uk>
References: <20230103114427.1825-1-marcan@marcan.st>
 <ff77ba1c-8b67-4697-d713-0392d3b1d77a@linaro.org>
 <95a4cfde-490f-d26d-163e-7ab1400e7380@marcan.st>
 <b118af4c-e4cc-c50b-59aa-d768f1ec69ff@linaro.org>
 <b98e313d-8875-056b-4b64-bb7528f2670a@marcan.st>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b98e313d-8875-056b-4b64-bb7528f2670a@marcan.st>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 03, 2023 at 11:56:21PM +0900, Hector Martin wrote:
> On 03/01/2023 23.22, Srinivas Kandagatla wrote:
> >>>>    drivers/nvmem/core.c | 32 +++++++++++++++++---------------
> >>>>    1 file changed, 17 insertions(+), 15 deletions(-)
> >>>>
> >>>> diff --git a/drivers/nvmem/core.c b/drivers/nvmem/core.c
> >>>> index 321d7d63e068..606f428d6292 100644
> >>>> --- a/drivers/nvmem/core.c
> >>>> +++ b/drivers/nvmem/core.c
> >>>> @@ -822,11 +822,8 @@ struct nvmem_device *nvmem_register(const struct nvmem_config *config)
> >>>>    		break;
> >>>>    	}
> >>>>
> >>>> -	if (rval) {
> >>>> -		ida_free(&nvmem_ida, nvmem->id);
> >>>> -		kfree(nvmem);
> >>>> -		return ERR_PTR(rval);
> >>>> -	}
> >>>> +	if (rval)
> >>>> +		goto err_gpiod_put;
> >>>
> >>> Why was gpiod changes added to this patch, that should be a separate
> >>> patch/discussion, as this is not relevant to the issue that you are
> >>> reporting.
> >>
> >> Because freeing the device also does a gpiod_put in the destructor, so
> > This are clearly untested, And I dont want this to be in the middle to 
> > fix to the issue you are hitting.
> 
> I somehow doubt you tested any of these error paths either. Nobody tests
> initialization error paths. That's why there was a gpio leak here to
> begin with.

Sadly, this is one of the biggest problems with error paths, they get
very little proper testing - and in most cases we're reliant on
reviewers spotting errors. That's why we much prefer the devm_* stuff,
but even that can be error-prone.

> > We should always be careful about untested changes, in this case gpiod 
> > has some conditions to check before doing a put. So the patch is 
> > incorrect as it is.
> 
> Then the existing code is also incorrect as it is, because the device
> release callback is doing the same gpiod_put() already. I just moved it
> out since we are now registering the device later.

At the point where this change is being made (checking rval after
dev_set_name()) the struct device has not been initialised, so the
release callback will not be called. nvmem->wp_gpio will be leaked.

However, there may be bigger problems with wp_gpio - related to where
it can come from and what we do with it.

nvmem->wp_gpio has two sources - one of them is gpiod_get_optional(),
and we need to call gpiod_put() on that to drop the reference that
_this_ code acquired. The other is config->wp_gpio - we don't own
that reference, yet we call gpiod_put() on it. I'm not sure whether
config->wp_gpio is actually used anywhere - my grepping so far has
not found any users, but maybe Srivinas knows better.

Hence, sorting out the leak of wp_gpio needs more discussion, and it
would not be right to delay merging the fix for the very real race
that people hit today resulting in stuff not working while we try
to work out how wp_gpio should be handled.

So... always fix one problem in one patch. Sometimes a fix is not as
obvious as one may first think.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!

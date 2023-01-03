Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 379FC65C2EB
	for <lists+stable@lfdr.de>; Tue,  3 Jan 2023 16:23:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237551AbjACPWx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Jan 2023 10:22:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237757AbjACPWb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Jan 2023 10:22:31 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A459625F0;
        Tue,  3 Jan 2023 07:22:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=y1ul7efxZNAVNH9AU1USRVGMWta2/7di2SV8aglnj4o=; b=xMEN2rI6xG0UAfipPh0hKVsIlg
        TnH5O2c7xhrF8kY1cja6X/Cfa/Xp/rGZA3M1ITvuF7ldTXE9dnlxGh3sfMJ3ZljGwpL/PcLoMXcVW
        5jJV3zSSG9JhLFxISjM+PpxkhZnvjDsTJ8D5i7gaqastxyqEzpNIhOlHwlKH/FIAnHDkL1QpKCTD2
        +PeEvYFbL3NYuZFmachEM1lQyuhZuuMSnBuViDGrr7Zww4cjxHTdCSJGACjQIa9xni75OA42NY3R1
        W1yGfyRHQ8CrNBEIAEPRl2J7pV0mTwb4RW5Ah1IlRTeGS3o17zNU+53opb67S04kiI+zF8JjpiXRb
        le8Z/U+Q==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:35940)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pCj7S-0005Um-LB; Tue, 03 Jan 2023 15:22:26 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pCj7R-0002Aa-Lh; Tue, 03 Jan 2023 15:22:25 +0000
Date:   Tue, 3 Jan 2023 15:22:25 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Hector Martin <marcan@marcan.st>
Cc:     Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Sven Peter <sven@svenpeter.dev>,
        Alyssa Rosenzweig <alyssa@rosenzweig.io>,
        asahi@lists.linux.dev, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Eric Curtin <ecurtin@redhat.com>
Subject: Re: [PATCH v2] nvmem: core: Fix race in nvmem_register()
Message-ID: <Y7RIMeMoKD70NIcc@shell.armlinux.org.uk>
References: <20230103114427.1825-1-marcan@marcan.st>
 <ff77ba1c-8b67-4697-d713-0392d3b1d77a@linaro.org>
 <95a4cfde-490f-d26d-163e-7ab1400e7380@marcan.st>
 <Y7REcpXjxTlxv1Fp@shell.armlinux.org.uk>
 <ec2c2712-04fa-751d-9817-23ff4e0b7fb4@marcan.st>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ec2c2712-04fa-751d-9817-23ff4e0b7fb4@marcan.st>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 04, 2023 at 12:14:10AM +0900, Hector Martin wrote:
> On 04/01/2023 00.06, Russell King (Oracle) wrote:
> > Hi Hector,
> > 
> > On Tue, Jan 03, 2023 at 10:48:52PM +0900, Hector Martin wrote:
> >>>> @@ -822,11 +822,8 @@ struct nvmem_device *nvmem_register(const struct nvmem_config *config)
> >>>>   		break;
> >>>>   	}
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
> >> doing this is correct in every other instance below and maintains
> >> existing behavior, and it just so happens that this instance converges
> >> into the same codepath so it is correct to merge it, and it just so
> >> happens that the gpiod put was missing in this path to begin with so
> >> this becomes a drive-by bugfix.
> >>
> >> If you don't like it I can remove it (i.e. reintroduce the bug for no
> >> good reason) and you can submit this fix yourself, because I have no
> >> incentive to waste time submitting a separate patch to fix a GPIO leak
> >> in an error path corner case in a subsystem I don't own and I have much
> >> bigger things to spend my (increasingly lower and lower) willingness to
> >> fight for upstream submissions than this.
> >>
> >> Seriously, what is wrong with y'all kernel people. No other open source
> >> project wastes contributors' time with stupid nitpicks like this. I
> >> found a bug, I fixed it, I then fixed the issues you pointed out, and I
> >> don't have the time nor energy to fight over this kind of nonsense next.
> >> Do you want bugs fixed or not?
> > 
> > This is not nonsense. We have always had a policy of one fix/change
> > per patch, and in this case it makes complete and utter sense. Of
> > course, the interpretation of "one change" is a matter of opinion.
> 
> The change here is the race condition fix. That change involves adding
> an error cleanup path that involves a gpio_put(). Therefore it seems
> logical to actually use it in that one extra case that should've used it
> anyway, a few lines above.

The two are entirely unrelated. as I've already explained. The call
to device_register() happens _after_ the check for rval from the
dev_set_name() that you are changing. Moving device_register() doesn't
make the lack of gpiod_put() any better or worse than it was before.

That said, I'm now thinking that my patch is actually wrong, but for
a different reason unrelated to the gpiod issue. :(

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!

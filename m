Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACA0165C2B5
	for <lists+stable@lfdr.de>; Tue,  3 Jan 2023 16:07:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233296AbjACPGh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Jan 2023 10:06:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230337AbjACPGg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Jan 2023 10:06:36 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31B93205;
        Tue,  3 Jan 2023 07:06:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=Dgg2V3XdAJEAvAwCR53ObsS3ED5q+vl5crLxugRFVHE=; b=Fg7++s5QaEnwTPh2vp+uB7t1AM
        v6gzSQ7x8SZzKO8d6J9bZui2HnWApW4I+Gl9kyb8nJf7oS/LZ49FlHWGgPJU2aEuETMupzNRhsZf7
        4brMpKT8AkZ0eaFWbtOAeZ9ib/VRxP1aQfncbdFXCdd6HFEZNKmL+TvWGzTwiUyPK+ZyiDUcB7GpL
        bB8m2U9bMikSRc/uD6/D/iTiFs5V1+0k0IUTD5VOu0j0mXaUWMGwL/aSaaGWA4+zT/HrgfeMaY/7i
        gWioAQdBABkn4FV8l/Muy9U/PgGv85JkaIYxn9OiJzqjnfrBWNGePTvvBeOFt+7NDyxgvRf7fljD4
        0o39d+bA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:35934)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pCis1-0005T0-3e; Tue, 03 Jan 2023 15:06:28 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pCiry-00029I-9P; Tue, 03 Jan 2023 15:06:26 +0000
Date:   Tue, 3 Jan 2023 15:06:26 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Hector Martin <marcan@marcan.st>
Cc:     Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Sven Peter <sven@svenpeter.dev>,
        Alyssa Rosenzweig <alyssa@rosenzweig.io>,
        asahi@lists.linux.dev, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Eric Curtin <ecurtin@redhat.com>
Subject: Re: [PATCH v2] nvmem: core: Fix race in nvmem_register()
Message-ID: <Y7REcpXjxTlxv1Fp@shell.armlinux.org.uk>
References: <20230103114427.1825-1-marcan@marcan.st>
 <ff77ba1c-8b67-4697-d713-0392d3b1d77a@linaro.org>
 <95a4cfde-490f-d26d-163e-7ab1400e7380@marcan.st>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <95a4cfde-490f-d26d-163e-7ab1400e7380@marcan.st>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Hector,

On Tue, Jan 03, 2023 at 10:48:52PM +0900, Hector Martin wrote:
> >> @@ -822,11 +822,8 @@ struct nvmem_device *nvmem_register(const struct nvmem_config *config)
> >>   		break;
> >>   	}
> >>
> >> -	if (rval) {
> >> -		ida_free(&nvmem_ida, nvmem->id);
> >> -		kfree(nvmem);
> >> -		return ERR_PTR(rval);
> >> -	}
> >> +	if (rval)
> >> +		goto err_gpiod_put;
> > 
> > Why was gpiod changes added to this patch, that should be a separate 
> > patch/discussion, as this is not relevant to the issue that you are 
> > reporting.
> 
> Because freeing the device also does a gpiod_put in the destructor, so
> doing this is correct in every other instance below and maintains
> existing behavior, and it just so happens that this instance converges
> into the same codepath so it is correct to merge it, and it just so
> happens that the gpiod put was missing in this path to begin with so
> this becomes a drive-by bugfix.
> 
> If you don't like it I can remove it (i.e. reintroduce the bug for no
> good reason) and you can submit this fix yourself, because I have no
> incentive to waste time submitting a separate patch to fix a GPIO leak
> in an error path corner case in a subsystem I don't own and I have much
> bigger things to spend my (increasingly lower and lower) willingness to
> fight for upstream submissions than this.
> 
> Seriously, what is wrong with y'all kernel people. No other open source
> project wastes contributors' time with stupid nitpicks like this. I
> found a bug, I fixed it, I then fixed the issues you pointed out, and I
> don't have the time nor energy to fight over this kind of nonsense next.
> Do you want bugs fixed or not?

This is not nonsense. We have always had a policy of one fix/change
per patch, and in this case it makes complete and utter sense. Of
course, the interpretation of "one change" is a matter of opinion.

Your patch contains two bug fixes for problems:
1) publication of nvmem_device before it's fully setup (leading to the
   race) which has been around since the inception of nvmem stuff.
2) fixing a memory leak for gpiod stuff, caused by a recent patch
   5544e90c8126 ("nvmem: core: add error handling for dev_set_name")
   from September 2022.

Hence these two changes need different treatment for stable backporting,
with the former needing to be backported to more kernels than the
latter. So, it makes complete sense to split the two fixes into their
own separate patches.

Why are other projects happy to accept a patch that fixes multiple
issues? Maybe they work in different ways - maybe they don't backport
changes to older releases? Maybe they don't do multiple stable
versions like we do with the kernel.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!

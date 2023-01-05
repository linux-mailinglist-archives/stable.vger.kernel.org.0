Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D63165EAED
	for <lists+stable@lfdr.de>; Thu,  5 Jan 2023 13:47:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232845AbjAEMrw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Jan 2023 07:47:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232370AbjAEMru (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Jan 2023 07:47:50 -0500
Received: from smtp-out-08.comm2000.it (smtp-out-08.comm2000.it [212.97.32.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1B333B931
        for <stable@vger.kernel.org>; Thu,  5 Jan 2023 04:47:46 -0800 (PST)
Received: from francesco-nb.int.toradex.com (31-10-206-125.static.upc.ch [31.10.206.125])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: francesco@dolcini.it)
        by smtp-out-08.comm2000.it (Postfix) with ESMTPSA id AE8D6420F17;
        Thu,  5 Jan 2023 13:47:44 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=mailserver.it;
        s=mailsrv; t=1672922865;
        bh=7bFpsL453HyKnpFTYVsA8GiulGO4aIzlZZqiWerQDnc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To;
        b=ZuA/8o3DqN/jJk6jp0Tj51u7u0BUh70D58qzkW2BVlmkvtR4wkqVYMSzT2cSUYHq9
         xOcMctjqR7WTSKViEQCThyk7TesCKm8l3F71rR2jBoResqN2OFb/ywca3LRrhauaTI
         GudqHDLVbFNGIJpvHJmixP4a9wlRlgTg5XDvKp29yKKLDto8DNK4LNa7DRrKN4pG8H
         vH6u0VaaobJZ5jl3mR+gsjOOkkP7CCj+A9ff6o/S2xiGr+dkBk1fp8INNvVLoGyNgL
         /xYccta3YGuOb0LCPTEhJ+j01BpAY/kHZrwFCVJ09IKIdg1e0ImJ29qthltsWMQTVY
         29g+nq+o5uyxQ==
Date:   Thu, 5 Jan 2023 13:47:40 +0100
From:   Francesco Dolcini <francesco@dolcini.it>
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Francesco Dolcini <francesco@dolcini.it>,
        Marek Vasut <marex@denx.de>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        linux-mtd@lists.infradead.org,
        Francesco Dolcini <francesco.dolcini@toradex.com>,
        Shawn Guo <shawnguo@kernel.org>,
        linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org,
        u-boot@lists.denx.de
Subject: Re: [PATCH v1] mtd: parsers: ofpart: Fix parsing when size-cells is 0
Message-ID: <Y7bG7GFDMS6bmQ4d@francesco-nb.int.toradex.com>
References: <Y5wiAPvPU+YY39oX@francesco-nb.int.toradex.com>
 <6f5f5b32-d7fe-13cc-b52d-83a27bd9f53e@denx.de>
 <20221216120155.4b78e5cf@xps-13>
 <Y5xmi62hR6JeYUt1@francesco-nb.int.toradex.com>
 <20221216143720.3c8923d8@xps-13>
 <fb55a784-eda3-8916-1413-581b9436b3f2@denx.de>
 <20221216163501.1c2ace21@xps-13>
 <Y5ydGhn/qYUalamm@francesco-nb.int.toradex.com>
 <20230102104004.6abae6da@xps-13>
 <20230105123334.7f90c289@xps-13>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230105123334.7f90c289@xps-13>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Miquel,

On Thu, Jan 05, 2023 at 12:33:34PM +0100, Miquel Raynal wrote:
> miquel.raynal@bootlin.com wrote on Mon, 2 Jan 2023 10:40:04 +0100:
> > francesco@dolcini.it wrote on Fri, 16 Dec 2022 17:30:18 +0100:
> > > On Fri, Dec 16, 2022 at 04:35:01PM +0100, Miquel Raynal wrote:  
> > > > marex@denx.de wrote on Fri, 16 Dec 2022 15:32:28 +0100:    
> > > > > The second part of the message, as far as I understand it, is
> > > > > "ignore problems this will cause to users of boards we do not know
> > > > > about, let them run into unbootable systems after some linux kernel
> > > > > update,     
> > > > 
> > > > Now you know what kernel update will break them, so you can prevent it
> > > > from happening. 
> > > > 
> > > > For boards without even a dtsi in the kernel, should we care?    
> > > 
> > > Would caring for those boards not be just exact the same as caring for
> > > some UEFI/ACPI mess for which no source code is normally available and
> > > nobody really known at which point the various vendors have forked their
> > > source code from some Intel or AMD or whatever reference code?  
> > 
> > I am sorry I don't know UEFI/ACPI well enough to discuss it.
> > 
> > > IMHO we should care for the multiple reason I have already written in my
> > > previous emails.
> > > 
> > > And honestly, just as a side comment, I would feel way more happy
> > > to know that the elevator control system in the elevator I use everyday
> > > or the chemical industrial plan HMI next to my home is running an up to
> > > date Linux system that is not affected by known security vulnerabilities
> > > and they did stop updating it just because there was some random bug
> > > preventing the updated kernel to boot and nobody had the time/skill to
> > > investigate and fix it. [1]  
> > 
> > The issue comes from a very specific U-Boot function that should have
> > never existed. I hope people working on chemical plants do not make
> > use of these and will not disregard the "your DT is broken there [...]"
> > warning we plan to add right before their updated board will fail. We
> > are not living people in the dark, I agreed for a warning, but I don't
> > think applying the proposed fix blindly is wise and future-proof.
> 
> Let's move forward with this. Let's assume my fears are baseless. We
> might consider the situation where someone tries to hide the partitions
> by setting #size-cell to 0 even wronger and too unlikely. Hopefully we
> will not break any other existing setups by applying an always-on fix.

Nice, good!

> I would still like to see U-Boot partitions handling evolve, at least:
> - fix #size-cells in fdt_fixup_mtd()
> - avoid the fdt_fixup_mtd() call from Collibri boards (ie. an example
>   that can be followed by the other users)

Fine, I can do it. 

However I am just not 100% sure about your proposal, I wonder if we
should just deprecate this function or we should fix it.
The exact end result will depend on the discussion with the U-Boot
folks, but I absolutely agree that the current situation needs to
change. I'll keep you in CC on those patches.

> On Linux side let's fix #size-cells like you proposed without filtering
> against a list of compatibles. We however need to improve the
> heuristics:
> - Do it only when there are partitions declared within a NAND
>   controller node.
> - Change the warning to avoid mentioning backward compatibility, just
>   mention this is utterly wrong and thus the value will be set to 1
>   instead of 0.
> - Mention in the comment above this only works on systems with <4GiB
>   chips.
> If you think about other conditions please feel free to add them.
> 
> Do you concur?
Yes, I do agree.

Side comment, I have been recently busy with other life AND work priorities
and this task was just idling on the bottom of my backlog. I do not see
the situation improving that much in the next few weeks.

Said that patches coming, I am committed to have this sorted out before
the next Linux Kernel merge window, for U-Boot the merge window opens in
3 days and I am already late, let's see, this might be as well
considered a fix that is fine for a late integration.

Francesco


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 712F75BBC85
	for <lists+stable@lfdr.de>; Sun, 18 Sep 2022 10:26:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229515AbiIRI0m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Sep 2022 04:26:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbiIRI0l (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 18 Sep 2022 04:26:41 -0400
Received: from angie.orcam.me.uk (angie.orcam.me.uk [78.133.224.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A49EC23BFD;
        Sun, 18 Sep 2022 01:26:40 -0700 (PDT)
Received: by angie.orcam.me.uk (Postfix, from userid 500)
        id C201292009C; Sun, 18 Sep 2022 10:26:39 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by angie.orcam.me.uk (Postfix) with ESMTP id BB15C92009B;
        Sun, 18 Sep 2022 09:26:39 +0100 (BST)
Date:   Sun, 18 Sep 2022 09:26:39 +0100 (BST)
From:   "Maciej W. Rozycki" <macro@orcam.me.uk>
To:     Josh Triplett <josh@joshtriplett.org>
cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        Anders Blomdell <anders.blomdell@control.lth.se>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 0/2] serial: 8250: Let drivers request full 16550A feature
 probing
In-Reply-To: <0B189972-4FD8-4245-BF2F-ADEAB18AAAE0@joshtriplett.org>
Message-ID: <alpine.DEB.2.21.2209180906570.5908@angie.orcam.me.uk>
References: <alpine.DEB.2.21.2209162317180.19473@angie.orcam.me.uk> <0B189972-4FD8-4245-BF2F-ADEAB18AAAE0@joshtriplett.org>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, 17 Sep 2022, Josh Triplett wrote:

> > This small patch series fixes the issue by letting individual device 
> >subdrivers to request full 16550A device feature probing by means of a 
> >flag regardless of the SERIAL_8250_16550A_VARIANTS setting chosen.
> >
> > The changes have been verified with an OXPCIe952 device, in the native 
> >UART mode and a 64-bit RISC-V system as well as in the legacy UART mode 
> >and a 32-bit x86 system.
> 
> Seems reasonable to me, as long as the flag is only set by drivers that 
> know they've found their hardware.

 That has been my intent or otherwise the change would make no sense as 
far as I am concerned.

 In principle for most if not all PCI/e devices we could suppress UART 
probing altogether and still support device's features as we could infer 
the features from the vendor:device ID pair via a table of per-device 
flags.  This might even have worked if we started making one right from 
the beginning as individual devices were added to our 8250/PCI driver.

 Though I can imagine that for some devices no documentation was available 
to the contributor and it could have been hard to determine whether a 
feature actually discovered is really guaranteed for a given vendor:device 
ID or whether there are additional constraints, such as a device revision.  

 I imagine especially early PCI serial port devices may have used discrete 
UART chips behind a piece of PCI glue (just as we now see numerous PCIe 
devices with the actual device placed behind a PCIe-to-PCI bridge onboard) 
and then the set of features could have depended on the specific UART 
chips chosen which may have changed in the course of the life of product.

 At this point however I suspect it would be hard to (re)construct such a 
table and in any case it could have been a maintenance burden, so I guess 
we need to live with what we have.

 Thank you for your input.

  Maciej

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 249BF59B2BC
	for <lists+stable@lfdr.de>; Sun, 21 Aug 2022 10:21:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229834AbiHUIVc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 21 Aug 2022 04:21:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229820AbiHUIVa (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 21 Aug 2022 04:21:30 -0400
Received: from rfvt.org.uk (rfvt.org.uk [37.187.119.221])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D87FD1E3CA;
        Sun, 21 Aug 2022 01:21:28 -0700 (PDT)
Received: from wylie.me.uk (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by rfvt.org.uk (Postfix) with ESMTPS id 62B7182CC4;
        Sun, 21 Aug 2022 09:21:23 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=wylie.me.uk;
        s=mydkim005; t=1661070083;
        bh=u0WovpEjOWgoBz0CSgRBErAMzNvohbaXiC2A5f/5JtI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References;
        b=0sdPYW0VOcsrf7RGo88Dnk+AAsSUP7RQowrblg1JQ0I7stsbsgu29kNCqgyVGZwvG
         7r1qxVu8R6YwM1A68lAnSMJUPzKfebod5urMDAzi/yPaEStM7RHpA/K9FrZOjt3KuQ
         x3WOFUrrT5Bg1WoT8QhEBEtMue0vGqia9GwHgT1+owEMcfwD3jp0DjbTs70LR3vzsl
         9D7j8wmTYQcUZkViCJD+BbMaWYILs2uFd4z691c8LntisSDUP7DmdnGG0vJzyBSv/D
         F2OQ4AqEnrQsJaQkyvkU/aVZaqii5PavfBK6x9aG1A6vJjBci3Yl0Hg7RvsjTpQpqY
         RTRFbT9ss8rNw==
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <25345.60162.942383.502797@wylie.me.uk>
Date:   Sun, 21 Aug 2022 09:21:22 +0100
From:   "Alan J. Wylie" <alan@wylie.me.uk>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: Regression in 5.19.0: USB errors during boot
In-Reply-To: <20220821062345.GA26598@lst.de>
References: <25342.20092.262450.330346@wylie.me.uk>
        <Yv5Q8gDvVTGOHd8k@kroah.com>
        <20220821062345.GA26598@lst.de>
X-Mailer: VM 8.2.0b under 27.2 (x86_64-pc-linux-gnu)
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

at 08:23 on Sun 21-Aug-2022 Christoph Hellwig (hch@lst.de) wrote:

> On Thu, Aug 18, 2022 at 04:47:14PM +0200, Greg Kroah-Hartman wrote:
> > What is the output of the lspci -v for the USB 3 controller?
> > 
> > Christoph, any ideas?
>
> Well, with that commit it must be related to dma ops selection.
> As this appears to be an AMD system the options here are direct,
> amd_iommu and possibly amd_gart as the odd one in the mix.
>
> Alan, can you send me your .config?

I hope that with the following information there is no need for me to
do so.

It is indeed an old AMD CPU
  Model name:          AMD FX(tm)-4300 Quad-Core Processor
  CPU family:          21
  Model:               2

Comparing with another AMD system that doesn't show the problem,
I see that CONFIG_GART_IOMMU is only set on the one with the problem.

The configs have just had "make oldconfig" run on them for years, I
have no idea why one has it set.

Clearing it fixes the problem!

Thanks for the hint, although there is a still wider issue with this
regression.

$ diff .config.old  .config
353c353
< CONFIG_GART_IOMMU=y
---
> # CONFIG_GART_IOMMU is not set
4683d4682
< CONFIG_IOMMU_HELPER=y
4987d4985
< # CONFIG_IOMMU_DEBUG is not set
$

-- 
Alan J. Wylie                                          https://www.wylie.me.uk/

Dance like no-one's watching. / Encrypt like everyone is.
Security is inversely proportional to convenience

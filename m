Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95A1164EF26
	for <lists+stable@lfdr.de>; Fri, 16 Dec 2022 17:31:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231475AbiLPQbb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Dec 2022 11:31:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231682AbiLPQa4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Dec 2022 11:30:56 -0500
Received: from smtp-out-07.comm2000.it (smtp-out-07.comm2000.it [212.97.32.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E9E36DCDF
        for <stable@vger.kernel.org>; Fri, 16 Dec 2022 08:30:35 -0800 (PST)
Received: from francesco-nb.int.toradex.com (93-49-2-63.ip317.fastwebnet.it [93.49.2.63])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: francesco@dolcini.it)
        by smtp-out-07.comm2000.it (Postfix) with ESMTPSA id 58D0B3C91BB;
        Fri, 16 Dec 2022 17:30:27 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=mailserver.it;
        s=mailsrv; t=1671208233;
        bh=QuD3vviGMYLaRssF2NDncqKGvsdSjgCqIPf7dKm1D2A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To;
        b=yNFxzyoEkLGlHwXnBp/qUPl7/BCI8EA5FpUjJxSHwFhLmerOkD1q4gKyK45wTXPbY
         LE6eOEAe1chQ4U0CzzLBYx+XOM84Mo0UV+q4QJeGNa3repaD+gsLiF4N0V2UjbBaAj
         vQJuzJ0qcytsu9ocezcDjdaPY5bBOEJByBYQBvOmVjWnFJQqdKFXzckQFAUOXqxWPq
         o/meSmfxeojrdtbcbm2VgKcsix2T6watQg5oTeruHzfnOYxWWHH2rfjQrkosb9Mrs+
         hpd9VP2v1ftYvExo0539VM71YXetFBx7jJFPQmryjPtOR3HjUFcQZUfzUU5OXHbqtF
         SBtCvkJFgUnQw==
Date:   Fri, 16 Dec 2022 17:30:18 +0100
From:   Francesco Dolcini <francesco@dolcini.it>
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Marek Vasut <marex@denx.de>,
        Francesco Dolcini <francesco@dolcini.it>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        linux-mtd@lists.infradead.org,
        Francesco Dolcini <francesco.dolcini@toradex.com>,
        Shawn Guo <shawnguo@kernel.org>,
        linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org,
        u-boot@lists.denx.de
Subject: Re: [PATCH v1] mtd: parsers: ofpart: Fix parsing when size-cells is 0
Message-ID: <Y5ydGhn/qYUalamm@francesco-nb.int.toradex.com>
References: <Y5wiAPvPU+YY39oX@francesco-nb.int.toradex.com>
 <6f5f5b32-d7fe-13cc-b52d-83a27bd9f53e@denx.de>
 <20221216120155.4b78e5cf@xps-13>
 <Y5xmi62hR6JeYUt1@francesco-nb.int.toradex.com>
 <20221216143720.3c8923d8@xps-13>
 <fb55a784-eda3-8916-1413-581b9436b3f2@denx.de>
 <20221216163501.1c2ace21@xps-13>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221216163501.1c2ace21@xps-13>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Dec 16, 2022 at 04:35:01PM +0100, Miquel Raynal wrote:
> marex@denx.de wrote on Fri, 16 Dec 2022 15:32:28 +0100:
> > The second part of the message, as far as I understand it, is
> > "ignore problems this will cause to users of boards we do not know
> > about, let them run into unbootable systems after some linux kernel
> > update, 
> 
> Now you know what kernel update will break them, so you can prevent it
> from happening. 
> 
> For boards without even a dtsi in the kernel, should we care?

Would caring for those boards not be just exact the same as caring for
some UEFI/ACPI mess for which no source code is normally available and
nobody really known at which point the various vendors have forked their
source code from some Intel or AMD or whatever reference code?

IMHO we should care for the multiple reason I have already written in my
previous emails.

And honestly, just as a side comment, I would feel way more happy
to know that the elevator control system in the elevator I use everyday
or the chemical industrial plan HMI next to my home is running an up to
date Linux system that is not affected by known security vulnerabilities
and they did stop updating it just because there was some random bug
preventing the updated kernel to boot and nobody had the time/skill to
investigate and fix it. [1]

Francesco

[1] this is pure fictional, I have no elevator in my condo and no
industrial plant next to my home :-), yet I know that this non upstream
boards we are talking about are used every day in such environments ...


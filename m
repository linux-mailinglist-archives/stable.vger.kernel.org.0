Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FF6D64E7EF
	for <lists+stable@lfdr.de>; Fri, 16 Dec 2022 08:52:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229495AbiLPHwx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Dec 2022 02:52:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229639AbiLPHww (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Dec 2022 02:52:52 -0500
Received: from smtp-out-08.comm2000.it (smtp-out-08.comm2000.it [212.97.32.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7067520986
        for <stable@vger.kernel.org>; Thu, 15 Dec 2022 23:52:51 -0800 (PST)
Received: from francesco-nb.int.toradex.com (93-49-2-63.ip317.fastwebnet.it [93.49.2.63])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: francesco@dolcini.it)
        by smtp-out-08.comm2000.it (Postfix) with ESMTPSA id A9CB6426668;
        Fri, 16 Dec 2022 08:52:49 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=mailserver.it;
        s=mailsrv; t=1671177169;
        bh=HLaXNaF9mrgP2DSCe+1XOpANqOwz9+kAh1gAdGINbZY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To;
        b=gvIZykeGYsqzYQGmpktJ/UnYaqy6LxNezbUxGv+MY1T4LWECVJz67SOMBZYOSUQ3b
         ME65aUaExHrdzqsYD91ULBZVqrRC2ramAlirxP/Ju1uWFlII7LTIqU2HKJsVets3cq
         IJBeEEl+KWfgRzPWWAlUZnZHNW/w7HrPKErYq3RYy9qwAhf6OIUqrSQ49O2aPNTOg2
         s2TyPkDvzLN5qsClutosEJBhfvKOWSdwmQoW80m1JhfzPX4ibffwojnkiANf+kGGKB
         Bd+szTsnxVzJXzlqilCizlt4P/3UKOOWUgJs6QDZM5EGokAzpFizJQi5cqFCoaAL6b
         XWf6V4fhO1Mbg==
Date:   Fri, 16 Dec 2022 08:52:48 +0100
From:   Francesco Dolcini <francesco@dolcini.it>
To:     Marek Vasut <marex@denx.de>
Cc:     Miquel Raynal <miquel.raynal@bootlin.com>,
        Francesco Dolcini <francesco@dolcini.it>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        linux-mtd@lists.infradead.org,
        Francesco Dolcini <francesco.dolcini@toradex.com>,
        Shawn Guo <shawnguo@kernel.org>,
        linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org,
        u-boot@lists.denx.de
Subject: Re: [PATCH v1] mtd: parsers: ofpart: Fix parsing when size-cells is 0
Message-ID: <Y5wj0BHKBYvNRFFK@francesco-nb.int.toradex.com>
References: <e80377c9-1542-d47d-6d35-2efdc15bcbf8@denx.de>
 <20221202175730.231d75d5@xps-13>
 <7afd364c-33b8-38a9-65a6-015b4360db6b@denx.de>
 <Y43VdPftDbq6cD2L@francesco-nb.int.toradex.com>
 <20221205144917.6514168a@xps-13>
 <ecca019d-b0b7-630c-4221-2684cb51634c@denx.de>
 <20221215081604.5385fa56@xps-13>
 <ac50a1ee-4312-48f6-af78-7b95a77e6fda@denx.de>
 <20221215090446.28363133@xps-13>
 <a54bf573-c14a-a546-10fc-e50274986ff5@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a54bf573-c14a-a546-10fc-e50274986ff5@denx.de>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Dec 16, 2022 at 01:36:03AM +0100, Marek Vasut wrote:
> On 12/15/22 09:04, Miquel Raynal wrote:
> > > > That would fix all cases and only have an impact on the affected
> > > > boards.
> > > 
> > > Sadly, it does only fix the known cases, not the unknown cases
> > > like downstream forks which never get any bootloader updates ever,
> > > and which you can't find in upstream U-Boot, and which you
> > > therefore cannot easily catch in the arch side fixup.
> > 
> > And ?
> 
> I was under the impression Linux was supposed to deliver the best possible
> experience to its users even on not-perfect hardware, and if there are any
> quirks, the kernel should try to fix them up or work around them as best as
> it can, not dismiss them as broken hardware and fail to boot outright.

I would say something more on this.

We are not talking about Linux not working well on some hardware, we are
talking about breaking hardware that was working fine since ever.
I believe that the Linux has a quite strong point of view on such kind
of regression.

Quoting Linus
> If the kernel used to work for you, the rule is that it continues to work for you.

Francesco


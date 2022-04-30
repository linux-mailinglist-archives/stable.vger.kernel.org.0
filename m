Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD62B515E96
	for <lists+stable@lfdr.de>; Sat, 30 Apr 2022 17:09:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233664AbiD3PMs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 30 Apr 2022 11:12:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242596AbiD3PMq (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 30 Apr 2022 11:12:46 -0400
Received: from angie.orcam.me.uk (angie.orcam.me.uk [78.133.224.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E44EB49CB0;
        Sat, 30 Apr 2022 08:09:24 -0700 (PDT)
Received: by angie.orcam.me.uk (Postfix, from userid 500)
        id 2EDE592009C; Sat, 30 Apr 2022 17:09:24 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by angie.orcam.me.uk (Postfix) with ESMTP id 2799B92009B;
        Sat, 30 Apr 2022 16:09:24 +0100 (BST)
Date:   Sat, 30 Apr 2022 16:09:24 +0100 (BST)
From:   "Maciej W. Rozycki" <macro@orcam.me.uk>
To:     Stephen Zhang <starzhangzsd@gmail.com>
cc:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Joshua Kinard <kumba@gentoo.org>, linux-mips@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/2] MIPS: IP27: Remove incorrect `cpu_has_fpu'
 override
In-Reply-To: <CANubcdU99rke6AM4bQEyPNTkJbk1kMit1UVyDggTwTciTUeQMA@mail.gmail.com>
Message-ID: <alpine.DEB.2.21.2204301607380.9383@angie.orcam.me.uk>
References: <alpine.DEB.2.21.2204291523460.9383@angie.orcam.me.uk> <alpine.DEB.2.21.2204291529070.9383@angie.orcam.me.uk> <CANubcdU99rke6AM4bQEyPNTkJbk1kMit1UVyDggTwTciTUeQMA@mail.gmail.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, 30 Apr 2022, Stephen Zhang wrote:

> > Remove unsupported forcing of `cpu_has_fpu' to 1, which makes the `nofpu'
> > kernel parameter non-functional, and also causes a link error:
> >
> > ld: arch/mips/kernel/traps.o: in function `trap_init':
> > ./arch/mips/include/asm/msa.h:(.init.text+0x348): undefined reference to `handle_fpe'
> > ld: ./arch/mips/include/asm/msa.h:(.init.text+0x354): undefined reference to `handle_fpe'
> > ld: ./arch/mips/include/asm/msa.h:(.init.text+0x360): undefined reference to `handle_fpe'
> >
> > where the CONFIG_MIPS_FP_SUPPORT configuration option has been chosen.
> >
> 
> Sorry, but I have a question. From the code in
> arch/mips/kernel/genex.S:567, 'handle_fpe’‘s
>  definition is controlled by CONFIG_MIPS_FP_SUPPORT. Then how can it
> still report such
> error when the CONFIG_MIPS_FP_SUPPORT configuration option has been chosen.

 Good catch, thanks!  For some reason I inverted the condition in my mind 
as I wrote the change description.  I have now posted v2 with the mistake 
corrected.

  Maciej

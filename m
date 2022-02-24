Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 668B64C33E4
	for <lists+stable@lfdr.de>; Thu, 24 Feb 2022 18:42:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230522AbiBXRlw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Feb 2022 12:41:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229909AbiBXRlv (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Feb 2022 12:41:51 -0500
Received: from gate.crashing.org (gate.crashing.org [63.228.1.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 464B61C2DAA;
        Thu, 24 Feb 2022 09:41:21 -0800 (PST)
Received: from gate.crashing.org (localhost.localdomain [127.0.0.1])
        by gate.crashing.org (8.14.1/8.14.1) with ESMTP id 21OHbDJC020019;
        Thu, 24 Feb 2022 11:37:13 -0600
Received: (from segher@localhost)
        by gate.crashing.org (8.14.1/8.14.1/Submit) id 21OHbDNV020018;
        Thu, 24 Feb 2022 11:37:13 -0600
X-Authentication-Warning: gate.crashing.org: segher set sender to segher@kernel.crashing.org using -f
Date:   Thu, 24 Feb 2022 11:37:13 -0600
From:   Segher Boessenkool <segher@kernel.crashing.org>
To:     Michael Ellerman <mpe@ellerman.id.au>
Cc:     Anders Roxell <anders.roxell@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 2/3] powerpc: fix build errors
Message-ID: <20220224173713.GO614@gate.crashing.org>
References: <20220223135820.2252470-1-anders.roxell@linaro.org> <20220223135820.2252470-2-anders.roxell@linaro.org> <871qzsphfv.fsf@mpe.ellerman.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <871qzsphfv.fsf@mpe.ellerman.id.au>
User-Agent: Mutt/1.4.2.3i
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 24, 2022 at 11:39:16PM +1100, Michael Ellerman wrote:
> >  	/* Calculate the parity of the value */
> > -	asm ("popcntd %0,%1" : "=r" (parity) : "r" (val));
> > +	asm (".machine \"push\"\n"
> > +	     ".machine \"power7\"\n"
> > +	     "popcntd %0,%1\n"
> > +	     ".machine \"pop\"\n"
> > +	     : "=r" (parity) : "r" (val));
> 
> This was actually present in an older CPU, but it doesn't really matter,
> this is fine.

popcntd was new on p7 (popcntb is the older one :-) )  And it does not
matter indeed.


Segher

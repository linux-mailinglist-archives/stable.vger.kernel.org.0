Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDB663EED8D
	for <lists+stable@lfdr.de>; Tue, 17 Aug 2021 15:36:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236488AbhHQNgk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Aug 2021 09:36:40 -0400
Received: from angie.orcam.me.uk ([78.133.224.34]:33052 "EHLO
        angie.orcam.me.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235092AbhHQNgj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Aug 2021 09:36:39 -0400
Received: by angie.orcam.me.uk (Postfix, from userid 500)
        id 33F2A92009D; Tue, 17 Aug 2021 15:36:05 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by angie.orcam.me.uk (Postfix) with ESMTP id 2CC7592009B;
        Tue, 17 Aug 2021 15:36:05 +0200 (CEST)
Date:   Tue, 17 Aug 2021 15:36:05 +0200 (CEST)
From:   "Maciej W. Rozycki" <macro@orcam.me.uk>
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>
cc:     Jan-Benedict Glaw <jbglaw@lug-owl.de>,
        Ralf Baechle <ralf@linux-mips.org>,
        Paul Burton <paulburton@kernel.org>,
        James Hogan <jhogan@kernel.org>, linux-mips@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: build failure of mips decstation_r4k_defconfig with
 binutils-2_37
In-Reply-To: <YRujeISiIjKF5eAi@debian>
Message-ID: <alpine.DEB.2.21.2108171528360.45958@angie.orcam.me.uk>
References: <YRujeISiIjKF5eAi@debian>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 17 Aug 2021, Sudip Mukherjee wrote:

> While I was testing v5.4.142-rc2 I noticed mips build of
> decstation_r4k_defconfig fails with binutils-2_37. The error is:
> 
> arch/mips/dec/prom/locore.S: Assembler messages:
> arch/mips/dec/prom/locore.S:29: Error: opcode not supported on this
> processor: r4600 (mips3) `rfe'
> 
> I have also reported this at https://sourceware.org/bugzilla/show_bug.cgi?id=28241

 Thanks.  I have known it for a while thanks to an earlier report from 
Jan-Benedict Glaw, but didn't get to fixing it.  I mean to address it 
sometime later this month or early Sep the latest.

 This file shouldn't be built for R4k configurations in the first place 
because they use the REX firmware exclusively, which this source has 
nothing to do with.  A trivial fix would be to override the ISA level 
temporarily across RFE, but that's missing the point as it's dead code 
anyway with R4k.  OTOH a proper fix requires proper verification.

 As a workaround use older binutils for the time being.  Apologies for the 
inconvenience.

  Maciej

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0AC43EEDAB
	for <lists+stable@lfdr.de>; Tue, 17 Aug 2021 15:47:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236635AbhHQNrp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Aug 2021 09:47:45 -0400
Received: from angie.orcam.me.uk ([78.133.224.34]:33062 "EHLO
        angie.orcam.me.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235092AbhHQNrp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Aug 2021 09:47:45 -0400
Received: by angie.orcam.me.uk (Postfix, from userid 500)
        id EC45192009C; Tue, 17 Aug 2021 15:47:10 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by angie.orcam.me.uk (Postfix) with ESMTP id E657F92009B;
        Tue, 17 Aug 2021 15:47:10 +0200 (CEST)
Date:   Tue, 17 Aug 2021 15:47:10 +0200 (CEST)
From:   "Maciej W. Rozycki" <macro@orcam.me.uk>
To:     Ralf Baechle <ralf@linux-mips.org>
cc:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Paul Burton <paulburton@kernel.org>,
        James Hogan <jhogan@kernel.org>, linux-mips@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: build failure of mips decstation_r4k_defconfig with
 binutils-2_37
In-Reply-To: <YRuxrfYxahPbHmXl@linux-mips.org>
Message-ID: <alpine.DEB.2.21.2108171536240.45958@angie.orcam.me.uk>
References: <YRujeISiIjKF5eAi@debian> <YRuxrfYxahPbHmXl@linux-mips.org>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 17 Aug 2021, Ralf Baechle wrote:

> > While I was testing v5.4.142-rc2 I noticed mips build of
> > decstation_r4k_defconfig fails with binutils-2_37. The error is:
> > 
> > arch/mips/dec/prom/locore.S: Assembler messages:
> > arch/mips/dec/prom/locore.S:29: Error: opcode not supported on this
> > processor: r4600 (mips3) `rfe'
> > 
> > I have also reported this at https://sourceware.org/bugzilla/show_bug.cgi?id=28241
> 
> It would appear gas got more anal about ISA checking for the RFE instructions
> which did only exist in MIPS I and II; MIPS III and later use ERET for
> returning from an exception.

 Yes, I made such a change when I discovered the mess around coprocessor 
instructions in binutils earlier this year.  Eighteen patches total to 
straighten it out.  Some instructions were misassembled even, and no 
proper subsetting was made, so you could come with a nonsensical mixture 
when disassembling.  And RFE was disassembled as `c0 0x10' regardless of 
the ISA chosen.

> It should be fixable by simply putting gas into mips1 mode.  Can you test
> below patch?

 But it's missing the point, as I noted in the other message.  I've been 
too busy with higher priority stuff to get to a proper fix right away (I 
thought I was the last one using the DECstation, and especially with the 
top of the tree binutils).

  Maciej

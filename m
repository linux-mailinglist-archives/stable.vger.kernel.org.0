Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4FEF5BC439
	for <lists+stable@lfdr.de>; Mon, 19 Sep 2022 10:23:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229690AbiISIXg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Sep 2022 04:23:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230022AbiISISf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Sep 2022 04:18:35 -0400
Received: from angie.orcam.me.uk (angie.orcam.me.uk [IPv6:2001:4190:8020::34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9090320F5B;
        Mon, 19 Sep 2022 01:18:28 -0700 (PDT)
Received: by angie.orcam.me.uk (Postfix, from userid 500)
        id B428992009D; Mon, 19 Sep 2022 10:18:26 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by angie.orcam.me.uk (Postfix) with ESMTP id AD9D892009C;
        Mon, 19 Sep 2022 09:18:26 +0100 (BST)
Date:   Mon, 19 Sep 2022 09:18:26 +0100 (BST)
From:   "Maciej W. Rozycki" <macro@orcam.me.uk>
To:     Jiri Slaby <jirislaby@kernel.org>
cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Josh Triplett <josh@joshtriplett.org>,
        Anders Blomdell <anders.blomdell@control.lth.se>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 1/2] serial: 8250: Let drivers request full 16550A feature
 probing
In-Reply-To: <8fa701a1-3f34-9152-daf6-1618dd0e7727@kernel.org>
Message-ID: <alpine.DEB.2.21.2209190911540.14808@angie.orcam.me.uk>
References: <alpine.DEB.2.21.2209162317180.19473@angie.orcam.me.uk> <alpine.DEB.2.21.2209171043270.31781@angie.orcam.me.uk> <8fa701a1-3f34-9152-daf6-1618dd0e7727@kernel.org>
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

On Mon, 19 Sep 2022, Jiri Slaby wrote:

> > --- linux-macro.orig/include/linux/serial_core.h
> > +++ linux-macro/include/linux/serial_core.h
> > @@ -414,7 +414,7 @@ struct uart_icount {
> >   	__u32	buf_overrun;
> >   };
> >   -typedef unsigned int __bitwise upf_t;
> > +typedef __u64 __bitwise upf_t;
> 
> Why __u64 and not u64?

 For consistency as there's `__u32' used elsewhere in this file.  It's not 
clear to me what our rules WRT the use of `s*'/`u*' vs `__s*'/`__u*' are.  
I don't think we have it mentioned under Documentation/.  Please clarify 
if you know and I can update the change accordingly.

> > @@ -522,6 +522,7 @@ struct uart_port {
> >   #define UPF_FIXED_PORT		((__force upf_t) (1 << 29))
> >   #define UPF_DEAD		((__force upf_t) (1 << 30))
> >   #define UPF_IOREMAP		((__force upf_t) (1 << 31))
> > +#define UPF_FULL_PROBE		((__force upf_t) (1ULL << 32))
> 
> This looks like a perfect time to switch them all to BIT_ULL().

 Good point, I keep forgetting about that macro.  I'll keep this part 
unchanged for the purpose of backporting and add 3/3 to switch all the 
macros over.

  Maciej

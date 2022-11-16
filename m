Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42F1762BC7D
	for <lists+stable@lfdr.de>; Wed, 16 Nov 2022 12:50:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231397AbiKPLuM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Nov 2022 06:50:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238454AbiKPLtv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Nov 2022 06:49:51 -0500
Received: from angie.orcam.me.uk (angie.orcam.me.uk [IPv6:2001:4190:8020::34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3F3F232043
        for <stable@vger.kernel.org>; Wed, 16 Nov 2022 03:37:30 -0800 (PST)
Received: by angie.orcam.me.uk (Postfix, from userid 500)
        id 97F3692009C; Wed, 16 Nov 2022 12:37:26 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by angie.orcam.me.uk (Postfix) with ESMTP id 90DD792009B;
        Wed, 16 Nov 2022 11:37:26 +0000 (GMT)
Date:   Wed, 16 Nov 2022 11:37:26 +0000 (GMT)
From:   "Maciej W. Rozycki" <macro@orcam.me.uk>
To:     Pavel Machek <pavel@denx.de>
cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, patches@lists.linux.dev,
        Anders Blomdell <anders.blomdell@control.lth.se>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 001/118] serial: 8250: Let drivers request full
 16550A feature probing
In-Reply-To: <Y3S4ZT9Vz8VmU3Zw@duo.ucw.cz>
Message-ID: <alpine.DEB.2.21.2211161050470.54611@angie.orcam.me.uk>
References: <20221108133340.718216105@linuxfoundation.org> <20221108133340.777783271@linuxfoundation.org> <Y3S4ZT9Vz8VmU3Zw@duo.ucw.cz>
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

On Wed, 16 Nov 2022, Pavel Machek wrote:

> > From: Maciej W. Rozycki <macro@orcam.me.uk>
> > 
> > [ Upstream commit 9906890c89e4dbd900ed87ad3040080339a7f411 ]
> > 
> > A SERIAL_8250_16550A_VARIANTS configuration option has been recently
> > defined that lets one request the 8250 driver not to probe for 16550A
> > device features so as to reduce the driver's device startup time in
> > virtual machines.
> > 
> > Some actual hardware devices require these features to have been fully
> > determined however for their driver to work correctly, so define a flag
> > to let drivers request full 16550A feature probing on a device-by-device
> > basis if required regardless of the SERIAL_8250_16550A_VARIANTS option
> > setting chosen.
> > 
> > Fixes: dc56ecb81a0a ("serial: 8250: Support disabling mdelay-filled probes of 16550A variants")
> > Cc: stable@vger.kernel.org # v5.6+
> 
> You said you'd drop this. It is still unused in 5.10.155, as flag is
> never set.

 Right.  Technically it fixes a problem introduced in v5.6, but it wasn't 
exposed until commit 00b7a4d4ee42 ("serial: 8250: Request full 16550A 
feature probing for OxSemi PCIe devices") in v5.19 (unless, of course 
another UART broke that we don't know of).  I agree it's OK to drop this 
change in this case.

  Maciej

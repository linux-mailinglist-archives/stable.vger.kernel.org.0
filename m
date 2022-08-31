Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A3695A7940
	for <lists+stable@lfdr.de>; Wed, 31 Aug 2022 10:43:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229449AbiHaIny (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 31 Aug 2022 04:43:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231533AbiHaInw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 31 Aug 2022 04:43:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D51F6B654D;
        Wed, 31 Aug 2022 01:43:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7187C619FE;
        Wed, 31 Aug 2022 08:43:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6B32C433D6;
        Wed, 31 Aug 2022 08:43:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661935430;
        bh=dm+pvJSM/8LOzQK4c/qlkqG81fhAs6PnuK9pqgoP4XU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ldbpOVcqHGil33wvOXJaontPgzI7+5Q3/7q+PyDzfjzndsSgw+y0Z2O1/AsVM5Ci9
         UUQ7pZScIFhSn9hjOzb2F94fBZYBGkWeUNtghnPTE2ksvnIUD+j013IFUPmajOp9Ei
         4bXCzVdd63xahb1Bn1wk+tn5+SIFHXlXe+JG/QhUP/hVL1gVOtbSnpKZRDoQrr+70B
         IoCE9ljyB52RJTjno+gWYY+n8lw/GmqG0h+EzWI1rJgbVIQ2Le0Rq9/hcrpgqXTZIJ
         FS2wG4bvsdiQSiI6gdMQRWSkjAupz0qA2rLdv6AYd6nkVmQuUZSpLWIcOkavtQlo6K
         hO0dXdJcbn7CQ==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1oTJK7-0000nY-6Q; Wed, 31 Aug 2022 10:43:47 +0200
Date:   Wed, 31 Aug 2022 10:43:47 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Jiri Slaby <jirislaby@kernel.org>
Cc:     Jonathan Woithe <jwoithe@just42.net>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/2] USB: serial: ch341: fix lost character on LCR updates
Message-ID: <Yw8fQz2amdKKYNvS@hovoldconsulting.com>
References: <20220831081525.30557-1-johan@kernel.org>
 <20220831081525.30557-2-johan@kernel.org>
 <863b4190-9b38-ed5a-0a18-74505702da21@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <863b4190-9b38-ed5a-0a18-74505702da21@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 31, 2022 at 10:36:18AM +0200, Jiri Slaby wrote:
> On 31. 08. 22, 10:15, Johan Hovold wrote:
> > Disable LCR updates for pre-0x30 devices which use a different (unknown)
> > protocol for line control and where the current register write causes
> > the next received character to be lost.
> > 
> > Note that updating LCR using the INIT command has no effect on these
> > devices either.
> > 
> > Reported-by: Jonathan Woithe <jwoithe@just42.net>
> > Link: https://lore.kernel.org/r/Ys1iPTfiZRWj2gXs@marvin.atrad.com.au
> > Fixes: 4e46c410e050 ("USB: serial: ch341: reinitialize chip on reconfiguration")
> > Fixes: 55fa15b5987d ("USB: serial: ch341: fix baud rate and line-control handling")
> > Cc: stable@vger.kernel.org      # 4.10
> > Signed-off-by: Johan Hovold <johan@kernel.org>
> > ---
> >   drivers/usb/serial/ch341.c | 10 +++++++++-
> >   1 file changed, 9 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/usb/serial/ch341.c b/drivers/usb/serial/ch341.c
> > index 2798fca71261..2bcce172355b 100644
> > --- a/drivers/usb/serial/ch341.c
> > +++ b/drivers/usb/serial/ch341.c
> > @@ -97,7 +97,10 @@ struct ch341_private {
> >   	u8 mcr;
> >   	u8 msr;
> >   	u8 lcr;
> > +
> >   	unsigned long quirks;
> > +	u8 version;
> 
> Could you move version above quirks? That would not create another 
> 7-byte padding in here. Actually it would not make ch341_private larger 
> on 64bit at all, if I am looking correctly.

No, I added it after quirks on purpose as it isn't protected by the
spinlock and doesn't change during runtime like the shadow registers.

And I really don't care about saving 8 bytes on 64-bit. :)

Johan

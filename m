Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C22337FAA9
	for <lists+stable@lfdr.de>; Thu, 13 May 2021 17:25:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234259AbhEMP1B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 May 2021 11:27:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:40308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234885AbhEMP0r (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 May 2021 11:26:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 28E59613BF;
        Thu, 13 May 2021 15:25:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620919537;
        bh=foFE/3HGOiVwbmdkUBxDhc/bQzdfVzKQdZ5U+jRRBo8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=zC2/654ihZIAJmLWlcLGHhhZ1b6DjiC8KyZKalOZoHGWeOHN1usLxRYd0FgnT6NFW
         Bqeu9qM5BTIBTrnMs6O2Nr6bQE1DHG1chhKWnUrz2uXLjs/zvaaCB22q1zYAvpPgip
         mCpf65HjypoCRbOdvInt/3AoLEznLv6cr0ebivb0=
Date:   Thu, 13 May 2021 17:25:35 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jacek Anaszewski <jacek.anaszewski@gmail.com>
Cc:     linux-kernel@vger.kernel.org,
        Phillip Potter <phil@philpotter.co.uk>,
        stable <stable@vger.kernel.org>,
        Linux LED Subsystem <linux-leds@vger.kernel.org>,
        Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH 09/69] leds: lp5523: check return value of lp5xx_read and
 jump to cleanup code
Message-ID: <YJ1E7/2f0OXVHR2V@kroah.com>
References: <20210503115736.2104747-1-gregkh@linuxfoundation.org>
 <20210503115736.2104747-10-gregkh@linuxfoundation.org>
 <f821d2a3-3801-66a6-3c5b-0e00a8289ec1@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f821d2a3-3801-66a6-3c5b-0e00a8289ec1@gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 03, 2021 at 09:36:14PM +0200, Jacek Anaszewski wrote:
> On 5/3/21 1:56 PM, Greg Kroah-Hartman wrote:
> > From: Phillip Potter <phil@philpotter.co.uk>
> > 
> > Check return value of lp5xx_read and if non-zero, jump to code at end of
> > the function, causing lp5523_stop_all_engines to be executed before
> > returning the error value up the call chain. This fixes the original
> > commit (248b57015f35) which was reverted due to the University of Minnesota
> > problems.
> > 
> > Cc: Jacek Anaszewski <jacek.anaszewski@gmail.com>
> > Cc: stable <stable@vger.kernel.org>
> > Signed-off-by: Phillip Potter <phil@philpotter.co.uk>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > ---
> >   drivers/leds/leds-lp5523.c | 4 +++-
> >   1 file changed, 3 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/leds/leds-lp5523.c b/drivers/leds/leds-lp5523.c
> > index 5036d7d5f3d4..b1590cb4a188 100644
> > --- a/drivers/leds/leds-lp5523.c
> > +++ b/drivers/leds/leds-lp5523.c
> > @@ -305,7 +305,9 @@ static int lp5523_init_program_engine(struct lp55xx_chip *chip)
> >   	/* Let the programs run for couple of ms and check the engine status */
> >   	usleep_range(3000, 6000);
> > -	lp55xx_read(chip, LP5523_REG_STATUS, &status);
> > +	ret = lp55xx_read(chip, LP5523_REG_STATUS, &status);
> > +	if (ret)
> > +		goto out;
> >   	status &= LP5523_ENG_STATUS_MASK;
> >   	if (status != LP5523_ENG_STATUS_MASK) {
> > 
> 
> Acked-by: Jacek Anaszewski <jacek.anaszewski@gmail.com>

Thanks for the review!

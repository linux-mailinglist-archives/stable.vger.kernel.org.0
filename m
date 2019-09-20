Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92AD5B93EF
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 17:27:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389917AbfITP1w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Sep 2019 11:27:52 -0400
Received: from relay11.mail.gandi.net ([217.70.178.231]:35085 "EHLO
        relay11.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726098AbfITP1w (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Sep 2019 11:27:52 -0400
Received: from localhost (aclermont-ferrand-651-1-259-53.w86-207.abo.wanadoo.fr [86.207.98.53])
        (Authenticated sender: gregory.clement@bootlin.com)
        by relay11.mail.gandi.net (Postfix) with ESMTPSA id A7C76100003;
        Fri, 20 Sep 2019 15:27:49 +0000 (UTC)
From:   Gregory CLEMENT <gregory.clement@bootlin.com>
To:     Mark Brown <broonie@kernel.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>
Cc:     linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Ludovic Desroches <ludovic.desroches@microchip.com>,
        linux-arm-kernel@lists.infradead.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH] spi: atmel: Fix crash when using more than 4 gpio CS
In-Reply-To: <20190920105101.GA3822@sirena.co.uk>
References: <20190919153847.7179-1-gregory.clement@bootlin.com> <20190919160315.GQ3642@sirena.co.uk> <20190919172350.GZ21254@piout.net> <20190920105101.GA3822@sirena.co.uk>
Date:   Fri, 20 Sep 2019 17:27:49 +0200
Message-ID: <87a7az7zt6.fsf@FE-laptop>
MIME-Version: 1.0
Content-Type: text/plain
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Mark,

> On Thu, Sep 19, 2019 at 07:23:50PM +0200, Alexandre Belloni wrote:
>> On 19/09/2019 17:03:15+0100, Mark Brown wrote:
>
>> > This is going to break any system where we use both a GPIO chip select
>> > and chip select 0.  Ideally we'd try to figure out an unused chip select
>> > to use here...
>
>> The point is that this use case is already broken and this patch fixes
>> the crash and is easily backportable.
>
>> Fixing the CS + gpio CS should probably be done in a separate patch.
>
> If the GPIO is overlaid on any of the existing slots (except GPIO 0)
> then it'll cause GPIO 0 to start toggling.  I'm not convinced that the
> code doesn't currently support that.

Actually, the current code is not designed to mix CS and gpio CS, so
this patch doesn't introduce any regression on this side.

But after going further in the details of the driver, this patch could
cause a regression for on the old controllers.

I also found other issues in this driver in the chip select
management. So I will send a new series fixing all of it.

Gregory


-- 
Gregory Clement, Bootlin
Embedded Linux and Kernel engineering
http://bootlin.com

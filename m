Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AD17211D1D
	for <lists+stable@lfdr.de>; Thu,  2 Jul 2020 09:37:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726844AbgGBHhR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jul 2020 03:37:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:33360 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726630AbgGBHhQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jul 2020 03:37:16 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8A27F2085B;
        Thu,  2 Jul 2020 07:37:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593675436;
        bh=vpifWVwgbjHSUaEegAAHzDiKupI4P46wI+RPjm/wU9M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KmcMFIrPlH/DYGVA69kjk8PKCY/DCTSfxA7mi8F7SUmgwxhtcI3ae4CZwpCU359bq
         O48jck5Plf9ZR0KbrKdFvmTivRigbjS7x7dcIjocdZd0fcyNBPP6IoFm28o+ZJ2gwT
         rN71msrjI6cYKrnS0UT2QSDl1Lxr4H8miKM1euLk=
Date:   Thu, 2 Jul 2020 09:37:20 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Serge Semin <Sergey.Semin@baikalelectronics.ru>
Cc:     Daniel Winkler <danielwinkler@google.com>,
        Serge Semin <fancer.lancer@gmail.com>,
        linux-serial@vger.kernel.org, linux-mediatek@lists.infradead.org,
        Alexey Malahov <Alexey.Malahov@baikalelectronics.ru>,
        BlueZ <linux-bluetooth@vger.kernel.org>,
        chromeos-bluetooth-upstreaming 
        <chromeos-bluetooth-upstreaming@chromium.org>,
        stable@vger.kernel.org, abhishekpandit@chromium.org,
        Aaron Sierra <asierra@xes-inc.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Jiri Slaby <jslaby@suse.com>, Lukas Wunner <lukas@wunner.de>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/1] Revert "serial: 8250: Fix max baud limit in
 generic 8250 port"
Message-ID: <20200702073720.GE1073011@kroah.com>
References: <20200701211337.3027448-1-danielwinkler@google.com>
 <20200701223713.gavale4aramu3xnb@mobilestation>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200701223713.gavale4aramu3xnb@mobilestation>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 02, 2020 at 01:37:13AM +0300, Serge Semin wrote:
> On Wed, Jul 01, 2020 at 02:13:36PM -0700, Daniel Winkler wrote:
> > 
> > This change regresses the QCA6174A-3 bluetooth chip, preventing
> > firmware from being properly loaded. Without this change, the
> > chip works as intended.
> > 
> > The device is the Kukui Chromebook using the Mediatek chipset
> > and the 8250_mtk uart. Initial controller baudrate is 115200
> > and operating speed is 3000000. Our entire suite of bluetooth
> > tests now fail on this platform due to an apparent failure to
> > sync its firmware on initialization.
> 
> Ok. It's mediatek 8250 driver, which is responsible for the failure.
> Then we'll have two options:
> 
> 1) Add a new capability like UART_CAP_NO16DIV and take it into account
>    in the serial8250_get_baud_rate() method.
>  
> I don't have a documentation for the Mediatek UART port, but it seems to me
> that that controller calculates the baud rate differently from the standard
> 8250 port. A standard 8250 port does that by the next formulae:
>   baud = uartclk / (16 * divisor).
> While it seems to me that the Mediatek port uses the formulae like:
>   baud = uartclk / divisor. (Please, correct me if I'm wrong)
> If so, then we could introduce a new capability like UART_CAP_NO16DIV. The
> 8250_mtk driver will add it to the 8250-port capabilities field. The
> serial8250_get_baud_rate() method should be altered in a way so one would check
> whether the UART_CAP_NO16DIV flag is set and if it is then the
> uart_get_baud_rate() function will be called without uartclk normalized by the
> factor of 16.
> 
> 2) Manually call serial8250_do_set_divisor() in the custom set_termios()
>    callback.
> 
> Just add the uart_update_timeout() and serial8250_do_set_divisor() methods
> invocation into the mtk8250_set_termios() function, which the original commit
> 81bb549fdf14 ("serial: 8250_mtk: support big baud rate") author should have
> done in the first place.

Sounds like a sane fix, thanks for looking into this.

greg k-h

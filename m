Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA209211AD5
	for <lists+stable@lfdr.de>; Thu,  2 Jul 2020 06:11:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726118AbgGBEL4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jul 2020 00:11:56 -0400
Received: from bmailout1.hostsharing.net ([83.223.95.100]:45731 "EHLO
        bmailout1.hostsharing.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725857AbgGBEL4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Jul 2020 00:11:56 -0400
Received: from h08.hostsharing.net (h08.hostsharing.net [IPv6:2a01:37:1000::53df:5f1c:0])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "*.hostsharing.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (not verified))
        by bmailout1.hostsharing.net (Postfix) with ESMTPS id 07030300011B9;
        Thu,  2 Jul 2020 06:11:53 +0200 (CEST)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
        id BC3492ED3E2; Thu,  2 Jul 2020 06:11:52 +0200 (CEST)
Date:   Thu, 2 Jul 2020 06:11:52 +0200
From:   Lukas Wunner <lukas@wunner.de>
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
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/1] Revert "serial: 8250: Fix max baud limit in
 generic 8250 port"
Message-ID: <20200702041152.e5csvbodojzwnagx@wunner.de>
References: <20200701211337.3027448-1-danielwinkler@google.com>
 <20200701223713.gavale4aramu3xnb@mobilestation>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200701223713.gavale4aramu3xnb@mobilestation>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 02, 2020 at 01:37:13AM +0300, Serge Semin wrote:
> 1) Add a new capability like UART_CAP_NO16DIV and take it into account
>    in the serial8250_get_baud_rate() method.
>  
> I don't have a documentation for the Mediatek UART port, but it seems to me
> that that controller calculates the baud rate differently from the standard
> 8250 port. A standard 8250 port does that by the next formulae:
>   baud = uartclk / (16 * divisor).
> While it seems to me that the Mediatek port uses the formulae like:
>   baud = uartclk / divisor. (Please, correct me if I'm wrong)

8250_bcm2835aux.c seems to suffer from a similar issue and
solves it like this in the ->probe hook:

	/* the HW-clock divider for bcm2835aux is 8,
	 * but 8250 expects a divider of 16,
	 * so we have to multiply the actual clock by 2
	 * to get identical baudrates.
	 */
	up.port.uartclk = clk_get_rate(data->clk) * 2;


> 2) Manually call serial8250_do_set_divisor() in the custom set_termios()
>    callback.
> 
> Just add the uart_update_timeout() and serial8250_do_set_divisor() methods
> invocation into the mtk8250_set_termios() function, which the original commit
> 81bb549fdf14 ("serial: 8250_mtk: support big baud rate") author should have
> done in the first place.

That sound preferable as adding new quirks into core code feels
like a case of midlayer fallacy:

https://blog.ffwll.ch/2016/12/midlayers-once-more-with-feeling.html

Thanks,

Lukas

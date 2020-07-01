Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 580CD211629
	for <lists+stable@lfdr.de>; Thu,  2 Jul 2020 00:37:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726404AbgGAWhV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jul 2020 18:37:21 -0400
Received: from mail.baikalelectronics.com ([87.245.175.226]:49852 "EHLO
        mail.baikalelectronics.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726121AbgGAWhV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Jul 2020 18:37:21 -0400
Received: from localhost (unknown [127.0.0.1])
        by mail.baikalelectronics.ru (Postfix) with ESMTP id 1F473803202A;
        Wed,  1 Jul 2020 22:37:18 +0000 (UTC)
X-Virus-Scanned: amavisd-new at baikalelectronics.ru
Received: from mail.baikalelectronics.ru ([127.0.0.1])
        by localhost (mail.baikalelectronics.ru [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id DHd7Fb6uuWwY; Thu,  2 Jul 2020 01:37:16 +0300 (MSK)
Date:   Thu, 2 Jul 2020 01:37:13 +0300
From:   Serge Semin <Sergey.Semin@baikalelectronics.ru>
To:     Daniel Winkler <danielwinkler@google.com>
CC:     Serge Semin <fancer.lancer@gmail.com>,
        <linux-serial@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>,
        Alexey Malahov <Alexey.Malahov@baikalelectronics.ru>,
        BlueZ <linux-bluetooth@vger.kernel.org>,
        chromeos-bluetooth-upstreaming 
        <chromeos-bluetooth-upstreaming@chromium.org>,
        <stable@vger.kernel.org>, <abhishekpandit@chromium.org>,
        Aaron Sierra <asierra@xes-inc.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.com>, Lukas Wunner <lukas@wunner.de>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 0/1] Revert "serial: 8250: Fix max baud limit in
 generic 8250 port"
Message-ID: <20200701223713.gavale4aramu3xnb@mobilestation>
References: <20200701211337.3027448-1-danielwinkler@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20200701211337.3027448-1-danielwinkler@google.com>
X-ClientProxiedBy: MAIL.baikal.int (192.168.51.25) To mail (192.168.51.25)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 01, 2020 at 02:13:36PM -0700, Daniel Winkler wrote:
> 
> This change regresses the QCA6174A-3 bluetooth chip, preventing
> firmware from being properly loaded. Without this change, the
> chip works as intended.
> 
> The device is the Kukui Chromebook using the Mediatek chipset
> and the 8250_mtk uart. Initial controller baudrate is 115200
> and operating speed is 3000000. Our entire suite of bluetooth
> tests now fail on this platform due to an apparent failure to
> sync its firmware on initialization.

Ok. It's mediatek 8250 driver, which is responsible for the failure.
Then we'll have two options:

1) Add a new capability like UART_CAP_NO16DIV and take it into account
   in the serial8250_get_baud_rate() method.
 
I don't have a documentation for the Mediatek UART port, but it seems to me
that that controller calculates the baud rate differently from the standard
8250 port. A standard 8250 port does that by the next formulae:
  baud = uartclk / (16 * divisor).
While it seems to me that the Mediatek port uses the formulae like:
  baud = uartclk / divisor. (Please, correct me if I'm wrong)
If so, then we could introduce a new capability like UART_CAP_NO16DIV. The
8250_mtk driver will add it to the 8250-port capabilities field. The
serial8250_get_baud_rate() method should be altered in a way so one would check
whether the UART_CAP_NO16DIV flag is set and if it is then the
uart_get_baud_rate() function will be called without uartclk normalized by the
factor of 16.

2) Manually call serial8250_do_set_divisor() in the custom set_termios()
   callback.

Just add the uart_update_timeout() and serial8250_do_set_divisor() methods
invocation into the mtk8250_set_termios() function, which the original commit
81bb549fdf14 ("serial: 8250_mtk: support big baud rate") author should have
done in the first place.

-Sergey

> 
> The driver is in the cros tree at drivers/bluetooth/hci_qca.c
> and uses the serdev interface. Specifically, this is the
> QCA_ROME chipset.
> 
> 
> Daniel Winkler (1):
>   Revert "serial: 8250: Fix max baud limit in generic 8250 port"
> 
>  drivers/tty/serial/8250/8250_port.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> -- 
> 2.27.0.212.ge8ba1cc988-goog
> 

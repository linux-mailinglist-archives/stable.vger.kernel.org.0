Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8089A211F19
	for <lists+stable@lfdr.de>; Thu,  2 Jul 2020 10:46:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726462AbgGBIq6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jul 2020 04:46:58 -0400
Received: from mga07.intel.com ([134.134.136.100]:46981 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726445AbgGBIq5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jul 2020 04:46:57 -0400
IronPort-SDR: SMm7EsYoyGOCw1VH5AY5MYxjoaW32H29P1oECYocvko45IY5F5b95UUmHgEiCVDdbXD7I/6b+L
 oqc/XQVNs4sQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9669"; a="211871600"
X-IronPort-AV: E=Sophos;i="5.75,303,1589266800"; 
   d="scan'208";a="211871600"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2020 01:46:57 -0700
IronPort-SDR: 8v773znlm029UZL/qcOa676PS5qX3eVR1JOuEsIfC/o5+P9qUYXJro3MDuwBkXM9lWFBy+Zfy4
 emMN3tj3kZLQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,303,1589266800"; 
   d="scan'208";a="455443914"
Received: from smile.fi.intel.com (HELO smile) ([10.237.68.40])
  by orsmga005.jf.intel.com with ESMTP; 02 Jul 2020 01:46:53 -0700
Received: from andy by smile with local (Exim 4.94)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1jqurt-00HAon-VD; Thu, 02 Jul 2020 11:46:53 +0300
Date:   Thu, 2 Jul 2020 11:46:53 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Lukas Wunner <lukas@wunner.de>
Cc:     Serge Semin <Sergey.Semin@baikalelectronics.ru>,
        Daniel Winkler <danielwinkler@google.com>,
        Serge Semin <fancer.lancer@gmail.com>,
        linux-serial@vger.kernel.org, linux-mediatek@lists.infradead.org,
        Alexey Malahov <Alexey.Malahov@baikalelectronics.ru>,
        BlueZ <linux-bluetooth@vger.kernel.org>,
        chromeos-bluetooth-upstreaming 
        <chromeos-bluetooth-upstreaming@chromium.org>,
        stable@vger.kernel.org, abhishekpandit@chromium.org,
        Aaron Sierra <asierra@xes-inc.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/1] Revert "serial: 8250: Fix max baud limit in
 generic 8250 port"
Message-ID: <20200702084653.GG3703480@smile.fi.intel.com>
References: <20200701211337.3027448-1-danielwinkler@google.com>
 <20200701223713.gavale4aramu3xnb@mobilestation>
 <20200702041152.e5csvbodojzwnagx@wunner.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200702041152.e5csvbodojzwnagx@wunner.de>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 02, 2020 at 06:11:52AM +0200, Lukas Wunner wrote:
> On Thu, Jul 02, 2020 at 01:37:13AM +0300, Serge Semin wrote:
> > 1) Add a new capability like UART_CAP_NO16DIV and take it into account
> >    in the serial8250_get_baud_rate() method.
> >  
> > I don't have a documentation for the Mediatek UART port, but it seems to me
> > that that controller calculates the baud rate differently from the standard
> > 8250 port. A standard 8250 port does that by the next formulae:
> >   baud = uartclk / (16 * divisor).
> > While it seems to me that the Mediatek port uses the formulae like:
> >   baud = uartclk / divisor. (Please, correct me if I'm wrong)
> 
> 8250_bcm2835aux.c seems to suffer from a similar issue and
> solves it like this in the ->probe hook:
> 
> 	/* the HW-clock divider for bcm2835aux is 8,
> 	 * but 8250 expects a divider of 16,
> 	 * so we have to multiply the actual clock by 2
> 	 * to get identical baudrates.
> 	 */
> 	up.port.uartclk = clk_get_rate(data->clk) * 2;

8250_mid for example lies about UART clock due to this. It has a comment in the
code in its ->set_termios().

Yes, we have a lot of possibilities here to fix, I guess. We have custom
termios callback, also get and set divisor and so on.

-- 
With Best Regards,
Andy Shevchenko



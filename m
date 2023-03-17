Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 370306BE743
	for <lists+stable@lfdr.de>; Fri, 17 Mar 2023 11:51:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229970AbjCQKvm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Mar 2023 06:51:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbjCQKvl (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Mar 2023 06:51:41 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17C0BD5174;
        Fri, 17 Mar 2023 03:51:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679050300; x=1710586300;
  h=date:from:to:cc:subject:in-reply-to:message-id:
   references:mime-version:content-id;
  bh=YVFL4ge9rV3l7hCkWnb3UlUIAamKuHY1SEXdPYljMcU=;
  b=OecK244Wi2+hgqxWGhD/B/CmaR8MsIbULdDY+mjUMV4c44Oi5qqjGWvQ
   Y6QjR6FYbAhtyjX0U+7jm9l/aaltUmvQSub1i1NPCAKk4nlLpciDHwrhc
   84NgUYuWPoqOGwt+gyLOLTPb7RsJ9UVcaw0pRITD/0J4mzK6e+kFc2k85
   YdFu59ncsP/o3soAIE3iCzrEH7zPdUxCxI0b1/F3ZtmFgCHjGtj5wsiy9
   rtSSgBpL9+J1zpc6eYKE2fu+TgFOgiAuXmfnSZr9CAxMGQr/CnN6JDT0u
   OF8caRbYkKOeUZPjyWx1B9qeqK5TsYi+cONJWjtqU7XfctDSDmlQgQ/xM
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10651"; a="335729921"
X-IronPort-AV: E=Sophos;i="5.98,268,1673942400"; 
   d="scan'208";a="335729921"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2023 03:51:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10651"; a="790670316"
X-IronPort-AV: E=Sophos;i="5.98,268,1673942400"; 
   d="scan'208";a="790670316"
Received: from bstach-mobl1.ger.corp.intel.com ([10.251.221.222])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2023 03:51:37 -0700
Date:   Fri, 17 Mar 2023 12:51:35 +0200 (EET)
From:   =?ISO-8859-15?Q?Ilpo_J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>
To:     David Laight <David.Laight@ACULAB.COM>
cc:     "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH 2/2] serial: 8250: Fix serial8250_tx_empty() race with
 DMA Tx
In-Reply-To: <55704d488ee644f5a710841f3912b25f@AcuMS.aculab.com>
Message-ID: <ce143371-3ad-6c8-a37c-f8bcbc9382a@linux.intel.com>
References: <20230316132452.76478-1-ilpo.jarvinen@linux.intel.com> <20230316132452.76478-3-ilpo.jarvinen@linux.intel.com> <55704d488ee644f5a710841f3912b25f@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; BOUNDARY="8323329-1087178227-1679049047=:2227"
Content-ID: <20fe732a-369d-11c1-b35-1e8fcc56b0@linux.intel.com>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-1087178227-1679049047=:2227
Content-Type: text/plain; CHARSET=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Content-ID: <f8943e1-539b-1d44-6a3d-e3a465255b85@linux.intel.com>

On Fri, 17 Mar 2023, David Laight wrote:

> From: Ilpo Järvinen
> > Sent: 16 March 2023 13:25
> > 
> > There's a potential race before THRE/TEMT deasserts when DMA Tx is
> > starting up (or the next batch of continuous Tx is being submitted).
> > This can lead to misdetecting Tx empty condition.
> > 
> > It is entirely normal for THRE/TEMT to be set for some time after the
> > DMA Tx had been setup in serial8250_tx_dma(). As Tx side is definitely
> > not empty at that point, it seems incorrect for serial8250_tx_empty()
> > claim Tx is empty.
> > 
> > Fix the race by also checking in serial8250_tx_empty() whether there's
> > DMA Tx active.
> > 
> > Note: This fix only addresses in-kernel race mainly to make using
> > TCSADRAIN/FLUSH robust. Userspace can still cause other races but they
> > seem userspace concurrency control problems.
> > 
> > Fixes: 9ee4b83e51f74 ("serial: 8250: Add support for dmaengine")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
> > ---
> >  drivers/tty/serial/8250/8250.h      | 12 ++++++++++++
> >  drivers/tty/serial/8250/8250_port.c |  7 ++++++-
> >  2 files changed, 18 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/tty/serial/8250/8250.h b/drivers/tty/serial/8250/8250.h
> ...
> >  static inline int ns16550a_goto_highspeed(struct uart_8250_port *up)
> > diff --git a/drivers/tty/serial/8250/8250_port.c b/drivers/tty/serial/8250/8250_port.c
> > index fa43df05342b..4954c4f15fb2 100644
> > --- a/drivers/tty/serial/8250/8250_port.c
> > +++ b/drivers/tty/serial/8250/8250_port.c
> > @@ -2006,17 +2006,22 @@ static unsigned int serial8250_tx_empty(struct uart_port *port)
> >  {
> >  	struct uart_8250_port *up = up_to_u8250p(port);
> >  	unsigned long flags;
> > +	bool dma_tx_running;
> >  	u16 lsr;
> > 
> >  	serial8250_rpm_get(up);
> > 
> >  	spin_lock_irqsave(&port->lock, flags);
> >  	lsr = serial_lsr_in(up);
> > +	dma_tx_running = serial8250_tx_dma_running(up);
> >  	spin_unlock_irqrestore(&port->lock, flags);
> > 
> >  	serial8250_rpm_put(up);
> > 
> > -	return uart_lsr_tx_empty(lsr) ? TIOCSER_TEMT : 0;
> > +	if (uart_lsr_tx_empty(lsr) && !dma_tx_running)
> > +		return TIOCSER_TEMT;
> > +
> > +	return 0;
> >  }
> 
> Since checking whether dma is active is fast but reading
> the lsr is slow it is probably better to generate the return
> value inside the lock and test for dma first.
> Something like:
> 	spin_lock()
> 	result = 0;
> 	if (!serial8250_tx_dma_running(up) &&
> 	    uart_lsr_tx_empty(serial_lsr_in(up)))
> 		result = TIOCSER_TEMT;
> 	}
> 	spin_unlock()
> 	...
> 	return result;
> 
> 	David

Thanks, I'll change it to something along those lines.

-- 
 i.
--8323329-1087178227-1679049047=:2227--

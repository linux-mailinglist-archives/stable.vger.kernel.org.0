Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 469AE6C0CAD
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 10:00:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231137AbjCTJA0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 05:00:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230240AbjCTJAZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 05:00:25 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1888974A;
        Mon, 20 Mar 2023 02:00:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679302822; x=1710838822;
  h=date:from:to:cc:subject:in-reply-to:message-id:
   references:mime-version:content-id;
  bh=Ds82R3aLyID+1VGsHfWdZtKBC3BhEztxpsHjVaC2+mo=;
  b=m3VUY8T8FE7Ck8tmhBFNc9EF2gGfM1x0LSNbvgN6OHjQDxQcUpSREzKD
   LxjxzfXOIQl+ZKQuXNN3Sm4O1UD349NY5rn0SkuDiXPRSvYY0a9i9zJaR
   qlNp3BoaMaCdiHz8BKiQttHBfQzJh4h+NDk/6b86t5NM5gJZcPPTF1ZeH
   yUaxvurr0GUHpDN2Lhw3FrWvFyDU7PlHnezMCRR8ibj57xsdtZ37/aB0j
   ulq1HDhsv0KF777LTJHxPac+jtC5G6VXpw3E2hwPDH0l5793z/aBd36dv
   LHMEjx7kanu35s0xJZXTJ5Ks+w3bXsOmgk9ixCJGp8ZNmtsMYv0P2CUrg
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10654"; a="338635707"
X-IronPort-AV: E=Sophos;i="5.98,274,1673942400"; 
   d="scan'208";a="338635707"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2023 02:00:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10654"; a="674279824"
X-IronPort-AV: E=Sophos;i="5.98,274,1673942400"; 
   d="scan'208";a="674279824"
Received: from mbouhaou-mobl1.ger.corp.intel.com ([10.252.61.151])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2023 02:00:20 -0700
Date:   Mon, 20 Mar 2023 11:00:11 +0200 (EET)
From:   =?ISO-8859-15?Q?Ilpo_J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>
To:     David Laight <David.Laight@ACULAB.COM>
cc:     "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH v2 2/2] serial: 8250: Fix serial8250_tx_empty() race with
 DMA Tx
In-Reply-To: <52fae6e3e7254a96beefd2774f7d6254@AcuMS.aculab.com>
Message-ID: <396842cd-4ed5-cd46-6d13-c258c3fb836f@linux.intel.com>
References: <20230317113318.31327-1-ilpo.jarvinen@linux.intel.com> <20230317113318.31327-3-ilpo.jarvinen@linux.intel.com> <52fae6e3e7254a96beefd2774f7d6254@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; BOUNDARY="8323329-1060030904-1679300990=:2177"
Content-ID: <276915e2-fe2f-7337-97b5-4e58ad22bf7@linux.intel.com>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-1060030904-1679300990=:2177
Content-Type: text/plain; CHARSET=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Content-ID: <e5ed4fa8-e9d2-1886-f1cc-3e9f17d5eb3e@linux.intel.com>

On Sat, 18 Mar 2023, David Laight wrote:

> From: Ilpo Järvinen
> > Sent: 17 March 2023 11:33
> > To: linux-serial@vger.kernel.org; Greg Kroah-Hartman <gregkh@linuxfoundation.org>; Jiri Slaby
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
> 
> Looks better, but I'm not sure it actually works.
> 
> If interrupts are being used to copy data to the tx fifo then
> (depending on interrupt latency and exactly when the interrupt
> is requested) the code might report 'tx empty' when the ISR
> is about to copy in more data.
>
> Now the drain/flush code might already have checked there is
> no more data queued in the driver before calling this,

Thanks for taking a look, it's really appreciated.

Yes, set_termios() checks for tty_chars_in_buffer() which calls into 
serial_core's ->chars_in_buffer(). This does check 
uart_circ_chars_pending() so it's not possible to have such chars in the 
circular buffer in the drain/flush case.

> but more generally shouldn't it be checking:
> 	no_data_queued_in_driver && hardware_fifo_empty.
> 
> Any 'no_data_queued_in_driver' check would probably include
> data that dma is copying - so the explicit dma check might
> not be needed.

What for you'd want this change? Refactor the code? uart_get_lsr_info() 
already does check for uart_circ_chars_pending() so what you'd want more?

I suppose uart_get_lsr_info() should hold port's lock across the checks 
though, having that wishful comment about a racing interrupt messing 
things up doesn't really help that much :-).

Also, now that I looked into uart_get_lsr_info() I guess 
uart_chars_in_buffer() should also consider x_char like 
uart_get_lsr_info() does.


-- 
 i.

> > Fixes: 9ee4b83e51f74 ("serial: 8250: Add support for dmaengine")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
> > ---
> >  drivers/tty/serial/8250/8250.h      | 12 ++++++++++++
> >  drivers/tty/serial/8250/8250_port.c |  7 ++++---
> >  2 files changed, 16 insertions(+), 3 deletions(-)
> > 
> > diff --git a/drivers/tty/serial/8250/8250.h b/drivers/tty/serial/8250/8250.h
> > index 287153d32536..1e8fe44a7099 100644
> > --- a/drivers/tty/serial/8250/8250.h
> > +++ b/drivers/tty/serial/8250/8250.h
> > @@ -365,6 +365,13 @@ static inline void serial8250_do_prepare_rx_dma(struct uart_8250_port *p)
> >  	if (dma->prepare_rx_dma)
> >  		dma->prepare_rx_dma(p);
> >  }
> > +
> > +static inline bool serial8250_tx_dma_running(struct uart_8250_port *p)
> > +{
> > +	struct uart_8250_dma *dma = p->dma;
> > +
> > +	return dma && dma->tx_running;
> > +}
> >  #else
> >  static inline int serial8250_tx_dma(struct uart_8250_port *p)
> >  {
> > @@ -380,6 +387,11 @@ static inline int serial8250_request_dma(struct uart_8250_port *p)
> >  	return -1;
> >  }
> >  static inline void serial8250_release_dma(struct uart_8250_port *p) { }
> > +
> > +static inline bool serial8250_tx_dma_running(struct uart_8250_port *p)
> > +{
> > +	return false;
> > +}
> >  #endif
> > 
> >  static inline int ns16550a_goto_highspeed(struct uart_8250_port *up)
> > diff --git a/drivers/tty/serial/8250/8250_port.c b/drivers/tty/serial/8250/8250_port.c
> > index fa43df05342b..107bcdfb119c 100644
> > --- a/drivers/tty/serial/8250/8250_port.c
> > +++ b/drivers/tty/serial/8250/8250_port.c
> > @@ -2005,18 +2005,19 @@ static int serial8250_tx_threshold_handle_irq(struct uart_port *port)
> >  static unsigned int serial8250_tx_empty(struct uart_port *port)
> >  {
> >  	struct uart_8250_port *up = up_to_u8250p(port);
> > +	unsigned int result = 0;
> >  	unsigned long flags;
> > -	u16 lsr;
> > 
> >  	serial8250_rpm_get(up);
> > 
> >  	spin_lock_irqsave(&port->lock, flags);
> > -	lsr = serial_lsr_in(up);
> > +	if (!serial8250_tx_dma_running(up) && uart_lsr_tx_empty(serial_lsr_in(up)))
> > +		result = TIOCSER_TEMT;
> >  	spin_unlock_irqrestore(&port->lock, flags);
> > 
> >  	serial8250_rpm_put(up);
> > 
> > -	return uart_lsr_tx_empty(lsr) ? TIOCSER_TEMT : 0;
> > +	return result;
> >  }
> > 
> >  unsigned int serial8250_do_get_mctrl(struct uart_port *port)
> > --
> > 2.30.2
> 
> -
> Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
> Registration No: 1397386 (Wales)
> 
--8323329-1060030904-1679300990=:2177--

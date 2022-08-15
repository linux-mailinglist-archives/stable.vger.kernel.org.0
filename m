Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EEA7592F23
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 14:44:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242376AbiHOMo6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 08:44:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242375AbiHOMo5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 08:44:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AB9DDEF4;
        Mon, 15 Aug 2022 05:44:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 30F3C611D3;
        Mon, 15 Aug 2022 12:44:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05178C433D6;
        Mon, 15 Aug 2022 12:44:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660567495;
        bh=TZYLlk3W3nAvHUdt4q3X9iVBQXyr803loTxzGJkJI2k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HgK/cRAMArBD901BXT4oKqd9Hfy8rwRlXYQW+58fPB8I2OV/5kKZ2Rg8gjUEzzrcT
         iPTY01Tm8MWz3vByClibaw61UQ16KhdrzscecQkv/YSjZ6W9tUjdQGTWPBDXxLwYRQ
         CYKP8Ll3RB0hQajcmnr/LGPTqiA4WUwmp+BeG4OQ=
Date:   Mon, 15 Aug 2022 14:44:52 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Ilpo =?iso-8859-1?Q?J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>
Cc:     Sasha Levin <sashal@kernel.org>, stable-commits@vger.kernel.org,
        Jiri Slaby <jirislaby@kernel.org>, stable@vger.kernel.org
Subject: Re: Patch "serial: Store character timing information to uart_port"
 has been added to the 5.18-stable tree
Message-ID: <Yvo/xFOEgoCvHxG6@kroah.com>
References: <20220813215542.1973126-1-sashal@kernel.org>
 <1119a468-deef-8edb-ac92-ae02c18ca22@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1119a468-deef-8edb-ac92-ae02c18ca22@linux.intel.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 15, 2022 at 01:54:32PM +0300, Ilpo Järvinen wrote:
> On Sat, 13 Aug 2022, Sasha Levin wrote:
> 
> > This is a note to let you know that I've just added the patch titled
> > 
> >     serial: Store character timing information to uart_port
> > 
> > to the 5.18-stable tree which can be found at:
> >     http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
> > 
> > The filename of the patch is:
> >      serial-store-character-timing-information-to-uart_po.patch
> > and it can be found in the queue-5.18 subdirectory.
> > 
> > If you, or anyone else, feels it should not be added to the stable tree,
> > please let <stable@vger.kernel.org> know about it.
> >
> > commit 5517053a2e0b30a1e35f90504446af4a2c4920e8
> > Author: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
> > Date:   Mon Apr 25 17:33:58 2022 +0300
> > 
> >     serial: Store character timing information to uart_port
> >     
> >     [ Upstream commit 31f6bd7fad3b149a1eb6f67fc2e742e4df369b3d ]
> >     
> >     Struct uart_port currently stores FIFO timeout. Having character timing
> >     information readily available is useful. Even serial core itself
> >     determines char_time from port->timeout using inverse calculation.
> >     
> >     Store frame_time directly into uart_port. Character time is stored in
> >     nanoseconds to have reasonable precision with high rates. To avoid
> >     overflow, 64-bit math is necessary.
> >     
> >     It might be possible to determine timeout from frame_time by
> >     multiplying it with fifosize as needed but only part of the users seem
> >     to be protected by a lock. Thus, this patch does not pursue storing
> >     only frame_time in uart_port.
> >     
> >     Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
> >     Link: https://lore.kernel.org/r/20220425143410.12703-2-ilpo.jarvinen@linux.intel.com
> >     Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> >     Signed-off-by: Sasha Levin <sashal@kernel.org>
> > 
> > diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
> > index 95d8d1fcd543..6b07b7b41354 100644
> > --- a/drivers/tty/serial/serial_core.c
> > +++ b/drivers/tty/serial/serial_core.c
> > @@ -24,6 +24,7 @@
> >  #include <linux/sysrq.h>
> >  #include <linux/delay.h>
> >  #include <linux/mutex.h>
> > +#include <linux/math64.h>
> >  #include <linux/security.h>
> >  
> >  #include <linux/irq.h>
> > @@ -333,15 +334,18 @@ void
> >  uart_update_timeout(struct uart_port *port, unsigned int cflag,
> >  		    unsigned int baud)
> >  {
> > -	unsigned int size;
> > +	unsigned int size = tty_get_frame_size(cflag);
> > +	u64 frame_time;
> >  
> > -	size = tty_get_frame_size(cflag) * port->fifosize;
> > +	frame_time = (u64)size * NSEC_PER_SEC;
> > +	size *= port->fifosize;
> >  
> >  	/*
> >  	 * Figure the timeout to send the above number of bits.
> >  	 * Add .02 seconds of slop
> >  	 */
> >  	port->timeout = (HZ * size) / baud + HZ/50;
> > +	port->frame_time = DIV64_U64_ROUND_UP(frame_time, baud);
> >  }
> >  EXPORT_SYMBOL(uart_update_timeout);
> >  
> > @@ -1610,10 +1614,8 @@ static void uart_wait_until_sent(struct tty_struct *tty, int timeout)
> >  	 * Note: we have to use pretty tight timings here to satisfy
> >  	 * the NIST-PCTS.
> >  	 */
> > -	char_time = (port->timeout - HZ/50) / port->fifosize;
> > -	char_time = char_time / 5;
> > -	if (char_time == 0)
> > -		char_time = 1;
> > +	char_time = max(nsecs_to_jiffies(port->frame_time / 5), 1UL);
> > +
> >  	if (timeout && timeout < char_time)
> >  		char_time = timeout;
> >  
> > diff --git a/include/linux/serial_core.h b/include/linux/serial_core.h
> > index ca57d686d4d1..409573ea5ea4 100644
> > --- a/include/linux/serial_core.h
> > +++ b/include/linux/serial_core.h
> > @@ -232,6 +232,7 @@ struct uart_port {
> >  	int			hw_stopped;		/* sw-assisted CTS flow state */
> >  	unsigned int		mctrl;			/* current modem ctrl settings */
> >  	unsigned int		timeout;		/* character-based timeout */
> > +	unsigned int		frame_time;		/* frame timing in ns */
> >  	unsigned int		type;			/* port type */
> >  	const struct uart_ops	*ops;
> >  	unsigned int		custom_divisor;
> > 
> 
> Why is this change necessary for stable? The change was made simply to 
> make some other feature changes following a lot simpler but I don't think 
> there is any known bug/issue it would be fixing.

Good point, now dropped from 5.15.y and 5.18.y, thanks.

greg k-h

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EC014035C1
	for <lists+stable@lfdr.de>; Wed,  8 Sep 2021 09:57:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235106AbhIHH6Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Sep 2021 03:58:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:52310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234696AbhIHH6P (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 8 Sep 2021 03:58:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 33A7B610A3;
        Wed,  8 Sep 2021 07:57:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631087828;
        bh=jz9wlXKaLI0RSIL3ClN6wAXFar4LORkGjAHnGdogGy0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bQFZBqja1XOyxYvIJChbO5kwHSOthj1ZB5bPdW8QRHTgyUP/JaM2SKQ8onptdWtEa
         MdeLGH7JPT5hjKIzCJwRXXbF+DFNSlABWQ5/Fbe3JSJn+0Et7CpkQdqZANpytgMYQH
         MyfuRFWuzyzwyuyHN+HTmrTS19Z40SZTyWklha1DqoZZ9cOH98Ib8j2wJCsVXrhk3N
         m+Grlxai5Sl8dOHspIZ3AGxZuwVxMydWI73aeKnqsmss4v0Q/aE5dPRjAXtLDSjE0o
         uI5IYDHeUpzLzsgsIM7BFf4nrNTdIufFzmPuHqcNEv0Y+wglkCrpF3zgeEES/Nds0X
         0CFyal/A3JWtw==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1mNsS0-00049i-3P; Wed, 08 Sep 2021 09:56:56 +0200
Date:   Wed, 8 Sep 2021 09:56:56 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Alex Elder <elder@linaro.org>
Cc:     David Lin <dtwlin@gmail.com>, Alex Elder <elder@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        greybus-dev@lists.linaro.org, linux-staging@lists.linux.dev,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [greybus-dev] [PATCH] staging: greybus: uart: fix tty use after
 free
Message-ID: <YThsyOlHqWmb5hsV@hovoldconsulting.com>
References: <20210906124538.22358-1-johan@kernel.org>
 <56782caa-bd9d-b049-7ca6-c64e3fbe109a@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <56782caa-bd9d-b049-7ca6-c64e3fbe109a@linaro.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 07, 2021 at 08:32:25AM -0500, Alex Elder wrote:
> On 9/6/21 7:45 AM, Johan Hovold wrote:
  
> > +static void gb_tty_port_destruct(struct tty_port *port)
> > +{
> > +	struct gb_tty *gb_tty = container_of(port, struct gb_tty, port);
> > +
> 
> So the minor number is GB_NUM_MINORS until after both the buffer
> and the kfifo have been allocated.

Yes, but more importantly until the minor number has been allocated.

> And kfifo_free() (similar to
> kfree()) handles being provided a non-initialized kfifo, correct?

Correct, as long as it has been zeroed.

> > +	if (gb_tty->minor != GB_NUM_MINORS)
> > +		release_minor(gb_tty);
> > +	kfifo_free(&gb_tty->write_fifo);
> > +	kfree(gb_tty->buffer);
> > +	kfree(gb_tty);
> > +}
> > +
> >   static const struct tty_operations gb_ops = {
> >   	.install =		gb_tty_install,
> >   	.open =			gb_tty_open,
> > @@ -786,6 +797,7 @@ static const struct tty_port_operations gb_port_ops = {
> >   	.dtr_rts =		gb_tty_dtr_rts,
> >   	.activate =		gb_tty_port_activate,
> >   	.shutdown =		gb_tty_port_shutdown,
> > +	.destruct =		gb_tty_port_destruct,
> >   };
> >   
> >   static int gb_uart_probe(struct gbphy_device *gbphy_dev,
> > @@ -798,17 +810,11 @@ static int gb_uart_probe(struct gbphy_device *gbphy_dev,
> >   	int retval;
> >   	int minor;
> >   
> > -	gb_tty = kzalloc(sizeof(*gb_tty), GFP_KERNEL);
> > -	if (!gb_tty)
> > -		return -ENOMEM;
> > -
> 
> Why do you reorder when you allocate the gb_tty structure?
> I don't have a problem with it, but it seems like the order
> doesn't matter.  Is it just so you can initialize it right
> after it's allocated?  (If so, I like that reason.)

Yeah, and I wanted to keep the bits managed by the port reference count
together.

> >   	connection = gb_connection_create(gbphy_dev->bundle,
> >   					  le16_to_cpu(gbphy_dev->cport_desc->id),
> >   					  gb_uart_request_handler);
> > -	if (IS_ERR(connection)) {
> > -		retval = PTR_ERR(connection);
> > -		goto exit_tty_free;
> > -	}
> > +	if (IS_ERR(connection))
> > +		return PTR_ERR(connection);
> >   
> >   	max_payload = gb_operation_get_payload_size_max(connection);
> >   	if (max_payload < sizeof(struct gb_uart_send_data_request)) {
> > @@ -816,13 +822,23 @@ static int gb_uart_probe(struct gbphy_device *gbphy_dev,
> >   		goto exit_connection_destroy;
> >   	}
> >   
> > +	gb_tty = kzalloc(sizeof(*gb_tty), GFP_KERNEL);
> > +	if (!gb_tty) {
> > +		retval = -ENOMEM;
> > +		goto exit_connection_destroy;
> > +	}
> > +
> > +	tty_port_init(&gb_tty->port);
> > +	gb_tty->port.ops = &gb_port_ops;
> > +	gb_tty->minor = GB_NUM_MINORS;
> > +
> >   	gb_tty->buffer_payload_max = max_payload -
> >   			sizeof(struct gb_uart_send_data_request);
> >   
> >   	gb_tty->buffer = kzalloc(gb_tty->buffer_payload_max, GFP_KERNEL);
> >   	if (!gb_tty->buffer) {
> >   		retval = -ENOMEM;
> > -		goto exit_connection_destroy;
> > +		goto exit_put_port;
> >   	}
> >   
> >   	INIT_WORK(&gb_tty->tx_work, gb_uart_tx_write_work);
> > @@ -830,7 +846,7 @@ static int gb_uart_probe(struct gbphy_device *gbphy_dev,
> >   	retval = kfifo_alloc(&gb_tty->write_fifo, GB_UART_WRITE_FIFO_SIZE,
> >   			     GFP_KERNEL);
> >   	if (retval)
> > -		goto exit_buf_free;
> > +		goto exit_put_port;
> >   
> >   	gb_tty->credits = GB_UART_FIRMWARE_CREDITS;
> >   	init_completion(&gb_tty->credits_complete);
> > @@ -844,7 +860,7 @@ static int gb_uart_probe(struct gbphy_device *gbphy_dev,
> >   		} else {
> >   			retval = minor;
> >   		}
> > -		goto exit_kfifo_free;
> > +		goto exit_put_port;
> >   	}
> >   
> >   	gb_tty->minor = minor;
> > @@ -853,9 +869,6 @@ static int gb_uart_probe(struct gbphy_device *gbphy_dev,
> >   	init_waitqueue_head(&gb_tty->wioctl);
> >   	mutex_init(&gb_tty->mutex);
> >   
> > -	tty_port_init(&gb_tty->port);
> > -	gb_tty->port.ops = &gb_port_ops;
> > -
> >   	gb_tty->connection = connection;
> >   	gb_tty->gbphy_dev = gbphy_dev;
> >   	gb_connection_set_data(connection, gb_tty);
> > @@ -863,7 +876,7 @@ static int gb_uart_probe(struct gbphy_device *gbphy_dev,
> >   
> >   	retval = gb_connection_enable_tx(connection);
> >   	if (retval)
> > -		goto exit_release_minor;
> > +		goto exit_put_port;
> >   
> >   	send_control(gb_tty, gb_tty->ctrlout);
> >   
> > @@ -890,16 +903,10 @@ static int gb_uart_probe(struct gbphy_device *gbphy_dev,
> >   
> >   exit_connection_disable:
> >   	gb_connection_disable(connection);
> > -exit_release_minor:
> > -	release_minor(gb_tty);
> > -exit_kfifo_free:
> > -	kfifo_free(&gb_tty->write_fifo);
> > -exit_buf_free:
> > -	kfree(gb_tty->buffer);
> > +exit_put_port:
> > +	tty_port_put(&gb_tty->port);
> >   exit_connection_destroy:
> >   	gb_connection_destroy(connection);
> > -exit_tty_free:
> > -	kfree(gb_tty);
> >   
> >   	return retval;
> >   }
> > @@ -930,15 +937,10 @@ static void gb_uart_remove(struct gbphy_device *gbphy_dev)
> >   	gb_connection_disable_rx(connection);
> >   	tty_unregister_device(gb_tty_driver, gb_tty->minor);
> >   
> > -	/* FIXME - free transmit / receive buffers */
> > -
> >   	gb_connection_disable(connection);
> > -	tty_port_destroy(&gb_tty->port);
> >   	gb_connection_destroy(connection);
> > -	release_minor(gb_tty);
> > -	kfifo_free(&gb_tty->write_fifo);
> > -	kfree(gb_tty->buffer);
> > -	kfree(gb_tty);
> > +
> > +	tty_port_put(&gb_tty->port);
> 
> In the error path above, you call tty_port_put()
> before calling gb_connection_destroy(), which matches
> (in reverse) the order in which they're created. I'm
> accustomed to having the order of the calls here match
> the error path.  Is this difference intentional?  (It
> shouldn't really matter.)

I considered reordering (it stands out a bit in my eyes too) but decided
to leave it in place to highlight the fact that the connection may be
freed before the rest of the state either way (since a user may hold a
reference to it).

[ A driver mustn't do I/O after remove() returns even if it might be
  possible to keep the connection structure around. That would however be
  complicated by the lack of reference counting on the bundle/interface
  structures so I decided not to venture down that path. ]

Like you say, the order here doesn't really matter so I can move it up
if you prefer.

Johan

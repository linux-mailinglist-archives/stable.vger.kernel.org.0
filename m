Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1216536231A
	for <lists+stable@lfdr.de>; Fri, 16 Apr 2021 16:52:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245041AbhDPOq1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Apr 2021 10:46:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:36180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244605AbhDPOq1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 16 Apr 2021 10:46:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 795AC610FC;
        Fri, 16 Apr 2021 14:46:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618584362;
        bh=qpm8MHd3hC7x4V+sHrNbEegZYfAuyfhVcaQke9j+V4w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=emeqpdgMpiXTBNBcX+7GWIkt6+uwu9f/LSuSpAsfeu5lI4+6Wx9eqv7xDr/sugXm4
         9gQFCnBEFdx2WjeZstLIUwzu9C4AUvzT8jXoMKBcWxVu4NOHencpiPlj2TQVWOMZQ8
         zajt5y1otU6cSmsw0wCRanjuxVJkkeQ/KmqoQWQt9tg0AhRqbOEpJw6YzivV4pnsHa
         G1NNIOYnOF5ehTftC/lHlWuza/TcGW0umzXHCmLSoXAwOvzo7Q9quHYQoNi6twAymg
         WV5bHRUXKMplB5dNaZs3q7s4s9MewkyLo9zS2y0KnKO9M8Z1Qh5HePT7EfUh3j0dlp
         6CdVXgRcZM6FQ==
Received: from johan by xi.lan with local (Exim 4.93.0.4)
        (envelope-from <johan@kernel.org>)
        id 1lXPjO-0006fq-1A; Fri, 16 Apr 2021 16:46:02 +0200
Date:   Fri, 16 Apr 2021 16:46:02 +0200
From:   Johan Hovold <johan@kernel.org>
To:     dillon min <dillon.minfei@gmail.com>
Cc:     Alexandre TORGUE <alexandre.torgue@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Erwan Le Ray <erwan.leray@foss.st.com>,
        Gerald Baeza <gerald.baeza@st.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 2/3] serial: stm32: fix threaded interrupt handling
Message-ID: <YHmjKhH7xWz0BxEv@hovoldconsulting.com>
References: <20210416140557.25177-1-johan@kernel.org>
 <20210416140557.25177-3-johan@kernel.org>
 <CAL9mu0KwgOFQfa8ft4rB6+F=KLd1gZLYDvwpAW72zPAFntehVw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAL9mu0KwgOFQfa8ft4rB6+F=KLd1gZLYDvwpAW72zPAFntehVw@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Apr 16, 2021 at 10:35:25PM +0800, dillon min wrote:
> Hi Johan
> 
> Thanks for share your patch.
> 
> Johan Hovold <johan@kernel.org>于2021年4月16日 周五22:11写道：
> 
> > When DMA is enabled the receive handler runs in a threaded handler, but
> > the primary handler up until very recently neither disabled interrupts
> > in the device or used IRQF_ONESHOT. This would lead to a deadlock if an
> > interrupt comes in while the threaded receive handler is running under
> > the port lock.
> >
> Greg told me there was a patch fixed this case. In case hard irq &
> threaded_fn both offered. The local_irq_save() will be executed before call
> driver’s threaded handler.
> 
> Post the original mail from Greg
> 
> Please see 81e2073c175b ("genirq: Disable interrupts for force threaded
> handlers") for when threaded irq handlers have irqs disabled, isn't that
> the case you are trying to "protect" from here?
> 
> Why is the "threaded" flag used at all?  The driver should not care.
> 
> Also see 9baedb7baeda ("serial: imx: drop workaround for forced irq
> threading") in linux-next for an example of how this was fixed up in a
> serial driver.

Neither of these commits are (directly) related to the problem this
patch addresses (they are about force-threaded handlers, this is about a
normal threaded handler which run with interrupts enabled).

Johan

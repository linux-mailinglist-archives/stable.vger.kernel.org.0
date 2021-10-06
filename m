Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75325423BB7
	for <lists+stable@lfdr.de>; Wed,  6 Oct 2021 12:49:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231571AbhJFKvQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Oct 2021 06:51:16 -0400
Received: from phobos.denx.de ([85.214.62.61]:48306 "EHLO phobos.denx.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229824AbhJFKvP (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 6 Oct 2021 06:51:15 -0400
Received: from mail.denx.de (unknown [IPv6:2a01:238:438b:c500:173d:9f52:ddab:ee01])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: festevam@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id 35CA48324B;
        Wed,  6 Oct 2021 12:49:21 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1633517361;
        bh=oE7kQQEjC3EyGHKWcyJtq4yIkuBJWBR9pWa1Xn24X2M=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=rKITM9isv0HQg8FQY8n2okU8Jzb03TjukOMGl+/x8GDwUEr2g5Rg+JZhEFjuYwOAK
         Gqcdz8hJnJJPKhZY0dviMFuOWQ5/p9Fox8nC0pqMdISfYYSz8G1lzmqKsFjhJQ7Q56
         2MB2iMM+/gRxBFfoskzxBkF+oEUGOJ1j4U7nbffJqp69bmtxDemFzzAhzLZ8LWgh9O
         ilxPyKsfWmXbH3m4XIIBXRUx7hx5r3T0gkQeXZPF80sP4CkYP0wmy2e27ZiPRvM3kz
         RCmGEeOWLEZDM9hWAAO9KIBvSoAb6sQiYSS+ZGWdF6k5WJFE8OPJxlIN5B1ZeMtKYX
         86MKoQLl09BFQ==
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 06 Oct 2021 07:49:21 -0300
From:   Fabio Estevam <festevam@denx.de>
To:     Johan Hovold <johan@kernel.org>
Cc:     Tejun Heo <tj@kernel.org>, Lai Jiangshan <jiangshanlai@gmail.com>,
        Petr Mladek <pmladek@suse.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        John Ogness <john.ogness@linutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] workqueue: fix state-dump console deadlock
In-Reply-To: <20211006081115.20451-1-johan@kernel.org>
References: <YV1Z8JslFiBSFGJF@hovoldconsulting.com>
 <20211006081115.20451-1-johan@kernel.org>
Message-ID: <4b350c456eff081e92fe8868cccc52a5@denx.de>
X-Sender: festevam@denx.de
User-Agent: Roundcube Webmail/1.3.6
X-Virus-Scanned: clamav-milter 0.103.2 at phobos.denx.de
X-Virus-Status: Clean
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Johan,

On 06/10/2021 05:11, Johan Hovold wrote:
> Console drivers often queue work while holding locks also taken in 
> their
> console write paths, something which can lead to deadlocks on SMP when
> dumping workqueue state (e.g. sysrq-t or on suspend failures).
> 
> For serial console drivers this could look like:
> 
> 	CPU0				CPU1
> 	----				----
> 
> 	show_workqueue_state();
> 	  lock(&pool->lock);		<IRQ>
> 	  				  lock(&port->lock);
> 					  schedule_work();
> 					    lock(&pool->lock);
> 	  printk();
> 	    lock(console_owner);
> 	    lock(&port->lock);
> 
> where workqueues are, for example, used to push data to the line
> discipline, process break signals and handle modem-status changes. Line
> disciplines and serdev drivers can also queue work on write-wakeup
> notifications, etc.
> 
> Reworking every console driver to avoid queuing work while holding 
> locks
> also taken in their write paths would complicate drivers and is neither
> desirable or feasible.
> 
> Instead use the deferred-printk mechanism to avoid printing while
> holding pool locks when dumping workqueue state.
> 
> Note that there are a few WARN_ON() assertions in the workqueue code
> which could potentially also trigger a deadlock. Hopefully the ongoing
> printk rework will provide a general solution for this eventually.
> 
> This was originally reported after a lockdep splat when executing
> sysrq-t with the imx serial driver.
> 
> Fixes: 3494fc30846d ("workqueue: dump workqueues on sysrq-t")
> Cc: stable@vger.kernel.org	# 4.0
> Reported-by: Fabio Estevam <festevam@denx.de>
> Signed-off-by: Johan Hovold <johan@kernel.org>

With this patch applied, I no longer get the lockdep splat when 
executing
sysrq-t with the imx serial driver, thanks:

Tested-by: Fabio Estevam <festevam@denx.de>

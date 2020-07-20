Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 004F7225F84
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 14:51:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728724AbgGTMud (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 08:50:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:46674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728842AbgGTMub (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 08:50:31 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7DAAD2073A;
        Mon, 20 Jul 2020 12:50:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595249431;
        bh=EpCBYwNnx6X/nlQur+5lQcYTtsHD5GOPZLbr3Y5VuQo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SrKTPt+vTO7RCeoU+p9/ag2zdsoGcngnc5q9QiMm+Rf0cQF3JnWBTWaI5WG+sH/yB
         Hl3SROwNDH/FHQf8UxNWUoOXfYAbCmWZ9WsLPkA2zgFp+5OwKaHHr3ix0bLLj4s8qo
         mdvrBHLul8ThpAGFF/ETl0/hv1YV8z857gr4Emqs=
Date:   Mon, 20 Jul 2020 14:50:41 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Cc:     stable@vger.kernel.org, Petr Mladek <pmladek@suse.com>
Subject: Re: printk: queue wake_up_klogd irq_work only if per-CPU areas are
 ready
Message-ID: <20200720125041.GC3147730@kroah.com>
References: <20200414120613.GD12779@google.com>
 <20200414121412.GA605766@kroah.com>
 <20200414131309.GE12779@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200414131309.GE12779@google.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 14, 2020 at 10:13:09PM +0900, Sergey Senozhatsky wrote:
> On (20/04/14 14:14), Greg KH wrote:
> > On Tue, Apr 14, 2020 at 09:06:13PM +0900, Sergey Senozhatsky wrote:
> > > Hello,
> > > 
> > > Commit ab6f762f0f53162d41 Linus' HEAD.
> > > 
> > > printk_deferred() does not make sure that it's safe to write to
> > > per-CPU data, which causes problems when printk_deferred() is
> > > invoked "too early", before per-CPU areas are initialized. There
> > > are multiple bug reports, e.g.
> > > https://bugzilla.kernel.org/show_bug.cgi?id=206847
> > > 
> > > 	-ss
> > 
> > So where do you want this commit backported to?
> 
> Well,  printk() is affected in all the kernels where
> printk_deferred() relies on per-CPU data. Which may
> translate to "pretty much all current stable kernels?"
> This patch, however, uses printk_safe() bits, so it
> won't apply on pre-printk_safe() kernels (not sure if
> we have such -stable kernels though).

This is already in the 5.4.y tree, so I've added it to 4.19.y, but I
could not apply it to anything older (4.14.y, 4.9.y, 4.4.y) as it did
not apply there.

If you want it in those older kernels, and you think it is really
needed, please feel free to send a backported version for them.

thanks,

greg k-h

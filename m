Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25954D296B
	for <lists+stable@lfdr.de>; Thu, 10 Oct 2019 14:24:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728086AbfJJMYa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Oct 2019 08:24:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:43378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727800AbfJJMYa (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Oct 2019 08:24:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 00DA62064A;
        Thu, 10 Oct 2019 12:24:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570710269;
        bh=V6Im9tIruuo5nEvuNj2TYE6nnP2KSGGLoqkQxLOo1Rg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vE005q4Dy9h01CqRYK7q5jjWARTiVtFAM+i+HEH6av5S/ONj6l1u+XVHiQux6YEJI
         KD8y237gGMVO/3gGWma4xJaVvbUHNAcl+7HvNTJkZLrkRPQJ8skXNSEvKnN3pB6b/8
         lyn1k0I5QDuvKQ74B12TcsIjO51ZnBYyPD+EaADQ=
Date:   Thu, 10 Oct 2019 14:24:26 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Johan Hovold <johan@kernel.org>
Cc:     linux-usb@vger.kernel.org, Keith Packard <keithp@keithp.com>,
        Juergen Stuber <starblue@users.sourceforge.net>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH 5/5] USB: yurex: fix NULL-derefs on disconnect
Message-ID: <20191010122426.GA702899@kroah.com>
References: <20191009153848.8664-1-johan@kernel.org>
 <20191009153848.8664-6-johan@kernel.org>
 <20191010110532.GC27819@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191010110532.GC27819@localhost>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 10, 2019 at 01:05:32PM +0200, Johan Hovold wrote:
> On Wed, Oct 09, 2019 at 05:38:48PM +0200, Johan Hovold wrote:
> > The driver was using its struct usb_interface pointer as an inverted
> > disconnected flag, but was setting it to NULL without making sure all
> > code paths that used it were done with it.
> > 
> > Before commit ef61eb43ada6 ("USB: yurex: Fix protection fault after
> > device removal") this included the interrupt-in completion handler, but
> > there are further accesses in dev_err and dev_dbg statements in
> > yurex_write() and the driver-data destructor (sic!).
> > 
> > Fix this by unconditionally stopping also the control URB at disconnect
> > and by using a dedicated disconnected flag.
> > 
> > Note that we need to take a reference to the struct usb_interface to
> > avoid a use-after-free in the destructor whenever the device was
> > disconnected while the character device was still open.
> > 
> > Fixes: aadd6472d904 ("USB: yurex.c: remove dbg() usage")
> > Fixes: 45714104b9e8 ("USB: yurex.c: remove err() usage")
> > Cc: stable <stable@vger.kernel.org>     # 3.5: ef61eb43ada6
> > Signed-off-by: Johan Hovold <johan@kernel.org>
> 
> Greg, I noticed that you picked up all patches in this series except
> this last one.
> 
> Was that one purpose or by mistake?

Mistake, thanks for catching that.  Now queued up.

greg k-h

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1ADBD31FF5
	for <lists+stable@lfdr.de>; Sat,  1 Jun 2019 18:20:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726762AbfFAQUe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 1 Jun 2019 12:20:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:59248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726149AbfFAQUe (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 1 Jun 2019 12:20:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AFB932774F;
        Sat,  1 Jun 2019 16:20:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559406033;
        bh=6laOSTLzmJPn/3X/WVYoQFU6lfzJEz5F7FILZLqK2hw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XIi6I+UM6/JKaZBVQxA0JJURbfWoRFp5o/O/D4PRyoLiiV4PfzsW8bU7pLPo70wRA
         zn3vhn4QjclSP9t/mjs5Ne65h6e9e9Zq6yoAcGZW3MDeM541B7s8TO7/PHTAF4D1H0
         3uk2TQHvQfWRy6k9tlbcCukURXynl1V/sM0wntRo=
Date:   Sat, 1 Jun 2019 09:18:36 -0700
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Sahara <keun-o.park@darkmatter.ae>
Subject: Re: [PATCH AUTOSEL 4.4 50/56] tty: pty: Fix race condition between
 release_one_tty and pty_write
Message-ID: <20190601161836.GD4200@kroah.com>
References: <20190601132600.27427-1-sashal@kernel.org>
 <20190601132600.27427-50-sashal@kernel.org>
 <20190601161707.GC4200@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190601161707.GC4200@kroah.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jun 01, 2019 at 09:17:07AM -0700, Greg Kroah-Hartman wrote:
> On Sat, Jun 01, 2019 at 09:25:54AM -0400, Sasha Levin wrote:
> > From: Sahara <keun-o.park@darkmatter.ae>
> > 
> > [ Upstream commit b9ca5f8560af244489b4a1bc1ae88b341f24bc95 ]
> > 
> > Especially when a linked tty is used such as pty, the linked tty
> > port's buf works have not been cancelled while master tty port's
> > buf work has been cancelled. Since release_one_tty and flush_to_ldisc
> > run in workqueue threads separately, when pty_cleanup happens and
> > link tty port is freed, flush_to_ldisc tries to access freed port
> > and port->itty, eventually it causes a panic.
> > This patch utilizes the magic value with holding the tty_mutex to
> > check if the tty->link is valid.
> > 
> > Fixes: 2b022ab7542d ("pty: cancel pty slave port buf's work in tty_release")
> > Signed-off-by: Sahara <keun-o.park@darkmatter.ae>
> > Cc: stable <stable@vger.kernel.org>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > ---
> >  drivers/tty/pty.c    | 7 +++++++
> >  drivers/tty/tty_io.c | 3 +++
> >  2 files changed, 10 insertions(+)
> 
> For some reason I did not apply this to the stable kernels, and this
> shouldn't only be for 4.4.y, so please drop this.

Ah, I never applied it because it was later reverted, also upstream,
0eae4686a128 ("Revert "tty: pty: Fix race condition between
release_one_tty and pty_write""), so I didn't apply both of them to the
stable trees as that wouldn't have made sense.

thanks,

greg k-h

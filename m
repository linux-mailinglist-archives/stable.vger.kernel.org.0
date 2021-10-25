Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B1F3439AD9
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 17:51:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230070AbhJYPxu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 11:53:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:33062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232711AbhJYPxu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 11:53:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 528E260184;
        Mon, 25 Oct 2021 15:51:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635177087;
        bh=HxdPjBPnGIttkaa3TypuRSPZtcG6/Elr6j35miiBv0Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=p/rfnLtAj+aDZSBD1rToQvk7RUgp+D3YaJn3fhiBkTlqO5gGOO2z0EhV4ADY30z6C
         pRx6Pb4ovHkC2xRtg5bT6+rAABaKfDE6rxwXe2jEnMG9QBUyEjopT1s6E4J3i7xpWj
         BLcIsJa+IhraWkjOrX8OcFwCanpkiY/Uql9DeZbQ=
Date:   Mon, 25 Oct 2021 17:51:25 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Joe Perches <joe@perches.com>
Cc:     Larry Finger <Larry.Finger@lwfinger.net>,
        Johan Hovold <johan@kernel.org>, cocci@inria.fr,
        Florian Schilhabel <florian.c.schilhabel@googlemail.com>,
        linux-staging@lists.linux.dev, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/2] staging: rtl8192u: fix control-message timeouts
Message-ID: <YXbSfYIuyj3PI6pm@kroah.com>
References: <20211025120910.6339-1-johan@kernel.org>
 <20211025120910.6339-2-johan@kernel.org>
 <fdb677be-6e06-fef9-811d-bb2c71246197@lwfinger.net>
 <094a8f50ccef81e0317c89d0a605c327c825d5cb.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <094a8f50ccef81e0317c89d0a605c327c825d5cb.camel@perches.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 25, 2021 at 08:41:36AM -0700, Joe Perches wrote:
> On Mon, 2021-10-25 at 10:06 -0500, Larry Finger wrote:
> > On 10/25/21 07:09, Johan Hovold wrote:
> > > USB control-message timeouts are specified in milliseconds and should
> > > specifically not vary with CONFIG_HZ.
> 
> There appears to be more than a few of these in the kernel.
> 
> $ cat usb_hz.cocci
> @@
> expression e;
> @@
> * usb_control_msg(..., HZ * e)
> 
> @@
> expression e;
> @@
> * usb_control_msg(..., HZ / e)
> 
> @@
> @@
> * usb_control_msg(..., HZ)
> 
> $ spatch --very-quiet -U 0 -sp-file usb_hz.cocci .
> warning: line 4: should HZ be a metavariable?
> warning: line 9: should HZ be a metavariable?
> warning: line 13: should HZ be a metavariable?
> 50 files match

Look at the lists, he's sent a bunch of fixes for this today to all the
subsystems...

greg k-h

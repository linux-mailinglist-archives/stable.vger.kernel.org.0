Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A5C416216E
	for <lists+stable@lfdr.de>; Tue, 18 Feb 2020 08:17:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726104AbgBRHRr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Feb 2020 02:17:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:39582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726072AbgBRHRr (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 18 Feb 2020 02:17:47 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7B597207FD;
        Tue, 18 Feb 2020 07:17:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582010266;
        bh=TptrOmN9olc77EOFb55S0oGUJ2AnHnCIpyfBD4JXfpk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JHwm9kzUgoWAlTQXwUpdpe6fhpgeX19c3Yxgc1Ga4x20dsQh2iWTkLYidTOBxENUG
         Sc16GXyFOlBH9qK+efHnhQySjDauwZR4hWaB6hSlvIBKbjJbYUJ+WDX8rvbOiqyII6
         pgfBIpVWXe/JLq9FbNOCbv6MPEjohNsSzfgSH5FQ=
Date:   Tue, 18 Feb 2020 08:17:44 +0100
From:   "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To:     Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
        <u.kleine-koenig@pengutronix.de>
Cc:     Schrempf Frieder <frieder.schrempf@kontron.de>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "shawnguo@kernel.org" <shawnguo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>
Subject: Re: [PATCH 0/2] serial: imx: Backport fixes for irq handling to v4.14
Message-ID: <20200218071744.GA2087281@kroah.com>
References: <20200217140740.29743-1-frieder.schrempf@kontron.de>
 <20200218045008.GA2049358@kroah.com>
 <20200218070310.ibv2m2f7ihfaevrp@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200218070310.ibv2m2f7ihfaevrp@pengutronix.de>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 18, 2020 at 08:03:10AM +0100, Uwe Kleine-König wrote:
> On Tue, Feb 18, 2020 at 05:50:08AM +0100, gregkh@linuxfoundation.org wrote:
> > On Mon, Feb 17, 2020 at 02:08:00PM +0000, Schrempf Frieder wrote:
> > > From: Frieder Schrempf <frieder.schrempf@kontron.de>
> > > 
> > > A customer of ours has problems with RS485 on i.MX6UL with the latest v4.14
> > > kernel. They get an exception like below from time to time (the trace is
> > > from an older kernel, but the problem also exists in v4.14.170).
> > > 
> > > As the cpuidle state 2 causes large delays for the interrupt that controls the
> > > RS485 RTS signal (which can lead to collisions on the bus), cpuidle state 2 was
> > > disabled on this system. This aspect might cause the exception happening more
> > > often on this system than on other systems with default cpuidle settings.
> > > 
> > > Looking for solutions I found Uwe's patches that were applied in v4.17 being
> > > mentioned here [1] and here [2]. In [1] Uwe notes that backporting these fixes
> > > to v4.14 might not be trivial, but I tried and in my opinion found it not to be
> > > too problematic either.
> > > 
> > > With the backported patches applied, our customer reports that the exceptions
> > > stopped occuring. Given this and the fact that the problem seems to be known
> > > and quite common, it would be nice to get this into the v4.14 stable tree. 
> > 
> > Thanks for the backports, both now queued up.
> 
> To complete these fixes you also want to backport
> 
> 	101aa46bd221 serial: imx: fix a race condition in receive path

If so, it needs to also go to 4.19.y, and someone needs to provide a
working backport for both places :)

thanks,

greg k-h

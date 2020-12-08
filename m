Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 720632D26FD
	for <lists+stable@lfdr.de>; Tue,  8 Dec 2020 10:06:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728774AbgLHJFq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Dec 2020 04:05:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:59986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728192AbgLHJFp (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Dec 2020 04:05:45 -0500
Date:   Tue, 8 Dec 2020 10:06:06 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1607418298;
        bh=Mxm4tMc0lHI8bH/rVnSlJy9zQmdRnBcybnvarWYeXXg=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=yE8rQ4cCeTYmHpAZV1twhXooXpSNffV/wzJ4rqpRmIfBkKkORQmkjmFsObfxuoaVO
         biU1+JtbWqp9niROIfCYuRWDjP/hR7mARtp+xKRM+VMwQMJXiGLuA3k522da1ZiDWP
         o5Nlgv8cOrjJYPp/embz6olO9XR5icUZKAOkGSu0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@ucw.cz>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Brian King <brking@linux.vnet.ibm.com>,
        Pradeep Satyanarayana <pradeeps@linux.vnet.ibm.com>,
        Dany Madden <drt@linux.ibm.com>, Lijun Pan <ljp@linux.ibm.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH 4.19 11/32] ibmvnic: notify peers when failover and
 migration happen
Message-ID: <X89B/ob8dDZpHHee@kroah.com>
References: <20201206111555.787862631@linuxfoundation.org>
 <20201206111556.317195640@linuxfoundation.org>
 <20201206170708.GA4901@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201206170708.GA4901@duo.ucw.cz>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Dec 06, 2020 at 06:07:08PM +0100, Pavel Machek wrote:
> Hi!
> 
> > From: Lijun Pan <ljp@linux.ibm.com>
> > 
> > [ Upstream commit 98025bce3a6200a0c4637272a33b5913928ba5b8 ]
> > 
> > Commit 61d3e1d9bc2a ("ibmvnic: Remove netdev notify for failover resets")
> > excluded the failover case for notify call because it said
> > netdev_notify_peers() can cause network traffic to stall or halt.
> > Current testing does not show network traffic stall
> > or halt because of the notify call for failover event.
> > netdev_notify_peers may be used when a device wants to inform the
> > rest of the network about some sort of a reconfiguration
> > such as failover or migration.
> > 
> > It is unnecessary to call that in other events like
> > FATAL, NON_FATAL, CHANGE_PARAM, and TIMEOUT resets
> > since in those scenarios the hardware does not change.
> > If the driver must do a hard reset, it is necessary to notify peers.
> 
> Something went wrong here.
> 
> > @@ -1877,8 +1877,9 @@ static int do_reset(struct ibmvnic_adapt
> >  	for (i = 0; i < adapter->req_rx_queues; i++)
> >  		napi_schedule(&adapter->napi[i]);
> >  
> > -	if (adapter->reset_reason != VNIC_RESET_FAILOVER &&
> > -	    adapter->reset_reason != VNIC_RESET_CHANGE_PARAM) {
> > +	if ((adapter->reset_reason != VNIC_RESET_FAILOVER &&
> > +	     adapter->reset_reason != VNIC_RESET_CHANGE_PARAM) ||
> > +	     adapter->reset_reason == VNIC_RESET_MOBILITY) {
> 
> This condition does not make sense... part after || is redundant.
> 
> Mainline changed != in FAILOVER test to ==, so it does not have same
> problem.

Odd, ok, I'll just go drop this patch from the queue, thanks.

greg k-h

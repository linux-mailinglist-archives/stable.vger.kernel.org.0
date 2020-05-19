Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0A8C1D94C5
	for <lists+stable@lfdr.de>; Tue, 19 May 2020 12:53:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728683AbgESKxw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 May 2020 06:53:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:51126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726121AbgESKxw (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 May 2020 06:53:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6D7B7206D4;
        Tue, 19 May 2020 10:53:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589885631;
        bh=SaHVtBOSU3JUQGaVfj+rJSDVhkCnrgknWT7OZr409xM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RRA2R/hmv3rkRNxzfnF1zussdKZOqXRSZaI52hpowLFU2bVJVWJIXtelQcuDHKX7u
         h/iD6QuSNBLUpkVUqQcw7LShZOZ4B3b4PV8IRZTsRl/PfibFeo1/TTli1sdfAwIeNW
         1TKezX+fuvRAoT/4wfB/yQXeaXMMyTO+pKytl0lM=
Date:   Tue, 19 May 2020 12:53:49 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Henri Rosten <henri.rosten@unikie.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>,
        Keith Busch <keith.busch@intel.com>, Jens Axboe <axboe@fb.com>,
        Giuliano Procida <gprocida@google.com>, lukas.bulwahn@gmail.com
Subject: Re: [PATCH 4.4 63/86] block: defer timeouts to a workqueue
Message-ID: <20200519105349.GB120343@kroah.com>
References: <20200518173450.254571947@linuxfoundation.org>
 <20200518173503.131794977@linuxfoundation.org>
 <20200519060036.GA28441@buimax>
 <20200519073147.GA3997465@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200519073147.GA3997465@kroah.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 19, 2020 at 09:31:47AM +0200, Greg Kroah-Hartman wrote:
> On Tue, May 19, 2020 at 09:00:38AM +0300, Henri Rosten wrote:
> > On Mon, May 18, 2020 at 07:36:34PM +0200, Greg Kroah-Hartman wrote:
> > > From: Christoph Hellwig <hch@lst.de>
> > > 
> > > commit 287922eb0b186e2a5bf54fdd04b734c25c90035c upstream.
> > 
> > I notice 287922eb0b18 has been referenced in Fixes-tag in mainline 
> > commit 5480e299b5ae ("scsi: iscsi: Fix a potential deadlock in the 
> > timeout handler"). Consider if backporting 5480e299b5ae together with 
> > this 4.4 version of 287922eb0b18 is also relevant.
> 
> Ugh, there are lots of "fixes for fixes" in these releases that seem to
> be needed.  Let me dig through and find them all as I should have done
> before starting this -rc round :(

Turns out you found the two issues here, and I've queued up this fix
now.

thanks,

greg k-h

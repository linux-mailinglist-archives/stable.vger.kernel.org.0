Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD9CB3F5F01
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 15:25:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237604AbhHXN0G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 09:26:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:34254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237590AbhHXN0F (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 09:26:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 811D9611AF;
        Tue, 24 Aug 2021 13:25:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629811521;
        bh=Xg8K4I0Gs0daaOlalTp5ULJqYhu6wF81wH5q1gzUe3w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Tuyg+xGDwAtSeSsE7cdJlUneRlDcb/YpW627m2oKkwrvSzUlgdLnrZRUcWZNyNICN
         bcWxByqGm597JipPnCO7rBSuoXYyb6bAlzTcapH6dzrgjaeci5xgwMVQ2USlB5Hk+A
         GBo7iR4agE090uW4VsC63g9NMdm4avzMFkMllYTCUVlvQLvuEpcmSfzh7kxdtdvJgO
         mOw6JWXCnwMtJ8kNXShmtDI46CDQfl6jc1Ie5xm2kvdGscsUoUkqBJnr9mC6I6Xga6
         TqLfqbNscprG2hkgO27C/QW66fxtyu4dEZFizpxDNcQ0+1/JR/DsaIOJ7bqgeUY0AC
         bLphbAAqV40cQ==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1mIWQW-0005FL-EE; Tue, 24 Aug 2021 15:25:17 +0200
Date:   Tue, 24 Aug 2021 15:25:16 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Willy Tarreau <w@1wt.eu>
Cc:     linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paul =?utf-8?B?R3LDtsOfZWw=?= <pb.g@gmx.de>,
        stable@vger.kernel.org
Subject: Re: [PATCH] Revert "USB: serial: ch341: fix character loss at high
 transfer rates"
Message-ID: <YSTzPIkwNDOON5j8@hovoldconsulting.com>
References: <20210824121926.19311-1-johan@kernel.org>
 <20210824123232.GA25435@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210824123232.GA25435@1wt.eu>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 24, 2021 at 02:32:32PM +0200, Willy Tarreau wrote:
> On Tue, Aug 24, 2021 at 02:19:26PM +0200, Johan Hovold wrote:
> > This reverts commit 3c18e9baee0ef97510dcda78c82285f52626764b.
> > 
> > These devices do not appear to send a zero-length packet when the
> > transfer size is a multiple of the bulk-endpoint max-packet size. This
> > means that incoming data may not be processed by the driver until a
> > short packet is received or the receive buffer is full.
> > 
> > Revert back to using endpoint-sized receive buffers to avoid stalled
> > reads.
> 
> Sorry for this, I didn't notice any issue here (aside for the chip
> working where it used not to). I have no idea what these zero-length
> packets correspond to, nor why they're affected by the transfer size.
> Do you have any idea what I should look for ? Because without that
> patch, the device is unusable for me :-/

Zero-length packets are used to indicate completion of bulk transfers
that are multiples of the endpoint max-packet size (as per the USB
spec). Without those the host controller driver doesn't now that the
transfer is complete and that it should call the driver completion
callback (and instead waits for the other completion conditions).

It may be possible to configure the device to send ZLPs somehow but
since there's no public documentation for the protocol that may require
some reverse engineering.

Johan

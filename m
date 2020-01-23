Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 983DE146B3D
	for <lists+stable@lfdr.de>; Thu, 23 Jan 2020 15:26:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728792AbgAWO0V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jan 2020 09:26:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:59490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727022AbgAWO0V (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 Jan 2020 09:26:21 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A70372077C;
        Thu, 23 Jan 2020 14:26:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579789580;
        bh=pUpQjy5gmWH6F5Tm3J4L2GQ2KbZcKDf/Jszg+gCQgfM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JLXastXZbPjfh1uCgY2jBGGs45MbDtWsIDkpGqr8xoH/0j0m96yYbGHmKzEULyA+D
         /qibCaBE3Qzj+yQ/7YA9Vs85vwbsDJiVrB3EqRwHGzbLNBC+ItZePO4AR2TtlHe5Wm
         nLO+1NLyDhnWHvmO9IwZq5DJIdt2/lmhO4Qc7bUY=
Date:   Thu, 23 Jan 2020 15:26:17 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     Johan Hovold <johan@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 4.19 592/671] USB: usb-skeleton: fix
 use-after-free after driver unbind
Message-ID: <20200123142617.GA1685167@kroah.com>
References: <20200116170509.12787-1-sashal@kernel.org>
 <20200116170509.12787-329-sashal@kernel.org>
 <20200117102116.GS2301@localhost>
 <20200123142252.GE1706@sasha-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200123142252.GE1706@sasha-vm>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 23, 2020 at 09:22:52AM -0500, Sasha Levin wrote:
> On Fri, Jan 17, 2020 at 11:21:16AM +0100, Johan Hovold wrote:
> > On Thu, Jan 16, 2020 at 12:03:50PM -0500, Sasha Levin wrote:
> > > From: Johan Hovold <johan@kernel.org>
> > > 
> > > [ Upstream commit 6353001852776e7eeaab4da78922d4c6f2b076af ]
> > > 
> > > The driver failed to stop its read URB on disconnect, something which
> > > could lead to a use-after-free in the completion handler after driver
> > > unbind in case the character device has been closed.
> > > 
> > > Fixes: e7389cc9a7ff ("USB: skel_read really sucks royally")
> > > Signed-off-by: Johan Hovold <johan@kernel.org>
> > > Link: https://lore.kernel.org/r/20191009170944.30057-3-johan@kernel.org
> > > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > 
> > This one isn't needed in any stable tree. As we discussed before, the
> > skeleton driver is only there for documentation purposes.
> 
> I'll drop this, but I'm curious: doesn't this mean that users will build
> on buggy example code?

They should always be grabbing the "latest" version of the file to work
off of anyway.  Given that there are very few new USB drivers anymore, I
doubt this really matters much...

thanks,

greg k-h

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 769263E8B0A
	for <lists+stable@lfdr.de>; Wed, 11 Aug 2021 09:29:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235551AbhHKH3a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Aug 2021 03:29:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:44628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235502AbhHKH33 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Aug 2021 03:29:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1D7DC60EBD;
        Wed, 11 Aug 2021 07:29:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628666946;
        bh=pRQZSx3XWLGdwaXfIsQOAgpolYggzCai5Yf7G6+I4ag=;
        h=Date:From:To:Subject:References:In-Reply-To:From;
        b=HJA5LvM/i3BqBPc0dBTDDcqyEil40lAoi5lhKt3nl0kUiSf7BrKaJZqixpXnjyyT1
         uvxNCbWv5PaeaXFRE5hsl32ls5IGhlgdEcb5efJLARVrSkic4nb/eL20xHwOIvFFXH
         xR8ExmJX0IJrIbhbr9qOP+UAW7v5NF+P0oGg+p6s=
Date:   Wed, 11 Aug 2021 09:29:04 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Wolfram Sang <wsa@kernel.org>, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH v2] i2c: dev: zero out array used for i2c reads from
 userspace
Message-ID: <YRN8QHingopdwmxO@kroah.com>
References: <20210729143532.47240-1-gregkh@linuxfoundation.org>
 <YRLnr24IBwe5HS+j@kunai>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YRLnr24IBwe5HS+j@kunai>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 10, 2021 at 10:55:11PM +0200, Wolfram Sang wrote:
> On Thu, Jul 29, 2021 at 04:35:32PM +0200, Greg Kroah-Hartman wrote:
> > If an i2c driver happens to not provide the full amount of data that a
> > user asks for, it is possible that some uninitialized data could be sent
> > to userspace.  While all in-kernel drivers look to be safe, just be sure
> > by initializing the buffer to zero before it is passed to the i2c driver
> > so that any future drivers will not have this issue.
> > 
> > Also properly copy the amount of data recvieved to the userspace buffer,
> > as pointed out by Dan Carpenter.
> > 
> > Reported-by: Eric Dumazet <edumazet@google.com>
> > Cc: Dan Carpenter <dan.carpenter@oracle.com>
> > Cc: stable <stable@vger.kernel.org>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> Fixed checkpatch warning "WARNING: Invalid email format for stable:
> 'stable <stable@vger.kernel.org>', prefer 'stable@vger.kernel.org' " and
> applied to for-current, thanks!

That is a crazy warning, never even knew it was there.  But as the
stable maintainer, it does not look correct as both are just fine...

Anyway, thanks for taking the patch!

greg k-h

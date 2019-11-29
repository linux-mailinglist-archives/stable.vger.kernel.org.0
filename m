Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BAB6310D236
	for <lists+stable@lfdr.de>; Fri, 29 Nov 2019 09:04:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726847AbfK2IEy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Nov 2019 03:04:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:46418 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726763AbfK2IEy (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 29 Nov 2019 03:04:54 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4C17121721;
        Fri, 29 Nov 2019 08:04:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575014693;
        bh=HGzGPGDHGk7a3EnuhDNKCqOba0G729gHkP+G8ZTBkJs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=xSB/WHbkMDdp3eG42osTXjB0EqzJog9kSMZ9RJBN9W3S40qNnEnX6c4xT9J8l+ceA
         PWVyzHIuKSOFw/WhT50vzdf9QENPGg6i8X6WqkmnPgNAIw3MCXxqfUGXE1veprX9JF
         A4OHtb213PBtO11BvUKb7+XLgiqoM0d5qYUPOGdM=
Date:   Fri, 29 Nov 2019 09:04:50 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org,
        David Barmann <david.barmann@stackpath.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.4 093/132] sock: Reset dst when changing sk_mark via
 setsockopt
Message-ID: <20191129080450.GA3559797@kroah.com>
References: <20191127202857.270233486@linuxfoundation.org>
 <20191127203020.182005605@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191127203020.182005605@linuxfoundation.org>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 27, 2019 at 09:31:24PM +0100, Greg Kroah-Hartman wrote:
> From: David Barmann <david.barmann@stackpath.com>
> 
> [ Upstream commit 50254256f382c56bde87d970f3d0d02fdb76ec70 ]
> 
> When setting the SO_MARK socket option, if the mark changes, the dst
> needs to be reset so that a new route lookup is performed.
> 
> This fixes the case where an application wants to change routing by
> setting a new sk_mark.  If this is done after some packets have already
> been sent, the dst is cached and has no effect.
> 
> Signed-off-by: David Barmann <david.barmann@stackpath.com>
> Reviewed-by: Eric Dumazet <edumazet@google.com>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  net/core/sock.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)

This patch breaks a bunch of runtime tests in the Android ecosystem,
that somehow all successfully run just fine with kernels newer than 5.0
where this patch showed up in, so I think this is an "incomplete
backport".

Because of this, I'm going to drop this from the stable trees now.

thanks,

greg k-h

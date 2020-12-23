Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 344F82E205B
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 19:19:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726662AbgLWSRR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Dec 2020 13:17:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:41500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726554AbgLWSRR (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 23 Dec 2020 13:17:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5CA5622287;
        Wed, 23 Dec 2020 18:16:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1608747396;
        bh=BoQeJmWdEr/OznMQvbfeKfkjp8cYpgpv8gCuy8jo81s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=xe2rD6qcrQ/OrYBR9bMnz0//jGjqnP3FrHcZta6uon1FYnAvfAyg7HhTAC0qNO67t
         xk5+Zdj2BBTBTJY+Y3C6tw9DxbKDQdBPI0f8cRf3Z4FbI1vTDrKLAEKqNrZcMKnKCP
         zBADkyFpbGbBvjx6gi7wpGuTf+JtsgOJ3pR7Z7jc=
Date:   Wed, 23 Dec 2020 19:17:47 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Peilin Ye <yepeilin.cs@gmail.com>
Cc:     marcel@holtmann.org, stable@vger.kernel.org
Subject: Re: [PATCH 4.14 4.9 4.4-stable] Bluetooth: Fix slab-out-of-bounds
 read in hci_le_direct_adv_report_evt()
Message-ID: <X+OJyx/VEBlfItDz@kroah.com>
References: <20201223180446.17207-1-yepeilin.cs@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201223180446.17207-1-yepeilin.cs@gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 23, 2020 at 01:04:46PM -0500, Peilin Ye wrote:
> commit f7e0e8b2f1b0a09b527885babda3e912ba820798 upstream.
> 
> `num_reports` is not being properly checked. A malformed event packet with
> a large `num_reports` number makes hci_le_direct_adv_report_evt() read out
> of bounds. Fix it.
> 
> Backporting notes:
>   - Rebased on linux-4.14.y, commit 3f2ecb86cb90 ("Linux 4.14.212")
>   - Retested by syzbot
> 
> Cc: stable@vger.kernel.org
> Fixes: 2f010b55884e ("Bluetooth: Add support for handling LE Direct Advertising Report events")
> Reported-and-tested-by: syzbot+24ebd650e20bd263ca01@syzkaller.appspotmail.com
> Link: https://syzkaller.appspot.com/bug?extid=24ebd650e20bd263ca01
> Signed-off-by: Peilin Ye <yepeilin.cs@gmail.com>
> Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
> ---
>  net/bluetooth/hci_event.c | 12 +++++-------
>  1 file changed, 5 insertions(+), 7 deletions(-)

Thanks for the backport, now queued up!

greg k-h

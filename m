Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3DBCE17178C
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 13:37:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728998AbgB0Mh5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 07:37:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:36302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728982AbgB0Mh4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 07:37:56 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5EE3124692;
        Thu, 27 Feb 2020 12:37:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582807075;
        bh=LYndjluasFvOwT9cS111JQlMY4yrNHQvHvqjIBLUJgQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UDe5pD7Wm98QR+Duu+FR746o0EA24PTZ9S8Nsjv46813sLABQri45IwXqVox/7iDZ
         uQGs/RrB77tuiAMtSx9TNf0oqrcTaw+AGXh7lViF5zaXHFjNyMoEkJ1ZcVOosaV+GJ
         BsR/ZHsbnLG/c4Hog5WKQsjcNFXy4Jx+EAYenlVs=
Date:   Thu, 27 Feb 2020 13:37:53 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     stable@vger.kernel.org, io-uring@vger.kernel.org, axboe@kernel.dk
Subject: Re: [PATCH 5.4] io_uring: prevent sq_thread from spinning when it
 should stop
Message-ID: <20200227123753.GC962932@kroah.com>
References: <20200227104311.76533-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200227104311.76533-1-sgarzare@redhat.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 27, 2020 at 11:43:11AM +0100, Stefano Garzarella wrote:
> [ Upstream commit 7143b5ac5750f404ff3a594b34fdf3fc2f99f828 ]
> 
> This patch drops 'cur_mm' before calling cond_resched(), to prevent
> the sq_thread from spinning even when the user process is finished.
> 
> Before this patch, if the user process ended without closing the
> io_uring fd, the sq_thread continues to spin until the
> 'sq_thread_idle' timeout ends.
> 
> In the worst case where the 'sq_thread_idle' parameter is bigger than
> INT_MAX, the sq_thread will spin forever.
> 
> Fixes: 6c271ce2f1d5 ("io_uring: add submission polling")
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>  fs/io_uring.c | 20 ++++++++++----------
>  1 file changed, 10 insertions(+), 10 deletions(-)

thanks for this, now queued up.

greg k-h

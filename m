Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78FBB481381
	for <lists+stable@lfdr.de>; Wed, 29 Dec 2021 14:30:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234041AbhL2NaF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Dec 2021 08:30:05 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:49422 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233989AbhL2N3V (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Dec 2021 08:29:21 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3679DB818CB
        for <stable@vger.kernel.org>; Wed, 29 Dec 2021 13:29:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CA2EC36AE9;
        Wed, 29 Dec 2021 13:29:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640784559;
        bh=+IkEbxFanI7G1NMInY/FB/Ea5yyZvCFXSt4P++gpV90=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OjEuVoudjESfpKb1pS9MGdNaQguCyq+mYmdrslo67PBqNqqrolNl7kbvZW+nbtxXe
         PJLCkXJ/y3JZPJ3ApScqlcSJ0jZreLBigr88iITdEMCB9vQPdxh5UCA0J0zIzfKlCJ
         G6j1eI/kpXQioT5Xgo9n8GY0LGsFOzmU7qsG4FJg=
Date:   Wed, 29 Dec 2021 14:29:16 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jens Wiklander <jens.wiklander@linaro.org>
Cc:     stable@vger.kernel.org, Sumit Garg <sumit.garg@linaro.org>,
        Lars Persson <larper@axis.com>,
        Patrik Lantz <patrik.lantz@axis.com>
Subject: Re: [PATCH backport for 5.4] tee: handle lookup of shm with
 reference count 0
Message-ID: <YcxirCe9rQrvAv7c@kroah.com>
References: <20211228083255.1350258-1-jens.wiklander@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211228083255.1350258-1-jens.wiklander@linaro.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 28, 2021 at 09:32:55AM +0100, Jens Wiklander wrote:
> commit dfd0743f1d9ea76931510ed150334d571fbab49d upstream.
> 
> Since the tee subsystem does not keep a strong reference to its idle
> shared memory buffers, it races with other threads that try to destroy a
> shared memory through a close of its dma-buf fd or by unmapping the
> memory.
> 
> In tee_shm_get_from_id() when a lookup in teedev->idr has been
> successful, it is possible that the tee_shm is in the dma-buf teardown
> path, but that path is blocked by the teedev mutex. Since we don't have
> an API to tell if the tee_shm is in the dma-buf teardown path or not we
> must find another way of detecting this condition.
> 
> Fix this by doing the reference counting directly on the tee_shm using a
> new refcount_t refcount field. dma-buf is replaced by using
> anon_inode_getfd() instead, this separates the life-cycle of the
> underlying file from the tee_shm. tee_shm_put() is updated to hold the
> mutex when decreasing the refcount to 0 and then remove the tee_shm from
> teedev->idr before releasing the mutex. This means that the tee_shm can
> never be found unless it has a refcount larger than 0.
> 
> Fixes: 967c9cca2cc5 ("tee: generic TEE subsystem")
> Cc: stable@vger.kernel.org
> Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Reviewed-by: Lars Persson <larper@axis.com>
> Reviewed-by: Sumit Garg <sumit.garg@linaro.org>
> Reported-by: Patrik Lantz <patrik.lantz@axis.com>
> [JW: backport to 5.4-stable]
> Signed-off-by: Jens Wiklander <jens.wiklander@linaro.org>
> ---
>  drivers/tee/tee_shm.c   | 177 +++++++++++++++-------------------------
>  include/linux/tee_drv.h |   4 +-
>  2 files changed, 69 insertions(+), 112 deletions(-)

All backports queue up, thanks.

greg k-h

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84D9747591D
	for <lists+stable@lfdr.de>; Wed, 15 Dec 2021 13:52:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242610AbhLOMwl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Dec 2021 07:52:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232543AbhLOMwk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Dec 2021 07:52:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A53FC061574;
        Wed, 15 Dec 2021 04:52:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3A18F61880;
        Wed, 15 Dec 2021 12:52:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13FC4C34605;
        Wed, 15 Dec 2021 12:52:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639572759;
        bh=3tbuzGHVe1zQ3v7gkAGd6loUbFMON32Ei6GpwYqDi6Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OXb5TfFzE6CbjQHWoEbaXDEMyu1GIJe5M/YtafQMJDKom7N78yV+RREcruehy1Hu7
         xYEa/kSdOi2w44lX5gSlTwRXuxOxEvpt5rVlaOuOUSTVwZyIhodY5N6WQmYr9eXMRZ
         HTCBHG9xEYNfv68sxTUWt4qy/RtUtRLjT1ujPWyE=
Date:   Wed, 15 Dec 2021 13:52:37 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jens Wiklander <jens.wiklander@linaro.org>
Cc:     linux-kernel@vger.kernel.org, op-tee@lists.trustedfirmware.org,
        Sumit Garg <sumit.garg@linaro.org>,
        Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
        Rijo Thomas <Rijo-john.Thomas@amd.com>,
        Devaraj Rangasamy <Devaraj.Rangasamy@amd.com>,
        stable@vger.kernel.org, Lars Persson <larper@axis.com>,
        Patrik Lantz <patrik.lantz@axis.com>
Subject: Re: [PATCH v2] tee: handle lookup of shm with reference count 0
Message-ID: <YbnlFf8930RuLkU8@kroah.com>
References: <20211215092501.1861229-1-jens.wiklander@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211215092501.1861229-1-jens.wiklander@linaro.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 15, 2021 at 10:25:01AM +0100, Jens Wiklander wrote:
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
> Reviewed-by: Lars Persson <larper@axis.com>
> Reviewed-by: Sumit Garg <sumit.garg@linaro.org>
> Reported-by: Patrik Lantz <patrik.lantz@axis.com>
> Signed-off-by: Jens Wiklander <jens.wiklander@linaro.org>
> ---
> v1->v2
> * fix copyright years in drivers/tee/tee_shm.c
> * update kerneldoc comment for struct tee_shm with the reference counter

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

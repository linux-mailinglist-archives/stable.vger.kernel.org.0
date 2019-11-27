Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4089D10A8A6
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 03:14:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726118AbfK0COI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Nov 2019 21:14:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:46524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725871AbfK0COI (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 Nov 2019 21:14:08 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 411642071A;
        Wed, 27 Nov 2019 02:14:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574820847;
        bh=AQVrsr38RQLL3tD3fw9xrZ+S3FUuX8mJkag9za/ceko=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=s9kN0vesePUifr95XPfS5Dl7xQawWjVGaDUSw35q2zqZ8wZzzGkxd9hIHVf2d+DlT
         rDZlXGAnuYeNz9XbpPAxVZoKyl0sHRFUpzTI4XNzh9RRHwhs+jWo23g1s937PGdw/2
         zOBM6Rz8d147JZmqOrSsrlHmrVkZn21/W0TSjCuE=
Date:   Tue, 26 Nov 2019 21:14:06 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     lvivier@redhat.com, mst@redhat.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] virtio_console: allocate inbufs in
 add_port() only if it is" failed to apply to 4.9-stable tree
Message-ID: <20191127021406.GL5861@sasha-vm>
References: <15747038452146@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <15747038452146@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 25, 2019 at 06:44:05PM +0100, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 4.9-stable tree.
>If someone wants it applied there, or to any other stable or longterm
>tree, then please email the backport, including the original git commit
>id to <stable@vger.kernel.org>.
>
>thanks,
>
>greg k-h
>
>------------------ original commit in Linus's tree ------------------
>
>From d791cfcbf98191122af70b053a21075cb450d119 Mon Sep 17 00:00:00 2001
>From: Laurent Vivier <lvivier@redhat.com>
>Date: Thu, 14 Nov 2019 13:25:48 +0100
>Subject: [PATCH] virtio_console: allocate inbufs in add_port() only if it is
> needed
>
>When we hot unplug a virtserialport and then try to hot plug again,
>it fails:
>
>(qemu) chardev-add socket,id=serial0,path=/tmp/serial0,server,nowait
>(qemu) device_add virtserialport,bus=virtio-serial0.0,nr=2,\
>                  chardev=serial0,id=serial0,name=serial0
>(qemu) device_del serial0
>(qemu) device_add virtserialport,bus=virtio-serial0.0,nr=2,\
>                  chardev=serial0,id=serial0,name=serial0
>kernel error:
>  virtio-ports vport2p2: Error allocating inbufs
>qemu error:
>  virtio-serial-bus: Guest failure in adding port 2 for device \
>                     virtio-serial0.0
>
>This happens because buffers for the in_vq are allocated when the port is
>added but are not released when the port is unplugged.
>
>They are only released when virtconsole is removed (see a7a69ec0d8e4)
>
>To avoid the problem and to be symmetric, we could allocate all the buffers
>in init_vqs() as they are released in remove_vqs(), but it sounds like
>a waste of memory.
>
>Rather than that, this patch changes add_port() logic to ignore ENOSPC
>error in fill_queue(), which means queue has already been filled.
>
>Fixes: a7a69ec0d8e4 ("virtio_console: free buffers after reset")
>Cc: mst@redhat.com
>Cc: stable@vger.kernel.org
>Signed-off-by: Laurent Vivier <lvivier@redhat.com>
>Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

I took the following two commits as well and queued all 3 for 4.9 and
4.4:

2855b33514d2 ("virtio_console: don't tie bufs to a vq")
5c60300d68da ("virtio_console: reset on out of memory")

-- 
Thanks,
Sasha

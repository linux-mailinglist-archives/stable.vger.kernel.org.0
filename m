Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 559334514CB
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 21:13:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346010AbhKOUNM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 15:13:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:45220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345015AbhKOTZ6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:25:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2BFEF63705;
        Mon, 15 Nov 2021 19:08:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637003317;
        bh=KqPV+5idkf2+NjD6Q1uow3wjLkwmEutaUPHgxT3W8Fw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CTT+41KSI0fqc5wqwazDxsJbpz7BFc7d+dSjtsylHNK/YIvts2okgJE6mzj4/R7n6
         N5/o6UqUU9zcNH54kMYtIIc3eVgU97zpjExqEO1vYQnTZ1REughGuSS6rqJO8cVxuH
         L+8jtChbzEWUqHgw9VmAkWNVf+dUcM3pIrK3c5GI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Halil Pasic <pasic@linux.ibm.com>,
        bfu@redhat.com, Vineeth Vijayan <vneethv@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 5.15 891/917] s390/cio: make ccw_device_dma_* more robust
Date:   Mon, 15 Nov 2021 18:06:26 +0100
Message-Id: <20211115165459.263479992@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Halil Pasic <pasic@linux.ibm.com>

commit ad9a14517263a16af040598c7920c09ca9670a31 upstream.

Since commit 48720ba56891 ("virtio/s390: use DMA memory for ccw I/O and
classic notifiers") we were supposed to make sure that
virtio_ccw_release_dev() completes before the ccw device and the
attached dma pool are torn down, but unfortunately we did not.  Before
that commit it used to be OK to delay cleaning up the memory allocated
by virtio-ccw indefinitely (which isn't really intuitive for guys used
to destruction happens in reverse construction order), but now we
trigger a BUG_ON if the genpool is destroyed before all memory allocated
from it is deallocated. Which brings down the guest. We can observe this
problem, when unregister_virtio_device() does not give up the last
reference to the virtio_device (e.g. because a virtio-scsi attached scsi
disk got removed without previously unmounting its previously mounted
partition).

To make sure that the genpool is only destroyed after all the necessary
freeing is done let us take a reference on the ccw device on each
ccw_device_dma_zalloc() and give it up on each ccw_device_dma_free().

Actually there are multiple approaches to fixing the problem at hand
that can work. The upside of this one is that it is the safest one while
remaining simple. We don't crash the guest even if the driver does not
pair allocations and frees. The downside is the reference counting
overhead, that the reference counting for ccw devices becomes more
complex, in a sense that we need to pair the calls to the aforementioned
functions for it to be correct, and that if we happen to leak, we leak
more than necessary (the whole ccw device instead of just the genpool).

Some alternatives to this approach are taking a reference in
virtio_ccw_online() and giving it up in virtio_ccw_release_dev() or
making sure virtio_ccw_release_dev() completes its work before
virtio_ccw_remove() returns. The downside of these approaches is that
these are less safe against programming errors.

Cc: <stable@vger.kernel.org> # v5.3
Signed-off-by: Halil Pasic <pasic@linux.ibm.com>
Fixes: 48720ba56891 ("virtio/s390: use DMA memory for ccw I/O and classic notifiers")
Reported-by: bfu@redhat.com
Reviewed-by: Vineeth Vijayan <vneethv@linux.ibm.com>
Acked-by: Cornelia Huck <cohuck@redhat.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/s390/cio/device_ops.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/drivers/s390/cio/device_ops.c
+++ b/drivers/s390/cio/device_ops.c
@@ -825,13 +825,23 @@ EXPORT_SYMBOL_GPL(ccw_device_get_chid);
  */
 void *ccw_device_dma_zalloc(struct ccw_device *cdev, size_t size)
 {
-	return cio_gp_dma_zalloc(cdev->private->dma_pool, &cdev->dev, size);
+	void *addr;
+
+	if (!get_device(&cdev->dev))
+		return NULL;
+	addr = cio_gp_dma_zalloc(cdev->private->dma_pool, &cdev->dev, size);
+	if (IS_ERR_OR_NULL(addr))
+		put_device(&cdev->dev);
+	return addr;
 }
 EXPORT_SYMBOL(ccw_device_dma_zalloc);
 
 void ccw_device_dma_free(struct ccw_device *cdev, void *cpu_addr, size_t size)
 {
+	if (!cpu_addr)
+		return;
 	cio_gp_dma_free(cdev->private->dma_pool, cpu_addr, size);
+	put_device(&cdev->dev);
 }
 EXPORT_SYMBOL(ccw_device_dma_free);
 



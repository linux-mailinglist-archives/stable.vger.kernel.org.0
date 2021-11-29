Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 757D4462777
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 00:03:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236777AbhK2XGB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 18:06:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237209AbhK2XFc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 18:05:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16885C1A3C83;
        Mon, 29 Nov 2021 10:39:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D3404B81636;
        Mon, 29 Nov 2021 18:39:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D93AC53FAD;
        Mon, 29 Nov 2021 18:39:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638211162;
        bh=pbHZVCbXC/eF3f6TOtZqlHEN9GURbrP05wCUtPzDAo8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lXlFVJnS9eKVydeNV6cc9JzmW8saNFVW3r+7upPM9rK3thJLoKSJZf9IOV0tAtFMf
         Xh0YH+OIIR3H9GZ/1GKCC9dnIyR/2y6+723Le/sP1I3bb2nOra2eJ6MYXTXEJl1sA2
         jZ6sf3q7KnOyN1sko6UFXSygF8a8mV1Hyy4EeoSw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jie Deng <jie.deng@intel.com>,
        Vincent Whitchurch <vincent.whitchurch@axis.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 118/179] i2c: virtio: disable timeout handling
Date:   Mon, 29 Nov 2021 19:18:32 +0100
Message-Id: <20211129181722.841187768@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181718.913038547@linuxfoundation.org>
References: <20211129181718.913038547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vincent Whitchurch <vincent.whitchurch@axis.com>

[ Upstream commit 84e1d0bf1d7121759622dabf8fbef4c99ad597c5 ]

If a timeout is hit, it can result is incorrect data on the I2C bus
and/or memory corruptions in the guest since the device can still be
operating on the buffers it was given while the guest has freed them.

Here is, for example, the start of a slub_debug splat which was
triggered on the next transfer after one transfer was forced to timeout
by setting a breakpoint in the backend (rust-vmm/vhost-device):

 BUG kmalloc-1k (Not tainted): Poison overwritten
 First byte 0x1 instead of 0x6b
 Allocated in virtio_i2c_xfer+0x65/0x35c age=350 cpu=0 pid=29
 	__kmalloc+0xc2/0x1c9
 	virtio_i2c_xfer+0x65/0x35c
 	__i2c_transfer+0x429/0x57d
 	i2c_transfer+0x115/0x134
 	i2cdev_ioctl_rdwr+0x16a/0x1de
 	i2cdev_ioctl+0x247/0x2ed
 	vfs_ioctl+0x21/0x30
 	sys_ioctl+0xb18/0xb41
 Freed in virtio_i2c_xfer+0x32e/0x35c age=244 cpu=0 pid=29
 	kfree+0x1bd/0x1cc
 	virtio_i2c_xfer+0x32e/0x35c
 	__i2c_transfer+0x429/0x57d
 	i2c_transfer+0x115/0x134
 	i2cdev_ioctl_rdwr+0x16a/0x1de
 	i2cdev_ioctl+0x247/0x2ed
 	vfs_ioctl+0x21/0x30
 	sys_ioctl+0xb18/0xb41

There is no simple fix for this (the driver would have to always create
bounce buffers and hold on to them until the device eventually returns
the buffers), so just disable the timeout support for now.

Fixes: 3cfc88380413d20f ("i2c: virtio: add a virtio i2c frontend driver")
Acked-by: Jie Deng <jie.deng@intel.com>
Signed-off-by: Vincent Whitchurch <vincent.whitchurch@axis.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Reviewed-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-virtio.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/i2c/busses/i2c-virtio.c b/drivers/i2c/busses/i2c-virtio.c
index f10a603b13fb0..7b2474e6876f4 100644
--- a/drivers/i2c/busses/i2c-virtio.c
+++ b/drivers/i2c/busses/i2c-virtio.c
@@ -106,11 +106,10 @@ static int virtio_i2c_prepare_reqs(struct virtqueue *vq,
 
 static int virtio_i2c_complete_reqs(struct virtqueue *vq,
 				    struct virtio_i2c_req *reqs,
-				    struct i2c_msg *msgs, int num,
-				    bool timedout)
+				    struct i2c_msg *msgs, int num)
 {
 	struct virtio_i2c_req *req;
-	bool failed = timedout;
+	bool failed = false;
 	unsigned int len;
 	int i, j = 0;
 
@@ -132,7 +131,7 @@ static int virtio_i2c_complete_reqs(struct virtqueue *vq,
 			j++;
 	}
 
-	return timedout ? -ETIMEDOUT : j;
+	return j;
 }
 
 static int virtio_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg *msgs,
@@ -141,7 +140,6 @@ static int virtio_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg *msgs,
 	struct virtio_i2c *vi = i2c_get_adapdata(adap);
 	struct virtqueue *vq = vi->vq;
 	struct virtio_i2c_req *reqs;
-	unsigned long time_left;
 	int count;
 
 	reqs = kcalloc(num, sizeof(*reqs), GFP_KERNEL);
@@ -164,11 +162,9 @@ static int virtio_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg *msgs,
 	reinit_completion(&vi->completion);
 	virtqueue_kick(vq);
 
-	time_left = wait_for_completion_timeout(&vi->completion, adap->timeout);
-	if (!time_left)
-		dev_err(&adap->dev, "virtio i2c backend timeout.\n");
+	wait_for_completion(&vi->completion);
 
-	count = virtio_i2c_complete_reqs(vq, reqs, msgs, count, !time_left);
+	count = virtio_i2c_complete_reqs(vq, reqs, msgs, count);
 
 err_free:
 	kfree(reqs);
-- 
2.33.0




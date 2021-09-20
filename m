Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 292B841256D
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:44:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349975AbhITSpF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:45:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:56450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1382743AbhITSmT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:42:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0C9366334D;
        Mon, 20 Sep 2021 17:31:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632159109;
        bh=pw/YhXeLQgIy92tRrU+Uocd8/aJGDTn4x9qwe/4rOWY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zlj5MXYSR98o0sIBv2npf9ab0yVUwGFCz4B7vng+zJXoyc0i3qJjhdtLM1CGwg/oQ
         pIPDTy+VhaSzhitWZPCzxfIX2TVhxIlCXfuPHvCt2IodMK743enhOOi/TfsoJIAe0Y
         W+00+IdKXaOnTikfCcIm6SM4u4qHTKdYTnEkutxA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
        Andrea Parri <parri.andrea@gmail.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 080/168] Drivers: hv: vmbus: Fix kernel crash upon unbinding a device from uio_hv_generic driver
Date:   Mon, 20 Sep 2021 18:43:38 +0200
Message-Id: <20210920163924.269200445@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163921.633181900@linuxfoundation.org>
References: <20210920163921.633181900@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vitaly Kuznetsov <vkuznets@redhat.com>

[ Upstream commit f1940d4e9cbe6208e7e77e433c587af108152a17 ]

The following crash happens when a never-used device is unbound from
uio_hv_generic driver:

 kernel BUG at mm/slub.c:321!
 invalid opcode: 0000 [#1] SMP PTI
 CPU: 0 PID: 4001 Comm: bash Kdump: loaded Tainted: G               X --------- ---  5.14.0-0.rc2.23.el9.x86_64 #1
 Hardware name: Microsoft Corporation Virtual Machine/Virtual Machine, BIOS 090008  12/07/2018
 RIP: 0010:__slab_free+0x1d5/0x3d0
...
 Call Trace:
  ? pick_next_task_fair+0x18e/0x3b0
  ? __cond_resched+0x16/0x40
  ? vunmap_pmd_range.isra.0+0x154/0x1c0
  ? __vunmap+0x22d/0x290
  ? hv_ringbuffer_cleanup+0x36/0x40 [hv_vmbus]
  kfree+0x331/0x380
  ? hv_uio_remove+0x43/0x60 [uio_hv_generic]
  hv_ringbuffer_cleanup+0x36/0x40 [hv_vmbus]
  vmbus_free_ring+0x21/0x60 [hv_vmbus]
  hv_uio_remove+0x4f/0x60 [uio_hv_generic]
  vmbus_remove+0x23/0x30 [hv_vmbus]
  __device_release_driver+0x17a/0x230
  device_driver_detach+0x3c/0xa0
  unbind_store+0x113/0x130
...

The problem appears to be that we free 'ring_info->pkt_buffer' twice:
first, when the device is unbound from in-kernel driver (netvsc in this
case) and second from hv_uio_remove(). Normally, ring buffer is supposed
to be re-initialized from hv_uio_open() but this happens when UIO device
is being opened and this is not guaranteed to happen.

Generally, it is OK to call hv_ringbuffer_cleanup() twice for the same
channel (which is being handed over between in-kernel drivers and UIO) even
if we didn't call hv_ringbuffer_init() in between. We, however, need to
avoid kfree() call for an already freed pointer.

Fixes: adae1e931acd ("Drivers: hv: vmbus: Copy packets sent by Hyper-V out of the ring buffer")
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Reviewed-by: Andrea Parri <parri.andrea@gmail.com>
Reviewed-by: Michael Kelley <mikelley@microsoft.com>
Link: https://lore.kernel.org/r/20210831143916.144983-1-vkuznets@redhat.com
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hv/ring_buffer.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/hv/ring_buffer.c b/drivers/hv/ring_buffer.c
index 2aee356840a2..314015d9e912 100644
--- a/drivers/hv/ring_buffer.c
+++ b/drivers/hv/ring_buffer.c
@@ -245,6 +245,7 @@ void hv_ringbuffer_cleanup(struct hv_ring_buffer_info *ring_info)
 	mutex_unlock(&ring_info->ring_buffer_mutex);
 
 	kfree(ring_info->pkt_buffer);
+	ring_info->pkt_buffer = NULL;
 	ring_info->pkt_buffer_size = 0;
 }
 
-- 
2.30.2




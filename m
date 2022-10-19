Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FA28603D4D
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 11:00:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232064AbiJSJAY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 05:00:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232339AbiJSI7a (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 04:59:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F2C645F59;
        Wed, 19 Oct 2022 01:55:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B4B786186A;
        Wed, 19 Oct 2022 08:52:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8476C433C1;
        Wed, 19 Oct 2022 08:52:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169577;
        bh=qI9liugzN9G0XVfsXLBml/djNWH/lcscIH6cMpNxmU4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1otpvgNo50GNs9CuQUCXlBilL1KKhzwP+QHO+jG/wo2a7z0hH6u5d5AtVJZKto5xx
         UsNqlsBLupIvFO4NONaXGqPDpoJ1Vojt43hy3rlwmqurJJ1IrDWIWvPrCDAY/zAAD8
         vbt6mOxuGJ0s635YmBCEWqXB37QYfPlUzTZ819sk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Junichi Uekawa <uekawa@chromium.org>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 328/862] vhost/vsock: Use kvmalloc/kvfree for larger packets.
Date:   Wed, 19 Oct 2022 10:26:55 +0200
Message-Id: <20221019083304.525246952@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Junichi Uekawa <uekawa@chromium.org>

[ Upstream commit 0e3f72931fc47bb81686020cc643cde5d9cd0bb8 ]

When copying a large file over sftp over vsock, data size is usually 32kB,
and kmalloc seems to fail to try to allocate 32 32kB regions.

 vhost-5837: page allocation failure: order:4, mode:0x24040c0
 Call Trace:
  [<ffffffffb6a0df64>] dump_stack+0x97/0xdb
  [<ffffffffb68d6aed>] warn_alloc_failed+0x10f/0x138
  [<ffffffffb68d868a>] ? __alloc_pages_direct_compact+0x38/0xc8
  [<ffffffffb664619f>] __alloc_pages_nodemask+0x84c/0x90d
  [<ffffffffb6646e56>] alloc_kmem_pages+0x17/0x19
  [<ffffffffb6653a26>] kmalloc_order_trace+0x2b/0xdb
  [<ffffffffb66682f3>] __kmalloc+0x177/0x1f7
  [<ffffffffb66e0d94>] ? copy_from_iter+0x8d/0x31d
  [<ffffffffc0689ab7>] vhost_vsock_handle_tx_kick+0x1fa/0x301 [vhost_vsock]
  [<ffffffffc06828d9>] vhost_worker+0xf7/0x157 [vhost]
  [<ffffffffb683ddce>] kthread+0xfd/0x105
  [<ffffffffc06827e2>] ? vhost_dev_set_owner+0x22e/0x22e [vhost]
  [<ffffffffb683dcd1>] ? flush_kthread_worker+0xf3/0xf3
  [<ffffffffb6eb332e>] ret_from_fork+0x4e/0x80
  [<ffffffffb683dcd1>] ? flush_kthread_worker+0xf3/0xf3

Work around by doing kvmalloc instead.

Fixes: 433fc58e6bf2 ("VSOCK: Introduce vhost_vsock.ko")
Signed-off-by: Junichi Uekawa <uekawa@chromium.org>
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Link: https://lore.kernel.org/r/20220928064538.667678-1-uekawa@chromium.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vhost/vsock.c                   | 2 +-
 net/vmw_vsock/virtio_transport_common.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
index 368330417bde..5703775af129 100644
--- a/drivers/vhost/vsock.c
+++ b/drivers/vhost/vsock.c
@@ -393,7 +393,7 @@ vhost_vsock_alloc_pkt(struct vhost_virtqueue *vq,
 		return NULL;
 	}
 
-	pkt->buf = kmalloc(pkt->len, GFP_KERNEL);
+	pkt->buf = kvmalloc(pkt->len, GFP_KERNEL);
 	if (!pkt->buf) {
 		kfree(pkt);
 		return NULL;
diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index ec2c2afbf0d0..3a12aee33e92 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -1342,7 +1342,7 @@ EXPORT_SYMBOL_GPL(virtio_transport_recv_pkt);
 
 void virtio_transport_free_pkt(struct virtio_vsock_pkt *pkt)
 {
-	kfree(pkt->buf);
+	kvfree(pkt->buf);
 	kfree(pkt);
 }
 EXPORT_SYMBOL_GPL(virtio_transport_free_pkt);
-- 
2.35.1




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5241D63DFB0
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:49:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231437AbiK3Stk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:49:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231431AbiK3St2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:49:28 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EE041A205
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:49:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1BCCF61D56
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:49:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A235C433C1;
        Wed, 30 Nov 2022 18:49:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669834166;
        bh=O1i2dYBHridwErdiGETdZFSjo0ppKKFFtvK2fw+AesI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OEM9Ok76awcLBRQ16o0R6fNO2vIwt6D6wppBqoKZrfiYw73qAkGQGs6Rs12aXNVxN
         NhREAmn6Ll05ROMTtSrsoGEqgzXUCN5PJHIyhPBoOOp2qoPoMtoJ98kOeymDxlIMYF
         Xv57HR+ydyb3Jh2AYmYRnKBtb9r7/8v/1rQRjcWs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Li Zetao <lizetao1@huawei.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 154/289] virtio_net: Fix probe failed when modprobe virtio_net
Date:   Wed, 30 Nov 2022 19:22:19 +0100
Message-Id: <20221130180547.626521037@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Li Zetao <lizetao1@huawei.com>

[ Upstream commit b0686565946368892c2cdf92f102392e24823588 ]

When doing the following test steps, an error was found:
  step 1: modprobe virtio_net succeeded
    # modprobe virtio_net        <-- OK

  step 2: fault injection in register_netdevice()
    # modprobe -r virtio_net     <-- OK
    # ...
      FAULT_INJECTION: forcing a failure.
      name failslab, interval 1, probability 0, space 0, times 0
      CPU: 0 PID: 3521 Comm: modprobe
      Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
      Call Trace:
       <TASK>
       ...
       should_failslab+0xa/0x20
       ...
       dev_set_name+0xc0/0x100
       netdev_register_kobject+0xc2/0x340
       register_netdevice+0xbb9/0x1320
       virtnet_probe+0x1d72/0x2658 [virtio_net]
       ...
       </TASK>
      virtio_net: probe of virtio0 failed with error -22

  step 3: modprobe virtio_net failed
    # modprobe virtio_net        <-- failed
      virtio_net: probe of virtio0 failed with error -2

The root cause of the problem is that the queues are not
disable on the error handling path when register_netdevice()
fails in virtnet_probe(), resulting in an error "-ENOENT"
returned in the next modprobe call in setup_vq().

virtio_pci_modern_device uses virtqueues to send or
receive message, and "queue_enable" records whether the
queues are available. In vp_modern_find_vqs(), all queues
will be selected and activated, but once queues are enabled
there is no way to go back except reset.

Fix it by reset virtio device on error handling path. This
makes error handling follow the same order as normal device
cleanup in virtnet_remove() which does: unregister, destroy
failover, then reset. And that flow is better tested than
error handling so we can be reasonably sure it works well.

Fixes: 024655555021 ("virtio_net: fix use after free on allocation failure")
Signed-off-by: Li Zetao <lizetao1@huawei.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Link: https://lore.kernel.org/r/20221122150046.3910638-1-lizetao1@huawei.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/virtio_net.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 9cce7dec7366..f5c88d232b11 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -3933,12 +3933,11 @@ static int virtnet_probe(struct virtio_device *vdev)
 	return 0;
 
 free_unregister_netdev:
-	virtio_reset_device(vdev);
-
 	unregister_netdev(dev);
 free_failover:
 	net_failover_destroy(vi->failover);
 free_vqs:
+	virtio_reset_device(vdev);
 	cancel_delayed_work_sync(&vi->refill);
 	free_receive_page_frags(vi);
 	virtnet_del_vqs(vi);
-- 
2.35.1




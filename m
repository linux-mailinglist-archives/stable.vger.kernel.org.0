Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 165E168D76B
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 13:59:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231434AbjBGM7s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 07:59:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231449AbjBGM7d (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 07:59:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A8941F48F
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 04:59:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BBD8A613EA
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 12:59:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAA9BC433EF;
        Tue,  7 Feb 2023 12:59:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675774772;
        bh=5b+25BnKOgUH4AKlHqJnATnWoVGxHZFq9BBSHRmrYwQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZgelcAFb4c+3ZdFjfWFXP4A+1CV/9xG6E8cLQbdRJWMSTy1d16i94awaeQh8Fp8KV
         mlpYClwaKXtGWbCctRH79xRzozombFHiBF0W/1MmrLP0ZIR51+D7VEsnyW9VMXcSqG
         CH4MInQdwnrsl9ubnzxTxzCZWUMttLBe3Rwbem9c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Eric Auger <eric.auger@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 029/208] vhost/net: Clear the pending messages when the backend is removed
Date:   Tue,  7 Feb 2023 13:54:43 +0100
Message-Id: <20230207125635.628827131@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125634.292109991@linuxfoundation.org>
References: <20230207125634.292109991@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Auger <eric.auger@redhat.com>

[ Upstream commit 9526f9a2b762af16be94a72aca5d65c677d28f50 ]

When the vhost iotlb is used along with a guest virtual iommu
and the guest gets rebooted, some MISS messages may have been
recorded just before the reboot and spuriously executed by
the virtual iommu after the reboot.

As vhost does not have any explicit reset user API,
VHOST_NET_SET_BACKEND looks a reasonable point where to clear
the pending messages, in case the backend is removed.

Export vhost_clear_msg() and call it in vhost_net_set_backend()
when fd == -1.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
Suggested-by: Jason Wang <jasowang@redhat.com>
Fixes: 6b1e6cc7855b0 ("vhost: new device IOTLB API")
Message-Id: <20230117151518.44725-3-eric.auger@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vhost/net.c   | 3 +++
 drivers/vhost/vhost.c | 3 ++-
 drivers/vhost/vhost.h | 1 +
 3 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index 20265393aee7..c7e44d818252 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -1511,6 +1511,9 @@ static long vhost_net_set_backend(struct vhost_net *n, unsigned index, int fd)
 	nvq = &n->vqs[index];
 	mutex_lock(&vq->mutex);
 
+	if (fd == -1)
+		vhost_clear_msg(&n->dev);
+
 	/* Verify that ring has been setup correctly. */
 	if (!vhost_vq_access_ok(vq)) {
 		r = -EFAULT;
diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 3c2359570df9..547f89a6940f 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -661,7 +661,7 @@ void vhost_dev_stop(struct vhost_dev *dev)
 }
 EXPORT_SYMBOL_GPL(vhost_dev_stop);
 
-static void vhost_clear_msg(struct vhost_dev *dev)
+void vhost_clear_msg(struct vhost_dev *dev)
 {
 	struct vhost_msg_node *node, *n;
 
@@ -679,6 +679,7 @@ static void vhost_clear_msg(struct vhost_dev *dev)
 
 	spin_unlock(&dev->iotlb_lock);
 }
+EXPORT_SYMBOL_GPL(vhost_clear_msg);
 
 void vhost_dev_cleanup(struct vhost_dev *dev)
 {
diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
index d9109107af08..790b296271f1 100644
--- a/drivers/vhost/vhost.h
+++ b/drivers/vhost/vhost.h
@@ -181,6 +181,7 @@ long vhost_dev_ioctl(struct vhost_dev *, unsigned int ioctl, void __user *argp);
 long vhost_vring_ioctl(struct vhost_dev *d, unsigned int ioctl, void __user *argp);
 bool vhost_vq_access_ok(struct vhost_virtqueue *vq);
 bool vhost_log_access_ok(struct vhost_dev *);
+void vhost_clear_msg(struct vhost_dev *dev);
 
 int vhost_get_vq_desc(struct vhost_virtqueue *,
 		      struct iovec iov[], unsigned int iov_count,
-- 
2.39.0




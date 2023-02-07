Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 858BD68D8BC
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 14:12:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232550AbjBGNMf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 08:12:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232547AbjBGNMM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 08:12:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A984B3D0B9
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 05:11:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BB9A561383
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 13:10:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C547BC433EF;
        Tue,  7 Feb 2023 13:10:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675775458;
        bh=aAChgl2wP1h0juF076MpSmrRUMDhMuRurOtT3VtJBqo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AHVIcGgTyqVBpNfgoszevmHcicI7ruvXap0eVCamH1Ykaawj06ZdBNpHMZNAexXLJ
         Y+hpvO9Ar/NUw4DlbY2z6ojh9r7FoJ0hnTM/gTkYWw0pe1Zk55vG1Snn2GWKoKb5Dl
         gSClhm864VIQwjqsUyffxfvyYTxFZcNR67Mb9I/s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Eric Auger <eric.auger@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 017/120] vhost/net: Clear the pending messages when the backend is removed
Date:   Tue,  7 Feb 2023 13:56:28 +0100
Message-Id: <20230207125619.490368113@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125618.699726054@linuxfoundation.org>
References: <20230207125618.699726054@linuxfoundation.org>
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
index 297b5db47454..32148f011200 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -1517,6 +1517,9 @@ static long vhost_net_set_backend(struct vhost_net *n, unsigned index, int fd)
 	nvq = &n->vqs[index];
 	mutex_lock(&vq->mutex);
 
+	if (fd == -1)
+		vhost_clear_msg(&n->dev);
+
 	/* Verify that ring has been setup correctly. */
 	if (!vhost_vq_access_ok(vq)) {
 		r = -EFAULT;
diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 0a9746bc9228..c0f926a9c298 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -669,7 +669,7 @@ void vhost_dev_stop(struct vhost_dev *dev)
 }
 EXPORT_SYMBOL_GPL(vhost_dev_stop);
 
-static void vhost_clear_msg(struct vhost_dev *dev)
+void vhost_clear_msg(struct vhost_dev *dev)
 {
 	struct vhost_msg_node *node, *n;
 
@@ -687,6 +687,7 @@ static void vhost_clear_msg(struct vhost_dev *dev)
 
 	spin_unlock(&dev->iotlb_lock);
 }
+EXPORT_SYMBOL_GPL(vhost_clear_msg);
 
 void vhost_dev_cleanup(struct vhost_dev *dev)
 {
diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
index 638bb640d6b4..f2675c0aa08e 100644
--- a/drivers/vhost/vhost.h
+++ b/drivers/vhost/vhost.h
@@ -182,6 +182,7 @@ long vhost_dev_ioctl(struct vhost_dev *, unsigned int ioctl, void __user *argp);
 long vhost_vring_ioctl(struct vhost_dev *d, unsigned int ioctl, void __user *argp);
 bool vhost_vq_access_ok(struct vhost_virtqueue *vq);
 bool vhost_log_access_ok(struct vhost_dev *);
+void vhost_clear_msg(struct vhost_dev *dev);
 
 int vhost_get_vq_desc(struct vhost_virtqueue *,
 		      struct iovec iov[], unsigned int iov_count,
-- 
2.39.0




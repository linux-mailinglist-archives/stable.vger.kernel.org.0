Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 697501576DA
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 13:55:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729390AbgBJMzt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 07:55:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:44324 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729793AbgBJMlo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:41:44 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A570220873;
        Mon, 10 Feb 2020 12:41:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338503;
        bh=RRVK0oQs8vlOlni2dD9fgIUqyQiHBCOg6uoiikTwBws=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zlnAlzJE+cEdJDG/DpaJ7dZ6Qx69NItgTw6qEqeshKCnRCMWmj6ZXLtbDLSS+ildo
         ibqdJvpulcmY+G1xuuLF+w1bkRY/3Gm0IYyYgV/4KyGTPeFQm/AhCGdfMGv+Kdq9Qz
         7BIPGOXVT+cSsHm0hbvLES3gprYXMqD6jNjrCIEw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Wei Wang <wei.w.wang@intel.com>,
        Liang Li <liang.z.li@intel.com>,
        David Hildenbrand <david@redhat.com>
Subject: [PATCH 5.5 302/367] virtio_balloon: Fix memory leaks on errors in virtballoon_probe()
Date:   Mon, 10 Feb 2020 04:33:35 -0800
Message-Id: <20200210122451.409743460@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122423.695146547@linuxfoundation.org>
References: <20200210122423.695146547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Hildenbrand <david@redhat.com>

commit 1ad6f58ea9364b0a5d8ae06249653ac9304a8578 upstream.

We forget to put the inode and unmount the kernfs used for compaction.

Fixes: 71994620bb25 ("virtio_balloon: replace oom notifier with shrinker")
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Jason Wang <jasowang@redhat.com>
Cc: Wei Wang <wei.w.wang@intel.com>
Cc: Liang Li <liang.z.li@intel.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
Link: https://lore.kernel.org/r/20200205163402.42627-3-david@redhat.com
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/virtio/virtio_balloon.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

--- a/drivers/virtio/virtio_balloon.c
+++ b/drivers/virtio/virtio_balloon.c
@@ -901,8 +901,7 @@ static int virtballoon_probe(struct virt
 	vb->vb_dev_info.inode = alloc_anon_inode(balloon_mnt->mnt_sb);
 	if (IS_ERR(vb->vb_dev_info.inode)) {
 		err = PTR_ERR(vb->vb_dev_info.inode);
-		kern_unmount(balloon_mnt);
-		goto out_del_vqs;
+		goto out_kern_unmount;
 	}
 	vb->vb_dev_info.inode->i_mapping->a_ops = &balloon_aops;
 #endif
@@ -913,13 +912,13 @@ static int virtballoon_probe(struct virt
 		 */
 		if (virtqueue_get_vring_size(vb->free_page_vq) < 2) {
 			err = -ENOSPC;
-			goto out_del_vqs;
+			goto out_iput;
 		}
 		vb->balloon_wq = alloc_workqueue("balloon-wq",
 					WQ_FREEZABLE | WQ_CPU_INTENSIVE, 0);
 		if (!vb->balloon_wq) {
 			err = -ENOMEM;
-			goto out_del_vqs;
+			goto out_iput;
 		}
 		INIT_WORK(&vb->report_free_page_work, report_free_page_func);
 		vb->cmd_id_received_cache = VIRTIO_BALLOON_CMD_ID_STOP;
@@ -953,6 +952,12 @@ static int virtballoon_probe(struct virt
 out_del_balloon_wq:
 	if (virtio_has_feature(vdev, VIRTIO_BALLOON_F_FREE_PAGE_HINT))
 		destroy_workqueue(vb->balloon_wq);
+out_iput:
+#ifdef CONFIG_BALLOON_COMPACTION
+	iput(vb->vb_dev_info.inode);
+out_kern_unmount:
+	kern_unmount(balloon_mnt);
+#endif
 out_del_vqs:
 	vdev->config->del_vqs(vdev);
 out_free_vb:



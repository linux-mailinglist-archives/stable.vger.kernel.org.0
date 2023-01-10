Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9163E664864
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:11:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238930AbjAJSL0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:11:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238939AbjAJSKP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:10:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84376F24
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 10:08:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1FCA961864
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 18:08:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EAA4C433EF;
        Tue, 10 Jan 2023 18:08:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673374099;
        bh=W8VJ1W+khlaCFUy2flCJ7ZF7VXVhqpIwtC6XSejzBls=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dL3UFcbrSXWSnV/sXh2TM7U8BvyYtBeiFfMgeXyFexlaA5MuxnZG5ZVU6pyqjQX5O
         syIuKjUhxM6f0H1CfqIkN0l7p5kQoO2II1jLYSacoCiPGTRDUks9/289OS1g+XG/U3
         mZGGqCoJ6gx5K7NsAQVSA9fi6TulUFEc5TsGk2js=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Stefano Garzarella <sgarzare@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 045/148] vhost-vdpa: fix an iotlb memory leak
Date:   Tue, 10 Jan 2023 19:02:29 +0100
Message-Id: <20230110180018.646970896@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180017.145591678@linuxfoundation.org>
References: <20230110180017.145591678@linuxfoundation.org>
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

From: Stefano Garzarella <sgarzare@redhat.com>

[ Upstream commit c070c1912a83432530cbb4271d5b9b11fa36b67a ]

Before commit 3d5698793897 ("vhost-vdpa: introduce asid based IOTLB")
we called vhost_vdpa_iotlb_unmap(v, iotlb, 0ULL, 0ULL - 1) during
release to free all the resources allocated when processing user IOTLB
messages through vhost_vdpa_process_iotlb_update().
That commit changed the handling of IOTLB a bit, and we accidentally
removed some code called during the release.

We partially fixed this with commit 037d4305569a ("vhost-vdpa: call
vhost_vdpa_cleanup during the release") but a potential memory leak is
still there as showed by kmemleak if the application does not send
VHOST_IOTLB_INVALIDATE or crashes:

  unreferenced object 0xffff888007fbaa30 (size 16):
    comm "blkio-bench", pid 914, jiffies 4294993521 (age 885.500s)
    hex dump (first 16 bytes):
      40 73 41 07 80 88 ff ff 00 00 00 00 00 00 00 00  @sA.............
    backtrace:
      [<0000000087736d2a>] kmem_cache_alloc_trace+0x142/0x1c0
      [<0000000060740f50>] vhost_vdpa_process_iotlb_msg+0x68c/0x901 [vhost_vdpa]
      [<0000000083e8e205>] vhost_chr_write_iter+0xc0/0x4a0 [vhost]
      [<000000008f2f414a>] vhost_vdpa_chr_write_iter+0x18/0x20 [vhost_vdpa]
      [<00000000de1cd4a0>] vfs_write+0x216/0x4b0
      [<00000000a2850200>] ksys_write+0x71/0xf0
      [<00000000de8e720b>] __x64_sys_write+0x19/0x20
      [<0000000018b12cbb>] do_syscall_64+0x3f/0x90
      [<00000000986ec465>] entry_SYSCALL_64_after_hwframe+0x63/0xcd

Let's fix this calling vhost_vdpa_iotlb_unmap() on the whole range in
vhost_vdpa_remove_as(). We move that call before vhost_dev_cleanup()
since we need a valid v->vdev.mm in vhost_vdpa_pa_unmap().
vhost_iotlb_reset() call can be removed, since vhost_vdpa_iotlb_unmap()
on the whole range removes all the entries.

The kmemleak log reported was observed with a vDPA device that has `use_va`
set to true (e.g. VDUSE). This patch has been tested with both types of
devices.

Fixes: 037d4305569a ("vhost-vdpa: call vhost_vdpa_cleanup during the release")
Fixes: 3d5698793897 ("vhost-vdpa: introduce asid based IOTLB")
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
Message-Id: <20221109154213.146789-1-sgarzare@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vhost/vdpa.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index 166044642fd5..b08e07fc7d1f 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -65,6 +65,10 @@ static DEFINE_IDA(vhost_vdpa_ida);
 
 static dev_t vhost_vdpa_major;
 
+static void vhost_vdpa_iotlb_unmap(struct vhost_vdpa *v,
+				   struct vhost_iotlb *iotlb,
+				   u64 start, u64 last);
+
 static inline u32 iotlb_to_asid(struct vhost_iotlb *iotlb)
 {
 	struct vhost_vdpa_as *as = container_of(iotlb, struct
@@ -135,7 +139,7 @@ static int vhost_vdpa_remove_as(struct vhost_vdpa *v, u32 asid)
 		return -EINVAL;
 
 	hlist_del(&as->hash_link);
-	vhost_iotlb_reset(&as->iotlb);
+	vhost_vdpa_iotlb_unmap(v, &as->iotlb, 0ULL, 0ULL - 1);
 	kfree(as);
 
 	return 0;
@@ -1162,14 +1166,14 @@ static void vhost_vdpa_cleanup(struct vhost_vdpa *v)
 	struct vhost_vdpa_as *as;
 	u32 asid;
 
-	vhost_dev_cleanup(&v->vdev);
-	kfree(v->vdev.vqs);
-
 	for (asid = 0; asid < v->vdpa->nas; asid++) {
 		as = asid_to_as(v, asid);
 		if (as)
 			vhost_vdpa_remove_as(v, asid);
 	}
+
+	vhost_dev_cleanup(&v->vdev);
+	kfree(v->vdev.vqs);
 }
 
 static int vhost_vdpa_open(struct inode *inode, struct file *filep)
-- 
2.35.1




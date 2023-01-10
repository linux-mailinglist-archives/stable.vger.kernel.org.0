Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBD9F6648B3
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:14:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232186AbjAJSOb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:14:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239199AbjAJSNq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:13:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D6C085C8C
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 10:12:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D2473B81905
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 18:12:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 298B8C433D2;
        Tue, 10 Jan 2023 18:12:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673374332;
        bh=2DIEZeLD4WYX5tp2259lupBeM1yAbgN0tSMgpFItQTs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c5KUXbmRap85pwSTP1YnrJ3XxvYMOBYmi4QxB/rtVuofeV2lkVBEwIGDUQm1CyEya
         +7u2JahhUbWx6egGVkOorf78gUQihxVsU84trBIk2MXCkiCTNblwIU62qxSLvtmfao
         p5r2d2U4x4FDoB+k+wLUvbj55kZJcAbtEKgk7Bf4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Cindy Lu <lulu@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH 6.0 132/148] vhost_vdpa: fix the crash in unmap a large memory
Date:   Tue, 10 Jan 2023 19:03:56 +0100
Message-Id: <20230110180021.367428635@linuxfoundation.org>
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

From: Cindy Lu <lulu@redhat.com>

commit e794070af224ade46db368271896b2685ff4f96b upstream.

While testing in vIOMMU, sometimes Guest will unmap very large memory,
which will cause the crash. To fix this, add a new function
vhost_vdpa_general_unmap(). This function will only unmap the memory
that saved in iotlb.

Call Trace:
[  647.820144] ------------[ cut here ]------------
[  647.820848] kernel BUG at drivers/iommu/intel/iommu.c:1174!
[  647.821486] invalid opcode: 0000 [#1] PREEMPT SMP PTI
[  647.822082] CPU: 10 PID: 1181 Comm: qemu-system-x86 Not tainted 6.0.0-rc1home_lulu_2452_lulu7_vhost+ #62
[  647.823139] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.15.0-29-g6a62e0cb0dfe-prebuilt.qem4
[  647.824365] RIP: 0010:domain_unmap+0x48/0x110
[  647.825424] Code: 48 89 fb 8d 4c f6 1e 39 c1 0f 4f c8 83 e9 0c 83 f9 3f 7f 18 48 89 e8 48 d3 e8 48 85 c0 75 59
[  647.828064] RSP: 0018:ffffae5340c0bbf0 EFLAGS: 00010202
[  647.828973] RAX: 0000000000000001 RBX: ffff921793d10540 RCX: 000000000000001b
[  647.830083] RDX: 00000000080000ff RSI: 0000000000000001 RDI: ffff921793d10540
[  647.831214] RBP: 0000000007fc0100 R08: ffffae5340c0bcd0 R09: 0000000000000003
[  647.832388] R10: 0000007fc0100000 R11: 0000000000100000 R12: 00000000080000ff
[  647.833668] R13: ffffae5340c0bcd0 R14: ffff921793d10590 R15: 0000008000100000
[  647.834782] FS:  00007f772ec90640(0000) GS:ffff921ce7a80000(0000) knlGS:0000000000000000
[  647.836004] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  647.836990] CR2: 00007f02c27a3a20 CR3: 0000000101b0c006 CR4: 0000000000372ee0
[  647.838107] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  647.839283] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[  647.840666] Call Trace:
[  647.841437]  <TASK>
[  647.842107]  intel_iommu_unmap_pages+0x93/0x140
[  647.843112]  __iommu_unmap+0x91/0x1b0
[  647.844003]  iommu_unmap+0x6a/0x95
[  647.844885]  vhost_vdpa_unmap+0x1de/0x1f0 [vhost_vdpa]
[  647.845985]  vhost_vdpa_process_iotlb_msg+0xf0/0x90b [vhost_vdpa]
[  647.847235]  ? _raw_spin_unlock+0x15/0x30
[  647.848181]  ? _copy_from_iter+0x8c/0x580
[  647.849137]  vhost_chr_write_iter+0xb3/0x430 [vhost]
[  647.850126]  vfs_write+0x1e4/0x3a0
[  647.850897]  ksys_write+0x53/0xd0
[  647.851688]  do_syscall_64+0x3a/0x90
[  647.852508]  entry_SYSCALL_64_after_hwframe+0x63/0xcd
[  647.853457] RIP: 0033:0x7f7734ef9f4f
[  647.854408] Code: 89 54 24 18 48 89 74 24 10 89 7c 24 08 e8 29 76 f8 ff 48 8b 54 24 18 48 8b 74 24 10 41 89 c8
[  647.857217] RSP: 002b:00007f772ec8f040 EFLAGS: 00000293 ORIG_RAX: 0000000000000001
[  647.858486] RAX: ffffffffffffffda RBX: 00000000fef00000 RCX: 00007f7734ef9f4f
[  647.859713] RDX: 0000000000000048 RSI: 00007f772ec8f090 RDI: 0000000000000010
[  647.860942] RBP: 00007f772ec8f1a0 R08: 0000000000000000 R09: 0000000000000000
[  647.862206] R10: 0000000000000001 R11: 0000000000000293 R12: 0000000000000010
[  647.863446] R13: 0000000000000002 R14: 0000000000000000 R15: ffffffff01100000
[  647.864692]  </TASK>
[  647.865458] Modules linked in: rpcsec_gss_krb5 auth_rpcgss nfsv4 dns_resolver nfs lockd grace fscache netfs v]
[  647.874688] ---[ end trace 0000000000000000 ]---

Cc: stable@vger.kernel.org
Fixes: 4c8cf31885f6 ("vhost: introduce vDPA-based backend")
Signed-off-by: Cindy Lu <lulu@redhat.com>
Message-Id: <20221219073331.556140-1-lulu@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/vhost/vdpa.c |   46 ++++++++++++++++++++++++++--------------------
 1 file changed, 26 insertions(+), 20 deletions(-)

--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -66,8 +66,8 @@ static DEFINE_IDA(vhost_vdpa_ida);
 static dev_t vhost_vdpa_major;
 
 static void vhost_vdpa_iotlb_unmap(struct vhost_vdpa *v,
-				   struct vhost_iotlb *iotlb,
-				   u64 start, u64 last);
+				   struct vhost_iotlb *iotlb, u64 start,
+				   u64 last, u32 asid);
 
 static inline u32 iotlb_to_asid(struct vhost_iotlb *iotlb)
 {
@@ -139,7 +139,7 @@ static int vhost_vdpa_remove_as(struct v
 		return -EINVAL;
 
 	hlist_del(&as->hash_link);
-	vhost_vdpa_iotlb_unmap(v, &as->iotlb, 0ULL, 0ULL - 1);
+	vhost_vdpa_iotlb_unmap(v, &as->iotlb, 0ULL, 0ULL - 1, asid);
 	kfree(as);
 
 	return 0;
@@ -687,10 +687,20 @@ static long vhost_vdpa_unlocked_ioctl(st
 	mutex_unlock(&d->mutex);
 	return r;
 }
+static void vhost_vdpa_general_unmap(struct vhost_vdpa *v,
+				     struct vhost_iotlb_map *map, u32 asid)
+{
+	struct vdpa_device *vdpa = v->vdpa;
+	const struct vdpa_config_ops *ops = vdpa->config;
+	if (ops->dma_map) {
+		ops->dma_unmap(vdpa, asid, map->start, map->size);
+	} else if (ops->set_map == NULL) {
+		iommu_unmap(v->domain, map->start, map->size);
+	}
+}
 
-static void vhost_vdpa_pa_unmap(struct vhost_vdpa *v,
-				struct vhost_iotlb *iotlb,
-				u64 start, u64 last)
+static void vhost_vdpa_pa_unmap(struct vhost_vdpa *v, struct vhost_iotlb *iotlb,
+				u64 start, u64 last, u32 asid)
 {
 	struct vhost_dev *dev = &v->vdev;
 	struct vhost_iotlb_map *map;
@@ -707,13 +717,13 @@ static void vhost_vdpa_pa_unmap(struct v
 			unpin_user_page(page);
 		}
 		atomic64_sub(PFN_DOWN(map->size), &dev->mm->pinned_vm);
+		vhost_vdpa_general_unmap(v, map, asid);
 		vhost_iotlb_map_free(iotlb, map);
 	}
 }
 
-static void vhost_vdpa_va_unmap(struct vhost_vdpa *v,
-				struct vhost_iotlb *iotlb,
-				u64 start, u64 last)
+static void vhost_vdpa_va_unmap(struct vhost_vdpa *v, struct vhost_iotlb *iotlb,
+				u64 start, u64 last, u32 asid)
 {
 	struct vhost_iotlb_map *map;
 	struct vdpa_map_file *map_file;
@@ -722,20 +732,21 @@ static void vhost_vdpa_va_unmap(struct v
 		map_file = (struct vdpa_map_file *)map->opaque;
 		fput(map_file->file);
 		kfree(map_file);
+		vhost_vdpa_general_unmap(v, map, asid);
 		vhost_iotlb_map_free(iotlb, map);
 	}
 }
 
 static void vhost_vdpa_iotlb_unmap(struct vhost_vdpa *v,
-				   struct vhost_iotlb *iotlb,
-				   u64 start, u64 last)
+				   struct vhost_iotlb *iotlb, u64 start,
+				   u64 last, u32 asid)
 {
 	struct vdpa_device *vdpa = v->vdpa;
 
 	if (vdpa->use_va)
-		return vhost_vdpa_va_unmap(v, iotlb, start, last);
+		return vhost_vdpa_va_unmap(v, iotlb, start, last, asid);
 
-	return vhost_vdpa_pa_unmap(v, iotlb, start, last);
+	return vhost_vdpa_pa_unmap(v, iotlb, start, last, asid);
 }
 
 static int perm_to_iommu_flags(u32 perm)
@@ -802,17 +813,12 @@ static void vhost_vdpa_unmap(struct vhos
 	const struct vdpa_config_ops *ops = vdpa->config;
 	u32 asid = iotlb_to_asid(iotlb);
 
-	vhost_vdpa_iotlb_unmap(v, iotlb, iova, iova + size - 1);
+	vhost_vdpa_iotlb_unmap(v, iotlb, iova, iova + size - 1, asid);
 
-	if (ops->dma_map) {
-		ops->dma_unmap(vdpa, asid, iova, size);
-	} else if (ops->set_map) {
+	if (ops->set_map) {
 		if (!v->in_batch)
 			ops->set_map(vdpa, asid, iotlb);
-	} else {
-		iommu_unmap(v->domain, iova, size);
 	}
-
 	/* If we are in the middle of batch processing, delay the free
 	 * of AS until BATCH_END.
 	 */



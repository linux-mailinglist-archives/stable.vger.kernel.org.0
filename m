Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF36D47340B
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 19:32:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230114AbhLMScA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 13:32:00 -0500
Received: from frasgout.his.huawei.com ([185.176.79.56]:4262 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241892AbhLMSb7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 13:31:59 -0500
Received: from fraeml714-chm.china.huawei.com (unknown [172.18.147.200])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4JCVS90FSJz682w5;
        Tue, 14 Dec 2021 02:30:33 +0800 (CST)
Received: from roberto-ThinkStation-P620.huawei.com (10.204.63.22) by
 fraeml714-chm.china.huawei.com (10.206.15.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 13 Dec 2021 19:31:56 +0100
From:   Roberto Sassu <roberto.sassu@huawei.com>
To:     <airlied@linux.ie>, <kraxel@redhat.com>, <daniel@ffwll.ch>
CC:     <dri-devel@lists.freedesktop.org>,
        <virtualization@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>,
        Roberto Sassu <roberto.sassu@huawei.com>,
        <stable@vger.kernel.org>,
        <syzbot+e9072e90624a31dfa85f@syzkaller.appspotmail.com>
Subject: [PATCH] drm/virtio: Ensure that objs is not NULL in virtio_gpu_array_put_free()
Date:   Mon, 13 Dec 2021 19:31:22 +0100
Message-ID: <20211213183122.838119-1-roberto.sassu@huawei.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.204.63.22]
X-ClientProxiedBy: lhreml752-chm.china.huawei.com (10.201.108.202) To
 fraeml714-chm.china.huawei.com (10.206.15.33)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

If virtio_gpu_object_shmem_init() fails (e.g. due to fault injection, as it
happened in the bug report by syzbot), virtio_gpu_array_put_free() could be
called with objs equal to NULL.

Ensure that objs is not NULL in virtio_gpu_array_put_free(), or otherwise
return from the function.

Cc: stable@vger.kernel.org # 5.13.x
Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
Reported-by: syzbot+e9072e90624a31dfa85f@syzkaller.appspotmail.com
Fixes: 377f8331d0565 ("drm/virtio: fix possible leak/unlock virtio_gpu_object_array")
---
 drivers/gpu/drm/virtio/virtgpu_gem.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/virtio/virtgpu_gem.c b/drivers/gpu/drm/virtio/virtgpu_gem.c
index 2de61b63ef91..48d3c9955f0d 100644
--- a/drivers/gpu/drm/virtio/virtgpu_gem.c
+++ b/drivers/gpu/drm/virtio/virtgpu_gem.c
@@ -248,6 +248,9 @@ void virtio_gpu_array_put_free(struct virtio_gpu_object_array *objs)
 {
 	u32 i;
 
+	if (!objs)
+		return;
+
 	for (i = 0; i < objs->nents; i++)
 		drm_gem_object_put(objs->objs[i]);
 	virtio_gpu_array_free(objs);
-- 
2.32.0


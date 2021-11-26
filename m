Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A920D45E4A5
	for <lists+stable@lfdr.de>; Fri, 26 Nov 2021 03:33:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344026AbhKZCfs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Nov 2021 21:35:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:47894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1357712AbhKZCdq (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Nov 2021 21:33:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EFCD66115A;
        Fri, 26 Nov 2021 02:30:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637893834;
        bh=QyAq05J8aKMtBpI2NIGtCz40YL2JvQEqxHMmH+5i4GM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E07MRrrNFidrydWyc5d2+ipFjPmnkjVvNgaTLAbz16jtymhbsEZzIW7vpMoU7S+5X
         A0dQTjndSvevi7xUHYAPJoG8WbUTikDhlNwAbYVDb6k7mMx1hZ0LmRsfQBFQd/gl5X
         +D/wvJOQZBfItX8SQJTxh5fETHXitp+CBmfTanjNnBB3yTrW5W78mOSJhvtxmK7e+G
         bpdEMmP47tgQ3DMGF0PX0MgiZVQmsCw7F56+r+eJWxLGHLpS/qGv+oHUn+gPmf74Kk
         0ZOgWmEgaFnP5LsZOS7+JVKqfUpXUgGT+/BuZnjy7Jgscg1U4Pla4Y3OYCjvcWS1AS
         2Y4Y7Zbyhu79w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     David Hildenbrand <david@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Marek Kedzierski <mkedzier@redhat.com>,
        Hui Zhu <teawater@gmail.com>,
        Sebastien Boeuf <sebastien.boeuf@intel.com>,
        Pankaj Gupta <pankaj.gupta.linux@gmail.com>,
        Wei Yang <richard.weiyang@linux.alibaba.com>,
        Sasha Levin <sashal@kernel.org>,
        virtualization@lists.linux-foundation.org
Subject: [PATCH AUTOSEL 5.15 7/7] virtio-mem: support VIRTIO_MEM_F_UNPLUGGED_INACCESSIBLE
Date:   Thu, 25 Nov 2021 21:30:06 -0500
Message-Id: <20211126023006.440839-7-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211126023006.440839-1-sashal@kernel.org>
References: <20211126023006.440839-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Hildenbrand <david@redhat.com>

[ Upstream commit 61082ad6a6e1f999eef7e7e90046486c87933b1e ]

The initial virtio-mem spec states that while unplugged memory should not
be read, the device still has to allow for reading unplugged memory inside
the usable region. The primary motivation for this default handling was
to simplify bringup of virtio-mem, because there were corner cases where
Linux might have accidentially read unplugged memory inside added Linux
memory blocks.

In the meantime, we:
1. Removed /dev/kmem in commit bbcd53c96071 ("drivers/char: remove
   /dev/kmem for good")
2. Disallowed access to virtio-mem device memory via /dev/mem in
   commit 2128f4e21aa2 ("virtio-mem: disallow mapping virtio-mem memory via
   /dev/mem")
3. Sanitized access to virtio-mem device memory via /proc/kcore in
   commit 0daa322b8ff9 ("fs/proc/kcore: don't read offline sections,
   logically offline pages and hwpoisoned pages")
4. Sanitized access to virtio-mem device memory via /proc/vmcore in
   commit ce2814622e84 ("virtio-mem: kdump mode to sanitize /proc/vmcore
   access")

"Accidential" access to unplugged memory is no longer possible; we can
support the new VIRTIO_MEM_F_UNPLUGGED_INACCESSIBLE feature that will be
required by some hypervisors implementing virtio-mem in the near future.

Acked-by: Michael S. Tsirkin <mst@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Jason Wang <jasowang@redhat.com>
Cc: Marek Kedzierski <mkedzier@redhat.com>
Cc: Hui Zhu <teawater@gmail.com>
Cc: Sebastien Boeuf <sebastien.boeuf@intel.com>
Cc: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Cc: Wei Yang <richard.weiyang@linux.alibaba.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/virtio/virtio_mem.c     | 1 +
 include/uapi/linux/virtio_mem.h | 9 ++++++---
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/virtio/virtio_mem.c b/drivers/virtio/virtio_mem.c
index bef8ad6bf4661..78dfdc9c98a1c 100644
--- a/drivers/virtio/virtio_mem.c
+++ b/drivers/virtio/virtio_mem.c
@@ -2758,6 +2758,7 @@ static unsigned int virtio_mem_features[] = {
 #if defined(CONFIG_NUMA) && defined(CONFIG_ACPI_NUMA)
 	VIRTIO_MEM_F_ACPI_PXM,
 #endif
+	VIRTIO_MEM_F_UNPLUGGED_INACCESSIBLE,
 };
 
 static const struct virtio_device_id virtio_mem_id_table[] = {
diff --git a/include/uapi/linux/virtio_mem.h b/include/uapi/linux/virtio_mem.h
index 70e01c687d5eb..e9122f1d0e0cb 100644
--- a/include/uapi/linux/virtio_mem.h
+++ b/include/uapi/linux/virtio_mem.h
@@ -68,9 +68,10 @@
  * explicitly triggered (VIRTIO_MEM_REQ_UNPLUG).
  *
  * There are no guarantees what will happen if unplugged memory is
- * read/written. Such memory should, in general, not be touched. E.g.,
- * even writing might succeed, but the values will simply be discarded at
- * random points in time.
+ * read/written. In general, unplugged memory should not be touched, because
+ * the resulting action is undefined. There is one exception: without
+ * VIRTIO_MEM_F_UNPLUGGED_INACCESSIBLE, unplugged memory inside the usable
+ * region can be read, to simplify creation of memory dumps.
  *
  * It can happen that the device cannot process a request, because it is
  * busy. The device driver has to retry later.
@@ -87,6 +88,8 @@
 
 /* node_id is an ACPI PXM and is valid */
 #define VIRTIO_MEM_F_ACPI_PXM		0
+/* unplugged memory must not be accessed */
+#define VIRTIO_MEM_F_UNPLUGGED_INACCESSIBLE	1
 
 
 /* --- virtio-mem: guest -> host requests --- */
-- 
2.33.0


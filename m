Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D5892ABA2D
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:16:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732103AbgKINQd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:16:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:43490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387466AbgKINQ3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:16:29 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F15BC20663;
        Mon,  9 Nov 2020 13:16:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604927788;
        bh=gfvcFmBkTuHwDfE/g82RQgtiq8nqAHjriJEz9WwW1BU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jn8Z+mgstj3+FQ3tj1WUTQWNfui46GdN3UK5V+tnglN6BFdGnSht2Y+7rxxkbITu3
         zDk3nmwOCboIwxMTDPTSBS+yr1or1p9+W5Eu+EWNqkGT0+px6GPBQg3xHLNyMmPZi7
         LBchqdpxOaFQovnbgm0OVXfpTujVKQJlKAbF15og=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Karol Herbst <kherbst@redhat.com>,
        Ben Skeggs <bskeggs@redhat.com>
Subject: [PATCH 5.9 021/133] drm/nouveau/device: fix changing endianess code to work on older GPUs
Date:   Mon,  9 Nov 2020 13:54:43 +0100
Message-Id: <20201109125031.740570960@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125030.706496283@linuxfoundation.org>
References: <20201109125030.706496283@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Karol Herbst <kherbst@redhat.com>

commit dcd292c172493067a72672b245a3dd1bcf7268dd upstream.

With this we try to detect if the endianess switch works and assume LE if
not. Suggested by Ben.

Fixes: 51c05340e407 ("drm/nouveau/device: detect if changing endianness failed")
Signed-off-by: Karol Herbst <kherbst@redhat.com>
Cc: <stable@vger.kernel.org> # v5.8+
Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/nouveau/nvkm/engine/device/base.c |   39 ++++++++++++++--------
 1 file changed, 26 insertions(+), 13 deletions(-)

--- a/drivers/gpu/drm/nouveau/nvkm/engine/device/base.c
+++ b/drivers/gpu/drm/nouveau/nvkm/engine/device/base.c
@@ -2924,17 +2924,34 @@ nvkm_device_del(struct nvkm_device **pde
 	}
 }
 
+/* returns true if the GPU is in the CPU native byte order */
 static inline bool
 nvkm_device_endianness(struct nvkm_device *device)
 {
-	u32 boot1 = nvkm_rd32(device, 0x000004) & 0x01000001;
 #ifdef __BIG_ENDIAN
-	if (!boot1)
-		return false;
+	const bool big_endian = true;
 #else
-	if (boot1)
-		return false;
+	const bool big_endian = false;
 #endif
+
+	/* Read NV_PMC_BOOT_1, and assume non-functional endian switch if it
+	 * doesn't contain the expected values.
+	 */
+	u32 pmc_boot_1 = nvkm_rd32(device, 0x000004);
+	if (pmc_boot_1 && pmc_boot_1 != 0x01000001)
+		return !big_endian; /* Assume GPU is LE in this case. */
+
+	/* 0 means LE and 0x01000001 means BE GPU. Condition is true when
+	 * GPU/CPU endianness don't match.
+	 */
+	if (big_endian == !pmc_boot_1) {
+		nvkm_wr32(device, 0x000004, 0x01000001);
+		nvkm_rd32(device, 0x000000);
+		if (nvkm_rd32(device, 0x000004) != (big_endian ? 0x01000001 : 0x00000000))
+			return !big_endian; /* Assume GPU is LE on any unexpected read-back. */
+	}
+
+	/* CPU/GPU endianness should (hopefully) match. */
 	return true;
 }
 
@@ -2987,14 +3004,10 @@ nvkm_device_ctor(const struct nvkm_devic
 	if (detect) {
 		/* switch mmio to cpu's native endianness */
 		if (!nvkm_device_endianness(device)) {
-			nvkm_wr32(device, 0x000004, 0x01000001);
-			nvkm_rd32(device, 0x000000);
-			if (!nvkm_device_endianness(device)) {
-				nvdev_error(device,
-					    "GPU not supported on big-endian\n");
-				ret = -ENOSYS;
-				goto done;
-			}
+			nvdev_error(device,
+				    "Couldn't switch GPU to CPUs endianess\n");
+			ret = -ENOSYS;
+			goto done;
 		}
 
 		boot0 = nvkm_rd32(device, 0x000000);



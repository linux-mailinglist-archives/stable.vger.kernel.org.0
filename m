Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AABB38A3E4
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 11:57:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234915AbhETJ6F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 05:58:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:59460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234079AbhETJ4D (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 05:56:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5D0CB61414;
        Thu, 20 May 2021 09:37:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621503453;
        bh=c8P8LeUszkN7SkAFEGjXTiKZVA02/BoIlz5tI9gquVI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n2McM5e6KmLq3Z9WNScFHELtmMZihzwSHFP+ky4vpkuStl5gyrADRGFKc1DUElj+o
         EsDQXo5FhfFw2HvPUBeWU/vBdFuS1njrp/WXyHzxRv60l/mjftBFYJmtArLXszZx+w
         y9ZlKDicrZyZ1cBFtzNt5PG8eMQW1kA4ErwyzSCE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 229/425] drm/amdkfd: fix build error with AMD_IOMMU_V2=m
Date:   Thu, 20 May 2021 11:19:58 +0200
Message-Id: <20210520092138.963470218@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092131.308959589@linuxfoundation.org>
References: <20210520092131.308959589@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Felix Kuehling <Felix.Kuehling@amd.com>

[ Upstream commit 1e87068570a2cc4db5f95a881686add71729e769 ]

Using 'imply AMD_IOMMU_V2' does not guarantee that the driver can link
against the exported functions. If the GPU driver is built-in but the
IOMMU driver is a loadable module, the kfd_iommu.c file is indeed
built but does not work:

x86_64-linux-ld: drivers/gpu/drm/amd/amdkfd/kfd_iommu.o: in function `kfd_iommu_bind_process_to_device':
kfd_iommu.c:(.text+0x516): undefined reference to `amd_iommu_bind_pasid'
x86_64-linux-ld: drivers/gpu/drm/amd/amdkfd/kfd_iommu.o: in function `kfd_iommu_unbind_process':
kfd_iommu.c:(.text+0x691): undefined reference to `amd_iommu_unbind_pasid'
x86_64-linux-ld: drivers/gpu/drm/amd/amdkfd/kfd_iommu.o: in function `kfd_iommu_suspend':
kfd_iommu.c:(.text+0x966): undefined reference to `amd_iommu_set_invalidate_ctx_cb'
x86_64-linux-ld: kfd_iommu.c:(.text+0x97f): undefined reference to `amd_iommu_set_invalid_ppr_cb'
x86_64-linux-ld: kfd_iommu.c:(.text+0x9a4): undefined reference to `amd_iommu_free_device'
x86_64-linux-ld: drivers/gpu/drm/amd/amdkfd/kfd_iommu.o: in function `kfd_iommu_resume':
kfd_iommu.c:(.text+0xa9a): undefined reference to `amd_iommu_init_device'
x86_64-linux-ld: kfd_iommu.c:(.text+0xadc): undefined reference to `amd_iommu_set_invalidate_ctx_cb'
x86_64-linux-ld: kfd_iommu.c:(.text+0xaff): undefined reference to `amd_iommu_set_invalid_ppr_cb'
x86_64-linux-ld: kfd_iommu.c:(.text+0xc72): undefined reference to `amd_iommu_bind_pasid'
x86_64-linux-ld: kfd_iommu.c:(.text+0xe08): undefined reference to `amd_iommu_set_invalidate_ctx_cb'
x86_64-linux-ld: kfd_iommu.c:(.text+0xe26): undefined reference to `amd_iommu_set_invalid_ppr_cb'
x86_64-linux-ld: kfd_iommu.c:(.text+0xe42): undefined reference to `amd_iommu_free_device'

Use IS_REACHABLE to only build IOMMU-V2 support if the amd_iommu symbols
are reachable by the amdkfd driver. Output a warning if they are not,
because that may not be what the user was expecting.

Fixes: 64d1c3a43a6f ("drm/amdkfd: Centralize IOMMUv2 code and make it conditional")
Reported-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Felix Kuehling <Felix.Kuehling@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_iommu.c | 6 ++++++
 drivers/gpu/drm/amd/amdkfd/kfd_iommu.h | 9 +++++++--
 2 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_iommu.c b/drivers/gpu/drm/amd/amdkfd/kfd_iommu.c
index 01494752c36a..f3a526ed8059 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_iommu.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_iommu.c
@@ -20,6 +20,10 @@
  * OTHER DEALINGS IN THE SOFTWARE.
  */
 
+#include <linux/kconfig.h>
+
+#if IS_REACHABLE(CONFIG_AMD_IOMMU_V2)
+
 #include <linux/printk.h>
 #include <linux/device.h>
 #include <linux/slab.h>
@@ -366,3 +370,5 @@ int kfd_iommu_add_perf_counters(struct kfd_topology_device *kdev)
 
 	return 0;
 }
+
+#endif
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_iommu.h b/drivers/gpu/drm/amd/amdkfd/kfd_iommu.h
index dd23d9fdf6a8..afd420b01a0c 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_iommu.h
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_iommu.h
@@ -23,7 +23,9 @@
 #ifndef __KFD_IOMMU_H__
 #define __KFD_IOMMU_H__
 
-#if defined(CONFIG_AMD_IOMMU_V2_MODULE) || defined(CONFIG_AMD_IOMMU_V2)
+#include <linux/kconfig.h>
+
+#if IS_REACHABLE(CONFIG_AMD_IOMMU_V2)
 
 #define KFD_SUPPORT_IOMMU_V2
 
@@ -46,6 +48,9 @@ static inline int kfd_iommu_check_device(struct kfd_dev *kfd)
 }
 static inline int kfd_iommu_device_init(struct kfd_dev *kfd)
 {
+#if IS_MODULE(CONFIG_AMD_IOMMU_V2)
+	WARN_ONCE(1, "iommu_v2 module is not usable by built-in KFD");
+#endif
 	return 0;
 }
 
@@ -73,6 +78,6 @@ static inline int kfd_iommu_add_perf_counters(struct kfd_topology_device *kdev)
 	return 0;
 }
 
-#endif /* defined(CONFIG_AMD_IOMMU_V2) */
+#endif /* IS_REACHABLE(CONFIG_AMD_IOMMU_V2) */
 
 #endif /* __KFD_IOMMU_H__ */
-- 
2.30.2




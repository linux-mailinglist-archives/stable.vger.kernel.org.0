Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D71326F01D
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 04:41:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726843AbgIRCkj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 22:40:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:37336 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728658AbgIRCLk (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:11:40 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A94E721582;
        Fri, 18 Sep 2020 02:11:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600395096;
        bh=In4oaqCILMZsMG6jV2Vkifbxu9SZjhTRRw2/AULid1k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UcxKAHXnK7YxhyAcyfQzS+07iksi3jOQ/9NRbxr+pFNdiz2/08ecT3jcUtjt/7PZL
         rydUbEJfQgb8neHbQODVOniNCIE0njUCnycHCcxHxPq4nRQBrN9do9OGorHcTT3bkA
         aqnQ8iFlF3X5KGhGBhNbRnHKeZ5rNko2bvSx3Onk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Qian Cai <cai@lca.pw>,
        Alex Williamson <alex.williamson@redhat.com>,
        Sasha Levin <sashal@kernel.org>, kvm@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 177/206] vfio/pci: fix memory leaks of eventfd ctx
Date:   Thu, 17 Sep 2020 22:07:33 -0400
Message-Id: <20200918020802.2065198-177-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020802.2065198-1-sashal@kernel.org>
References: <20200918020802.2065198-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qian Cai <cai@lca.pw>

[ Upstream commit 1518ac272e789cae8c555d69951b032a275b7602 ]

Finished a qemu-kvm (-device vfio-pci,host=0001:01:00.0) triggers a few
memory leaks after a while because vfio_pci_set_ctx_trigger_single()
calls eventfd_ctx_fdget() without the matching eventfd_ctx_put() later.
Fix it by calling eventfd_ctx_put() for those memory in
vfio_pci_release() before vfio_device_release().

unreferenced object 0xebff008981cc2b00 (size 128):
  comm "qemu-kvm", pid 4043, jiffies 4294994816 (age 9796.310s)
  hex dump (first 32 bytes):
    01 00 00 00 6b 6b 6b 6b 00 00 00 00 ad 4e ad de  ....kkkk.....N..
    ff ff ff ff 6b 6b 6b 6b ff ff ff ff ff ff ff ff  ....kkkk........
  backtrace:
    [<00000000917e8f8d>] slab_post_alloc_hook+0x74/0x9c
    [<00000000df0f2aa2>] kmem_cache_alloc_trace+0x2b4/0x3d4
    [<000000005fcec025>] do_eventfd+0x54/0x1ac
    [<0000000082791a69>] __arm64_sys_eventfd2+0x34/0x44
    [<00000000b819758c>] do_el0_svc+0x128/0x1dc
    [<00000000b244e810>] el0_sync_handler+0xd0/0x268
    [<00000000d495ef94>] el0_sync+0x164/0x180
unreferenced object 0x29ff008981cc4180 (size 128):
  comm "qemu-kvm", pid 4043, jiffies 4294994818 (age 9796.290s)
  hex dump (first 32 bytes):
    01 00 00 00 6b 6b 6b 6b 00 00 00 00 ad 4e ad de  ....kkkk.....N..
    ff ff ff ff 6b 6b 6b 6b ff ff ff ff ff ff ff ff  ....kkkk........
  backtrace:
    [<00000000917e8f8d>] slab_post_alloc_hook+0x74/0x9c
    [<00000000df0f2aa2>] kmem_cache_alloc_trace+0x2b4/0x3d4
    [<000000005fcec025>] do_eventfd+0x54/0x1ac
    [<0000000082791a69>] __arm64_sys_eventfd2+0x34/0x44
    [<00000000b819758c>] do_el0_svc+0x128/0x1dc
    [<00000000b244e810>] el0_sync_handler+0xd0/0x268
    [<00000000d495ef94>] el0_sync+0x164/0x180

Signed-off-by: Qian Cai <cai@lca.pw>
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vfio/pci/vfio_pci.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index 9f72a6ee13b53..86cd8bdfa9f28 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -409,6 +409,10 @@ static void vfio_pci_release(void *device_data)
 	if (!(--vdev->refcnt)) {
 		vfio_spapr_pci_eeh_release(vdev->pdev);
 		vfio_pci_disable(vdev);
+		if (vdev->err_trigger)
+			eventfd_ctx_put(vdev->err_trigger);
+		if (vdev->req_trigger)
+			eventfd_ctx_put(vdev->req_trigger);
 	}
 
 	mutex_unlock(&driver_lock);
-- 
2.25.1


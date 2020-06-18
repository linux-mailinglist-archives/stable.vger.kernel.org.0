Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A3501FE0A8
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 03:50:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731930AbgFRBtQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 21:49:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:35914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731910AbgFRB1l (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:27:41 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 25CF4221FC;
        Thu, 18 Jun 2020 01:27:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592443660;
        bh=7824x3/k4YK+DHkRKW4nSpWl3FtLjPQecHfwGNVT5TY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j/YTVtBDClNdkH9xCV+s8Hgzxs5bOzAigX8cl/v+2svB0SCaz+heQO6Fo31fpc6Xx
         JT5LEnOEFZcznAb9fENqVIs/qiiKNkJHe9dJJSbg7VLQckzcXPEX7MtLkVR73ki5my
         Cs9Kh9F7xiPounumBlUF96Z/f0SNI5j49MZos55A=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Qian Cai <cai@lca.pw>,
        Alex Williamson <alex.williamson@redhat.com>,
        Sasha Levin <sashal@kernel.org>, kvm@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 079/108] vfio/pci: fix memory leaks of eventfd ctx
Date:   Wed, 17 Jun 2020 21:25:31 -0400
Message-Id: <20200618012600.608744-79-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618012600.608744-1-sashal@kernel.org>
References: <20200618012600.608744-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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
index 550ab7707b57..b7733d3c06de 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -397,6 +397,10 @@ static void vfio_pci_release(void *device_data)
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


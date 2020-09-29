Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE61C27CC40
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:35:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732565AbgI2Meo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 08:34:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:36424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729558AbgI2LVZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:21:25 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 573D223A52;
        Tue, 29 Sep 2020 11:19:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601378369;
        bh=GkGlGLAibR47Bq9v7Y+rMMrr3gg5FDqfGgv1JKf7BCE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pemq6nyMMLcLg7VSMmhm3ojCsgR9IxoUHQJ/A85IPejf151j/35kJMfb+fE6SX4Oz
         fc63xyErMrqxV9kksqpOx78O2BHfxSoce8o1Ch0TVlZbm8j/g8ma+bsiXxF6bPlGVL
         UssQIMz8MvZL/GqrmSe276T71LsqIxtWlwkzQZug=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qian Cai <cai@lca.pw>,
        Alex Williamson <alex.williamson@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 127/166] vfio/pci: fix memory leaks of eventfd ctx
Date:   Tue, 29 Sep 2020 13:00:39 +0200
Message-Id: <20200929105941.540627406@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105935.184737111@linuxfoundation.org>
References: <20200929105935.184737111@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 794dc90aa5c95..902854a013521 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -399,6 +399,10 @@ static void vfio_pci_release(void *device_data)
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




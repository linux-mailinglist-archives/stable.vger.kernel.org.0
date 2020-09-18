Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CEE626EDDC
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 04:24:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729642AbgIRCYJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 22:24:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:46562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729426AbgIRCQk (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:16:40 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 02DA3239D0;
        Fri, 18 Sep 2020 02:16:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600395398;
        bh=j9M/ZVACyoaoos25pViqIw0OqwIayoGBc0LWdds0Jx8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zWZqSjkUaoP7EAX7eAnU3Dwb6dhT9v38xWoOUEcqBjJg10Sr67Y2TFC9kO6NA33b5
         Qzg18SwW43d6B7pIKCEzLfsQafcuNU9x9pnU34/SbdlMJVaPtEv5AbTt9f47jDDpiK
         hzuYz7BUPFUebn7b/R1ganX1H+nf/7BRPWG4aeWo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Qian Cai <cai@lca.pw>, Daniel Wagner <dwagner@suse.de>,
        Cornelia Huck <cohuck@redhat.com>,
        Sasha Levin <sashal@kernel.org>, kvm@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 87/90] vfio/pci: Clear error and request eventfd ctx after releasing
Date:   Thu, 17 Sep 2020 22:14:52 -0400
Message-Id: <20200918021455.2067301-87-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918021455.2067301-1-sashal@kernel.org>
References: <20200918021455.2067301-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Williamson <alex.williamson@redhat.com>

[ Upstream commit 5c5866c593bbd444d0339ede6a8fb5f14ff66d72 ]

The next use of the device will generate an underflow from the
stale reference.

Cc: Qian Cai <cai@lca.pw>
Fixes: 1518ac272e78 ("vfio/pci: fix memory leaks of eventfd ctx")
Reported-by: Daniel Wagner <dwagner@suse.de>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Tested-by: Daniel Wagner <dwagner@suse.de>
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vfio/pci/vfio_pci.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index c9c0af9a571f6..c08cff0ca08df 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -392,10 +392,14 @@ static void vfio_pci_release(void *device_data)
 	if (!(--vdev->refcnt)) {
 		vfio_spapr_pci_eeh_release(vdev->pdev);
 		vfio_pci_disable(vdev);
-		if (vdev->err_trigger)
+		if (vdev->err_trigger) {
 			eventfd_ctx_put(vdev->err_trigger);
-		if (vdev->req_trigger)
+			vdev->err_trigger = NULL;
+		}
+		if (vdev->req_trigger) {
 			eventfd_ctx_put(vdev->req_trigger);
+			vdev->req_trigger = NULL;
+		}
 	}
 
 	mutex_unlock(&driver_lock);
-- 
2.25.1


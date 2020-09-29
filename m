Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9043027C631
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:43:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730731AbgI2Lmn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:42:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:40210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730470AbgI2Lmf (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:42:35 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3BE7520702;
        Tue, 29 Sep 2020 11:42:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379754;
        bh=yGyQvtcrzzOsuLns5qoWHAXVBcKYt/j9EFNRVIfjoHU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Vb1IUDodbXAeTZHTsoP+fDWXiHoDijxKaHpBwHnQV+nJDf8jxfJT9CkxXRtIuFoFs
         1xL+2sNZJl6E6oHZF/rverkWCfaXHRAUD8nA+fKWMF64SnPNyk6oiGW5Wt8nDAh2Jp
         Ei3VFD/DtpHxHHKanwcbfziNasfihYyKNJOm8l2A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qian Cai <cai@lca.pw>,
        Daniel Wagner <dwagner@suse.de>,
        Cornelia Huck <cohuck@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 303/388] vfio/pci: Clear error and request eventfd ctx after releasing
Date:   Tue, 29 Sep 2020 13:00:34 +0200
Message-Id: <20200929110025.132412620@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929110010.467764689@linuxfoundation.org>
References: <20200929110010.467764689@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 12f7691e8b6ca..b669be5a20066 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -474,10 +474,14 @@ static void vfio_pci_release(void *device_data)
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
 
 	mutex_unlock(&vdev->reflck->lock);
-- 
2.25.1




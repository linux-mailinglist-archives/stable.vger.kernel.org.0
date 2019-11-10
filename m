Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82B0BF6377
	for <lists+stable@lfdr.de>; Sun, 10 Nov 2019 03:52:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728384AbfKJCwl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Nov 2019 21:52:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:36262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730012AbfKJCvc (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 9 Nov 2019 21:51:32 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 368D022583;
        Sun, 10 Nov 2019 02:51:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573354292;
        bh=avT296kkH6vYPf/CZXBH0ZritG7eBuOV/le7rkHC914=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I+enOqX5bDt6VqLO1KTIzMf5hy+GkKlqVz8XuHrkL/nEaqSQvcVfSaI+drcnuZjmG
         x9Gi3FeEUcvRlD/kp0lhCcwuMsSZdS3V4kDVbA4Y1sCLGzwlZgmdo+3pdDC1prgfSr
         pydu241RZXf6Bvoy21r+y47o9f2/PMesbq6KF2Gg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Li Qiang <liq3ea@gmail.com>, Eric Auger <eric.auger@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Sasha Levin <sashal@kernel.org>, kvm@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 32/40] vfio/pci: Fix potential memory leak in vfio_msi_cap_len
Date:   Sat,  9 Nov 2019 21:50:24 -0500
Message-Id: <20191110025032.827-32-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191110025032.827-1-sashal@kernel.org>
References: <20191110025032.827-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Li Qiang <liq3ea@gmail.com>

[ Upstream commit 30ea32ab1951c80c6113f300fce2c70cd12659e4 ]

Free allocated vdev->msi_perm in error path.

Signed-off-by: Li Qiang <liq3ea@gmail.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vfio/pci/vfio_pci_config.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
index c55c632a3b249..ad5929fbceb16 100644
--- a/drivers/vfio/pci/vfio_pci_config.c
+++ b/drivers/vfio/pci/vfio_pci_config.c
@@ -1130,8 +1130,10 @@ static int vfio_msi_cap_len(struct vfio_pci_device *vdev, u8 pos)
 		return -ENOMEM;
 
 	ret = init_pci_cap_msi_perm(vdev->msi_perm, len, flags);
-	if (ret)
+	if (ret) {
+		kfree(vdev->msi_perm);
 		return ret;
+	}
 
 	return len;
 }
-- 
2.20.1


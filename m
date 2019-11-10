Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56F8AF6471
	for <lists+stable@lfdr.de>; Sun, 10 Nov 2019 04:00:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729706AbfKJDAA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Nov 2019 22:00:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:47210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729267AbfKJC4r (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 9 Nov 2019 21:56:47 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 77A1321D7B;
        Sun, 10 Nov 2019 02:47:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573354061;
        bh=laLOVN9b3e7blkEA0eFOdsXXjtlukZsyKhx2FPSNf5o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=il3PdK4eRMmRoMuAmaK8oetg3LHpxnuAiNMVnqEvUva/BqBjoyeHjvt2BEtA3BUpM
         SHAS+KT5x9tdCUdK4BnITXdG1qb/JiPWZE7AK2jGFMA/IDSBm9Bxmvhou/YIl98SET
         OHVr7+lZFeYcCSRzVNX1YGLoZNMFHPVX/mQi9sZ0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Li Qiang <liq3ea@gmail.com>, Eric Auger <eric.auger@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Sasha Levin <sashal@kernel.org>, kvm@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 069/109] vfio/pci: Fix potential memory leak in vfio_msi_cap_len
Date:   Sat,  9 Nov 2019 21:45:01 -0500
Message-Id: <20191110024541.31567-69-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191110024541.31567-1-sashal@kernel.org>
References: <20191110024541.31567-1-sashal@kernel.org>
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
index 115a36f6f4039..62023b4a373b4 100644
--- a/drivers/vfio/pci/vfio_pci_config.c
+++ b/drivers/vfio/pci/vfio_pci_config.c
@@ -1180,8 +1180,10 @@ static int vfio_msi_cap_len(struct vfio_pci_device *vdev, u8 pos)
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


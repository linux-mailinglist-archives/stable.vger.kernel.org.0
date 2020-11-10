Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D24542ACD60
	for <lists+stable@lfdr.de>; Tue, 10 Nov 2020 05:01:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733146AbgKJDz1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 22:55:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:56812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731402AbgKJDz0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 22:55:26 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 90A1C21534;
        Tue, 10 Nov 2020 03:55:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604980525;
        bh=imKwv/Fb3tX8Sf2PNoVY7wcaiXIi4oQ+RdrROR2vnxo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aBHjt5PlamRb8rPRQ9/KPWGfBK76H/luNgBDTBk+vEw3DSZRgvlAN1rL0SkhTIRUw
         6hIEMsEY9oESsyM4BPwRAbkAbcg5qk/CAFPn3DiB5j+2fZaHbmLViLg1STujofD0Lw
         t86RkI8XEj2uE/IuY7FxFahyT6P4H/z4M3wUWOWU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Fred Gao <fred.gao@intel.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Xiong Zhang <xiong.y.zhang@intel.com>,
        Hang Yuan <hang.yuan@linux.intel.com>,
        Stuart Summers <stuart.summers@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Sasha Levin <sashal@kernel.org>, kvm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 32/42] vfio/pci: Bypass IGD init in case of -ENODEV
Date:   Mon,  9 Nov 2020 22:54:30 -0500
Message-Id: <20201110035440.424258-32-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201110035440.424258-1-sashal@kernel.org>
References: <20201110035440.424258-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fred Gao <fred.gao@intel.com>

[ Upstream commit e4eccb853664de7bcf9518fb658f35e748bf1f68 ]

Bypass the IGD initialization when -ENODEV returns,
that should be the case if opregion is not available for IGD
or within discrete graphics device's option ROM,
or host/lpc bridge is not found.

Then use of -ENODEV here means no special device resources found
which needs special care for VFIO, but we still allow other normal
device resource access.

Cc: Zhenyu Wang <zhenyuw@linux.intel.com>
Cc: Xiong Zhang <xiong.y.zhang@intel.com>
Cc: Hang Yuan <hang.yuan@linux.intel.com>
Cc: Stuart Summers <stuart.summers@intel.com>
Signed-off-by: Fred Gao <fred.gao@intel.com>
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vfio/pci/vfio_pci.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index a72fd5309b09f..443a35dde7f52 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -334,7 +334,7 @@ static int vfio_pci_enable(struct vfio_pci_device *vdev)
 	    pdev->vendor == PCI_VENDOR_ID_INTEL &&
 	    IS_ENABLED(CONFIG_VFIO_PCI_IGD)) {
 		ret = vfio_pci_igd_init(vdev);
-		if (ret) {
+		if (ret && ret != -ENODEV) {
 			pci_warn(pdev, "Failed to setup Intel IGD regions\n");
 			goto disable_exit;
 		}
-- 
2.27.0


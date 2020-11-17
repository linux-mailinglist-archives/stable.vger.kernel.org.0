Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F8F22B6327
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:37:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732471AbgKQNf0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:35:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:46150 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732468AbgKQNfZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:35:25 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9274C24686;
        Tue, 17 Nov 2020 13:35:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605620125;
        bh=ppERrehELOu1hQh6t1jCbm+AqyYz5ABoxm7pF4UNWcY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Bnmuk5wnIdS3ad6MsRNn7JV6QVVwfa+POA11ibOar6a+KyL97hYtSFZNUG+6bDowQ
         ROdXKi2L8glcYLKIHFmsgQb1n7yjf6F/VrEwiCsYYvmwyu8tPMofL252u+l3LTWuLO
         iFL3qC0hKUNrw9D4hasHuJpN6WAy/g00HXBlBNYo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhenyu Wang <zhenyuw@linux.intel.com>,
        Xiong Zhang <xiong.y.zhang@intel.com>,
        Hang Yuan <hang.yuan@linux.intel.com>,
        Stuart Summers <stuart.summers@intel.com>,
        Fred Gao <fred.gao@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 115/255] vfio/pci: Bypass IGD init in case of -ENODEV
Date:   Tue, 17 Nov 2020 14:04:15 +0100
Message-Id: <20201117122144.543757070@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122138.925150709@linuxfoundation.org>
References: <20201117122138.925150709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 1ab1f5cda4ac2..bfdc010a6b043 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -385,7 +385,7 @@ static int vfio_pci_enable(struct vfio_pci_device *vdev)
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




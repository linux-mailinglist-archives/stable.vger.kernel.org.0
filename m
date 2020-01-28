Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E62CA14BA45
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:38:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728221AbgA1OiC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:38:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:43690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730608AbgA1OTT (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:19:19 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BF2A324681;
        Tue, 28 Jan 2020 14:19:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580221159;
        bh=4hGTtZ/hLdp2L12t5xiXK0BvSF3xpnX6O+7aCaXLxFg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sI19/nPd28BhthTKKQ5gnDVlUhpVzPWOmQdil0EIilrIsK/3C2B49rnAbdJq8bzLK
         7eiJWtXucdxV3L5VUTeIIKIZhWwdCMTuthH13L3mkGpKmjf7q3I2NVBnlJOjPYrkA1
         OmaBpWqHxBQan7yuf3N/fsBmaBG5+GAvx0QJHQYo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Auger <eric.auger@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 075/271] vfio_pci: Enable memory accesses before calling pci_map_rom
Date:   Tue, 28 Jan 2020 15:03:44 +0100
Message-Id: <20200128135858.152820233@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135852.449088278@linuxfoundation.org>
References: <20200128135852.449088278@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Auger <eric.auger@redhat.com>

[ Upstream commit 0cfd027be1d6def4a462cdc180c055143af24069 ]

pci_map_rom/pci_get_rom_size() performs memory access in the ROM.
In case the Memory Space accesses were disabled, readw() is likely
to trigger a synchronous external abort on some platforms.

In case memory accesses were disabled, re-enable them before the
call and disable them back again just after.

Fixes: 89e1f7d4c66d ("vfio: Add PCI device driver")
Signed-off-by: Eric Auger <eric.auger@redhat.com>
Suggested-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vfio/pci/vfio_pci.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index da3f0ed18c769..c94167d871789 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -729,6 +729,7 @@ static long vfio_pci_ioctl(void *device_data,
 		{
 			void __iomem *io;
 			size_t size;
+			u16 orig_cmd;
 
 			info.offset = VFIO_PCI_INDEX_TO_OFFSET(info.index);
 			info.flags = 0;
@@ -744,15 +745,23 @@ static long vfio_pci_ioctl(void *device_data,
 					break;
 			}
 
-			/* Is it really there? */
+			/*
+			 * Is it really there?  Enable memory decode for
+			 * implicit access in pci_map_rom().
+			 */
+			pci_read_config_word(pdev, PCI_COMMAND, &orig_cmd);
+			pci_write_config_word(pdev, PCI_COMMAND,
+					      orig_cmd | PCI_COMMAND_MEMORY);
+
 			io = pci_map_rom(pdev, &size);
-			if (!io || !size) {
+			if (io) {
+				info.flags = VFIO_REGION_INFO_FLAG_READ;
+				pci_unmap_rom(pdev, io);
+			} else {
 				info.size = 0;
-				break;
 			}
-			pci_unmap_rom(pdev, io);
 
-			info.flags = VFIO_REGION_INFO_FLAG_READ;
+			pci_write_config_word(pdev, PCI_COMMAND, orig_cmd);
 			break;
 		}
 		case VFIO_PCI_VGA_REGION_INDEX:
-- 
2.20.1




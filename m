Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53C7E13F1EA
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 19:32:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391858AbgAPRZC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 12:25:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:60398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391675AbgAPRZB (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:25:01 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1B3E5246B2;
        Thu, 16 Jan 2020 17:25:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579195500;
        bh=0YGQp/F2sJJuMbnncmCpycXLQIXk9mXxVpEpR5J7qPY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PRitjyXunnyxJBMdMTdw9cv7heDjOOQgPVy50r6x2YUmNlWB4+/aDX1TqKGbGQDN8
         aqRB3h5QY8DVH1uIo/WeQRaSc0M1Nj3Oo5dwm0a5A6qFELLBodPBGPaZSQvGxOkRoP
         Q3DG30NBwq3NAxbIqBYAMVddmS/He8A3yNtGXV54=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Eric Auger <eric.auger@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Sasha Levin <sashal@kernel.org>, kvm@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 101/371] vfio_pci: Enable memory accesses before calling pci_map_rom
Date:   Thu, 16 Jan 2020 12:19:33 -0500
Message-Id: <20200116172403.18149-44-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116172403.18149-1-sashal@kernel.org>
References: <20200116172403.18149-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 9bd3e7911af2..550ab7707b57 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -717,6 +717,7 @@ static long vfio_pci_ioctl(void *device_data,
 		{
 			void __iomem *io;
 			size_t size;
+			u16 orig_cmd;
 
 			info.offset = VFIO_PCI_INDEX_TO_OFFSET(info.index);
 			info.flags = 0;
@@ -732,15 +733,23 @@ static long vfio_pci_ioctl(void *device_data,
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


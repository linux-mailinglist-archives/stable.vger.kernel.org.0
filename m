Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 813C81AD8BD
	for <lists+stable@lfdr.de>; Fri, 17 Apr 2020 10:38:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729749AbgDQIgv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Apr 2020 04:36:51 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:57462 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729732AbgDQIgv (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Apr 2020 04:36:51 -0400
Received: from 61-220-137-37.hinet-ip.hinet.net ([61.220.137.37] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <kai.heng.feng@canonical.com>)
        id 1jPMUP-00047h-Dy; Fri, 17 Apr 2020 08:36:45 +0000
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
To:     kbusch@kernel.org, axboe@fb.com, hch@lst.de, sagi@grimberg.me
Cc:     Kai-Heng Feng <kai.heng.feng@canonical.com>,
        linux-stable <stable@vger.kernel.org>,
        linux-nvme@lists.infradead.org (open list:NVM EXPRESS DRIVER),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] nvme/pci: Use Discard instead of Write Zeroes on SK hynix SC300
Date:   Fri, 17 Apr 2020 16:36:41 +0800
Message-Id: <20200417083641.28205-1-kai.heng.feng@canonical.com>
X-Mailer: git-send-email 2.17.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

After commit 6e02318eaea5 ("nvme: add support for the Write Zeroes
command"), SK hynix SC300 becomes very slow with the following error
message:
[  224.567695] blk_update_request: operation not supported error, dev nvme1n1, sector 499384320 op 0x9:(WRITE_ZEROES) flags 0x1000000 phys_seg 0 prio class 0]

Use quirk NVME_QUIRK_DEALLOCATE_ZEROES to workaround this issue.

BugLink: https://bugs.launchpad.net/bugs/1872383
Cc: linux-stable <stable@vger.kernel.org> # >= 5.1
Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
---
 drivers/nvme/host/pci.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 4e79e412b276..e3f4dac823d8 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -3068,6 +3068,8 @@ static const struct pci_device_id nvme_id_table[] = {
 		.driver_data = NVME_QUIRK_DELAY_BEFORE_CHK_RDY, },
 	{ PCI_DEVICE(0x1c58, 0x0023),	/* WDC SN200 adapter */
 		.driver_data = NVME_QUIRK_DELAY_BEFORE_CHK_RDY, },
+	{ PCI_DEVICE(0x1c5c, 0x1504),	/* SK hynix SC300 */
+		.driver_data = NVME_QUIRK_DEALLOCATE_ZEROES, },
 	{ PCI_DEVICE(0x1c5f, 0x0540),	/* Memblaze Pblaze4 adapter */
 		.driver_data = NVME_QUIRK_DELAY_BEFORE_CHK_RDY, },
 	{ PCI_DEVICE(0x144d, 0xa821),   /* Samsung PM1725 */
-- 
2.17.1


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95B1733E43E
	for <lists+stable@lfdr.de>; Wed, 17 Mar 2021 02:01:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232187AbhCQA6z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Mar 2021 20:58:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:35252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231851AbhCQA57 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Mar 2021 20:57:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DF7E364FB2;
        Wed, 17 Mar 2021 00:57:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615942674;
        bh=MO9y2X2TYpmHs9c6mM9dk0a2itziTJp6h7Xq2GG3gms=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KgcmPOpOsFubc65PcRDlERN6cN8CuCfX4yhLZWz4oAJGb+G5wv9wp4XtBh9vVz2rc
         /4nJ+gpZEQzse7PdyRS/CjdMvEIAMh7C8UOEalAS1zzt0TSzF+GRmKagAjrAF4o0Y3
         hHJTRmGn0FLpcLRoE9m4PDinhEFHXUiSbZ/bp3h5XcqWFTOIfVFOCgTtVL0enQoqFQ
         j0iLuewg3eDURFoZUnjsph2nvFDwJSSsTSziYQw8eRcnHxGZKsAd7q21XgWH6fXM+2
         2JZWe3GOUcjX8oM1TiFSdhNWhle1Y7RyWll0o2SUwlZ0ag7dmeTvjjBUT2BJ1s2yk9
         w2EvYl96tnwVg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dmitry Monakhov <dmtrmonakhov@yandex-team.ru>,
        Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 49/54] nvme-pci: add the DISABLE_WRITE_ZEROES quirk for a Samsung PM1725a
Date:   Tue, 16 Mar 2021 20:56:48 -0400
Message-Id: <20210317005654.724862-49-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210317005654.724862-1-sashal@kernel.org>
References: <20210317005654.724862-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Monakhov <dmtrmonakhov@yandex-team.ru>

[ Upstream commit abbb5f5929ec6c52574c430c5475c158a65c2a8c ]

This adds a quirk for Samsung PM1725a drive which fixes timeouts and
I/O errors due to the fact that the controller does not properly
handle the Write Zeroes command, dmesg log:

nvme nvme0: I/O 528 QID 10 timeout, aborting
nvme nvme0: I/O 529 QID 10 timeout, aborting
nvme nvme0: I/O 530 QID 10 timeout, aborting
nvme nvme0: I/O 531 QID 10 timeout, aborting
nvme nvme0: I/O 532 QID 10 timeout, aborting
nvme nvme0: I/O 533 QID 10 timeout, aborting
nvme nvme0: I/O 534 QID 10 timeout, aborting
nvme nvme0: I/O 535 QID 10 timeout, aborting
nvme nvme0: Abort status: 0x0
nvme nvme0: Abort status: 0x0
nvme nvme0: Abort status: 0x0
nvme nvme0: Abort status: 0x0
nvme nvme0: Abort status: 0x0
nvme nvme0: Abort status: 0x0
nvme nvme0: Abort status: 0x0
nvme nvme0: Abort status: 0x0
nvme nvme0: I/O 528 QID 10 timeout, reset controller
nvme nvme0: controller is down; will reset: CSTS=0x3, PCI_STATUS=0x10
nvme nvme0: Device not ready; aborting reset, CSTS=0x3
nvme nvme0: Device not ready; aborting reset, CSTS=0x3
nvme nvme0: Removing after probe failure status: -19
nvme0n1: detected capacity change from 6251233968 to 0
blk_update_request: I/O error, dev nvme0n1, sector 32776 op 0x1:(WRITE) flags 0x3000 phys_seg 6 prio class 0
blk_update_request: I/O error, dev nvme0n1, sector 113319936 op 0x9:(WRITE_ZEROES) flags 0x800 phys_seg 0 prio class 0
Buffer I/O error on dev nvme0n1p2, logical block 1, lost async page write
blk_update_request: I/O error, dev nvme0n1, sector 113319680 op 0x9:(WRITE_ZEROES) flags 0x0 phys_seg 0 prio class 0
Buffer I/O error on dev nvme0n1p2, logical block 2, lost async page write
blk_update_request: I/O error, dev nvme0n1, sector 113319424 op 0x9:(WRITE_ZEROES) flags 0x0 phys_seg 0 prio class 0
Buffer I/O error on dev nvme0n1p2, logical block 3, lost async page write
blk_update_request: I/O error, dev nvme0n1, sector 113319168 op 0x9:(WRITE_ZEROES) flags 0x0 phys_seg 0 prio class 0
Buffer I/O error on dev nvme0n1p2, logical block 4, lost async page write
blk_update_request: I/O error, dev nvme0n1, sector 113318912 op 0x9:(WRITE_ZEROES) flags 0x0 phys_seg 0 prio class 0
Buffer I/O error on dev nvme0n1p2, logical block 5, lost async page write
blk_update_request: I/O error, dev nvme0n1, sector 113318656 op 0x9:(WRITE_ZEROES) flags 0x0 phys_seg 0 prio class 0
Buffer I/O error on dev nvme0n1p2, logical block 6, lost async page write
blk_update_request: I/O error, dev nvme0n1, sector 113318400 op 0x9:(WRITE_ZEROES) flags 0x0 phys_seg 0 prio class 0
blk_update_request: I/O error, dev nvme0n1, sector 113318144 op 0x9:(WRITE_ZEROES) flags 0x0 phys_seg 0 prio class 0
blk_update_request: I/O error, dev nvme0n1, sector 113317888 op 0x9:(WRITE_ZEROES) flags 0x0 phys_seg 0 prio class 0

Signed-off-by: Dmitry Monakhov <dmtrmonakhov@yandex-team.ru>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/pci.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 99c59f93a064..4dca58f4afdf 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -3247,6 +3247,7 @@ static const struct pci_device_id nvme_id_table[] = {
 		.driver_data = NVME_QUIRK_DELAY_BEFORE_CHK_RDY, },
 	{ PCI_DEVICE(0x144d, 0xa822),   /* Samsung PM1725a */
 		.driver_data = NVME_QUIRK_DELAY_BEFORE_CHK_RDY |
+				NVME_QUIRK_DISABLE_WRITE_ZEROES|
 				NVME_QUIRK_IGNORE_DEV_SUBNQN, },
 	{ PCI_DEVICE(0x1987, 0x5016),	/* Phison E16 */
 		.driver_data = NVME_QUIRK_IGNORE_DEV_SUBNQN, },
-- 
2.30.1


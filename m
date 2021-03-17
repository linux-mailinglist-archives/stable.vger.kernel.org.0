Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEE7133E3A2
	for <lists+stable@lfdr.de>; Wed, 17 Mar 2021 01:58:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230085AbhCQA5O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Mar 2021 20:57:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:34420 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231244AbhCQA4r (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Mar 2021 20:56:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EFB5264F9B;
        Wed, 17 Mar 2021 00:56:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615942604;
        bh=gR+XjA2GvUDUPqy8DoHaelmXBzQE5a6V+SzzSf7OFhg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YDuWHPukzx3dW+QmXS5vIejl2dWpJuiVFGA8wpyNMjvSd7N5xapyQtz6dN/DQbsRO
         a5eV3dkqt7svR9FVqDj0OxxvKC+b3koRGSQl8w5zzUGxyoT8sLM3Ilm+RZq/vieXvn
         YmbE/xZu/Zi2MrVMU/kO5FWKhx1XX3UO6KKDw6T24rkYJO3Ql/We8hZ2qpXW7S0NFy
         YaB7PWwf0zjq4dYBuJwU32YYpG55G7DgowxfqAhc6fGGNxlp7ImO4CPdD+3Q4f0gNU
         LJ77lE5Rxg3lGWvRi/iu/QJSdSVHrKsspdQDrNxao2l58OAvYBCjj2gLmEJJbW1jEZ
         idIOh7G0OfaZg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dmitry Monakhov <dmtrmonakhov@yandex-team.ru>,
        Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 5.11 55/61] nvme-pci: add the DISABLE_WRITE_ZEROES quirk for a Samsung PM1725a
Date:   Tue, 16 Mar 2021 20:55:29 -0400
Message-Id: <20210317005536.724046-55-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210317005536.724046-1-sashal@kernel.org>
References: <20210317005536.724046-1-sashal@kernel.org>
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
index 806a5d071ef6..514dfd630035 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -3242,6 +3242,7 @@ static const struct pci_device_id nvme_id_table[] = {
 		.driver_data = NVME_QUIRK_DELAY_BEFORE_CHK_RDY, },
 	{ PCI_DEVICE(0x144d, 0xa822),   /* Samsung PM1725a */
 		.driver_data = NVME_QUIRK_DELAY_BEFORE_CHK_RDY |
+				NVME_QUIRK_DISABLE_WRITE_ZEROES|
 				NVME_QUIRK_IGNORE_DEV_SUBNQN, },
 	{ PCI_DEVICE(0x1987, 0x5016),	/* Phison E16 */
 		.driver_data = NVME_QUIRK_IGNORE_DEV_SUBNQN, },
-- 
2.30.1


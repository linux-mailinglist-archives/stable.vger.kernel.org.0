Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6962930C494
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 16:58:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235902AbhBBP4W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 10:56:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:39396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235252AbhBBPMX (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 10:12:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4396B64F7E;
        Tue,  2 Feb 2021 15:06:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612278409;
        bh=y6VZLk8zLqmib1CZS2K7UGdPbpx6dCtj2tVUJ0W9ZpM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F2RbEnI4+pC5ZUgEbW7RQWIujVErILwfFnAan1aRoZfQga5SI7VQGNevdo6UP1AdI
         eOs+IRBDqTWUT1WhDbBDKbNr52pf6X4txpSV4KIAMvPIsIHUKO2KfYdnn9al2kb8aH
         Ft5KqqBahsViwPfV1+d59bNRApzonJIyJgTbvJ33iUeyJXt22dn5mj+PBSxHCwCcPK
         bK0DxblluUUCKoakqTGUKKTY9i/rQII8DwYmnkzPEF1/VnmGc8q4EACspOHTvaM7Yj
         6yf8ztr6ljD9BbAPGoblMOh7gD951ASV/LPapIFgj7IN4dzAdQTJr9a/xG630Ug6Ty
         wWpry4njoP46w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        Bradley Chapman <chapman6235@comcast.net>,
        Keith Busch <kbusch@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 25/25] nvme-pci: add the DISABLE_WRITE_ZEROES quirk for a SPCC device
Date:   Tue,  2 Feb 2021 10:06:15 -0500
Message-Id: <20210202150615.1864175-25-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210202150615.1864175-1-sashal@kernel.org>
References: <20210202150615.1864175-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>

[ Upstream commit 899199292b14b7c735808a37517de4dd2160c300 ]

This adds a quirk for SPCC 256GB NVMe 1.3 drive which fixes timeouts and
I/O errors due to the fact that the controller does not properly
handle the Write Zeroes command:

[ 2745.659527] CPU: 2 PID: 0 Comm: swapper/2 Tainted: G            E 5.10.6-BET #1
[ 2745.659528] Hardware name: System manufacturer System Product Name/PRIME X570-P, BIOS 3001 12/04/2020
[ 2776.138874] nvme nvme1: I/O 414 QID 3 timeout, aborting
[ 2776.138886] nvme nvme1: I/O 415 QID 3 timeout, aborting
[ 2776.138891] nvme nvme1: I/O 416 QID 3 timeout, aborting
[ 2776.138895] nvme nvme1: I/O 417 QID 3 timeout, aborting
[ 2776.138912] nvme nvme1: Abort status: 0x0
[ 2776.138921] nvme nvme1: I/O 428 QID 3 timeout, aborting
[ 2776.138922] nvme nvme1: Abort status: 0x0
[ 2776.138925] nvme nvme1: Abort status: 0x0
[ 2776.138974] nvme nvme1: Abort status: 0x0
[ 2776.138977] nvme nvme1: Abort status: 0x0
[ 2806.346792] nvme nvme1: I/O 414 QID 3 timeout, reset controller
[ 2806.363566] nvme nvme1: 15/0/0 default/read/poll queues
[ 2836.554298] nvme nvme1: I/O 415 QID 3 timeout, disable controller
[ 2836.672064] blk_update_request: I/O error, dev nvme1n1, sector 16350 op 0x9:(WRITE_ZEROES) flags 0x0 phys_seg 0 prio class 0
[ 2836.672072] blk_update_request: I/O error, dev nvme1n1, sector 16093 op 0x9:(WRITE_ZEROES) flags 0x0 phys_seg 0 prio class 0
[ 2836.672074] blk_update_request: I/O error, dev nvme1n1, sector 15836 op 0x9:(WRITE_ZEROES) flags 0x0 phys_seg 0 prio class 0
[ 2836.672076] blk_update_request: I/O error, dev nvme1n1, sector 15579 op 0x9:(WRITE_ZEROES) flags 0x0 phys_seg 0 prio class 0
[ 2836.672078] blk_update_request: I/O error, dev nvme1n1, sector 15322 op 0x9:(WRITE_ZEROES) flags 0x0 phys_seg 0 prio class 0
[ 2836.672080] blk_update_request: I/O error, dev nvme1n1, sector 15065 op 0x9:(WRITE_ZEROES) flags 0x0 phys_seg 0 prio class 0
[ 2836.672082] blk_update_request: I/O error, dev nvme1n1, sector 14808 op 0x9:(WRITE_ZEROES) flags 0x0 phys_seg 0 prio class 0
[ 2836.672083] blk_update_request: I/O error, dev nvme1n1, sector 14551 op 0x9:(WRITE_ZEROES) flags 0x0 phys_seg 0 prio class 0
[ 2836.672085] blk_update_request: I/O error, dev nvme1n1, sector 14294 op 0x9:(WRITE_ZEROES) flags 0x0 phys_seg 0 prio class 0
[ 2836.672087] blk_update_request: I/O error, dev nvme1n1, sector 14037 op 0x9:(WRITE_ZEROES) flags 0x0 phys_seg 0 prio class 0
[ 2836.672121] nvme nvme1: failed to mark controller live state
[ 2836.672123] nvme nvme1: Removing after probe failure status: -19
[ 2836.689016] Aborting journal on device dm-0-8.
[ 2836.689024] Buffer I/O error on dev dm-0, logical block 25198592, lost sync page write
[ 2836.689027] JBD2: Error -5 detected when updating journal superblock for dm-0-8.

Reported-by: Bradley Chapman <chapman6235@comcast.net>
Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Tested-by: Bradley Chapman <chapman6235@comcast.net>
Reviewed-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/pci.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 77f615568194d..a4b169408bbf0 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -3248,6 +3248,8 @@ static const struct pci_device_id nvme_id_table[] = {
 		.driver_data = NVME_QUIRK_DISABLE_WRITE_ZEROES, },
 	{ PCI_DEVICE(0x15b7, 0x2001),   /*  Sandisk Skyhawk */
 		.driver_data = NVME_QUIRK_DISABLE_WRITE_ZEROES, },
+	{ PCI_DEVICE(0x1d97, 0x2263),   /* SPCC */
+		.driver_data = NVME_QUIRK_DISABLE_WRITE_ZEROES, },
 	{ PCI_DEVICE(PCI_VENDOR_ID_APPLE, 0x2001),
 		.driver_data = NVME_QUIRK_SINGLE_VECTOR },
 	{ PCI_DEVICE(PCI_VENDOR_ID_APPLE, 0x2003) },
-- 
2.27.0


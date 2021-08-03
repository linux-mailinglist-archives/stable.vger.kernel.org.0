Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D0463DECBA
	for <lists+stable@lfdr.de>; Tue,  3 Aug 2021 13:44:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236175AbhHCLpD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Aug 2021 07:45:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:35422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235897AbhHCLom (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Aug 2021 07:44:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 20D5F61037;
        Tue,  3 Aug 2021 11:44:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627991071;
        bh=//W2AOkZKarKR/m0ISvGsAjaLCFLauuC4u1WBYKVT2Q=;
        h=From:To:Cc:Subject:Date:From;
        b=ZPGs5Gr+EWqYBgIY8lgmOLi5ZvthZgkRC19Ave2eeHw3HQBmOyjnfiqJfuJagABSC
         9yJNnZgbiA32An+U9eatUAZjjnj6aBqVddP47J1pcyziuzqVBlUhgK93ZjZr3kIa9j
         EsJeT1uYUnpMX/DYLabl0yI1Z+zoel73ITPCTU8vZEL0HUjW8rOoByc3EuhClaCQmh
         9uO5+Ovcpzt0x7niuVKXbVCPJDxtU6SOJ8NuQEueRSpv3R4b3RYdw2X0buva/Mlqer
         0SWrf5L4+NmrxDyDNBWjwpf67c7HyDZNyingwq9LEe1QQfPaIaa7q3Q9ojGigPjZ5v
         MwvHBSKreaQTQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christoph Hellwig <hch@lst.de>,
        kernel test robot <oliver.sang@intel.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        linux-ide@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 1/5] libata: fix ata_pio_sector for CONFIG_HIGHMEM
Date:   Tue,  3 Aug 2021 07:44:25 -0400
Message-Id: <20210803114429.2252944-1-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit ecef6a9effe49e8e2635c839020b9833b71e934c ]

Data transfers are not required to be block aligned in memory, so they
span two pages.  Fix this by splitting the call to >sff_data_xfer into
two for that case.

This has been broken since the initial libata import before the damn
of git, but was uncovered by the legacy ide driver removal.

Reported-by: kernel test robot <oliver.sang@intel.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20210709130237.3730959-1-hch@lst.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/libata-sff.c | 35 +++++++++++++++++++++++++++--------
 1 file changed, 27 insertions(+), 8 deletions(-)

diff --git a/drivers/ata/libata-sff.c b/drivers/ata/libata-sff.c
index 7484ffdabd54..ec62d26c32a9 100644
--- a/drivers/ata/libata-sff.c
+++ b/drivers/ata/libata-sff.c
@@ -657,6 +657,20 @@ unsigned int ata_sff_data_xfer32(struct ata_queued_cmd *qc, unsigned char *buf,
 }
 EXPORT_SYMBOL_GPL(ata_sff_data_xfer32);
 
+static void ata_pio_xfer(struct ata_queued_cmd *qc, struct page *page,
+		unsigned int offset, size_t xfer_size)
+{
+	bool do_write = (qc->tf.flags & ATA_TFLAG_WRITE);
+	unsigned char *buf;
+
+	buf = kmap_atomic(page);
+	qc->ap->ops->sff_data_xfer(qc, buf + offset, xfer_size, do_write);
+	kunmap_atomic(buf);
+
+	if (!do_write && !PageSlab(page))
+		flush_dcache_page(page);
+}
+
 /**
  *	ata_pio_sector - Transfer a sector of data.
  *	@qc: Command on going
@@ -668,11 +682,9 @@ EXPORT_SYMBOL_GPL(ata_sff_data_xfer32);
  */
 static void ata_pio_sector(struct ata_queued_cmd *qc)
 {
-	int do_write = (qc->tf.flags & ATA_TFLAG_WRITE);
 	struct ata_port *ap = qc->ap;
 	struct page *page;
 	unsigned int offset;
-	unsigned char *buf;
 
 	if (!qc->cursg) {
 		qc->curbytes = qc->nbytes;
@@ -690,13 +702,20 @@ static void ata_pio_sector(struct ata_queued_cmd *qc)
 
 	DPRINTK("data %s\n", qc->tf.flags & ATA_TFLAG_WRITE ? "write" : "read");
 
-	/* do the actual data transfer */
-	buf = kmap_atomic(page);
-	ap->ops->sff_data_xfer(qc, buf + offset, qc->sect_size, do_write);
-	kunmap_atomic(buf);
+	/*
+	 * Split the transfer when it splits a page boundary.  Note that the
+	 * split still has to be dword aligned like all ATA data transfers.
+	 */
+	WARN_ON_ONCE(offset % 4);
+	if (offset + qc->sect_size > PAGE_SIZE) {
+		unsigned int split_len = PAGE_SIZE - offset;
 
-	if (!do_write && !PageSlab(page))
-		flush_dcache_page(page);
+		ata_pio_xfer(qc, page, offset, split_len);
+		ata_pio_xfer(qc, nth_page(page, 1), 0,
+			     qc->sect_size - split_len);
+	} else {
+		ata_pio_xfer(qc, page, offset, qc->sect_size);
+	}
 
 	qc->curbytes += qc->sect_size;
 	qc->cursg_ofs += qc->sect_size;
-- 
2.30.2


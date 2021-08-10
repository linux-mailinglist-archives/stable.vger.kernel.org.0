Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E5BC3E7F4C
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 19:41:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232549AbhHJRjs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 13:39:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:39322 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234812AbhHJRiT (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 13:38:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 03112610F7;
        Tue, 10 Aug 2021 17:36:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628616984;
        bh=IKYl1kJ9aYIpehnEShOGCBcaZC8ze61LAC9wbfsXwpE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ORjqFIaNECEggu2dls5Cq2pvWkTyeIGxIuP4W/1OTt1RR9DpwwN+tZAB73p6Gj81e
         aSYNN95n4oxqGAzS5bp3Ie7TghU7bCTMzD71vjAGZoyyG3joM02PYc1D5cP7zD6hRw
         8s/5NwUBu0e2vHV6sNCffbIjs989HgiGE+yT1vw0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <oliver.sang@intel.com>,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 79/85] libata: fix ata_pio_sector for CONFIG_HIGHMEM
Date:   Tue, 10 Aug 2021 19:30:52 +0200
Message-Id: <20210810172950.900660490@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810172948.192298392@linuxfoundation.org>
References: <20210810172948.192298392@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 038db94216a9..454f9d7d42fe 100644
--- a/drivers/ata/libata-sff.c
+++ b/drivers/ata/libata-sff.c
@@ -641,6 +641,20 @@ unsigned int ata_sff_data_xfer32(struct ata_queued_cmd *qc, unsigned char *buf,
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
@@ -652,11 +666,9 @@ EXPORT_SYMBOL_GPL(ata_sff_data_xfer32);
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
@@ -674,13 +686,20 @@ static void ata_pio_sector(struct ata_queued_cmd *qc)
 
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




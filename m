Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D7203E8090
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 19:51:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234940AbhHJRux (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 13:50:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:39034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233153AbhHJRsf (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 13:48:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 225CB610CF;
        Tue, 10 Aug 2021 17:41:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628617283;
        bh=t9rE8d4VGqB4QhBhylvlR5bDJliOPOMKyodt9YHq0vg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d8KNPEtMRq5FblnyHYOTPbZcxpuG2bV397sg53riGNVhqGeUdbRv6OKmMW8sabpjm
         PNTRJ0Eta9w8sopZsl0xAJqQVCN04ZNJjWCmcwmqBg3i+RFUlWynKBiUSu51L2cGQo
         opta1HKHHQ75hvXhJe7OhDdCMAgCXc8BmgL0TzPg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <oliver.sang@intel.com>,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 126/135] libata: fix ata_pio_sector for CONFIG_HIGHMEM
Date:   Tue, 10 Aug 2021 19:31:00 +0200
Message-Id: <20210810173000.080835408@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810172955.660225700@linuxfoundation.org>
References: <20210810172955.660225700@linuxfoundation.org>
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
index ae7189d1a568..b71ea4a680b0 100644
--- a/drivers/ata/libata-sff.c
+++ b/drivers/ata/libata-sff.c
@@ -637,6 +637,20 @@ unsigned int ata_sff_data_xfer32(struct ata_queued_cmd *qc, unsigned char *buf,
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
@@ -648,11 +662,9 @@ EXPORT_SYMBOL_GPL(ata_sff_data_xfer32);
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
@@ -670,13 +682,20 @@ static void ata_pio_sector(struct ata_queued_cmd *qc)
 
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




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A16D261799
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 19:39:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731737AbgIHRhx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 13:37:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:56658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731698AbgIHQOi (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 12:14:38 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 65FBA24912;
        Tue,  8 Sep 2020 15:53:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599580428;
        bh=iGJobUoHn8yZVUhhAlEuqw83zoj5Q2su3p7kWCOT0N0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0+oIgtvxqvNnb3RAVZevnHQ/4yJe87qxumQo9gXG4C9sEa/ZwQ9j0MFGmCOXg08gC
         P/qeuTYWqU9ml+Lt4DRFX7TsFGZfjNKNowchHzU325rN71g7UuMvFCu2WEF3LpGhtk
         N7t03P4eUiA6bOXlkyaYBclv1a8YNhUdP3AoQm4k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Karthik Shivaram <karthikgs@fb.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4.14 54/65] libata: implement ATA_HORKAGE_MAX_TRIM_128M and apply to Sandisks
Date:   Tue,  8 Sep 2020 17:26:39 +0200
Message-Id: <20200908152219.872724744@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908152217.022816723@linuxfoundation.org>
References: <20200908152217.022816723@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tejun Heo <tj@kernel.org>

commit 3b5455636fe26ea21b4189d135a424a6da016418 upstream.

All three generations of Sandisk SSDs lock up hard intermittently.
Experiments showed that disabling NCQ lowered the failure rate significantly
and the kernel has been disabling NCQ for some models of SD7's and 8's,
which is obviously undesirable.

Karthik worked with Sandisk to root cause the hard lockups to trim commands
larger than 128M. This patch implements ATA_HORKAGE_MAX_TRIM_128M which
limits max trim size to 128M and applies it to all three generations of
Sandisk SSDs.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Karthik Shivaram <karthikgs@fb.com>
Cc: stable@vger.kernel.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/ata/libata-core.c |    5 ++---
 drivers/ata/libata-scsi.c |    8 +++++++-
 include/linux/libata.h    |    1 +
 3 files changed, 10 insertions(+), 4 deletions(-)

--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -4488,9 +4488,8 @@ static const struct ata_blacklist_entry
 	/* https://bugzilla.kernel.org/show_bug.cgi?id=15573 */
 	{ "C300-CTFDDAC128MAG",	"0001",		ATA_HORKAGE_NONCQ, },
 
-	/* Some Sandisk SSDs lock up hard with NCQ enabled.  Reported on
-	   SD7SN6S256G and SD8SN8U256G */
-	{ "SanDisk SD[78]SN*G",	NULL,		ATA_HORKAGE_NONCQ, },
+	/* Sandisk SD7/8/9s lock up hard on large trims */
+	{ "SanDisk SD[789]*",	NULL,		ATA_HORKAGE_MAX_TRIM_128M, },
 
 	/* devices which puke on READ_NATIVE_MAX */
 	{ "HDS724040KLSA80",	"KFAOA20N",	ATA_HORKAGE_BROKEN_HPA, },
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -2392,6 +2392,7 @@ static unsigned int ata_scsiop_inq_89(st
 
 static unsigned int ata_scsiop_inq_b0(struct ata_scsi_args *args, u8 *rbuf)
 {
+	struct ata_device *dev = args->dev;
 	u16 min_io_sectors;
 
 	rbuf[1] = 0xb0;
@@ -2417,7 +2418,12 @@ static unsigned int ata_scsiop_inq_b0(st
 	 * with the unmap bit set.
 	 */
 	if (ata_id_has_trim(args->id)) {
-		put_unaligned_be64(65535 * ATA_MAX_TRIM_RNUM, &rbuf[36]);
+		u64 max_blocks = 65535 * ATA_MAX_TRIM_RNUM;
+
+		if (dev->horkage & ATA_HORKAGE_MAX_TRIM_128M)
+			max_blocks = 128 << (20 - SECTOR_SHIFT);
+
+		put_unaligned_be64(max_blocks, &rbuf[36]);
 		put_unaligned_be32(1, &rbuf[28]);
 	}
 
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -440,6 +440,7 @@ enum {
 	ATA_HORKAGE_NO_DMA_LOG	= (1 << 23),	/* don't use DMA for log read */
 	ATA_HORKAGE_NOTRIM	= (1 << 24),	/* don't use TRIM */
 	ATA_HORKAGE_MAX_SEC_1024 = (1 << 25),	/* Limit max sects to 1024 */
+	ATA_HORKAGE_MAX_TRIM_128M = (1 << 26),	/* Limit max trim size to 128M */
 
 	 /* DMA mask for user DMA control: User visible values; DO NOT
 	    renumber */



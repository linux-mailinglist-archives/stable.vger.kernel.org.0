Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F7542618A8
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 19:59:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729860AbgIHR6y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 13:58:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:56076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731342AbgIHQMK (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 12:12:10 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 855C024786;
        Tue,  8 Sep 2020 15:51:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599580270;
        bh=OYOtgndWecoxZwngBj2b+iEf7X5sIueE3Anj06XmutE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VMfLFyUcNw5Zt0lhkDT6yBD0xi/ewm+LlpHUU3oGe3fThvHmqLXkZamd3oPkNbYFZ
         +CQJ2Bd2K4HxpZpsRsg9XdCg+4/CjZjm3E646z8QlyHvk3/w458NqR5eHmt0Kszj1i
         RKhQSLHT86o3DAjcs7at2lhxdgXcpYaMBptMtEk8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Karthik Shivaram <karthikgs@fb.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4.19 75/88] libata: implement ATA_HORKAGE_MAX_TRIM_128M and apply to Sandisks
Date:   Tue,  8 Sep 2020 17:26:16 +0200
Message-Id: <20200908152224.923995652@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908152221.082184905@linuxfoundation.org>
References: <20200908152221.082184905@linuxfoundation.org>
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
@@ -4492,9 +4492,8 @@ static const struct ata_blacklist_entry
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
@@ -2391,6 +2391,7 @@ static unsigned int ata_scsiop_inq_89(st
 
 static unsigned int ata_scsiop_inq_b0(struct ata_scsi_args *args, u8 *rbuf)
 {
+	struct ata_device *dev = args->dev;
 	u16 min_io_sectors;
 
 	rbuf[1] = 0xb0;
@@ -2416,7 +2417,12 @@ static unsigned int ata_scsiop_inq_b0(st
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
@@ -439,6 +439,7 @@ enum {
 	ATA_HORKAGE_NO_DMA_LOG	= (1 << 23),	/* don't use DMA for log read */
 	ATA_HORKAGE_NOTRIM	= (1 << 24),	/* don't use TRIM */
 	ATA_HORKAGE_MAX_SEC_1024 = (1 << 25),	/* Limit max sects to 1024 */
+	ATA_HORKAGE_MAX_TRIM_128M = (1 << 26),	/* Limit max trim size to 128M */
 
 	 /* DMA mask for user DMA control: User visible values; DO NOT
 	    renumber */



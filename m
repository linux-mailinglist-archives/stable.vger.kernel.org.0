Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EA04419BA2
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 19:19:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236801AbhI0RVA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 13:21:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:35962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237663AbhI0RTC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 13:19:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7629061288;
        Mon, 27 Sep 2021 17:12:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632762758;
        bh=rgGC/9Gq+574w1jl5yUnIwXFS6gj6iay2b1K2pqlZ3c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2bcy7+vkyWkw6K00Yj7CrKBkE2Arg0dRck/O7IkbhP1MAvFm4+x62+bC6F7CR95Bh
         V06UEWx0ATT3aAUwLlYYB8lMn9vIhDWxi2B8q+0akqtDpYS/BSejBJm5ePq8Js5IeL
         Fmshfq9Q6ZLKoJ96RNZjnY5HU6JV9LC3Fuhz5iEM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Naohiro Aota <naohiro.aota@wdc.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.14 040/162] scsi: sd_zbc: Ensure buffer size is aligned to SECTOR_SIZE
Date:   Mon, 27 Sep 2021 19:01:26 +0200
Message-Id: <20210927170234.885541432@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927170233.453060397@linuxfoundation.org>
References: <20210927170233.453060397@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Naohiro Aota <naohiro.aota@wdc.com>

commit 7215e909814fed7cda33c954943a4050d8348204 upstream.

Reporting zones on a SCSI device sometimes fail with the following error:

[76248.516390] ata16.00: invalid transfer count 131328
[76248.523618] sd 15:0:0:0: [sda] REPORT ZONES start lba 536870912 failed

The error (from drivers/ata/libata-scsi.c:ata_scsi_zbc_in_xlat()) indicates
that buffer size is not aligned to SECTOR_SIZE.

This happens when the __vmalloc() failed. Consider we are reporting 4096
zones, then we will have "bufsize = roundup((4096 + 1) * 64,
SECTOR_SIZE)" = (513 * 512) = 262656. Then, __vmalloc() failure halves
the bufsize to 131328, which is no longer aligned to SECTOR_SIZE.

Use rounddown() to ensure the size is always aligned to SECTOR_SIZE and fix
the comment as well.

Link: https://lore.kernel.org/r/20210906140642.2267569-1-naohiro.aota@wdc.com
Fixes: 23a50861adda ("scsi: sd_zbc: Cleanup sd_zbc_alloc_report_buffer()")
Cc: stable@vger.kernel.org # 5.5+
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/sd_zbc.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -154,8 +154,8 @@ static void *sd_zbc_alloc_report_buffer(
 
 	/*
 	 * Report zone buffer size should be at most 64B times the number of
-	 * zones requested plus the 64B reply header, but should be at least
-	 * SECTOR_SIZE for ATA devices.
+	 * zones requested plus the 64B reply header, but should be aligned
+	 * to SECTOR_SIZE for ATA devices.
 	 * Make sure that this size does not exceed the hardware capabilities.
 	 * Furthermore, since the report zone command cannot be split, make
 	 * sure that the allocated buffer can always be mapped by limiting the
@@ -174,7 +174,7 @@ static void *sd_zbc_alloc_report_buffer(
 			*buflen = bufsize;
 			return buf;
 		}
-		bufsize >>= 1;
+		bufsize = rounddown(bufsize >> 1, SECTOR_SIZE);
 	}
 
 	return NULL;



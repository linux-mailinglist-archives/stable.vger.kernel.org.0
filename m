Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C25A6808F
	for <lists+stable@lfdr.de>; Sun, 14 Jul 2019 19:55:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728218AbfGNRzH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Jul 2019 13:55:07 -0400
Received: from len.romanrm.net ([91.121.75.85]:37428 "EHLO len.romanrm.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726813AbfGNRzH (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 14 Jul 2019 13:55:07 -0400
X-Greylist: delayed 742 seconds by postgrey-1.27 at vger.kernel.org; Sun, 14 Jul 2019 13:55:06 EDT
Received: from natsu (unknown [IPv6:fd39::e99e:8f1b:cfc9:ccb8])
        by len.romanrm.net (Postfix) with SMTP id 0D4782025D;
        Sun, 14 Jul 2019 17:42:42 +0000 (UTC)
Date:   Sun, 14 Jul 2019 22:42:42 +0500
From:   Roman Mamedov <rm@romanrm.net>
To:     linux-ide@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, stable@vger.kernel.org
Subject: [PATCH] libata: Disable queued TRIM for Samsung 860 series SSDs
Message-ID: <20190714224242.4689a874@natsu>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

My Samsung 860 EVO mSATA 500GB SSD lockups for 20-30 seconds on fstrim, while
dmesg is repeatedly flooded with:

[  332.792044] ata14.00: exception Emask 0x0 SAct 0x3fffe SErr 0x0 action 0x6 frozen
[  332.798271] ata14.00: failed command: SEND FPDMA QUEUED
[  332.804499] ata14.00: cmd 64/01:08:00:00:00/00:00:00:00:00/a0 tag 1 ncq dma 512 out
                        res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
[  332.817145] ata14.00: status: { DRDY }

Disabling queued TRIM for it, as already done for the 850 series models,
solves the issue completely.

Cc: Jens Axboe <axboe@kernel.dk>
Cc: stable@vger.kernel.org
BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=203475
Signed-off-by: Roman Mamedov <rm@romanrm.net>
---
 drivers/ata/libata-core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index cbb162b683b6..1fe50b8fe00d 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -4566,6 +4566,8 @@ static const struct ata_blacklist_entry ata_device_blacklist [] = {
 						ATA_HORKAGE_ZERO_AFTER_TRIM, },
 	{ "Samsung SSD 850*",		NULL,	ATA_HORKAGE_NO_NCQ_TRIM |
 						ATA_HORKAGE_ZERO_AFTER_TRIM, },
+	{ "Samsung SSD 860*",		NULL,	ATA_HORKAGE_NO_NCQ_TRIM |
+						ATA_HORKAGE_ZERO_AFTER_TRIM, },
 	{ "FCCT*M500*",			NULL,	ATA_HORKAGE_NO_NCQ_TRIM |
 						ATA_HORKAGE_ZERO_AFTER_TRIM, },
 
-- 
2.11.0

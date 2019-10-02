Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76B95C9168
	for <lists+stable@lfdr.de>; Wed,  2 Oct 2019 21:11:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729325AbfJBTIQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Oct 2019 15:08:16 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:35780 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729301AbfJBTIQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Oct 2019 15:08:16 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iFjyu-00035y-8H; Wed, 02 Oct 2019 20:08:12 +0100
Received: from ben by deadeye with local (Exim 4.92.1)
        (envelope-from <ben@decadent.org.uk>)
        id 1iFjyq-0003gt-OJ; Wed, 02 Oct 2019 20:08:08 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Roman Bolshakov" <r.bolshakov@yadro.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "Bart Van Assche" <bvanassche@acm.org>
Date:   Wed, 02 Oct 2019 20:06:51 +0100
Message-ID: <lsq.1570043211.378304899@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 85/87] scsi: target/iblock: Fix overrun in WRITE SAME
 emulation
In-Reply-To: <lsq.1570043210.379046399@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.75-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Roman Bolshakov <r.bolshakov@yadro.com>

commit 5676234f20fef02f6ca9bd66c63a8860fce62645 upstream.

WRITE SAME corrupts data on the block device behind iblock if the command
is emulated. The emulation code issues (M - 1) * N times more bios than
requested, where M is the number of 512 blocks per real block size and N is
the NUMBER OF LOGICAL BLOCKS specified in WRITE SAME command. So, for a
device with 4k blocks, 7 * N more LBAs gets written after the requested
range.

The issue happens because the number of 512 byte sectors to be written is
decreased one by one while the real bios are typically from 1 to 8 512 byte
sectors per bio.

Fixes: c66ac9db8d4a ("[SCSI] target: Add LIO target core v4.0.0-rc6")
Signed-off-by: Roman Bolshakov <r.bolshakov@yadro.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
[bwh: Backported to 3.16: use IBLOCK_LBA_SHIFT instead of SECTOR_SHIFT]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/target/target_core_iblock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -490,7 +490,7 @@ iblock_execute_write_same(struct se_cmd
 
 		/* Always in 512 byte units for Linux/Block */
 		block_lba += sg->length >> IBLOCK_LBA_SHIFT;
-		sectors -= 1;
+		sectors -= sg->length >> IBLOCK_LBA_SHIFT;
 	}
 
 	iblock_submit_bios(&list, WRITE);


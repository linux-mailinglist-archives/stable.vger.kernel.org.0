Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2AEA2E15C0
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 03:58:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726960AbgLWCxD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 21:53:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:46404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729285AbgLWCVS (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:21:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B9E1B229CA;
        Wed, 23 Dec 2020 02:20:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608690060;
        bh=fRCDfTFtMa1rQGWD8TuTb2Kx5o6ANhOkvCmNWyhVMlw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SwwYvD3AJ3xrBqdaikDHkDfAYWulm3l54SlGR2PKRI7Pt0Kl3YU0sKlvRXECxSJyM
         YZuUa/a5JRqURi/1fULRSfM204YeBsQUal7UQ9Mhkj3yKqwlkjRJbS40S4RSap/Ep4
         wgC9vSrC/U6pRx/1wMrXk4LRsTZVANp6LgAfADuoSrereaPRI/yTq45mg0F/K6JkN4
         pkEYE6pj5zoY0stK1Ac4uwl7456UYgFIdLtpDCZB7FwB/sLSqFkkMdV9/4MgNVjKeG
         hcRb2dncZ3TAl4kkLq3M0bm8XWL3E0dTR9CwBRTfqrxe/XzIbMM+x7ZOSpsiWk9J5l
         45KrFM73zlRSQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 129/130] cdrom: Reset sector_size back it is not 2048.
Date:   Tue, 22 Dec 2020 21:18:12 -0500
Message-Id: <20201223021813.2791612-129-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223021813.2791612-1-sashal@kernel.org>
References: <20201223021813.2791612-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

[ Upstream commit b5f32555567cfe0a5d5dbe7c1e85ebe37b3f545a ]

In v2.4.0-test2pre2 mmc_ioctl_cdrom_read_data() was extended by issuing
a MODE_SELECT opcode to change the sector size and READ_10 to perform
the actual read if the READ_CD opcode is not support.
The sector size is never changed back to the previous value of 2048
bytes which is however denoted by the comment for version 3.09 of the
cdrom.c file.

Use cdrom_switch_blocksize() to change the sector size only if the
requested size deviates from 2048. Change it back to 2048 after the read
operation if a change was mode.

Link: https://lkml.kernel.org/r/20201204164803.ovwurzs3257em2rp@linutronix.de
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cdrom/cdrom.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/cdrom/cdrom.c b/drivers/cdrom/cdrom.c
index eebdcbef0578f..f2e82390ef70c 100644
--- a/drivers/cdrom/cdrom.c
+++ b/drivers/cdrom/cdrom.c
@@ -2996,13 +2996,15 @@ static noinline int mmc_ioctl_cdrom_read_data(struct cdrom_device_info *cdi,
 		 * SCSI-II devices are not required to support
 		 * READ_CD, so let's try switching block size
 		 */
-		/* FIXME: switch back again... */
-		ret = cdrom_switch_blocksize(cdi, blocksize);
-		if (ret)
-			goto out;
+		if (blocksize != CD_FRAMESIZE) {
+			ret = cdrom_switch_blocksize(cdi, blocksize);
+			if (ret)
+				goto out;
+		}
 		cgc->sshdr = NULL;
 		ret = cdrom_read_cd(cdi, cgc, lba, blocksize, 1);
-		ret |= cdrom_switch_blocksize(cdi, blocksize);
+		if (blocksize != CD_FRAMESIZE)
+			ret |= cdrom_switch_blocksize(cdi, CD_FRAMESIZE);
 	}
 	if (!ret && copy_to_user(arg, cgc->buffer, blocksize))
 		ret = -EFAULT;
-- 
2.27.0


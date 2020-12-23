Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FADC2E14B8
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 03:48:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729934AbgLWCmk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 21:42:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:49658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729932AbgLWCXL (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:23:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B636423331;
        Wed, 23 Dec 2020 02:22:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608690170;
        bh=WJ2YbcCzCbbMfZ8umvB9RNvslUnQNWgf7B6zOnaQml8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=femxJxMjaDJ6W0/KJcd1UfjKMUs5VNxYtF9UPSc+mUXcCeGVZV4cKa9WakSQqhyh+
         KAcpLk3X1336IAAPbMXNLyVDJ8Ax/0fIg+zlOX+EtcrrxqKAGfmGUcxAWjD6Pf4Z4X
         aln6LRtE752N7FMp67SxUGZhCUUgJD3p2HBDdMFuV15EveyuNMuEWUUy34G6FeBMc+
         q7iKmImQIltQoXmNG7EK0h45G77KCISL5xL1aiKE7IHoKmn1ekUA3BCGo9+1bc+gOW
         m3U5hOW+t/qj1g3J2//kVrWOP4uuSaytmlw5OmNB1lA+5ahXiRiVqhD/JW1j7vHrEx
         BvFNebyPsEE1g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 86/87] cdrom: Reset sector_size back it is not 2048.
Date:   Tue, 22 Dec 2020 21:21:02 -0500
Message-Id: <20201223022103.2792705-86-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223022103.2792705-1-sashal@kernel.org>
References: <20201223022103.2792705-1-sashal@kernel.org>
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
index d3947388a3ef3..f379fb00f1773 100644
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


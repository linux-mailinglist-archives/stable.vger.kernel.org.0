Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51D8E11B263
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:35:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733249AbfLKPfv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:35:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:45130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387831AbfLKPfu (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:35:50 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5D37C24656;
        Wed, 11 Dec 2019 15:35:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576078550;
        bh=/+6g7v4r3IpGywefIv8ZdFwib2PrWscyPGU9R1Zcsw8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O55GThCb8BrUm2PHe3V6Y5+gWlkvaYwICoo9/OmEgLhymN0KnaEsM+0e26KSTNTy8
         sfXtouxpCrs2J5g6gSq4j0DIV4P4OlqsM316b5vXaNRffWeRrB0pDje0k2ETzt8S/l
         oSDyWifvg9swnW/rRZxSZPVrJUQdS6Ha+59cSQZg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Diego=20Elio=20Petten=C3=B2?= <flameeyes@flameeyes.com>,
        linux-scsi@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.9 37/42] cdrom: respect device capabilities during opening action
Date:   Wed, 11 Dec 2019 10:35:05 -0500
Message-Id: <20191211153510.23861-37-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191211153510.23861-1-sashal@kernel.org>
References: <20191211153510.23861-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Diego Elio Pettenò <flameeyes@flameeyes.com>

[ Upstream commit 366ba7c71ef77c08d06b18ad61b26e2df7352338 ]

Reading the TOC only works if the device can play audio, otherwise
these commands fail (and possibly bring the device to an unhealthy
state.)

Similarly, cdrom_mmc3_profile() should only be called if the device
supports generic packet commands.

To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Diego Elio Pettenò <flameeyes@flameeyes.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cdrom/cdrom.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/cdrom/cdrom.c b/drivers/cdrom/cdrom.c
index a46f188f679e7..782dbab5ad56a 100644
--- a/drivers/cdrom/cdrom.c
+++ b/drivers/cdrom/cdrom.c
@@ -998,6 +998,12 @@ static void cdrom_count_tracks(struct cdrom_device_info *cdi, tracktype *tracks)
 	tracks->xa = 0;
 	tracks->error = 0;
 	cd_dbg(CD_COUNT_TRACKS, "entering cdrom_count_tracks\n");
+
+	if (!CDROM_CAN(CDC_PLAY_AUDIO)) {
+		tracks->error = CDS_NO_INFO;
+		return;
+	}
+
 	/* Grab the TOC header so we can see how many tracks there are */
 	ret = cdi->ops->audio_ioctl(cdi, CDROMREADTOCHDR, &header);
 	if (ret) {
@@ -1164,7 +1170,8 @@ int cdrom_open(struct cdrom_device_info *cdi, struct block_device *bdev,
 		ret = open_for_data(cdi);
 		if (ret)
 			goto err;
-		cdrom_mmc3_profile(cdi);
+		if (CDROM_CAN(CDC_GENERIC_PACKET))
+			cdrom_mmc3_profile(cdi);
 		if (mode & FMODE_WRITE) {
 			ret = -EROFS;
 			if (cdrom_open_write(cdi))
@@ -2873,6 +2880,9 @@ int cdrom_get_last_written(struct cdrom_device_info *cdi, long *last_written)
 	   it doesn't give enough information or fails. then we return
 	   the toc contents. */
 use_toc:
+	if (!CDROM_CAN(CDC_PLAY_AUDIO))
+		return -ENOSYS;
+
 	toc.cdte_format = CDROM_MSF;
 	toc.cdte_track = CDROM_LEADOUT;
 	if ((ret = cdi->ops->audio_ioctl(cdi, CDROMREADTOCENTRY, &toc)))
-- 
2.20.1


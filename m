Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7222212F015
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 23:51:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729464AbgABWZH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:25:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:49808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729448AbgABWZC (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:25:02 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 18BB020863;
        Thu,  2 Jan 2020 22:25:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578003901;
        bh=IzLlOBA3ceL7TCJih7TvB2sTBQGpZ9urE3afA7yjw3A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a5SWEdZfwkrmq+yTHIsfrTXn2aqlGw40i9UmQhCxfDh8TWIjyUgNA8QQZSe+kWMP8
         OB38tMSEiOaBtiseR7k/y0Bi6ABLeQl6Wci6U4oh4N+izX9HuvEECJhkoiM5DQ4qzN
         Ekst7NGZ2tJ90ptql/SS98WWPyi5++5Pz/Td6qNo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, linux-scsi@vger.kernel.org,
        =?UTF-8?q?Diego=20Elio=20Petten=C3=B2?= <flameeyes@flameeyes.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 46/91] cdrom: respect device capabilities during opening action
Date:   Thu,  2 Jan 2020 23:07:28 +0100
Message-Id: <20200102220436.154889895@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102220356.856162165@linuxfoundation.org>
References: <20200102220356.856162165@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 90dd8e7291da..1c90da4af94f 100644
--- a/drivers/cdrom/cdrom.c
+++ b/drivers/cdrom/cdrom.c
@@ -995,6 +995,12 @@ static void cdrom_count_tracks(struct cdrom_device_info *cdi, tracktype *tracks)
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
@@ -1161,7 +1167,8 @@ int cdrom_open(struct cdrom_device_info *cdi, struct block_device *bdev,
 		ret = open_for_data(cdi);
 		if (ret)
 			goto err;
-		cdrom_mmc3_profile(cdi);
+		if (CDROM_CAN(CDC_GENERIC_PACKET))
+			cdrom_mmc3_profile(cdi);
 		if (mode & FMODE_WRITE) {
 			ret = -EROFS;
 			if (cdrom_open_write(cdi))
@@ -2878,6 +2885,9 @@ int cdrom_get_last_written(struct cdrom_device_info *cdi, long *last_written)
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




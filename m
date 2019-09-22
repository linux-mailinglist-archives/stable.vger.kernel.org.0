Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 533FEBA6C4
	for <lists+stable@lfdr.de>; Sun, 22 Sep 2019 21:47:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393072AbfIVSwt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Sep 2019 14:52:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:52082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392961AbfIVSws (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 22 Sep 2019 14:52:48 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5138621BE5;
        Sun, 22 Sep 2019 18:52:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569178368;
        bh=/rangsZ0ELaQluOZKEg4V40zOt8+RCVaCUrHYUx7Wvw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aJc/vZjwAjZGT+OXVaDRabBY3+7uNkRzabe2LIXXu5iJBAB/gc5xZSPKqxFPJxMN1
         TNe0Squsbj2N9MKY5xjxY/oydpLZ9wnJhHUhhJNgRe20y+QPl+Mw97LnC2AMVrBIsy
         XKWW+th9fvTrRXDF5EvCP1LArHTDO5eVEH3LJARQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Eddie James <eajames@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 119/185] media: aspeed-video: address a protential usage of an unitialized var
Date:   Sun, 22 Sep 2019 14:48:17 -0400
Message-Id: <20190922184924.32534-119-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190922184924.32534-1-sashal@kernel.org>
References: <20190922184924.32534-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>

[ Upstream commit 31b8b0bd6e55c3ea5a08bb8141fa5d3c90600e3b ]

While this might not occur in practice, if the device is doing
the right thing, it would be teoretically be possible to have
both hsync_counter and vsync_counter negatives.

If this ever happen, ctrl will be undefined, but the driver
will still call:

	aspeed_video_update(video, VE_CTRL, 0, ctrl);

Change the code to prevent this to happen.

This was warned by cppcheck:

	[drivers/media/platform/aspeed-video.c:653]: (error) Uninitialized variable: ctrl

Reviewed-by: Eddie James <eajames@linux.ibm.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/aspeed-video.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/aspeed-video.c b/drivers/media/platform/aspeed-video.c
index de0f192afa8b1..388c32a11345d 100644
--- a/drivers/media/platform/aspeed-video.c
+++ b/drivers/media/platform/aspeed-video.c
@@ -632,7 +632,7 @@ static void aspeed_video_check_and_set_polarity(struct aspeed_video *video)
 	}
 
 	if (hsync_counter < 0 || vsync_counter < 0) {
-		u32 ctrl;
+		u32 ctrl = 0;
 
 		if (hsync_counter < 0) {
 			ctrl = VE_CTRL_HSYNC_POL;
@@ -652,7 +652,8 @@ static void aspeed_video_check_and_set_polarity(struct aspeed_video *video)
 				V4L2_DV_VSYNC_POS_POL;
 		}
 
-		aspeed_video_update(video, VE_CTRL, 0, ctrl);
+		if (ctrl)
+			aspeed_video_update(video, VE_CTRL, 0, ctrl);
 	}
 }
 
-- 
2.20.1


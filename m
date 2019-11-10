Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD2E4F63AC
	for <lists+stable@lfdr.de>; Sun, 10 Nov 2019 03:54:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727942AbfKJCuu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Nov 2019 21:50:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:34802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729802AbfKJCus (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 9 Nov 2019 21:50:48 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D5D5D22790;
        Sun, 10 Nov 2019 02:50:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573354248;
        bh=lUApIQgyqmtoaBWAhlKzMgO5iOXa89CIZ9PudXst4ZY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r53JiNpynCCiuZB/gTAMOaU7n84gAa+3BC9P6WWm5+ZKClZYDK0MxRvrwLSn58kk5
         Hg8pXMeY3AsIv1CJI5AQwwzFzTiWtyweYY7767r/RrhfBLUpGjzYU9YZz107J40b2I
         E3R/Sz23uB2kjSxJNw/nmfgET2WoAL79Gc5PFw20=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andreas Kemnade <andreas@kemnade.info>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.4 08/40] power: supply: twl4030_charger: fix charging current out-of-bounds
Date:   Sat,  9 Nov 2019 21:50:00 -0500
Message-Id: <20191110025032.827-8-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191110025032.827-1-sashal@kernel.org>
References: <20191110025032.827-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andreas Kemnade <andreas@kemnade.info>

[ Upstream commit 8314c212f995bc0d06b54ad02ef0ab4089781540 ]

the charging current uses unsigned int variables, if we step back
if the current is still low, we would run into negative which
means setting the target to a huge value.
Better add checks here.

Signed-off-by: Andreas Kemnade <andreas@kemnade.info>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/twl4030_charger.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/power/twl4030_charger.c b/drivers/power/twl4030_charger.c
index bcd4dc304f270..14fed11e8f6e3 100644
--- a/drivers/power/twl4030_charger.c
+++ b/drivers/power/twl4030_charger.c
@@ -449,7 +449,8 @@ static void twl4030_current_worker(struct work_struct *data)
 
 	if (v < USB_MIN_VOLT) {
 		/* Back up and stop adjusting. */
-		bci->usb_cur -= USB_CUR_STEP;
+		if (bci->usb_cur >= USB_CUR_STEP)
+			bci->usb_cur -= USB_CUR_STEP;
 		bci->usb_cur_target = bci->usb_cur;
 	} else if (bci->usb_cur >= bci->usb_cur_target ||
 		   bci->usb_cur + USB_CUR_STEP > USB_MAX_CURRENT) {
-- 
2.20.1


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 437F61F3190
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 03:11:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726897AbgFIBKX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 21:10:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:49134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726912AbgFHXGQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:06:16 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1D21220774;
        Mon,  8 Jun 2020 23:06:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591657575;
        bh=MvkpziLz+OYcARuVbeGtxopmI4GZl9PufbVqxqdF9n4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LiRg6alm6r3eVfOHOW5WvzaOMAqLQOku9gT94QkQ99Nxx68EDi05y5Dx6T9xzmZcH
         8F8wdKCnuhEp5TJY2N7JOjIHt2Z+j/kCOtubOz7Z0gwAFOO9nt1lCig8bXqZUvo4A+
         058BpS+guDhxHS8Ir3k1Uoqm6v7jR/0aCNGYZVog=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bogdan Togorean <bogdan.togorean@analog.com>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.7 006/274] drm: bridge: adv7511: Extend list of audio sample rates
Date:   Mon,  8 Jun 2020 19:01:39 -0400
Message-Id: <20200608230607.3361041-6-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608230607.3361041-1-sashal@kernel.org>
References: <20200608230607.3361041-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bogdan Togorean <bogdan.togorean@analog.com>

[ Upstream commit b97b6a1f6e14a25d1e1ca2a46c5fa3e2ca374e22 ]

ADV7511 support sample rates up to 192kHz. CTS and N parameters should
be computed accordingly so this commit extend the list up to maximum
supported sample rate.

Signed-off-by: Bogdan Togorean <bogdan.togorean@analog.com>
Reviewed-by: Andrzej Hajda <a.hajda@samsung.com>
Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20200413113513.86091-2-bogdan.togorean@analog.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/adv7511/adv7511_audio.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/bridge/adv7511/adv7511_audio.c b/drivers/gpu/drm/bridge/adv7511/adv7511_audio.c
index a428185be2c1..d05b3033b510 100644
--- a/drivers/gpu/drm/bridge/adv7511/adv7511_audio.c
+++ b/drivers/gpu/drm/bridge/adv7511/adv7511_audio.c
@@ -19,13 +19,15 @@ static void adv7511_calc_cts_n(unsigned int f_tmds, unsigned int fs,
 {
 	switch (fs) {
 	case 32000:
-		*n = 4096;
+	case 48000:
+	case 96000:
+	case 192000:
+		*n = fs * 128 / 1000;
 		break;
 	case 44100:
-		*n = 6272;
-		break;
-	case 48000:
-		*n = 6144;
+	case 88200:
+	case 176400:
+		*n = fs * 128 / 900;
 		break;
 	}
 
-- 
2.25.1


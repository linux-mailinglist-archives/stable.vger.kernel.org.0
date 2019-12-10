Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3A94119320
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 22:08:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726883AbfLJVGt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 16:06:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:49080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726877AbfLJVEP (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 16:04:15 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 48C20214D8;
        Tue, 10 Dec 2019 21:04:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576011855;
        bh=Q8Q7aNebccwD6/X1QwWVe44pv8AWPGwmTkkkV/bDDBI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eT+4zNgWmPO4baFXnuqgUBG0Ybfi+7B6RFfl5hxs9knxOqFx6DGnrcny3FbtGugad
         TJwkSpPZtS6QTFCkrNTyy8QWpwzgnGb74dcU3dBPiP0kajpjAnsLTF/ahtHpj1RsAi
         UfkdEgvSLedMaufT2I86Gt865gseaiRU6G9sqED8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Brian Masney <masneyb@onstation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.4 009/350] drm/bridge: analogix-anx78xx: silence -EPROBE_DEFER warnings
Date:   Tue, 10 Dec 2019 15:58:21 -0500
Message-Id: <20191210210402.8367-9-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210210402.8367-1-sashal@kernel.org>
References: <20191210210402.8367-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Brian Masney <masneyb@onstation.org>

[ Upstream commit 2708e876272d89bbbff811d12834adbeef85f022 ]

Silence two warning messages that occur due to -EPROBE_DEFER errors to
help cleanup the system boot log.

Signed-off-by: Brian Masney <masneyb@onstation.org>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20190815004854.19860-4-masneyb@onstation.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/analogix-anx78xx.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/bridge/analogix-anx78xx.c b/drivers/gpu/drm/bridge/analogix-anx78xx.c
index 3c7cc5af735ce..56df07cdab68f 100644
--- a/drivers/gpu/drm/bridge/analogix-anx78xx.c
+++ b/drivers/gpu/drm/bridge/analogix-anx78xx.c
@@ -715,7 +715,9 @@ static int anx78xx_init_pdata(struct anx78xx *anx78xx)
 	/* 1.0V digital core power regulator  */
 	pdata->dvdd10 = devm_regulator_get(dev, "dvdd10");
 	if (IS_ERR(pdata->dvdd10)) {
-		DRM_ERROR("DVDD10 regulator not found\n");
+		if (PTR_ERR(pdata->dvdd10) != -EPROBE_DEFER)
+			DRM_ERROR("DVDD10 regulator not found\n");
+
 		return PTR_ERR(pdata->dvdd10);
 	}
 
@@ -1332,7 +1334,9 @@ static int anx78xx_i2c_probe(struct i2c_client *client,
 
 	err = anx78xx_init_pdata(anx78xx);
 	if (err) {
-		DRM_ERROR("Failed to initialize pdata: %d\n", err);
+		if (err != -EPROBE_DEFER)
+			DRM_ERROR("Failed to initialize pdata: %d\n", err);
+
 		return err;
 	}
 
-- 
2.20.1


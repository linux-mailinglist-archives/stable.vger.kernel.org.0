Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A46012C3A3
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 18:21:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727074AbfL2RVv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:21:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:37404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727056AbfL2RVs (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:21:48 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8EF66208E4;
        Sun, 29 Dec 2019 17:21:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577640108;
        bh=+2OIqPYWEhzwDaRzZw5OrWASZkpO39ITGj4mIkshvJg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eq91J3o1toy3WqJbSBDXU7cABmYTqBRL7N8s6j9L57MKoGBI4IMIPPc1TqURk6g0J
         0lob7yLeAlYzZJjQ56LY0tvGykZppLf9JUZaOzdeDPySVUVa+Szt7pFiEiTqgz3SWL
         Dyg75m2GAgVAIyMpxmHDYbs/C8bHzpKnN/QvfiKs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Brian Masney <masneyb@onstation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 021/161] drm/bridge: analogix-anx78xx: silence -EPROBE_DEFER warnings
Date:   Sun, 29 Dec 2019 18:17:49 +0100
Message-Id: <20191229162403.729799439@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229162355.500086350@linuxfoundation.org>
References: <20191229162355.500086350@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 9385eb0b1ee4..cd2bfd7bf048 100644
--- a/drivers/gpu/drm/bridge/analogix-anx78xx.c
+++ b/drivers/gpu/drm/bridge/analogix-anx78xx.c
@@ -725,7 +725,9 @@ static int anx78xx_init_pdata(struct anx78xx *anx78xx)
 	/* 1.0V digital core power regulator  */
 	pdata->dvdd10 = devm_regulator_get(dev, "dvdd10");
 	if (IS_ERR(pdata->dvdd10)) {
-		DRM_ERROR("DVDD10 regulator not found\n");
+		if (PTR_ERR(pdata->dvdd10) != -EPROBE_DEFER)
+			DRM_ERROR("DVDD10 regulator not found\n");
+
 		return PTR_ERR(pdata->dvdd10);
 	}
 
@@ -1344,7 +1346,9 @@ static int anx78xx_i2c_probe(struct i2c_client *client,
 
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




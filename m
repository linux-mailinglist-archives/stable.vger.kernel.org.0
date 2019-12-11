Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26AF511B769
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 17:07:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731233AbfLKQHh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 11:07:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:34034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730779AbfLKPM0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:12:26 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D16472173E;
        Wed, 11 Dec 2019 15:12:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077145;
        bh=augGkbXHJw6P2iLfo2wzGVeVGt69JYF7/I1eVjsO2S0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=maAnRy/f9Z/h47H+PvCAjReHyVQNPyjk+d5JUnKvRkCYxeF2YZ1tHmcgnPwKi0nOK
         5EuFpwTxkNdoCD2DuPk2xguZAfvFoZ5vBoQ6QBU8ELw01NY3v6qixPC9QB9uuIsdIY
         ELJJhQ3Ucgq5cI+osN8kPCui7wflTILAOVxO3LkI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Guido=20G=C3=BCnther?= <agx@sigxcpu.org>,
        Pavel Machek <pavel@ucw.cz>, Dan Murphy <dmurphy@ti.com>,
        Sasha Levin <sashal@kernel.org>, linux-leds@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 032/134] leds: lm3692x: Handle failure to probe the regulator
Date:   Wed, 11 Dec 2019 10:10:08 -0500
Message-Id: <20191211151150.19073-32-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191211151150.19073-1-sashal@kernel.org>
References: <20191211151150.19073-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guido Günther <agx@sigxcpu.org>

[ Upstream commit 396128d2ffcba6e1954cfdc9a89293ff79cbfd7c ]

Instead use devm_regulator_get_optional since the regulator
is optional and check for errors.

Signed-off-by: Guido Günther <agx@sigxcpu.org>
Acked-by: Pavel Machek <pavel@ucw.cz>
Reviewed-by: Dan Murphy <dmurphy@ti.com>
Signed-off-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/leds/leds-lm3692x.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/leds/leds-lm3692x.c b/drivers/leds/leds-lm3692x.c
index 3d381f2f73d04..1ac9a44570eed 100644
--- a/drivers/leds/leds-lm3692x.c
+++ b/drivers/leds/leds-lm3692x.c
@@ -334,9 +334,18 @@ static int lm3692x_probe_dt(struct lm3692x_led *led)
 		return ret;
 	}
 
-	led->regulator = devm_regulator_get(&led->client->dev, "vled");
-	if (IS_ERR(led->regulator))
+	led->regulator = devm_regulator_get_optional(&led->client->dev, "vled");
+	if (IS_ERR(led->regulator)) {
+		ret = PTR_ERR(led->regulator);
+		if (ret != -ENODEV) {
+			if (ret != -EPROBE_DEFER)
+				dev_err(&led->client->dev,
+					"Failed to get vled regulator: %d\n",
+					ret);
+			return ret;
+		}
 		led->regulator = NULL;
+	}
 
 	child = device_get_next_child_node(&led->client->dev, child);
 	if (!child) {
-- 
2.20.1


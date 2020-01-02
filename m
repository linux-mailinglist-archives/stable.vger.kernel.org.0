Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 273C812EBE3
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 23:13:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727649AbgABWNP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:13:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:52862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727632AbgABWNO (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:13:14 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B64F921835;
        Thu,  2 Jan 2020 22:13:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578003194;
        bh=bWieScTR+nkzZ01MDW5D8dk3AkB7khdSa4/5ypypEc8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2AWkWagYhhpk8FRPTIdIBYb+HVZTP4E2iOmnjbDw6YyKg6Yn24Qg8RVF0p5w3tkB7
         x0MduW1yNNSIKofHM3aUvIdoiUaf5/z8ax6AKxEAV2j9XCtfXv04mj+1De2mwobPyG
         I6jc1ygchPgz9W+pl8V0FdqYjB7uYS27zwZW2DmA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Guido=20G=C3=BCnther?= <agx@sigxcpu.org>,
        Pavel Machek <pavel@ucw.cz>, Dan Murphy <dmurphy@ti.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 033/191] leds: lm3692x: Handle failure to probe the regulator
Date:   Thu,  2 Jan 2020 23:05:15 +0100
Message-Id: <20200102215833.543600929@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102215829.911231638@linuxfoundation.org>
References: <20200102215829.911231638@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 3d381f2f73d0..1ac9a44570ee 100644
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




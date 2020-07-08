Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 239BA218BF5
	for <lists+stable@lfdr.de>; Wed,  8 Jul 2020 17:44:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730329AbgGHPni (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jul 2020 11:43:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:48696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730317AbgGHPlp (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 8 Jul 2020 11:41:45 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 21A7A207D0;
        Wed,  8 Jul 2020 15:41:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594222904;
        bh=dS8/G+hfAJds4aB+AZ58jEHtC4unT+hW+QxSxGfpACM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KgB8+wGzPOilTekboLA/+rDPufT0G5C2/PhJ7YCPZDxem3D86NevHfczXH/Zgu3ow
         dxIcIa1CIAHJaGUlpfjyigBbz/Sog77dJoLmMkKBQwVBNtOo9PVX3yprDU5YI7JD1v
         AG/qIZ4b9k/evjw0Z6NgRIbxDH73aVnrarm70Hl4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Anson Huang <Anson.Huang@nxp.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-pm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 07/16] thermal/drivers: imx: Fix missing of_node_put() at probe time
Date:   Wed,  8 Jul 2020 11:41:26 -0400
Message-Id: <20200708154135.3199907-7-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200708154135.3199907-1-sashal@kernel.org>
References: <20200708154135.3199907-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anson Huang <Anson.Huang@nxp.com>

[ Upstream commit b45fd13be340e4ed0a2a9673ba299eb2a71ba829 ]

After finishing using cpu node got from of_get_cpu_node(), of_node_put()
needs to be called.

Signed-off-by: Anson Huang <Anson.Huang@nxp.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Link: https://lore.kernel.org/r/1585232945-23368-1-git-send-email-Anson.Huang@nxp.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/imx_thermal.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/thermal/imx_thermal.c b/drivers/thermal/imx_thermal.c
index bb6754a5342c1..85511c1160b7f 100644
--- a/drivers/thermal/imx_thermal.c
+++ b/drivers/thermal/imx_thermal.c
@@ -656,7 +656,7 @@ MODULE_DEVICE_TABLE(of, of_imx_thermal_match);
 static int imx_thermal_register_legacy_cooling(struct imx_thermal_data *data)
 {
 	struct device_node *np;
-	int ret;
+	int ret = 0;
 
 	data->policy = cpufreq_cpu_get(0);
 	if (!data->policy) {
@@ -671,11 +671,12 @@ static int imx_thermal_register_legacy_cooling(struct imx_thermal_data *data)
 		if (IS_ERR(data->cdev)) {
 			ret = PTR_ERR(data->cdev);
 			cpufreq_cpu_put(data->policy);
-			return ret;
 		}
 	}
 
-	return 0;
+	of_node_put(np);
+
+	return ret;
 }
 
 static void imx_thermal_unregister_legacy_cooling(struct imx_thermal_data *data)
-- 
2.25.1


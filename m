Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E161B2268DC
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:24:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387887AbgGTQWL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:22:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:43788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731920AbgGTQHF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 12:07:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B0A1D2064B;
        Mon, 20 Jul 2020 16:07:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595261225;
        bh=jXwzaznj6HnmZcyrThYwe2ObKGTHQE4RcAMYcZSIg7w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v/JhooIa32d0PHO4uALZbJ1RoDXjXdRpScJpYmzY2JJfgUP98M065dubQ50+JsEeL
         cqhvJlNZfNpz+vpcWhZCCdyONUPdX2DfPo4RL0vHlMME9pK/G2ZVpEJ6dLD3pr3NNF
         fX19sy5Jo7gGKPgS+vuLsOisgIhM+aiYGMG2etZ0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anson Huang <Anson.Huang@nxp.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 037/244] thermal/drivers: imx: Fix missing of_node_put() at probe time
Date:   Mon, 20 Jul 2020 17:35:08 +0200
Message-Id: <20200720152827.623724274@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152825.863040590@linuxfoundation.org>
References: <20200720152825.863040590@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index e761c9b422179..1b84ea674edb7 100644
--- a/drivers/thermal/imx_thermal.c
+++ b/drivers/thermal/imx_thermal.c
@@ -649,7 +649,7 @@ MODULE_DEVICE_TABLE(of, of_imx_thermal_match);
 static int imx_thermal_register_legacy_cooling(struct imx_thermal_data *data)
 {
 	struct device_node *np;
-	int ret;
+	int ret = 0;
 
 	data->policy = cpufreq_cpu_get(0);
 	if (!data->policy) {
@@ -664,11 +664,12 @@ static int imx_thermal_register_legacy_cooling(struct imx_thermal_data *data)
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




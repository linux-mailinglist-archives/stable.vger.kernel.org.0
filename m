Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 071192269E8
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:31:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730113AbgGTQad (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:30:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:58582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732000AbgGTP6X (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 11:58:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 51AFE206E9;
        Mon, 20 Jul 2020 15:58:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595260702;
        bh=dS8/G+hfAJds4aB+AZ58jEHtC4unT+hW+QxSxGfpACM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kMEgGtqtvvTaBBmmhA67wOHWm+l9DQD+jC8U7bhKLMFIwWms2QMBnDNL75KQAlNUZ
         azm8il6X+ivfJqQAaXK0hjMMDCFFalc7cXLFnVvZtjPrukwakF3mxQsbXC6m5G5vNa
         I7/6unMknX/8wL8fOB9YYKH15CyI7zAXgO5Rr8GE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anson Huang <Anson.Huang@nxp.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 035/215] thermal/drivers: imx: Fix missing of_node_put() at probe time
Date:   Mon, 20 Jul 2020 17:35:17 +0200
Message-Id: <20200720152821.853538696@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152820.122442056@linuxfoundation.org>
References: <20200720152820.122442056@linuxfoundation.org>
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




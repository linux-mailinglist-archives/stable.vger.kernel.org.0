Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B67A29C141
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:24:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1818806AbgJ0RXr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 13:23:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:54970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752393AbgJ0Oyb (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:54:31 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B20BA22264;
        Tue, 27 Oct 2020 14:54:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603810471;
        bh=o426H1i3aVi6hnEFyHxSPISptOGmk3ZczSr4QHZcDSo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ozi78eCRHTS7cFbdmGUC0saD73YWCeRnh0UdeA2xjx6za6EGeRqBmG4YdcYKHI+QX
         v6lcuQ7CswSDglPas5AeDgU0NgSKNP+dlvsX/mgkHxNXaAa+gzI34A2wt50uGJDs5B
         LwLtxCDhTKqzPDEastbWLEangdUNTm3ir2qNUsmk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Serge Semin <Sergey.Semin@baikalelectronics.ru>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 151/633] hwmon: (bt1-pvt) Wait for the completion with timeout
Date:   Tue, 27 Oct 2020 14:48:14 +0100
Message-Id: <20201027135529.779803046@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Serge Semin <Sergey.Semin@baikalelectronics.ru>

[ Upstream commit 0ffd21d5985506d164ada9e8fff6daae8ef469a1 ]

If the PVT sensor is suddenly powered down while a caller is waiting for
the conversion completion, the request won't be finished and the task will
hang up on this procedure until the power is back up again. Let's call the
wait_for_completion_timeout() method instead to prevent that. The cached
timeout is exactly what we need to predict for how long conversion could
normally last.

Fixes: 87976ce2825d ("hwmon: Add Baikal-T1 PVT sensor driver")
Signed-off-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>
Link: https://lore.kernel.org/r/20200920110924.19741-4-Sergey.Semin@baikalelectronics.ru
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/bt1-pvt.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/hwmon/bt1-pvt.c b/drivers/hwmon/bt1-pvt.c
index 2600426a3b21c..3e1d56585b91a 100644
--- a/drivers/hwmon/bt1-pvt.c
+++ b/drivers/hwmon/bt1-pvt.c
@@ -477,6 +477,7 @@ static int pvt_read_data(struct pvt_hwmon *pvt, enum pvt_sensor_type type,
 			 long *val)
 {
 	struct pvt_cache *cache = &pvt->cache[type];
+	unsigned long timeout;
 	u32 data;
 	int ret;
 
@@ -500,7 +501,14 @@ static int pvt_read_data(struct pvt_hwmon *pvt, enum pvt_sensor_type type,
 	pvt_update(pvt->regs + PVT_INTR_MASK, PVT_INTR_DVALID, 0);
 	pvt_update(pvt->regs + PVT_CTRL, PVT_CTRL_EN, PVT_CTRL_EN);
 
-	wait_for_completion(&cache->conversion);
+	/*
+	 * Wait with timeout since in case if the sensor is suddenly powered
+	 * down the request won't be completed and the caller will hang up on
+	 * this procedure until the power is back up again. Multiply the
+	 * timeout by the factor of two to prevent a false timeout.
+	 */
+	timeout = 2 * usecs_to_jiffies(ktime_to_us(pvt->timeout));
+	ret = wait_for_completion_timeout(&cache->conversion, timeout);
 
 	pvt_update(pvt->regs + PVT_CTRL, PVT_CTRL_EN, 0);
 	pvt_update(pvt->regs + PVT_INTR_MASK, PVT_INTR_DVALID,
@@ -510,6 +518,9 @@ static int pvt_read_data(struct pvt_hwmon *pvt, enum pvt_sensor_type type,
 
 	mutex_unlock(&pvt->iface_mtx);
 
+	if (!ret)
+		return -ETIMEDOUT;
+
 	if (type == PVT_TEMP)
 		*val = pvt_calc_poly(&poly_N_to_temp, data);
 	else
-- 
2.25.1




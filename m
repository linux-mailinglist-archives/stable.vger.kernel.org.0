Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28017111C3C
	for <lists+stable@lfdr.de>; Tue,  3 Dec 2019 23:42:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728619AbfLCWmB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:42:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:56736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728183AbfLCWmA (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:42:00 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 87518206EC;
        Tue,  3 Dec 2019 22:41:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575412920;
        bh=WjHu08LmqT2OPELbjZFEqCtn8ZeJPW9t8uOuPbCMxrI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oGUmr7vpoonoKvShqVUIc2FzXHOAsEYNyBIDZbm+ApnZQciBcSyr0nEAXn1f3sy4C
         pZ7SF+M1ACA2fQjAZ+kBpMpJoUIV8hV6ttPjm5uzpU3Mydh8Rk3BuN/clnFgYsiqZC
         Wb2SuQvyVAgOYJdy+21A3gjsgivBpGbyv/V0LPgs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anson Huang <Anson.Huang@nxp.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 067/135] watchdog: imx_sc_wdt: Pretimeout should follow SCU firmware format
Date:   Tue,  3 Dec 2019 23:35:07 +0100
Message-Id: <20191203213025.741546037@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203213005.828543156@linuxfoundation.org>
References: <20191203213005.828543156@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anson Huang <Anson.Huang@nxp.com>

[ Upstream commit 2c50a6b825b3463a7600d6e6acadba73211c3d2c ]

SCU firmware calculates pretimeout based on current time stamp
instead of watchdog timeout stamp, need to convert the pretimeout
to SCU firmware's timeout value.

Fixes: 15f7d7fc5542 ("watchdog: imx_sc: Add pretimeout support")
Signed-off-by: Anson Huang <Anson.Huang@nxp.com>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Wim Van Sebroeck <wim@linux-watchdog.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/watchdog/imx_sc_wdt.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/watchdog/imx_sc_wdt.c b/drivers/watchdog/imx_sc_wdt.c
index 78eaaf75a263f..9545d1e07421a 100644
--- a/drivers/watchdog/imx_sc_wdt.c
+++ b/drivers/watchdog/imx_sc_wdt.c
@@ -99,8 +99,14 @@ static int imx_sc_wdt_set_pretimeout(struct watchdog_device *wdog,
 {
 	struct arm_smccc_res res;
 
+	/*
+	 * SCU firmware calculates pretimeout based on current time
+	 * stamp instead of watchdog timeout stamp, need to convert
+	 * the pretimeout to SCU firmware's timeout value.
+	 */
 	arm_smccc_smc(IMX_SIP_TIMER, IMX_SIP_TIMER_SET_PRETIME_WDOG,
-		      pretimeout * 1000, 0, 0, 0, 0, 0, &res);
+		      (wdog->timeout - pretimeout) * 1000, 0, 0, 0,
+		      0, 0, &res);
 	if (res.a0)
 		return -EACCES;
 
-- 
2.20.1




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 864EA2F110
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:09:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726125AbfE3EJp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 00:09:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:45256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730112AbfE3DRJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:17:09 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4767324667;
        Thu, 30 May 2019 03:17:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186229;
        bh=Yr1NWBa2ygGEK+iU7YFpXLjJuhvl7ZvsAVvfPbvqE5A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dr8uvFunzE59QWXJHthjh6W9cy50Dtqxt47jE/AMt8HQYbwrguRo5m8Tct1AbRdEh
         E0PnLjgUP+Scr6tqcHiqMBWvB/o/vGXlWZTazgo/1U2NmaiTjRlr1Szbg11Z3W2vjg
         FQ0GC+oo+J3hxz4Uj1OpaVB8+x8KZ9tQb3kJeZqE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fabien Dessenne <fabien.dessenne@st.com>,
        Amelie Delaunay <amelie.delaunay@st.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 085/276] rtc: stm32: manage the get_irq probe defer case
Date:   Wed, 29 May 2019 20:04:03 -0700
Message-Id: <20190530030531.603323909@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030523.133519668@linuxfoundation.org>
References: <20190530030523.133519668@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit cf612c5949aca2bd81a1e28688957c8149ea2693 ]

Manage the -EPROBE_DEFER error case for the wake IRQ.

Signed-off-by: Fabien Dessenne <fabien.dessenne@st.com>
Acked-by: Amelie Delaunay <amelie.delaunay@st.com>
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-stm32.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/rtc/rtc-stm32.c b/drivers/rtc/rtc-stm32.c
index c5908cfea2340..8e6c9b3bcc29a 100644
--- a/drivers/rtc/rtc-stm32.c
+++ b/drivers/rtc/rtc-stm32.c
@@ -788,11 +788,14 @@ static int stm32_rtc_probe(struct platform_device *pdev)
 	ret = device_init_wakeup(&pdev->dev, true);
 	if (rtc->data->has_wakeirq) {
 		rtc->wakeirq_alarm = platform_get_irq(pdev, 1);
-		if (rtc->wakeirq_alarm <= 0)
-			ret = rtc->wakeirq_alarm;
-		else
+		if (rtc->wakeirq_alarm > 0) {
 			ret = dev_pm_set_dedicated_wake_irq(&pdev->dev,
 							    rtc->wakeirq_alarm);
+		} else {
+			ret = rtc->wakeirq_alarm;
+			if (rtc->wakeirq_alarm == -EPROBE_DEFER)
+				goto err;
+		}
 	}
 	if (ret)
 		dev_warn(&pdev->dev, "alarm can't wake up the system: %d", ret);
-- 
2.20.1




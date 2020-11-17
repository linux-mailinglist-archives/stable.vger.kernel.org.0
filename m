Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CEC42B64D3
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:50:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733233AbgKQNuG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:50:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:42612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732335AbgKQNct (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:32:49 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 324562463D;
        Tue, 17 Nov 2020 13:32:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605619967;
        bh=xRpmdNRTP1fAlOrOwnDjQ9a9E8qeKPsVAymk/OWyVw8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DF2am0mwPIBGI/OeZiQr47Woo4RTCQnWyBHADP1nI234vBnPNcZ0ZfM6w3LOOReu3
         uMZLMEnUYjvxkw/Z8A9xiZmdgcFnnC8VippibKllUbBkteHQQLvukJWZvHRUuerr3/
         41magmC6FsDh5gNqwDRhiwI04YpD8FyR/4tND2sk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joakim Zhang <qiangqing.zhang@nxp.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 057/255] can: flexcan: flexcan_remove(): disable wakeup completely
Date:   Tue, 17 Nov 2020 14:03:17 +0100
Message-Id: <20201117122141.729363793@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122138.925150709@linuxfoundation.org>
References: <20201117122138.925150709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joakim Zhang <qiangqing.zhang@nxp.com>

[ Upstream commit ab07ff1c92fa60f29438e655a1b4abab860ed0b6 ]

With below sequence, we can see wakeup default is enabled after re-load module,
if it was enabled before, so we need disable wakeup in flexcan_remove().

| # cat /sys/bus/platform/drivers/flexcan/5a8e0000.can/power/wakeup
| disabled
| # echo enabled > /sys/bus/platform/drivers/flexcan/5a8e0000.can/power/wakeup
| # cat /sys/bus/platform/drivers/flexcan/5a8e0000.can/power/wakeup
| enabled
| # rmmod flexcan
| # modprobe flexcan
| # cat /sys/bus/platform/drivers/flexcan/5a8e0000.can/power/wakeup
| enabled

Fixes: de3578c198c6 ("can: flexcan: add self wakeup support")
Fixes: 915f9666421c ("can: flexcan: add support for DT property 'wakeup-source'")
Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
Link: https://lore.kernel.org/r/20201020184527.8190-1-qiangqing.zhang@nxp.com
[mkl: streamlined commit message]
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/flexcan.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
index bc504e09f2259..a330d6c56242e 100644
--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -1695,6 +1695,8 @@ static int flexcan_remove(struct platform_device *pdev)
 {
 	struct net_device *dev = platform_get_drvdata(pdev);
 
+	device_set_wakeup_enable(&pdev->dev, false);
+	device_set_wakeup_capable(&pdev->dev, false);
 	unregister_flexcandev(dev);
 	pm_runtime_disable(&pdev->dev);
 	free_candev(dev);
-- 
2.27.0




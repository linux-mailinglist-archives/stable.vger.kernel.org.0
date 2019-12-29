Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB10712C990
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:18:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731014AbfL2SKc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 13:10:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:52244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728961AbfL2RoP (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:44:15 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2D33920718;
        Sun, 29 Dec 2019 17:44:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577641454;
        bh=9OSaqMyXEV1YSYkKHen15K8b+MmvCI0xuHw1grtnIUo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ktw/HK2FiwAGKR2cp0vZB6KFH0VY+v44XWbmpviUAhnfHyz6jdMqBmMsRAX3fYNiD
         VREo/yEGk8dDEwLYEYNP9QD4JN7yg2h1rJ5vEpd+YKA74prN/b89fHEL+sBkVdOlav
         MyU1BdfI3sRng+E5Dvq5Rwf3NWVIEddqzbPFkfog=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Navid Emamdoost <navid.emamdoost@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 073/434] spi: gpio: prevent memory leak in spi_gpio_probe
Date:   Sun, 29 Dec 2019 18:22:06 +0100
Message-Id: <20191229172706.506071209@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
References: <20191229172702.393141737@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Navid Emamdoost <navid.emamdoost@gmail.com>

[ Upstream commit d3b0ffa1d75d5305ebe34735598993afbb8a869d ]

In spi_gpio_probe an SPI master is allocated via spi_alloc_master, but
this controller should be released if devm_add_action_or_reset fails,
otherwise memory leaks. In order to avoid leak spi_contriller_put must
be called in case of failure for devm_add_action_or_reset.

Fixes: 8b797490b4db ("spi: gpio: Make sure spi_master_put() is called in every error path")
Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
Link: https://lore.kernel.org/r/20190930205241.5483-1-navid.emamdoost@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-gpio.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi-gpio.c b/drivers/spi/spi-gpio.c
index 1d3e23ec20a6..f9c5bbb74714 100644
--- a/drivers/spi/spi-gpio.c
+++ b/drivers/spi/spi-gpio.c
@@ -371,8 +371,10 @@ static int spi_gpio_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	status = devm_add_action_or_reset(&pdev->dev, spi_gpio_put, master);
-	if (status)
+	if (status) {
+		spi_master_put(master);
 		return status;
+	}
 
 	if (of_id)
 		status = spi_gpio_probe_dt(pdev, master);
-- 
2.20.1




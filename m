Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2FA421014F8
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 06:39:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730253AbfKSFjO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:39:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:33298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730251AbfKSFjO (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:39:14 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E926F20721;
        Tue, 19 Nov 2019 05:39:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574141953;
        bh=p6r+QGUnfn2ffH/1ck6OW/KCJMN+5kOwAu34b+yJ69o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ymaAmUYvwxABbSkKHGcl9T4mb4TTd1NBhT2ZGdemzv3/vKd3NOZOBL83kRgG+Ujnc
         qt0NrdSuVTFHdTPtf4I0WKkizIpw1e/itOkY0PzN8uuZdkKfeedUdwBcrwD4qABRl+
         GU3Ld0lxDNrui+6p8xiPZnvs6oJP8CbL8VpYysfY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Claudiu Beznea <Claudiu.Beznea@microchip.com>,
        zhong jiang <zhongjiang@huawei.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 337/422] ARM: at91: pm: call put_device instead of of_node_put in at91_pm_config_ws
Date:   Tue, 19 Nov 2019 06:18:54 +0100
Message-Id: <20191119051420.855193553@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051400.261610025@linuxfoundation.org>
References: <20191119051400.261610025@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: zhong jiang <zhongjiang@huawei.com>

[ Upstream commit 95590a6286c547b7287d01c55515fb96b904aa03 ]

of_find_device_by_node takes a reference to the struct device when it
finds a match via get_device. but it fails to put_device in
at91_pm_config_ws, for_each_matching_node_and_match will get and put
the node properly, there is no need to call the of_put_node. Therefore,
just call put_device instead of of_node_put in at91_pm_config_ws.

Fixes: d7484f5c6b3b ("ARM: at91: pm: configure wakeup sources for ULP1 mode")
Suggested-by: Claudiu Beznea <Claudiu.Beznea@microchip.com>
Signed-off-by: zhong jiang <zhongjiang@huawei.com>
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-at91/pm.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mach-at91/pm.c b/arch/arm/mach-at91/pm.c
index 0921e2c10edfd..e2e4df3d11e53 100644
--- a/arch/arm/mach-at91/pm.c
+++ b/arch/arm/mach-at91/pm.c
@@ -143,15 +143,15 @@ static int at91_pm_config_ws(unsigned int pm_mode, bool set)
 
 			/* Check if enabled on SHDWC. */
 			if (wsi->shdwc_mr_bit && !(val & wsi->shdwc_mr_bit))
-				goto put_node;
+				goto put_device;
 
 			mode |= wsi->pmc_fsmr_bit;
 			if (wsi->set_polarity)
 				polarity |= wsi->pmc_fsmr_bit;
 		}
 
-put_node:
-		of_node_put(np);
+put_device:
+		put_device(&pdev->dev);
 	}
 
 	if (mode) {
-- 
2.20.1




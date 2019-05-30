Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C1E32EEDA
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 05:50:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731627AbfE3Dug (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:50:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:57206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728419AbfE3DTz (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:19:55 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 282DE2485E;
        Thu, 30 May 2019 03:19:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186395;
        bh=Abb7X/p0qruJLCrJBUM5ihEPlXP+BV4cMIDGS+W8tcM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vLaS6NNCFUQIhEeLZ/wVhY7bQ89LC0JKa4vmyJRNDNKi2evCPnW3hdukXc6ehf5jX
         uuTBhO1M4m7KN2tphbCPlSLrtVP6lE6+45N9/Gd0OS8t9NPka96k/8o7VTOPOInxlf
         bmfLegxc4PiIMijeuHYTiTk6S5yDKHHzYGp3PjkQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Charles Keepax <ckeepax@opensource.cirrus.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 125/193] extcon: arizona: Disable mic detect if running when driver is removed
Date:   Wed, 29 May 2019 20:06:19 -0700
Message-Id: <20190530030505.930287559@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030446.953835040@linuxfoundation.org>
References: <20190530030446.953835040@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 00053de52231117ddc154042549f2256183ffb86 ]

Microphone detection provides the button detection features on the
Arizona CODECs as such it will be running if the jack is currently
inserted. If the driver is unbound whilst the jack is still inserted
this will cause warnings from the regulator framework as the MICVDD
regulator is put but was never disabled.

Correct this by disabling microphone detection on driver removal and if
the microphone detection was running disable the regulator and put the
runtime reference that was currently held.

Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/extcon/extcon-arizona.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/extcon/extcon-arizona.c b/drivers/extcon/extcon-arizona.c
index f84da4a17724c..4937a404fee82 100644
--- a/drivers/extcon/extcon-arizona.c
+++ b/drivers/extcon/extcon-arizona.c
@@ -1726,6 +1726,16 @@ static int arizona_extcon_remove(struct platform_device *pdev)
 	struct arizona_extcon_info *info = platform_get_drvdata(pdev);
 	struct arizona *arizona = info->arizona;
 	int jack_irq_rise, jack_irq_fall;
+	bool change;
+
+	regmap_update_bits_check(arizona->regmap, ARIZONA_MIC_DETECT_1,
+				 ARIZONA_MICD_ENA, 0,
+				 &change);
+
+	if (change) {
+		regulator_disable(info->micvdd);
+		pm_runtime_put(info->dev);
+	}
 
 	gpiod_put(info->micd_pol_gpio);
 
-- 
2.20.1




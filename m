Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C1B62EDF3
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 05:43:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732169AbfE3Dmk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:42:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:60994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732451AbfE3DVH (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:21:07 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5438C24987;
        Thu, 30 May 2019 03:21:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186466;
        bh=nI1hJSSzPMF0V+a9RjsHDvr2N4Iii0c5mwQkd5roz+k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EJ88WhOF4zZTRpaaMpGywPjLGxvWyd3bYRpHZ4rBRh4b63qbOMLpHkkKqOFKKMGd/
         nAW2gzF8+dIYHirZnWMsq6qpdx/ymmpZbXtjm4xB2emMiSMR3bZu7MJsC5QcMRga9g
         /gKpTLIFBGSW2yqtoDgjwkTmm+qenhSNAy5OCCPg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Charles Keepax <ckeepax@opensource.cirrus.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 083/128] extcon: arizona: Disable mic detect if running when driver is removed
Date:   Wed, 29 May 2019 20:06:55 -0700
Message-Id: <20190530030449.707847284@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030432.977908967@linuxfoundation.org>
References: <20190530030432.977908967@linuxfoundation.org>
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
index 56e6c4c7c60d2..4c0b6df8b5ddb 100644
--- a/drivers/extcon/extcon-arizona.c
+++ b/drivers/extcon/extcon-arizona.c
@@ -1684,6 +1684,16 @@ static int arizona_extcon_remove(struct platform_device *pdev)
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




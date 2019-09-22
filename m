Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D7A8BA605
	for <lists+stable@lfdr.de>; Sun, 22 Sep 2019 21:45:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390598AbfIVSrL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Sep 2019 14:47:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:43484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390571AbfIVSrJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 22 Sep 2019 14:47:09 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4975F2186A;
        Sun, 22 Sep 2019 18:47:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569178029;
        bh=Hd313bNn1nwYn7nl2HeoEwQBysegcQMaraVjCkG6hTY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RBCrQVRmJJKJbQwqWpZVF1M91ut7qNRSFpTdIOPhwi8JmpNUv4e+X2j/rGYrNZafq
         ntZc1P1h02mGFPuLjVRCz/PiN313tPRGRXSgS/PCU/FHimzeJl+GB7ZKLnRznYc+GI
         nVkMgv+6RPabmJWfFtaAgkki2d5MXWDYjA/oiDzI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Anson Huang <Anson.Huang@nxp.com>,
        Leonard Crestez <leonard.crestez@nxp.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.3 112/203] cpufreq: imx-cpufreq-dt: Add i.MX8MN support
Date:   Sun, 22 Sep 2019 14:42:18 -0400
Message-Id: <20190922184350.30563-112-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190922184350.30563-1-sashal@kernel.org>
References: <20190922184350.30563-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anson Huang <Anson.Huang@nxp.com>

[ Upstream commit 75c000c4bcbe2b0eb82baf90c7dd75c7380cc3fd ]

i.MX8MN has different speed grading definition as below, it has 4 bits
to define speed grading, add support for it.

 SPEED_GRADE[3:0]    MHz
    0000            2300
    0001            2200
    0010            2100
    0011            2000
    0100            1900
    0101            1800
    0110            1700
    0111            1600
    1000            1500
    1001            1400
    1010            1300
    1011            1200
    1100            1100
    1101            1000
    1110             900
    1111             800

Signed-off-by: Anson Huang <Anson.Huang@nxp.com>
Reviewed-by: Leonard Crestez <leonard.crestez@nxp.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/imx-cpufreq-dt.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/cpufreq/imx-cpufreq-dt.c b/drivers/cpufreq/imx-cpufreq-dt.c
index 4f85f3112784f..35db14cf31026 100644
--- a/drivers/cpufreq/imx-cpufreq-dt.c
+++ b/drivers/cpufreq/imx-cpufreq-dt.c
@@ -16,6 +16,7 @@
 
 #define OCOTP_CFG3_SPEED_GRADE_SHIFT	8
 #define OCOTP_CFG3_SPEED_GRADE_MASK	(0x3 << 8)
+#define IMX8MN_OCOTP_CFG3_SPEED_GRADE_MASK	(0xf << 8)
 #define OCOTP_CFG3_MKT_SEGMENT_SHIFT    6
 #define OCOTP_CFG3_MKT_SEGMENT_MASK     (0x3 << 6)
 
@@ -34,7 +35,12 @@ static int imx_cpufreq_dt_probe(struct platform_device *pdev)
 	if (ret)
 		return ret;
 
-	speed_grade = (cell_value & OCOTP_CFG3_SPEED_GRADE_MASK) >> OCOTP_CFG3_SPEED_GRADE_SHIFT;
+	if (of_machine_is_compatible("fsl,imx8mn"))
+		speed_grade = (cell_value & IMX8MN_OCOTP_CFG3_SPEED_GRADE_MASK)
+			      >> OCOTP_CFG3_SPEED_GRADE_SHIFT;
+	else
+		speed_grade = (cell_value & OCOTP_CFG3_SPEED_GRADE_MASK)
+			      >> OCOTP_CFG3_SPEED_GRADE_SHIFT;
 	mkt_segment = (cell_value & OCOTP_CFG3_MKT_SEGMENT_MASK) >> OCOTP_CFG3_MKT_SEGMENT_SHIFT;
 
 	/*
-- 
2.20.1


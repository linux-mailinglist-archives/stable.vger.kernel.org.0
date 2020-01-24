Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F9C21488B7
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 15:31:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404980AbgAXOUm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 09:20:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:41978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404964AbgAXOUl (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 09:20:41 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 35F4722527;
        Fri, 24 Jan 2020 14:20:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579875641;
        bh=pYJmhRfn9YOi7piJCSMO3M5A4Rv0EXDHpAb2QRyajSE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZfbPKGV8vO+0HYTRvfBiZcYUvAtAz+TN9E5j3TXddgrDY5idKwqEyNBhTQeZG96O8
         MNvF0otU9FrPqRrN8vP18Uq4X0oe7pMBR4yB2nq639HLgrKQVxyNTsqT4WQ5MaFcaM
         lsBhO3ig2vUGz1sh2Rn3YrpM866yzP8XoHgSpIds=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Jason Anderson <jasona.594@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>,
        platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 24/56] platform/x86: GPD pocket fan: Allow somewhat lower/higher temperature limits
Date:   Fri, 24 Jan 2020 09:19:40 -0500
Message-Id: <20200124142012.29752-24-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200124142012.29752-1-sashal@kernel.org>
References: <20200124142012.29752-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 1f27dbd8265dbb379926c8f6a4453fe7fe26d7a3 ]

Allow the user to configure the fan to turn on / speed-up at lower
thresholds then before (20 degrees Celcius as minimum instead of 40) and
likewise also allow the user to delay the fan speeding-up till the
temperature hits 90 degrees Celcius (was 70).

Cc: Jason Anderson <jasona.594@gmail.com>
Reported-by: Jason Anderson <jasona.594@gmail.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/gpd-pocket-fan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/platform/x86/gpd-pocket-fan.c b/drivers/platform/x86/gpd-pocket-fan.c
index 73eb1572b9662..b471b86c28fe8 100644
--- a/drivers/platform/x86/gpd-pocket-fan.c
+++ b/drivers/platform/x86/gpd-pocket-fan.c
@@ -127,7 +127,7 @@ static int gpd_pocket_fan_probe(struct platform_device *pdev)
 	int i;
 
 	for (i = 0; i < ARRAY_SIZE(temp_limits); i++) {
-		if (temp_limits[i] < 40000 || temp_limits[i] > 70000) {
+		if (temp_limits[i] < 20000 || temp_limits[i] > 90000) {
 			dev_err(&pdev->dev, "Invalid temp-limit %d (must be between 40000 and 70000)\n",
 				temp_limits[i]);
 			temp_limits[0] = TEMP_LIMIT0_DEFAULT;
-- 
2.20.1


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16E0D21F4F2
	for <lists+stable@lfdr.de>; Tue, 14 Jul 2020 16:43:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729060AbgGNOjl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jul 2020 10:39:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:55138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729051AbgGNOjl (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jul 2020 10:39:41 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DA14F2256C;
        Tue, 14 Jul 2020 14:39:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594737580;
        bh=Nm/dHAUfuy1HFJpIfxRVncku+Ny6xyq7czkzy8OAcYs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OtmspIawtL50xKk9r2YsV2sMO6JE5NDCvdEuuEqMA/nab78TJMLU2VUmE+OZto1HO
         h6DofNgz362gZgyzOZUxQSljgOm+Y/a5601WiqNASgRpOV5nFpUgKe21Gk+YSshSJ/
         c0Rs+R8tKOW+ieK6ym3JiCVKpjMMM/nThWAgHVB8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Navid Emamdoost <navid.emamdoost@gmail.com>,
        Charles Keepax <ckeepax@opensource.cirrus.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>, patches@opensource.cirrus.com,
        linux-gpio@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 02/13] gpio: arizona: put pm_runtime in case of failure
Date:   Tue, 14 Jul 2020 10:39:26 -0400
Message-Id: <20200714143937.4035685-2-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200714143937.4035685-1-sashal@kernel.org>
References: <20200714143937.4035685-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Navid Emamdoost <navid.emamdoost@gmail.com>

[ Upstream commit 861254d826499944cb4d9b5a15f5a794a6b99a69 ]

Calling pm_runtime_get_sync increments the counter even in case of
failure, causing incorrect ref count if pm_runtime_put is not called in
error handling paths. Call pm_runtime_put if pm_runtime_get_sync fails.

Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
Acked-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://lore.kernel.org/r/20200605030052.78235-1-navid.emamdoost@gmail.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-arizona.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/gpio/gpio-arizona.c b/drivers/gpio/gpio-arizona.c
index 485aa45fc5d53..c6cf270035b56 100644
--- a/drivers/gpio/gpio-arizona.c
+++ b/drivers/gpio/gpio-arizona.c
@@ -69,6 +69,7 @@ static int arizona_gpio_get(struct gpio_chip *chip, unsigned offset)
 		ret = pm_runtime_get_sync(chip->parent);
 		if (ret < 0) {
 			dev_err(chip->parent, "Failed to resume: %d\n", ret);
+			pm_runtime_put_autosuspend(chip->parent);
 			return ret;
 		}
 
@@ -77,12 +78,15 @@ static int arizona_gpio_get(struct gpio_chip *chip, unsigned offset)
 		if (ret < 0) {
 			dev_err(chip->parent, "Failed to drop cache: %d\n",
 				ret);
+			pm_runtime_put_autosuspend(chip->parent);
 			return ret;
 		}
 
 		ret = regmap_read(arizona->regmap, reg, &val);
-		if (ret < 0)
+		if (ret < 0) {
+			pm_runtime_put_autosuspend(chip->parent);
 			return ret;
+		}
 
 		pm_runtime_mark_last_busy(chip->parent);
 		pm_runtime_put_autosuspend(chip->parent);
-- 
2.25.1


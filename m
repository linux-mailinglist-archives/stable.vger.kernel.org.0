Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3A1722F24D
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 16:39:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729764AbgG0OKG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 10:10:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:60866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729739AbgG0OKF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jul 2020 10:10:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 57D7B2083E;
        Mon, 27 Jul 2020 14:10:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595859004;
        bh=Nm/dHAUfuy1HFJpIfxRVncku+Ny6xyq7czkzy8OAcYs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TFs3Fk3Ba/WS844uPxI/YEUF8YzfgJ85b9hDF9TU+96DMg3pxlnXjfqijzGZ3XwQv
         SAZz7muL8SqHIKJOzWEXKqKMY2W87pMJKKwiknnJUT/oPll2xohh49NE0NymsE/4M9
         DJs5XlKlWc2a87iSR0o9XUy1Li4Xa9mdtQwvhNi4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Navid Emamdoost <navid.emamdoost@gmail.com>,
        Charles Keepax <ckeepax@opensource.cirrus.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 03/86] gpio: arizona: put pm_runtime in case of failure
Date:   Mon, 27 Jul 2020 16:03:37 +0200
Message-Id: <20200727134914.493395796@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200727134914.312934924@linuxfoundation.org>
References: <20200727134914.312934924@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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




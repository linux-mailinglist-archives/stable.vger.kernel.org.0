Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBE6F22EFCA
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 16:19:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731376AbgG0OTU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 10:19:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:47192 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731365AbgG0OTR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jul 2020 10:19:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CD61C2075A;
        Mon, 27 Jul 2020 14:19:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595859557;
        bh=90/WbSukEK5s1iW2h/xGVzDI+tjhox/mLpz3WTRUY30=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=klYNIKiVeaSM8YidgHtgsKC6dNwwhb9Jn4ccXvpfoBxmd9B/n3mRphG4vy2LpZm7R
         fWrewg9Jwv3gajbMbRn0wD8aOLXvYWbxDACludd7gwhxGnDYfwRFR8iMruYVFprG/D
         ysI/bkHeN0nxfgat1sfSTwYHO7HcXgUe9qaPyKQ4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Navid Emamdoost <navid.emamdoost@gmail.com>,
        Charles Keepax <ckeepax@opensource.cirrus.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 003/179] gpio: arizona: put pm_runtime in case of failure
Date:   Mon, 27 Jul 2020 16:02:58 +0200
Message-Id: <20200727134932.835754857@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200727134932.659499757@linuxfoundation.org>
References: <20200727134932.659499757@linuxfoundation.org>
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
index 7520a13b4c7ca..5bda38e0780f2 100644
--- a/drivers/gpio/gpio-arizona.c
+++ b/drivers/gpio/gpio-arizona.c
@@ -64,6 +64,7 @@ static int arizona_gpio_get(struct gpio_chip *chip, unsigned offset)
 		ret = pm_runtime_get_sync(chip->parent);
 		if (ret < 0) {
 			dev_err(chip->parent, "Failed to resume: %d\n", ret);
+			pm_runtime_put_autosuspend(chip->parent);
 			return ret;
 		}
 
@@ -72,12 +73,15 @@ static int arizona_gpio_get(struct gpio_chip *chip, unsigned offset)
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




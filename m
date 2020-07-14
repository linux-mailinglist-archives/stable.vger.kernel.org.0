Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 404DA21F526
	for <lists+stable@lfdr.de>; Tue, 14 Jul 2020 16:44:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729417AbgGNOok (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jul 2020 10:44:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:54546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728879AbgGNOjQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jul 2020 10:39:16 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5B612222C8;
        Tue, 14 Jul 2020 14:39:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594737556;
        bh=ePzMsZXUTslGkSsNhaVZcjTY3pwqZrmfziQBGeiOnbY=;
        h=From:To:Cc:Subject:Date:From;
        b=D0OKB/yCxw49myf5J7ZmM+DR/msFBRLXQYJ8CcbbaUEnY7jKzo6+JNTZN0Olqg3As
         e5SmYx3AXVISI0Nos+mlZaaeAPstlApsD3nQ204iibqGcscPJQmWTaXmyNNwOhxHLP
         QAWIi029t7v4mp9zS8zmsh4CD5Nz3Zq8ir54Esgc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Navid Emamdoost <navid.emamdoost@gmail.com>,
        Charles Keepax <ckeepax@opensource.cirrus.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>, patches@opensource.cirrus.com,
        linux-gpio@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 01/18] gpio: arizona: handle pm_runtime_get_sync failure case
Date:   Tue, 14 Jul 2020 10:38:57 -0400
Message-Id: <20200714143914.4035489-1-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Navid Emamdoost <navid.emamdoost@gmail.com>

[ Upstream commit e6f390a834b56583e6fc0949822644ce92fbb107 ]

Calling pm_runtime_get_sync increments the counter even in case of
failure, causing incorrect ref count. Call pm_runtime_put if
pm_runtime_get_sync fails.

Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
Acked-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://lore.kernel.org/r/20200605025207.65719-1-navid.emamdoost@gmail.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-arizona.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpio/gpio-arizona.c b/drivers/gpio/gpio-arizona.c
index 5640efe5e7504..7520a13b4c7ca 100644
--- a/drivers/gpio/gpio-arizona.c
+++ b/drivers/gpio/gpio-arizona.c
@@ -106,6 +106,7 @@ static int arizona_gpio_direction_out(struct gpio_chip *chip,
 		ret = pm_runtime_get_sync(chip->parent);
 		if (ret < 0) {
 			dev_err(chip->parent, "Failed to resume: %d\n", ret);
+			pm_runtime_put(chip->parent);
 			return ret;
 		}
 	}
-- 
2.25.1


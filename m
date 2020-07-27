Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60D2B22EF10
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 16:13:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730301AbgG0OND (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 10:13:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:37716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730295AbgG0ONB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jul 2020 10:13:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9EEBF2073E;
        Mon, 27 Jul 2020 14:13:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595859181;
        bh=ePzMsZXUTslGkSsNhaVZcjTY3pwqZrmfziQBGeiOnbY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KS2eAbcZHQe/uv09RxDp935dOEN+PWOSK9GB4niaN8jsZXKaYLWCKotBXSYQxG7Jt
         rDHckBZYPW0I2FOE05hDwnzJxpgWRs4Lksj5BfD5VjAIhp4h6m6CLl7Fxtu5swzSk5
         RaIU5LvQJZPaGvKKimX5v0EqbGR3zSRL2229FE/k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Navid Emamdoost <navid.emamdoost@gmail.com>,
        Charles Keepax <ckeepax@opensource.cirrus.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 002/138] gpio: arizona: handle pm_runtime_get_sync failure case
Date:   Mon, 27 Jul 2020 16:03:17 +0200
Message-Id: <20200727134925.364387472@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200727134925.228313570@linuxfoundation.org>
References: <20200727134925.228313570@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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




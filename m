Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7515B40126D
	for <lists+stable@lfdr.de>; Mon,  6 Sep 2021 03:19:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238545AbhIFBU6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Sep 2021 21:20:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:37236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238521AbhIFBU6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 5 Sep 2021 21:20:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9D11C61039;
        Mon,  6 Sep 2021 01:19:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630891194;
        bh=gCAjRcuy/AlnzyMJq9OxcgrHNO5ex/lpTCXsRBzMqZY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qaxC+Q1jG1euFwJ769qAClwkHl/qTFzNbK7t+2UHkMwQWlg1ltC/T00lqVOCbYkGm
         1ukGhHtoWqHStZf1rf4YQ6fcP1PufoLZOol94RxQVMvjcwjdaMidKZTJ/k+RzUWbQu
         6OfoO0emHRypiphNODWi1MnqRJnjMB23Wni5Q7OUluDoQ+Qif1qeFGwroxzhISZh2S
         BHsJWj2kdUBp7mL2aIkkzWStuC2vH3BucxKQcZ4vVYRJp8oefvFuAP+YtpwuBJ1jX0
         MTvaqMmawgtaM1S/A+Na+HrlsMtRkOaiyO1qvKvXuY50Su64VBlrUy50Ysw3+Jzb63
         oeM9JBV2kLWNA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jeongtae Park <jeongtae.park@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.14 02/47] regmap: fix the offset of register error log
Date:   Sun,  5 Sep 2021 21:19:06 -0400
Message-Id: <20210906011951.928679-2-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210906011951.928679-1-sashal@kernel.org>
References: <20210906011951.928679-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeongtae Park <jeongtae.park@gmail.com>

[ Upstream commit 1852f5ed358147095297a09cc3c6f160208a676d ]

This patch fixes the offset of register error log
by using regmap_get_offset().

Signed-off-by: Jeongtae Park <jeongtae.park@gmail.com>
Link: https://lore.kernel.org/r/20210701142630.44936-1-jeongtae.park@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/regmap/regmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index fe3e38dd5324..2fc826e97591 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -1667,7 +1667,7 @@ static int _regmap_raw_write_impl(struct regmap *map, unsigned int reg,
 			if (ret) {
 				dev_err(map->dev,
 					"Error in caching of register: %x ret: %d\n",
-					reg + i, ret);
+					reg + regmap_get_offset(map, i), ret);
 				return ret;
 			}
 		}
-- 
2.30.2


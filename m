Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8975D4012E1
	for <lists+stable@lfdr.de>; Mon,  6 Sep 2021 03:22:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239465AbhIFBWu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Sep 2021 21:22:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:38916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239100AbhIFBV6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 5 Sep 2021 21:21:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5833B610A1;
        Mon,  6 Sep 2021 01:20:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630891255;
        bh=dW2oviBPKYqxOqpv8BFVhShbCIxDDvWmOFv3kOeg5yw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ac3VAhRYW1eeX/2DC3+meuuwnb6wHP9JGsf2yiedfKrUdYe3bx1flsbSvBwRWsksu
         p8VSZJo/b7eOPZ39RmtPhVkPukOBLgjVb5PmUqy7cHovK4KIStP/ng0XR+sBUs8BLe
         14JcUKM7+k2NNEj0nWm0vlk4qcv8ftnkYtBdlg1hoaxIq46JBYH29AKOOukNLkG6Ay
         Njh/AkAAmPjkBchiKd0HXsU+mB0WGotNHkQFKscGBS+asX6ZoCHxyJeMJZ59A1Pq9K
         3sPzoLEo1L7YcNoVJmnOq5DbjQjvziHmqHt9ktoTDCpK/QYx7s2KZmnOx7yCIu8XE/
         hxZILGszeVIBA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jeongtae Park <jeongtae.park@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.13 02/46] regmap: fix the offset of register error log
Date:   Sun,  5 Sep 2021 21:20:07 -0400
Message-Id: <20210906012052.929174-2-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210906012052.929174-1-sashal@kernel.org>
References: <20210906012052.929174-1-sashal@kernel.org>
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
index 297e95be25b3..cf1dca0cde2c 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -1652,7 +1652,7 @@ static int _regmap_raw_write_impl(struct regmap *map, unsigned int reg,
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


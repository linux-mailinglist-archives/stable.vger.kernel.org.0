Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 029724013E0
	for <lists+stable@lfdr.de>; Mon,  6 Sep 2021 03:37:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240468AbhIFBcB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Sep 2021 21:32:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:47360 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241013AbhIFB11 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 5 Sep 2021 21:27:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 514A061163;
        Mon,  6 Sep 2021 01:22:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630891366;
        bh=ncDBB8v6ZZ296ieyuz/ySpKYoMXkYRaSFXZR0cBsyxQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eB2glZaFV0r964Jw2wEC9PA7X94EYJwJjPrlgklVfo9FsHM7lNT9BToqPSts+QQte
         J4HXkKjrG2Flyi57fDlgv9DesVbria2oenwz10hr+9ixoPJElkCfhJu60oHV7LvdZa
         7WPzQ3u0hIxVG7sHXF43yw1RIjMq5ILJOfocxEQtO4oOLuLIv3q6L1rj8aYtbQ8LXr
         ahzxC2JZ549YXts0xHsfHMXnK6GvF0HOCcLAY2hHkhPRimf4540KNr+KCqG8xX/Cxi
         dxzI56jkF24928GwDxzRjUPIo5In9hUV6GMwWe1Jt0YN+RkD5naCL7oRo5ZbwC5Lrq
         DzsQIzdPpsOeA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jeongtae Park <jeongtae.park@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 02/30] regmap: fix the offset of register error log
Date:   Sun,  5 Sep 2021 21:22:15 -0400
Message-Id: <20210906012244.930338-2-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210906012244.930338-1-sashal@kernel.org>
References: <20210906012244.930338-1-sashal@kernel.org>
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
index e0893f1b1452..43c0452a8ba9 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -1505,7 +1505,7 @@ static int _regmap_raw_write_impl(struct regmap *map, unsigned int reg,
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


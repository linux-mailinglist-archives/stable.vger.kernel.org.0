Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC31D40145C
	for <lists+stable@lfdr.de>; Mon,  6 Sep 2021 03:40:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243321AbhIFBdC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Sep 2021 21:33:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:48336 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351536AbhIFBaj (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 5 Sep 2021 21:30:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 057AC61139;
        Mon,  6 Sep 2021 01:23:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630891434;
        bh=nMaDKf7PvB3GfSvubjVxkNHXMMRtz0hVAIloS4vifmM=;
        h=From:To:Cc:Subject:Date:From;
        b=ERzaK6URW1mnMRgpgepOLXNmpbJmt4Nkwsf+wLhY/fokxoEKZNG5jrkNxRFP0YweF
         16I1F1rb66CImX1/6YZUGPbL1pWnUx6Zq2++DZ8lZkL4pX+HORgMvP0aKZmAbY3ySc
         1820H6+KREIkwZNwy5Muul5Je37frNcdEe7FvVm8DarPxZUBfLq99VnRRCRG1k/8jb
         pDKTICb/+DHFBLcrU0Emy8pIz9Js2kCWMJC9BWwl0Rkjm1jwNZ1gTS8mf3Mrj8X6KH
         mkcvAIG7jcKAmyKVq/woIvX76EixR4IKF6ii9ynmF5YiF2HPrm9iQR/Hhorgyazerf
         5d/aOKWTezGzg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jeongtae Park <jeongtae.park@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.14 01/17] regmap: fix the offset of register error log
Date:   Sun,  5 Sep 2021 21:23:36 -0400
Message-Id: <20210906012352.930954-1-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
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
index 4e0cc40ad9ce..1c5ff22d92f1 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -1378,7 +1378,7 @@ int _regmap_raw_write(struct regmap *map, unsigned int reg,
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


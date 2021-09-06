Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF737401471
	for <lists+stable@lfdr.de>; Mon,  6 Sep 2021 03:40:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235488AbhIFBdV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Sep 2021 21:33:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:48056 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351712AbhIFBa6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 5 Sep 2021 21:30:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0A36A6124C;
        Mon,  6 Sep 2021 01:24:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630891457;
        bh=a2TUNuH1+x0m23FFz5Pe4Pa0RQARuJhn2OcjxP2iapo=;
        h=From:To:Cc:Subject:Date:From;
        b=LwOHkxVDHrXZAYCLHYpsewiQZ8XLdVuzdDUZJyK5H4XeiiI+YrtS+SrMLJ+nbABkT
         hPdPaGR/7tqCeqDwlK4CWBGr+h8TuIEKG5E7ahGG3tKTP5FvWa2Nf1MCPnvCOU4dTR
         0IUh0w/eXJ1140VwBvBQddEDPN++8lS1L5J4qEbRWYT8Y3nvBh/ubeuvPErzQ0KgBU
         ydhKzhAHB+5y/JSb8nU77FNA1Cs/ur/6zWUcLCwXCLbpWSi/ozuuGD906E1pKu/fjL
         uL21xOK5DeILVal/rTCO7mxszL5pnAX+1+bSPzg0b5aC8yRcV/684V4F9BhqoadVNQ
         UHnxrY2beTzsw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jeongtae Park <jeongtae.park@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.9 01/14] regmap: fix the offset of register error log
Date:   Sun,  5 Sep 2021 21:24:02 -0400
Message-Id: <20210906012415.931147-1-sashal@kernel.org>
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
index cd984b59a8a1..40a9e5378633 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -1375,7 +1375,7 @@ int _regmap_raw_write(struct regmap *map, unsigned int reg,
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


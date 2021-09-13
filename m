Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80EBD40937D
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:20:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344637AbhIMOVk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:21:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:41882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344451AbhIMOTN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:19:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4805B61B1B;
        Mon, 13 Sep 2021 13:45:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631540750;
        bh=gCAjRcuy/AlnzyMJq9OxcgrHNO5ex/lpTCXsRBzMqZY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HtoQhEM0/ejg85ih8gqoq9o5rcK56V7p5AAdFY1qmvXfwiVQHjaOn/hYswOrZu2ZF
         uc9OHY6UFITj7a0jdTXKXQ0u25uNcHasy+ilNTiJqei5JEqWL/ksRZkvVgv/3F0du3
         7M4LsJo1dedN0RH+uC1bDpmhqrg633Tl7qH3uXHA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jeongtae Park <jeongtae.park@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 002/334] regmap: fix the offset of register error log
Date:   Mon, 13 Sep 2021 15:10:56 +0200
Message-Id: <20210913131113.474063237@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131113.390368911@linuxfoundation.org>
References: <20210913131113.390368911@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9B3A40135A
	for <lists+stable@lfdr.de>; Mon,  6 Sep 2021 03:25:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240485AbhIFBZj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Sep 2021 21:25:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:38098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239945AbhIFBYI (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 5 Sep 2021 21:24:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 89DE7610E9;
        Mon,  6 Sep 2021 01:21:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630891316;
        bh=SEHDyJufO6NEyM38WzYmIsRCTyI6KfpW3u6zvfVA5MY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CMnB83VxDrQYLpnogMCWm5xBCPVjybOWyTZYaC4XwB+0JNWIqbC9FOt6bIhKisCwM
         RWPKwt2zveNFU/oS93POzHKJUzsvjYN/QMRr//PQc9lZ5iGGrWAgqDt07sR7GSjVME
         kuYfjjpIbRR/sGcGlCVAjRI2bkrhnnqXTzViGbpIJf8gZPgXZX2zDBlFh6uVu1G+j2
         SV/VeCBxg5GnJ3YuS0VBZv/EiPYJCZ3Ft3zW9/8q72xhfA2m2ErVtXoeOmHGd/OQlD
         WLaukt8G25xlMi6QX8PW4gJce32/6tR23C7PC4tiU62A2nX+TcLw8zzPpV4myHF5pP
         rHwHN+8ATyqGw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jeongtae Park <jeongtae.park@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.10 02/39] regmap: fix the offset of register error log
Date:   Sun,  5 Sep 2021 21:21:16 -0400
Message-Id: <20210906012153.929962-2-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210906012153.929962-1-sashal@kernel.org>
References: <20210906012153.929962-1-sashal@kernel.org>
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
index 5db536ccfcd6..456a1787e18d 100644
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


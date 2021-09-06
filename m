Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 305F3401432
	for <lists+stable@lfdr.de>; Mon,  6 Sep 2021 03:38:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241198AbhIFBcl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Sep 2021 21:32:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:48058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243545AbhIFB31 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 5 Sep 2021 21:29:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 294056113A;
        Mon,  6 Sep 2021 01:23:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630891405;
        bh=11eeffGwG4uOSbQyfPb2wgUQ9gANrFEgY1LntyJbrkE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mDSGgH9cX0buLWZzLBC/F1BlC8LvYK7fOFgJR79p4ZybQAhvHef0E5UivjAPKQcx8
         nQsc/goPD8hLgoMBj5oFMOqwF37oSUwNzDuGEXJM3OOiQJXv8FyiTepQJ1VxNkOjQW
         kQ91KFfozc5qGg+r085GsKr7Z52xB2hA+uJkBe0jUoGSn1KKevUlsi6SlAggM427gl
         ymcFSv/8Y7GpRkLePJkMTlmSESQHSBOkI+0PWZEcw5vvse5OmSQrwAna6kKx93NMqB
         spemipu2H6BxOBXyN2xVxt7ejUvYYC8HbWHAAfvhSoIAyJUIXYUI/vgTTEohwmbTat
         EgX0xRrwr1kMw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jeongtae Park <jeongtae.park@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 02/23] regmap: fix the offset of register error log
Date:   Sun,  5 Sep 2021 21:23:01 -0400
Message-Id: <20210906012322.930668-2-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210906012322.930668-1-sashal@kernel.org>
References: <20210906012322.930668-1-sashal@kernel.org>
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
index e8b3353c18eb..330ab9c85d1b 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -1479,7 +1479,7 @@ static int _regmap_raw_write_impl(struct regmap *map, unsigned int reg,
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


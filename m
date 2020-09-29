Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D21BB27C665
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:44:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730906AbgI2Los (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:44:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:43958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730901AbgI2Loo (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:44:44 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 34385206F7;
        Tue, 29 Sep 2020 11:44:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379883;
        bh=JO5KuH9dgU3dALvaJEY+GwaZ5SvL6YABBJ4PYyJmbd8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tQo9EHJT4/ksipYJUIIjC8RK9A4PuVNZMfSfIWjMtZzt69WjV7BYfxfyl0abdRQi5
         TgYDNGeklQGWxJ8FroqFQebxsC1kPeSgMlj6eswBKMPzavlM8hha0rovet60PtkMFd
         rXxeWTcH2JNNtRah7ZKWvEL1p+eYrLQwcD+3ZuUU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 360/388] regmap: fix page selection for noinc reads
Date:   Tue, 29 Sep 2020 13:01:31 +0200
Message-Id: <20200929110027.891445123@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929110010.467764689@linuxfoundation.org>
References: <20200929110010.467764689@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit 4003324856311faebb46cbd56a1616bd3f3b67c2 ]

Non-incrementing reads can fail if register + length crosses page
border. However for non-incrementing reads we should not check for page
border crossing. Fix this by passing additional flag to _regmap_raw_read
and passing length to _regmap_select_page basing on the flag.

Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Fixes: 74fe7b551f33 ("regmap: Add regmap_noinc_read API")
Link: https://lore.kernel.org/r/20200917153405.3139200-1-dmitry.baryshkov@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/regmap/regmap.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index 927ebde1607be..7244319dd2d52 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -2454,7 +2454,7 @@ int regmap_raw_write_async(struct regmap *map, unsigned int reg,
 EXPORT_SYMBOL_GPL(regmap_raw_write_async);
 
 static int _regmap_raw_read(struct regmap *map, unsigned int reg, void *val,
-			    unsigned int val_len)
+			    unsigned int val_len, bool noinc)
 {
 	struct regmap_range_node *range;
 	int ret;
@@ -2467,7 +2467,7 @@ static int _regmap_raw_read(struct regmap *map, unsigned int reg, void *val,
 	range = _regmap_range_lookup(map, reg);
 	if (range) {
 		ret = _regmap_select_page(map, &reg, range,
-					  val_len / map->format.val_bytes);
+					  noinc ? 1 : val_len / map->format.val_bytes);
 		if (ret != 0)
 			return ret;
 	}
@@ -2505,7 +2505,7 @@ static int _regmap_bus_read(void *context, unsigned int reg,
 	if (!map->format.parse_val)
 		return -EINVAL;
 
-	ret = _regmap_raw_read(map, reg, work_val, map->format.val_bytes);
+	ret = _regmap_raw_read(map, reg, work_val, map->format.val_bytes, false);
 	if (ret == 0)
 		*val = map->format.parse_val(work_val);
 
@@ -2621,7 +2621,7 @@ int regmap_raw_read(struct regmap *map, unsigned int reg, void *val,
 
 		/* Read bytes that fit into whole chunks */
 		for (i = 0; i < chunk_count; i++) {
-			ret = _regmap_raw_read(map, reg, val, chunk_bytes);
+			ret = _regmap_raw_read(map, reg, val, chunk_bytes, false);
 			if (ret != 0)
 				goto out;
 
@@ -2632,7 +2632,7 @@ int regmap_raw_read(struct regmap *map, unsigned int reg, void *val,
 
 		/* Read remaining bytes */
 		if (val_len) {
-			ret = _regmap_raw_read(map, reg, val, val_len);
+			ret = _regmap_raw_read(map, reg, val, val_len, false);
 			if (ret != 0)
 				goto out;
 		}
@@ -2707,7 +2707,7 @@ int regmap_noinc_read(struct regmap *map, unsigned int reg,
 			read_len = map->max_raw_read;
 		else
 			read_len = val_len;
-		ret = _regmap_raw_read(map, reg, val, read_len);
+		ret = _regmap_raw_read(map, reg, val, read_len, true);
 		if (ret)
 			goto out_unlock;
 		val = ((u8 *)val) + read_len;
-- 
2.25.1




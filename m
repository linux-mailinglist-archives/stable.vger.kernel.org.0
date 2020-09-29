Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDEC727C7B1
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:56:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731083AbgI2Lzq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:55:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:44038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730326AbgI2Los (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:44:48 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7AF01207F7;
        Tue, 29 Sep 2020 11:44:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379886;
        bh=sG5bHEfphADR7PT/n3foG7HOi3+7ybYTmTUm18zAPjc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sNACu3PejPHjVrDjd2cYqgVcRKHClmWzMJJXcuuMhM06xMEWk5QqW2kzQGTeKljEK
         7ANshFkhJVsCuzy7txX/i8GlTg/FN338XR2WRocQpn3leMdk/rsYo5iEE8C0CNTrnG
         +cLNReddo9ICLDgAzo6dqUjB/zJeWOL6EtxeVurw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 361/388] regmap: fix page selection for noinc writes
Date:   Tue, 29 Sep 2020 13:01:32 +0200
Message-Id: <20200929110027.940285895@linuxfoundation.org>
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

[ Upstream commit 05669b63170771d554854c0e465b76dc98fc7c84 ]

Non-incrementing writes can fail if register + length crosses page
border. However for non-incrementing writes we should not check for page
border crossing. Fix this by passing additional flag to _regmap_raw_write
and passing length to _regmap_select_page basing on the flag.

Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Fixes: cdf6b11daa77 ("regmap: Add regmap_noinc_write API")
Link: https://lore.kernel.org/r/20200917153405.3139200-2-dmitry.baryshkov@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/regmap/internal.h |  2 +-
 drivers/base/regmap/regcache.c |  2 +-
 drivers/base/regmap/regmap.c   | 21 +++++++++++----------
 3 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/drivers/base/regmap/internal.h b/drivers/base/regmap/internal.h
index 3d80c4b43f720..d7c01b70e43db 100644
--- a/drivers/base/regmap/internal.h
+++ b/drivers/base/regmap/internal.h
@@ -259,7 +259,7 @@ bool regcache_set_val(struct regmap *map, void *base, unsigned int idx,
 int regcache_lookup_reg(struct regmap *map, unsigned int reg);
 
 int _regmap_raw_write(struct regmap *map, unsigned int reg,
-		      const void *val, size_t val_len);
+		      const void *val, size_t val_len, bool noinc);
 
 void regmap_async_complete_cb(struct regmap_async *async, int ret);
 
diff --git a/drivers/base/regmap/regcache.c b/drivers/base/regmap/regcache.c
index a93cafd7be4f2..7f4b3b62492ca 100644
--- a/drivers/base/regmap/regcache.c
+++ b/drivers/base/regmap/regcache.c
@@ -717,7 +717,7 @@ static int regcache_sync_block_raw_flush(struct regmap *map, const void **data,
 
 	map->cache_bypass = true;
 
-	ret = _regmap_raw_write(map, base, *data, count * val_bytes);
+	ret = _regmap_raw_write(map, base, *data, count * val_bytes, false);
 	if (ret)
 		dev_err(map->dev, "Unable to sync registers %#x-%#x. %d\n",
 			base, cur - map->reg_stride, ret);
diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index 7244319dd2d52..e0893f1b14522 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -1468,7 +1468,7 @@ static void regmap_set_work_buf_flag_mask(struct regmap *map, int max_bytes,
 }
 
 static int _regmap_raw_write_impl(struct regmap *map, unsigned int reg,
-				  const void *val, size_t val_len)
+				  const void *val, size_t val_len, bool noinc)
 {
 	struct regmap_range_node *range;
 	unsigned long flags;
@@ -1527,7 +1527,7 @@ static int _regmap_raw_write_impl(struct regmap *map, unsigned int reg,
 				win_residue, val_len / map->format.val_bytes);
 			ret = _regmap_raw_write_impl(map, reg, val,
 						     win_residue *
-						     map->format.val_bytes);
+						     map->format.val_bytes, noinc);
 			if (ret != 0)
 				return ret;
 
@@ -1541,7 +1541,7 @@ static int _regmap_raw_write_impl(struct regmap *map, unsigned int reg,
 			win_residue = range->window_len - win_offset;
 		}
 
-		ret = _regmap_select_page(map, &reg, range, val_num);
+		ret = _regmap_select_page(map, &reg, range, noinc ? 1 : val_num);
 		if (ret != 0)
 			return ret;
 	}
@@ -1749,7 +1749,8 @@ static int _regmap_bus_raw_write(void *context, unsigned int reg,
 				      map->work_buf +
 				      map->format.reg_bytes +
 				      map->format.pad_bytes,
-				      map->format.val_bytes);
+				      map->format.val_bytes,
+				      false);
 }
 
 static inline void *_regmap_map_get_context(struct regmap *map)
@@ -1843,7 +1844,7 @@ int regmap_write_async(struct regmap *map, unsigned int reg, unsigned int val)
 EXPORT_SYMBOL_GPL(regmap_write_async);
 
 int _regmap_raw_write(struct regmap *map, unsigned int reg,
-		      const void *val, size_t val_len)
+		      const void *val, size_t val_len, bool noinc)
 {
 	size_t val_bytes = map->format.val_bytes;
 	size_t val_count = val_len / val_bytes;
@@ -1864,7 +1865,7 @@ int _regmap_raw_write(struct regmap *map, unsigned int reg,
 
 	/* Write as many bytes as possible with chunk_size */
 	for (i = 0; i < chunk_count; i++) {
-		ret = _regmap_raw_write_impl(map, reg, val, chunk_bytes);
+		ret = _regmap_raw_write_impl(map, reg, val, chunk_bytes, noinc);
 		if (ret)
 			return ret;
 
@@ -1875,7 +1876,7 @@ int _regmap_raw_write(struct regmap *map, unsigned int reg,
 
 	/* Write remaining bytes */
 	if (val_len)
-		ret = _regmap_raw_write_impl(map, reg, val, val_len);
+		ret = _regmap_raw_write_impl(map, reg, val, val_len, noinc);
 
 	return ret;
 }
@@ -1908,7 +1909,7 @@ int regmap_raw_write(struct regmap *map, unsigned int reg,
 
 	map->lock(map->lock_arg);
 
-	ret = _regmap_raw_write(map, reg, val, val_len);
+	ret = _regmap_raw_write(map, reg, val, val_len, false);
 
 	map->unlock(map->lock_arg);
 
@@ -1966,7 +1967,7 @@ int regmap_noinc_write(struct regmap *map, unsigned int reg,
 			write_len = map->max_raw_write;
 		else
 			write_len = val_len;
-		ret = _regmap_raw_write(map, reg, val, write_len);
+		ret = _regmap_raw_write(map, reg, val, write_len, true);
 		if (ret)
 			goto out_unlock;
 		val = ((u8 *)val) + write_len;
@@ -2443,7 +2444,7 @@ int regmap_raw_write_async(struct regmap *map, unsigned int reg,
 
 	map->async = true;
 
-	ret = _regmap_raw_write(map, reg, val, val_len);
+	ret = _regmap_raw_write(map, reg, val, val_len, false);
 
 	map->async = false;
 
-- 
2.25.1




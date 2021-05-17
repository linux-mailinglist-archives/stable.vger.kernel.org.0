Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 924B6383424
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:05:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241712AbhEQPFg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:05:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:34300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242580AbhEQPD6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 11:03:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 22EB161A2D;
        Mon, 17 May 2021 14:28:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621261686;
        bh=ouWKma5hiW3rzLKl5d4oGwHRPdUEefIsJAcZnNT3+QY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CiHUuF3OD+NgK4ij5pBjElZYJ8i6ZSHgUoF8KfzUG0T9jloLW3Fo/QpTiPu/BuuMI
         7n+Tz5al8CaaUhrdu4GJoIj6Q3tVr+pj3LXFaSWmS8kDOCld9nV8TRQekhjRbL5Him
         fucjkE5jePy7UT6mwDuxuO6eC8SJih6Qf2ORaV6k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guangqing Zhu <zhuguangqing83@gmail.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 150/329] thermal/drivers/tsens: Fix missing put_device error
Date:   Mon, 17 May 2021 16:01:01 +0200
Message-Id: <20210517140307.185957821@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.043055203@linuxfoundation.org>
References: <20210517140302.043055203@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guangqing Zhu <zhuguangqing83@gmail.com>

[ Upstream commit f4136863e8899fa0554343201b78b9e197c78a78 ]

Fixes coccicheck error:

drivers/thermal/qcom/tsens.c:759:4-10: ERROR: missing put_device; call
of_find_device_by_node on line 715, but without a corresponding object
release within this function.

Fixes: a7ff82976122 ("drivers: thermal: tsens: Merge tsens-common.c into tsens.c")
Signed-off-by: Guangqing Zhu <zhuguangqing83@gmail.com>
Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Link: https://lore.kernel.org/r/20210404125431.12208-1-zhuguangqing83@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/qcom/tsens.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/thermal/qcom/tsens.c b/drivers/thermal/qcom/tsens.c
index d8ce3a687b80..3c4c0516e58a 100644
--- a/drivers/thermal/qcom/tsens.c
+++ b/drivers/thermal/qcom/tsens.c
@@ -755,8 +755,10 @@ int __init init_common(struct tsens_priv *priv)
 		for (i = VER_MAJOR; i <= VER_STEP; i++) {
 			priv->rf[i] = devm_regmap_field_alloc(dev, priv->srot_map,
 							      priv->fields[i]);
-			if (IS_ERR(priv->rf[i]))
-				return PTR_ERR(priv->rf[i]);
+			if (IS_ERR(priv->rf[i])) {
+				ret = PTR_ERR(priv->rf[i]);
+				goto err_put_device;
+			}
 		}
 		ret = regmap_field_read(priv->rf[VER_MINOR], &ver_minor);
 		if (ret)
-- 
2.30.2




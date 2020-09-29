Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 818A227CAFB
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:24:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732605AbgI2MXn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 08:23:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:50310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729769AbgI2LfJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:35:09 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D053423C83;
        Tue, 29 Sep 2020 11:28:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601378915;
        bh=x8otqe658uFEM+ovxAz7zRbLHXxEy6UTkVWx/+qbFLo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ytkfp3K+AFKf8G9LOXfj5SVzjZl5KcGbjMKSqaDzSep2ZhOzljQ5LmoObchz2iPLo
         NYD1rg9/dZR9Pd5fN7qqOsL6QcCChuEymobfWs2X7KsK3DdqyCLl+lLN6O+Fi/1VCZ
         XGsU4acxFHQ7qlBsx+SlQ/LITjWqGDJGGJhgdL0E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Tony Lindgren <tony@atomide.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 186/245] wlcore: fix runtime pm imbalance in wlcore_regdomain_config
Date:   Tue, 29 Sep 2020 13:00:37 +0200
Message-Id: <20200929105956.026303192@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105946.978650816@linuxfoundation.org>
References: <20200929105946.978650816@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dinghao Liu <dinghao.liu@zju.edu.cn>

[ Upstream commit 282a04bf1d8029eb98585cb5db3fd70fe8bc91f7 ]

pm_runtime_get_sync() increments the runtime PM usage counter even
the call returns an error code. Thus a pairing decrement is needed
on the error handling path to keep the counter balanced.

Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
Acked-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20200520124649.10848-1-dinghao.liu@zju.edu.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ti/wlcore/main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 2ca5658bbc2ab..43c7b37dec0c9 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -3671,8 +3671,10 @@ void wlcore_regdomain_config(struct wl1271 *wl)
 		goto out;
 
 	ret = pm_runtime_get_sync(wl->dev);
-	if (ret < 0)
+	if (ret < 0) {
+		pm_runtime_put_autosuspend(wl->dev);
 		goto out;
+	}
 
 	ret = wlcore_cmd_regdomain_config_locked(wl);
 	if (ret < 0) {
-- 
2.25.1




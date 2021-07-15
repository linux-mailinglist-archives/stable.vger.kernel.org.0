Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AD1A3CA5C0
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 20:41:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231407AbhGOSoT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 14:44:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:44436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231739AbhGOSoS (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 14:44:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 79E0561396;
        Thu, 15 Jul 2021 18:41:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626374484;
        bh=ZP1acyJ8uDVnQc1RK57kx3rIAh4r8Qwak6pgb9sNWd8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N68uiY6lFCH5Xgjmzc6x+aGeLUSZe0Ee/IrdFfhC0Dt7MWiu9vvGlxwv3eRfveNiV
         X5Fv3lk1HdAd2eO48WiFdeOOvZ9G/Ynp17zG0dYf2DuEP3QSTcDrDrT3ZOWZqm84Lt
         BtGcMIlgEESluQHApwKdNJIP6VlCo4YXUNoD2uDA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Zou Wei <zou_wei@huawei.com>,
        Robert Foss <robert.foss@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 019/122] drm/bridge: cdns: Fix PM reference leak in cdns_dsi_transfer()
Date:   Thu, 15 Jul 2021 20:37:46 +0200
Message-Id: <20210715182454.406242802@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182448.393443551@linuxfoundation.org>
References: <20210715182448.393443551@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zou Wei <zou_wei@huawei.com>

[ Upstream commit 33f90f27e1c5ccd648d3e78a1c28be9ee8791cf1 ]

pm_runtime_get_sync will increment pm usage counter even it failed.
Forgetting to putting operation will result in reference leak here.
Fix it by replacing it with pm_runtime_resume_and_get to keep usage
counter balanced.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zou Wei <zou_wei@huawei.com>
Reviewed-by: Robert Foss <robert.foss@linaro.org>
Signed-off-by: Robert Foss <robert.foss@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/1621840862-106024-1-git-send-email-zou_wei@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/cdns-dsi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/bridge/cdns-dsi.c b/drivers/gpu/drm/bridge/cdns-dsi.c
index 6166dca6be81..0cb9dd6986ec 100644
--- a/drivers/gpu/drm/bridge/cdns-dsi.c
+++ b/drivers/gpu/drm/bridge/cdns-dsi.c
@@ -1026,7 +1026,7 @@ static ssize_t cdns_dsi_transfer(struct mipi_dsi_host *host,
 	struct mipi_dsi_packet packet;
 	int ret, i, tx_len, rx_len;
 
-	ret = pm_runtime_get_sync(host->dev);
+	ret = pm_runtime_resume_and_get(host->dev);
 	if (ret < 0)
 		return ret;
 
-- 
2.30.2




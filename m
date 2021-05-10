Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FCB937843C
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 12:50:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232097AbhEJKvR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 06:51:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:58338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232473AbhEJKsj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:48:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DB0C2619C5;
        Mon, 10 May 2021 10:38:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620643084;
        bh=9nmZ9Pr/nDgFEeeAliQu9uMjuWaXNj3UsCrrHaNqzEs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Oyyz85878UgVhy9tvnIWNZV+QUBz2m3I82rZ4cR4jrMyLoDPEIRYiEV89MxGopPFu
         5TSOEN1wMkFdiKcWxV+AFApXfzXB7NhkZUUrd2KCIBdnxgPhoF8zfEkyCTtmUOSIRG
         H8hqWJc1H5KxagYL7xGAk5yRCbew8bRMRPwpGhKA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Abhinav Kumar <abhinavk@codeaurora.org>,
        Stephen Boyd <swboyd@chromium.org>,
        Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 172/299] drm/msm/dp: Fix incorrect NULL check kbot warnings in DP driver
Date:   Mon, 10 May 2021 12:19:29 +0200
Message-Id: <20210510102010.642657145@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102004.821838356@linuxfoundation.org>
References: <20210510102004.821838356@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Abhinav Kumar <abhinavk@codeaurora.org>

[ Upstream commit 7d649cfe0314aad2ba18042885ab9de2f13ad809 ]

Fix an incorrect NULL check reported by kbot in the MSM DP driver

smatch warnings:
drivers/gpu/drm/msm/dp/dp_hpd.c:37 dp_hpd_connect()
error: we previously assumed 'hpd_priv->dp_cb' could be null
(see line 37)

Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Abhinav Kumar <abhinavk@codeaurora.org>
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Link: https://lore.kernel.org/r/1614971839-2686-2-git-send-email-abhinavk@codeaurora.org
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/dp/dp_hpd.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/msm/dp/dp_hpd.c b/drivers/gpu/drm/msm/dp/dp_hpd.c
index 5b8fe32022b5..e1c90fa47411 100644
--- a/drivers/gpu/drm/msm/dp/dp_hpd.c
+++ b/drivers/gpu/drm/msm/dp/dp_hpd.c
@@ -34,8 +34,8 @@ int dp_hpd_connect(struct dp_usbpd *dp_usbpd, bool hpd)
 
 	dp_usbpd->hpd_high = hpd;
 
-	if (!hpd_priv->dp_cb && !hpd_priv->dp_cb->configure
-				&& !hpd_priv->dp_cb->disconnect) {
+	if (!hpd_priv->dp_cb || !hpd_priv->dp_cb->configure
+				|| !hpd_priv->dp_cb->disconnect) {
 		pr_err("hpd dp_cb not initialized\n");
 		return -EINVAL;
 	}
-- 
2.30.2




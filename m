Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1AAC3DD9CF
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 16:04:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236068AbhHBOEI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 10:04:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:49734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236302AbhHBOCH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Aug 2021 10:02:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 80505611C2;
        Mon,  2 Aug 2021 13:56:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627912612;
        bh=Yj+sF086lLxa8S5z6mau3gg85c58/w+d7h3K2wjLdTQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WbuYOyKAC4+O/vYURTYrSj4FxGRpWSulfJFvBW/q2mW3+7NiLtQRfgzH+A8CGHaNG
         btNlm/7bwiWH7+pUUNeUcOASTAMAK88yEZyC3QdcexbrbSfzGaj7qtT0mDDkenxuBa
         w34Wmw4d0GUxIYfQXoK7n43XbMBNWX4iX5upH/YY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuogee Hsieh <khsieh@codeaurora.org>,
        Stephen Boyd <swboyd@chromium.org>,
        Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 071/104] drm/msm/dp: use dp_ctrl_off_link_stream during PHY compliance test run
Date:   Mon,  2 Aug 2021 15:45:08 +0200
Message-Id: <20210802134346.348569758@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210802134344.028226640@linuxfoundation.org>
References: <20210802134344.028226640@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kuogee Hsieh <khsieh@codeaurora.org>

[ Upstream commit 7591c532b818ef4b8e3e635d842547c08b3a32b4 ]

DP cable should always connect to DPU during the entire PHY compliance
testing run. Since DP PHY compliance test is executed at irq_hpd event
context, dp_ctrl_off_link_stream() should be used instead of dp_ctrl_off().
dp_ctrl_off() is used for unplug event which is triggered when DP cable is
dis connected.

Changes in V2:
-- add fixes statement

Fixes: f21c8a276c2d ("drm/msm/dp: handle irq_hpd with sink_count = 0 correctly")

Signed-off-by: Kuogee Hsieh <khsieh@codeaurora.org>
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Link: https://lore.kernel.org/r/1626191647-13901-2-git-send-email-khsieh@codeaurora.org
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/dp/dp_ctrl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/dp/dp_ctrl.c b/drivers/gpu/drm/msm/dp/dp_ctrl.c
index 2a8955ca70d1..6856223e91e1 100644
--- a/drivers/gpu/drm/msm/dp/dp_ctrl.c
+++ b/drivers/gpu/drm/msm/dp/dp_ctrl.c
@@ -1528,7 +1528,7 @@ static int dp_ctrl_process_phy_test_request(struct dp_ctrl_private *ctrl)
 	 * running. Add the global reset just before disabling the
 	 * link clocks and core clocks.
 	 */
-	ret = dp_ctrl_off(&ctrl->dp_ctrl);
+	ret = dp_ctrl_off_link_stream(&ctrl->dp_ctrl);
 	if (ret) {
 		DRM_ERROR("failed to disable DP controller\n");
 		return ret;
-- 
2.30.2




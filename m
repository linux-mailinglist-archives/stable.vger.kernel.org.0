Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21F0E8C827
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 04:30:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727721AbfHNCRJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Aug 2019 22:17:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:48482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727624AbfHNCRI (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 13 Aug 2019 22:17:08 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A608720843;
        Wed, 14 Aug 2019 02:17:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565749027;
        bh=R9b0WmDUwLwfCrk+r4uWJfaX5hpfWv/qraTPHwJeGe0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O66RaF7PsGYE0us4sQv0XR+7vGCXuVY0w74XGDdpbDrz2JVMbiAflA7Mq7zS5qUUB
         MQJgPvsfZoey6w7RGsSGucsX74U/bUxh/+xqwU1FS9w1Ljvc+OTOsrj+JKGX+hoFaB
         NLnSdr9MMOCRPN3LmfTv6RQ+0nRU3+xbagc9ElMY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Douglas Anderson <dianders@chromium.org>,
        Sean Paul <seanpaul@chromium.org>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org, linux-rockchip@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 45/68] drm/rockchip: Suspend DP late
Date:   Tue, 13 Aug 2019 22:15:23 -0400
Message-Id: <20190814021548.16001-45-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190814021548.16001-1-sashal@kernel.org>
References: <20190814021548.16001-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Douglas Anderson <dianders@chromium.org>

[ Upstream commit f7ccbed656f78212593ca965d9a8f34bf24e0aab ]

In commit fe64ba5c6323 ("drm/rockchip: Resume DP early") we moved
resume to be early but left suspend at its normal time.  This seems
like it could be OK, but casues problems if a suspend gets interrupted
partway through.  The OS only balances matching suspend/resume levels.
...so if suspend was called then resume will be called.  If suspend
late was called then resume early will be called.  ...but if suspend
was called resume early might not get called.  This leads to an
unbalance in the clock enables / disables.

Lets take the simple fix and just move suspend to be late to match.
This makes the PM core take proper care in keeping things balanced.

Fixes: fe64ba5c6323 ("drm/rockchip: Resume DP early")
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Sean Paul <seanpaul@chromium.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20190802184616.44822-1-dianders@chromium.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/rockchip/analogix_dp-rockchip.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/rockchip/analogix_dp-rockchip.c b/drivers/gpu/drm/rockchip/analogix_dp-rockchip.c
index 080f053521950..6a4da3a0ff1c3 100644
--- a/drivers/gpu/drm/rockchip/analogix_dp-rockchip.c
+++ b/drivers/gpu/drm/rockchip/analogix_dp-rockchip.c
@@ -436,7 +436,7 @@ static int rockchip_dp_resume(struct device *dev)
 
 static const struct dev_pm_ops rockchip_dp_pm_ops = {
 #ifdef CONFIG_PM_SLEEP
-	.suspend = rockchip_dp_suspend,
+	.suspend_late = rockchip_dp_suspend,
 	.resume_early = rockchip_dp_resume,
 #endif
 };
-- 
2.20.1


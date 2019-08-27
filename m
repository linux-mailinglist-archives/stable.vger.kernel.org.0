Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B8C69E127
	for <lists+stable@lfdr.de>; Tue, 27 Aug 2019 10:10:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731687AbfH0IC4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Aug 2019 04:02:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:60188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732105AbfH0ICz (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Aug 2019 04:02:55 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 92666206BA;
        Tue, 27 Aug 2019 08:02:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566892974;
        bh=gMSsurQFK8yP6ao5WbTqBX6EiVu1X4UoGWIWom96rp0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XfZZ4Aa1m5FkY1FvMTcxSaL+78NvBCcopsRlCQIC9ZUqhhYV4kV7luSE0O0vNZamE
         sQySBcpyD4GUGAp3B0bTKqJ1JFvS6qdJ1cCZEJa01shGDhhxv9CPGnvHU+FKsFGF2h
         0RQj9Q4qRPN21kpvrfSmqEEQNMb/5gB28K7RemOE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Douglas Anderson <dianders@chromium.org>,
        Sean Paul <seanpaul@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 079/162] drm/rockchip: Suspend DP late
Date:   Tue, 27 Aug 2019 09:50:07 +0200
Message-Id: <20190827072740.863064218@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190827072738.093683223@linuxfoundation.org>
References: <20190827072738.093683223@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
index 95e5c517a15f7..9aae3d8e99ef4 100644
--- a/drivers/gpu/drm/rockchip/analogix_dp-rockchip.c
+++ b/drivers/gpu/drm/rockchip/analogix_dp-rockchip.c
@@ -432,7 +432,7 @@ static int rockchip_dp_resume(struct device *dev)
 
 static const struct dev_pm_ops rockchip_dp_pm_ops = {
 #ifdef CONFIG_PM_SLEEP
-	.suspend = rockchip_dp_suspend,
+	.suspend_late = rockchip_dp_suspend,
 	.resume_early = rockchip_dp_resume,
 #endif
 };
-- 
2.20.1




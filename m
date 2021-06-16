Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9377B3A9F6A
	for <lists+stable@lfdr.de>; Wed, 16 Jun 2021 17:36:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234990AbhFPPh5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Jun 2021 11:37:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:50548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234795AbhFPPhP (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Jun 2021 11:37:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6DBD0613C7;
        Wed, 16 Jun 2021 15:35:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623857708;
        bh=2TA4mXyXBZTlwjWBvvI9jvsDye+jGINjkSVK96VzFJU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LlIuhk1R42t9Lher8lBcBHLure8rgJYA5tVkwk66GbO4PsdURnDHx+qyoumgR+X/D
         gdT3qrZeGkfARi0MdJL4kFigVyCT8ZmzQNTgRpMz+EfgwHHaGSjhyrlKCooLyEqIYX
         xYpH1ASDeZSBVRfBcYQjPx8uEGv6TtwykggvFzdA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Pavel Machek (CIP)" <pavel@denx.de>,
        Thierry Reding <treding@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 09/28] drm/tegra: sor: Do not leak runtime PM reference
Date:   Wed, 16 Jun 2021 17:33:20 +0200
Message-Id: <20210616152834.446161526@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210616152834.149064097@linuxfoundation.org>
References: <20210616152834.149064097@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Machek (CIP) <pavel@denx.de>

[ Upstream commit 73a395c46704304b96bc5e2ee19be31124025c0c ]

It's theoretically possible for the runtime PM reference to leak if the
code fails anywhere between the pm_runtime_resume_and_get() and
pm_runtime_put() calls, so make sure to release the runtime PM reference
in that case.

Practically this will never happen because none of the functions will
fail on Tegra, but it's better for the code to be pedantic in case these
assumptions will ever become wrong.

Signed-off-by: Pavel Machek (CIP) <pavel@denx.de>
[treding@nvidia.com: add commit message]
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/tegra/sor.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/tegra/sor.c b/drivers/gpu/drm/tegra/sor.c
index 6c3d22165239..0419b6105c8a 100644
--- a/drivers/gpu/drm/tegra/sor.c
+++ b/drivers/gpu/drm/tegra/sor.c
@@ -2875,21 +2875,21 @@ static int tegra_sor_init(struct host1x_client *client)
 		if (err < 0) {
 			dev_err(sor->dev, "failed to acquire SOR reset: %d\n",
 				err);
-			return err;
+			goto rpm_put;
 		}
 
 		err = reset_control_assert(sor->rst);
 		if (err < 0) {
 			dev_err(sor->dev, "failed to assert SOR reset: %d\n",
 				err);
-			return err;
+			goto rpm_put;
 		}
 	}
 
 	err = clk_prepare_enable(sor->clk);
 	if (err < 0) {
 		dev_err(sor->dev, "failed to enable clock: %d\n", err);
-		return err;
+		goto rpm_put;
 	}
 
 	usleep_range(1000, 3000);
@@ -2900,7 +2900,7 @@ static int tegra_sor_init(struct host1x_client *client)
 			dev_err(sor->dev, "failed to deassert SOR reset: %d\n",
 				err);
 			clk_disable_unprepare(sor->clk);
-			return err;
+			goto rpm_put;
 		}
 
 		reset_control_release(sor->rst);
@@ -2929,6 +2929,12 @@ static int tegra_sor_init(struct host1x_client *client)
 	tegra_sor_writel(sor, value, SOR_INT_MASK);
 
 	return 0;
+
+rpm_put:
+	if (sor->rst)
+		pm_runtime_put(sor->dev);
+
+	return err;
 }
 
 static int tegra_sor_exit(struct host1x_client *client)
-- 
2.30.2




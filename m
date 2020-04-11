Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBF911A5714
	for <lists+stable@lfdr.de>; Sun, 12 Apr 2020 01:20:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727831AbgDKXU3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Apr 2020 19:20:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:55016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730523AbgDKXNl (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Apr 2020 19:13:41 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1EB95215A4;
        Sat, 11 Apr 2020 23:13:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586646821;
        bh=1f0C9+h3Ca875KB6G7eOrSbb0hcwgHXQUUmOxZgbUVM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cYLEWoJj9jA9e6VIszTMrTlVXsw4qM1jgSNQ0vJzI7H/EBYQuZP05fF1jbfPh6tVX
         /5pVlho0raQsXn3dctMaJCTDEHmtVN+L31Ph343uYNzLMSmSn2uBF6TkP0EmkiiLbf
         VOM4keqnhcALpXx4jR38jhZM3K4vDSD3vHrAIH14=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dmitry Osipenko <digetx@gmail.com>,
        Thierry Reding <treding@nvidia.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org, linux-tegra@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 12/37] drm/tegra: dc: Release PM and RGB output when client's registration fails
Date:   Sat, 11 Apr 2020 19:13:01 -0400
Message-Id: <20200411231327.26550-12-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200411231327.26550-1-sashal@kernel.org>
References: <20200411231327.26550-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Osipenko <digetx@gmail.com>

[ Upstream commit 0411ea89a689531e1829fdf8af3747646c02c721 ]

Runtime PM and RGB output need to be released when host1x client
registration fails. The releasing is missed in the code, let's correct it.

Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/tegra/dc.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/tegra/dc.c b/drivers/gpu/drm/tegra/dc.c
index 4df39112e38ec..176fb9a40ddf9 100644
--- a/drivers/gpu/drm/tegra/dc.c
+++ b/drivers/gpu/drm/tegra/dc.c
@@ -2059,10 +2059,16 @@ static int tegra_dc_probe(struct platform_device *pdev)
 	if (err < 0) {
 		dev_err(&pdev->dev, "failed to register host1x client: %d\n",
 			err);
-		return err;
+		goto disable_pm;
 	}
 
 	return 0;
+
+disable_pm:
+	pm_runtime_disable(&pdev->dev);
+	tegra_dc_rgb_remove(dc);
+
+	return err;
 }
 
 static int tegra_dc_remove(struct platform_device *pdev)
-- 
2.20.1


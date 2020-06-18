Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9617B1FE208
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 03:59:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731113AbgFRB6c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 21:58:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:59630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731289AbgFRBYv (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:24:51 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EF77F21974;
        Thu, 18 Jun 2020 01:24:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592443491;
        bh=iUc/GN+5ZpqakFuu/t3oXtaFHF2zHmLqIPuR7EGbeYg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HVyFoOEkTfCSUl9TOZPpNtES6aJ5CuRTc+tifLUOyZb4smBXwLlTS/kDt19F53xtt
         twYZFhwrYahUI30mVzYxWJZGqALWNjxTZwbBAeZ1vgwM8y3bbDUE3zsd2lEj2iz3Ys
         gvitFfbhEvvrz5XvK8yy86/JB5RJm+1z26tOdAwE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Qiushi Wu <wu000273@umn.edu>, Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 4.19 119/172] ASoC: fix incomplete error-handling in img_i2s_in_probe.
Date:   Wed, 17 Jun 2020 21:21:25 -0400
Message-Id: <20200618012218.607130-119-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618012218.607130-1-sashal@kernel.org>
References: <20200618012218.607130-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qiushi Wu <wu000273@umn.edu>

[ Upstream commit 25bf943e4e7b47282bd86ae7d39e039217ebb007 ]

Function "pm_runtime_get_sync()" is not handled by "pm_runtime_put()"
if "PTR_ERR(rst) == -EPROBE_DEFER". Fix this issue by adding
"pm_runtime_put()" into this error path.

Fixes: f65bb92ca12e ("ASoC: img-i2s-in: Add runtime PM")
Signed-off-by: Qiushi Wu <wu000273@umn.edu>
Link: https://lore.kernel.org/r/20200525055011.31925-1-wu000273@umn.edu
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/img/img-i2s-in.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/img/img-i2s-in.c b/sound/soc/img/img-i2s-in.c
index 388cefd7340a..c22880aea82a 100644
--- a/sound/soc/img/img-i2s-in.c
+++ b/sound/soc/img/img-i2s-in.c
@@ -485,6 +485,7 @@ static int img_i2s_in_probe(struct platform_device *pdev)
 	if (IS_ERR(rst)) {
 		if (PTR_ERR(rst) == -EPROBE_DEFER) {
 			ret = -EPROBE_DEFER;
+			pm_runtime_put(&pdev->dev);
 			goto err_suspend;
 		}
 
-- 
2.25.1


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 590ED3A84A4
	for <lists+stable@lfdr.de>; Tue, 15 Jun 2021 17:49:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231889AbhFOPv0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Jun 2021 11:51:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:45708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231869AbhFOPvO (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Jun 2021 11:51:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 68F7361628;
        Tue, 15 Jun 2021 15:49:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623772150;
        bh=UkDxa+fl9rFOLo1Io0faeV/fqWbjlXYKuHxxv5ocWTY=;
        h=From:To:Cc:Subject:Date:From;
        b=moUHnt1I3GMQCvNtnnG7jIRKTNDm8bpHisC7DbijLnDtNS+k42d0xAM7thDJxhRdA
         PsvgSXzVhHr56PTD1zfwcikHOTEcUsIHUQPSe6wyyEReA9McAuI3fNc8C1VHJmyzXU
         5+lod0kTbjJLs/qx28wOXfhwnMKyG9nXapVsdmKu7z6GUe8fnBVRDyouDGCAvLgter
         B/2BI++NpBNTSrDluVpF/hWPGpEq5NTkNoVFm/omkaly97AunAoogM9aj7H9zvXVq+
         BucieTTjqrC0lgdxGmJdJdGGizqutOGI7Yk/HtKi7cr32YptNGeBQmdbGn9/HQH0Jh
         nsGdHeIxnTjsA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Axel Lin <axel.lin@ingics.com>, Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.10 01/30] regulator: cros-ec: Fix error code in dev_err message
Date:   Tue, 15 Jun 2021 11:48:38 -0400
Message-Id: <20210615154908.62388-1-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Axel Lin <axel.lin@ingics.com>

[ Upstream commit 3d681804efcb6e5d8089a433402e19179347d7ae ]

Show proper error code instead of 0.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
Link: https://lore.kernel.org/r/20210512075824.620580-1-axel.lin@ingics.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/cros-ec-regulator.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/regulator/cros-ec-regulator.c b/drivers/regulator/cros-ec-regulator.c
index eb3fc1db4edc..c4754f3cf233 100644
--- a/drivers/regulator/cros-ec-regulator.c
+++ b/drivers/regulator/cros-ec-regulator.c
@@ -225,8 +225,9 @@ static int cros_ec_regulator_probe(struct platform_device *pdev)
 
 	drvdata->dev = devm_regulator_register(dev, &drvdata->desc, &cfg);
 	if (IS_ERR(drvdata->dev)) {
+		ret = PTR_ERR(drvdata->dev);
 		dev_err(&pdev->dev, "Failed to register regulator: %d\n", ret);
-		return PTR_ERR(drvdata->dev);
+		return ret;
 	}
 
 	platform_set_drvdata(pdev, drvdata);
-- 
2.30.2


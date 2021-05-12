Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1139237C85F
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:42:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234282AbhELQIT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:08:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:49158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236676AbhELQCO (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:02:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 01F8961CD8;
        Wed, 12 May 2021 15:33:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620833612;
        bh=sk39f7BcW7qfsEqn3oDJHypA/aw9+AGbHS6rNghlAc0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ABdgBHwc7+Ebp5yVWi6RpZHAz6SQH/Q3OOcyekqhwqX6oZgRRf2UeOGjz5YgrXIxQ
         ATDlSVxYcdBeqfiQRDjGitd2ouWPvqGdb0Nzbt20fCc6pSonppTAVKsxqW16GdFiP8
         poiokuRySIAoTkwLbURS29o8KVsa5bWVjjDE9bPg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 185/601] regulator: bd9576: Fix return from bd957x_probe()
Date:   Wed, 12 May 2021 16:44:22 +0200
Message-Id: <20210512144833.932772993@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 320fcd6bbd2b500923db518902c2c640242d2b50 ]

The probe() function returns an uninitialized variable in the success
path.  There is no need for the "err" variable at all, just delete it.

Fixes: b014e9fae7e7 ("regulator: Support ROHM BD9576MUF and BD9573MUF")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>
Link: https://lore.kernel.org/r/YEsbfLJfEWtnRpoU@mwanda
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/bd9576-regulator.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/regulator/bd9576-regulator.c b/drivers/regulator/bd9576-regulator.c
index a8b5832a5a1b..204a2da054f5 100644
--- a/drivers/regulator/bd9576-regulator.c
+++ b/drivers/regulator/bd9576-regulator.c
@@ -206,7 +206,7 @@ static int bd957x_probe(struct platform_device *pdev)
 {
 	struct regmap *regmap;
 	struct regulator_config config = { 0 };
-	int i, err;
+	int i;
 	bool vout_mode, ddr_sel;
 	const struct bd957x_regulator_data *reg_data = &bd9576_regulators[0];
 	unsigned int num_reg_data = ARRAY_SIZE(bd9576_regulators);
@@ -279,8 +279,7 @@ static int bd957x_probe(struct platform_device *pdev)
 		break;
 	default:
 		dev_err(&pdev->dev, "Unsupported chip type\n");
-		err = -EINVAL;
-		goto err;
+		return -EINVAL;
 	}
 
 	config.dev = pdev->dev.parent;
@@ -300,8 +299,7 @@ static int bd957x_probe(struct platform_device *pdev)
 			dev_err(&pdev->dev,
 				"failed to register %s regulator\n",
 				desc->name);
-			err = PTR_ERR(rdev);
-			goto err;
+			return PTR_ERR(rdev);
 		}
 		/*
 		 * Clear the VOUT1 GPIO setting - rest of the regulators do not
@@ -310,8 +308,7 @@ static int bd957x_probe(struct platform_device *pdev)
 		config.ena_gpiod = NULL;
 	}
 
-err:
-	return err;
+	return 0;
 }
 
 static const struct platform_device_id bd957x_pmic_id[] = {
-- 
2.30.2




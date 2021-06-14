Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E4553A6437
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 13:21:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233394AbhFNLVx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 07:21:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:49422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235946AbhFNLTw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 07:19:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6C27360FF1;
        Mon, 14 Jun 2021 10:51:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623667893;
        bh=4yqS63Nlty9BQgN5/vRi8CSRUdAiStEWYbVkTK3ky20=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FSFcaAzyqsHhhDO4zsnAKQ887axNgjlwtweSguLB4y7bTvgF+3LsD6noZw3C7w3ig
         iQcaDP2MHOM1X7BgbFm6nKPQ1AhsKtyT/0iYVDTqC9ulkgR9KvoElqqETTGhBBjgYJ
         zwSUIUuT6hQJVtKhyqqDT7AFjS/3y4/Iy7PcLdEA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Axel Lin <axel.lin@ingics.com>,
        Adam Ward <Adam.Ward.opensource@diasemi.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.12 116/173] regulator: da9121: Return REGULATOR_MODE_INVALID for invalid mode
Date:   Mon, 14 Jun 2021 12:27:28 +0200
Message-Id: <20210614102702.027710933@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102658.137943264@linuxfoundation.org>
References: <20210614102658.137943264@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Axel Lin <axel.lin@ingics.com>

commit 0b1e552673724832b08d49037cdeeac634a3b319 upstream.

-EINVAL is not a valid return value for .of_map_mode, return
REGULATOR_MODE_INVALID instead.

Fixes: 65ac97042d4e ("regulator: da9121: add mode support")
Signed-off-by: Axel Lin <axel.lin@ingics.com>
Acked-by: Adam Ward <Adam.Ward.opensource@diasemi.com>
Link: https://lore.kernel.org/r/20210517052721.1063375-1-axel.lin@ingics.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/regulator/da9121-regulator.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/drivers/regulator/da9121-regulator.c
+++ b/drivers/regulator/da9121-regulator.c
@@ -280,7 +280,7 @@ static unsigned int da9121_map_mode(unsi
 	case DA9121_BUCK_MODE_FORCE_PFM:
 		return REGULATOR_MODE_STANDBY;
 	default:
-		return -EINVAL;
+		return REGULATOR_MODE_INVALID;
 	}
 }
 
@@ -317,7 +317,7 @@ static unsigned int da9121_buck_get_mode
 {
 	struct da9121 *chip = rdev_get_drvdata(rdev);
 	int id = rdev_get_id(rdev);
-	unsigned int val;
+	unsigned int val, mode;
 	int ret = 0;
 
 	ret = regmap_read(chip->regmap, da9121_mode_field[id].reg, &val);
@@ -326,7 +326,11 @@ static unsigned int da9121_buck_get_mode
 		return -EINVAL;
 	}
 
-	return da9121_map_mode(val & da9121_mode_field[id].msk);
+	mode = da9121_map_mode(val & da9121_mode_field[id].msk);
+	if (mode == REGULATOR_MODE_INVALID)
+		return -EINVAL;
+
+	return mode;
 }
 
 static const struct regulator_ops da9121_buck_ops = {



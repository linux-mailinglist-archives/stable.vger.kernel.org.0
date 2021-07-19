Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A5A73CDCF2
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:35:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239460AbhGSOyV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:54:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:45208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237679AbhGSOwI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:52:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D54FD61222;
        Mon, 19 Jul 2021 15:32:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626708735;
        bh=oELBDiCkfRqdOuU0PT4sHdy7R3CRpNSQfTPY0Vfv2u0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J5tempMgwVVmQBBbpShtrJt6ACuPloYDUNtmpyaYxay0MNS3ULU7fb4WK9WlKnVo3
         yOyF2f/0AniwbP6QVKnGoAyNpmWjG5YVS83x3o6qLdowZ6tEHY8nzyq2QBPwPFn6UL
         zqxrsgNqkzEoosmIoH8DzQIq/Ti3orMVUuwU7Xec=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Axel Lin <axel.lin@ingics.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 076/421] regulator: da9052: Ensure enough delay time for .set_voltage_time_sel
Date:   Mon, 19 Jul 2021 16:48:07 +0200
Message-Id: <20210719144948.782814294@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144946.310399455@linuxfoundation.org>
References: <20210719144946.310399455@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Axel Lin <axel.lin@ingics.com>

[ Upstream commit a336dc8f683e5be794186b5643cd34cb28dd2c53 ]

Use DIV_ROUND_UP to prevent truncation by integer division issue.
This ensures we return enough delay time.

Also fix returning negative value when new_sel < old_sel.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
Link: https://lore.kernel.org/r/20210618141412.4014912-1-axel.lin@ingics.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/da9052-regulator.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/regulator/da9052-regulator.c b/drivers/regulator/da9052-regulator.c
index 9ececfef42d6..bd91c95f73e0 100644
--- a/drivers/regulator/da9052-regulator.c
+++ b/drivers/regulator/da9052-regulator.c
@@ -258,7 +258,8 @@ static int da9052_regulator_set_voltage_time_sel(struct regulator_dev *rdev,
 	case DA9052_ID_BUCK3:
 	case DA9052_ID_LDO2:
 	case DA9052_ID_LDO3:
-		ret = (new_sel - old_sel) * info->step_uV / 6250;
+		ret = DIV_ROUND_UP(abs(new_sel - old_sel) * info->step_uV,
+				   6250);
 		break;
 	}
 
-- 
2.30.2




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDDF63C4C93
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:38:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242094AbhGLHGP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:06:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:39708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243053AbhGLHEY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:04:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2D0F061108;
        Mon, 12 Jul 2021 07:01:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626073296;
        bh=9vnRA3Wy++7LojlzO1B1ztaIrIE2VgJhbNw4DsA2KLA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Sl2epgwvmDjidku95jRMo165R9Q42v3xCEG9bytO52snohBytKjOAismqiYEZQJWO
         j31wg6DrRAO3f+U8waFaTvAA7FStd1W5RiPEnt95X7vzG/iC9eGba/eYp4iAauDc8d
         wlMuodQJoIWg4NUxNMK+UOcBURGlskJLS9I/6vyQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Axel Lin <axel.lin@ingics.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 193/700] regulator: da9052: Ensure enough delay time for .set_voltage_time_sel
Date:   Mon, 12 Jul 2021 08:04:36 +0200
Message-Id: <20210712060954.137653508@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
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
index e18d291c7f21..23fa429ebe76 100644
--- a/drivers/regulator/da9052-regulator.c
+++ b/drivers/regulator/da9052-regulator.c
@@ -250,7 +250,8 @@ static int da9052_regulator_set_voltage_time_sel(struct regulator_dev *rdev,
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




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF4A713E1FC
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 17:54:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730378AbgAPQwr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 11:52:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:36020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730358AbgAPQwq (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 11:52:46 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7899F2081E;
        Thu, 16 Jan 2020 16:52:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579193566;
        bh=r9Ny1NmrJ44xIrdA3H/UUfVyCoCXphiEt47Z1mkQlOw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wzejHrsSiOGr8J8DPP4jW9uOi+/u8So9rxxp9OGSrgYMnHt0mPiY/si+ZdJ+pWlcn
         VNgBRJITlnZNnWo2eEJoHJWW5CPsp7tNShYSe2RIF2ktBcS0CpoBdF9uopCFTtZrd8
         qYfz0Afczn4cl+CP3cOjmzS0UnKlP4D3711PHQVM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Stephan Gerhold <stephan@gerhold.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 110/205] regulator: ab8500: Remove SYSCLKREQ from enum ab8505_regulator_id
Date:   Thu, 16 Jan 2020 11:41:25 -0500
Message-Id: <20200116164300.6705-110-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116164300.6705-1-sashal@kernel.org>
References: <20200116164300.6705-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stephan Gerhold <stephan@gerhold.net>

[ Upstream commit 458ea3ad033fc86e291712ce50cbe60c3428cf30 ]

Those regulators are not actually supported by the AB8500 regulator
driver. There is no ab8500_regulator_info for them and no entry in
ab8505_regulator_match.

As such, they cannot be registered successfully, and looking them
up in ab8505_regulator_match causes an out-of-bounds array read.

Fixes: 547f384f33db ("regulator: ab8500: add support for ab8505")
Cc: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Stephan Gerhold <stephan@gerhold.net>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Link: https://lore.kernel.org/r/20191106173125.14496-2-stephan@gerhold.net
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/regulator/ab8500.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/include/linux/regulator/ab8500.h b/include/linux/regulator/ab8500.h
index 505e94a6e3e8..3ab1ddf151a2 100644
--- a/include/linux/regulator/ab8500.h
+++ b/include/linux/regulator/ab8500.h
@@ -42,8 +42,6 @@ enum ab8505_regulator_id {
 	AB8505_LDO_ANAMIC2,
 	AB8505_LDO_AUX8,
 	AB8505_LDO_ANA,
-	AB8505_SYSCLKREQ_2,
-	AB8505_SYSCLKREQ_4,
 	AB8505_NUM_REGULATORS,
 };
 
-- 
2.20.1


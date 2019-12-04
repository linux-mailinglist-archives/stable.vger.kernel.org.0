Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63E511132D9
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 19:15:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731594AbfLDSMZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Dec 2019 13:12:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:41054 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730664AbfLDSMZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Dec 2019 13:12:25 -0500
Received: from localhost (unknown [217.68.49.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8AAB120674;
        Wed,  4 Dec 2019 18:12:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575483145;
        bh=wHJe79NNS5CsHxiLb0Fd9Du263Rb0zhqLGb4CJ3nlQs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VlohIWxCClo2rupVkw8NgrJ9NjNBZg7iRKJW6BKEg4bH4J8uhrlN9L4mALgA6PRnC
         +Ix9VtK1ltqdPodUuFa95OYhyYQ9INUle9eE5ZPhFNL4B0WT4nOVeK+ve6PKkbmlNe
         PlcEz9ovCVV4FLfFzPLN1WB/d0dzPD8KvFR6DwwM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kangjie Lu <kjlu@umn.edu>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 069/125] regulator: tps65910: fix a missing check of return value
Date:   Wed,  4 Dec 2019 18:56:14 +0100
Message-Id: <20191204175323.179287296@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191204175308.377746305@linuxfoundation.org>
References: <20191204175308.377746305@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kangjie Lu <kjlu@umn.edu>

[ Upstream commit cd07e3701fa6a4c68f8493ee1d12caa18d46ec6a ]

tps65910_reg_set_bits() may fail. The fix checks if it fails, and if so,
returns with its error code.

Signed-off-by: Kangjie Lu <kjlu@umn.edu>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/tps65910-regulator.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/regulator/tps65910-regulator.c b/drivers/regulator/tps65910-regulator.c
index 696116ebdf50a..9cde7b0757011 100644
--- a/drivers/regulator/tps65910-regulator.c
+++ b/drivers/regulator/tps65910-regulator.c
@@ -1102,8 +1102,10 @@ static int tps65910_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, pmic);
 
 	/* Give control of all register to control port */
-	tps65910_reg_set_bits(pmic->mfd, TPS65910_DEVCTRL,
+	err = tps65910_reg_set_bits(pmic->mfd, TPS65910_DEVCTRL,
 				DEVCTRL_SR_CTL_I2C_SEL_MASK);
+	if (err < 0)
+		return err;
 
 	switch (tps65910_chip_id(tps65910)) {
 	case TPS65910:
-- 
2.20.1




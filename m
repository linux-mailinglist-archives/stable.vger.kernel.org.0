Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45576111D88
	for <lists+stable@lfdr.de>; Tue,  3 Dec 2019 23:55:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728560AbfLCWyd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:54:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:48354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730288AbfLCWy2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:54:28 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9F7F52053B;
        Tue,  3 Dec 2019 22:54:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575413668;
        bh=W70HprwceHM95eqhp/i6jc2jryBT4sBo1lOQnbLjKaY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PUEh16/cu/G4TC0P/4tsI5vh3mVxq7sakja7lXv88k4ROwcyYZ9H4KS9NaOtkFDf0
         Hdh8L2XFoD4E4+YGZ8nqoD9Akhj/8g84+kRwszv8absxn9GCTu2t3mOLdLaor+ucKQ
         B/KIfn/j9rgoe5kL+UBzGeIhkiqpNQETVCV/c8ao=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kangjie Lu <kjlu@umn.edu>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 177/321] regulator: tps65910: fix a missing check of return value
Date:   Tue,  3 Dec 2019 23:34:03 +0100
Message-Id: <20191203223436.338800816@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203223427.103571230@linuxfoundation.org>
References: <20191203223427.103571230@linuxfoundation.org>
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
index 02ccdaa226a73..5ebb6ee73f077 100644
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




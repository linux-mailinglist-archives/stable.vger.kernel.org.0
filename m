Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83E663AF006
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:44:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231659AbhFUQqD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:46:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:33594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233088AbhFUQmA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:42:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 69D1261402;
        Mon, 21 Jun 2021 16:31:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624293078;
        bh=Nid7jggVe/PAW3eV73p0RQ07l3cgKqshs4Xx82lieVg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SiLyOgcX+GVhcGawJHdaZmkVJq0Cvf3gCPD5Ni17+gicuTaJVsM2/BygP9Pw/UPtQ
         TSv6NABGASmnygjI004da71qChAe6bxJ0U1EKh2D16F9LZEMoY0dBLj5AHXr79Lxsi
         UtB27DrR5AmYHcMuphzkC0cwG7BDlZUQPrXhfnao=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dmitry Osipenko <digetx@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 089/178] regulator: max77620: Silence deferred probe error
Date:   Mon, 21 Jun 2021 18:15:03 +0200
Message-Id: <20210621154925.720664715@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621154921.212599475@linuxfoundation.org>
References: <20210621154921.212599475@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Osipenko <digetx@gmail.com>

[ Upstream commit 62499a94ce5b9a41047dbadaad885347b1176079 ]

One of previous changes to regulator core causes PMIC regulators to
re-probe until supply regulator is registered. Silence noisy error
message about the deferred probe.

Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
Link: https://lore.kernel.org/r/20210523224243.13219-3-digetx@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/max77620-regulator.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/regulator/max77620-regulator.c b/drivers/regulator/max77620-regulator.c
index 5c439c850d09..3cf8f085170a 100644
--- a/drivers/regulator/max77620-regulator.c
+++ b/drivers/regulator/max77620-regulator.c
@@ -846,12 +846,10 @@ static int max77620_regulator_probe(struct platform_device *pdev)
 			return ret;
 
 		rdev = devm_regulator_register(dev, rdesc, &config);
-		if (IS_ERR(rdev)) {
-			ret = PTR_ERR(rdev);
-			dev_err(dev, "Regulator registration %s failed: %d\n",
-				rdesc->name, ret);
-			return ret;
-		}
+		if (IS_ERR(rdev))
+			return dev_err_probe(dev, PTR_ERR(rdev),
+					     "Regulator registration %s failed\n",
+					     rdesc->name);
 	}
 
 	return 0;
-- 
2.30.2




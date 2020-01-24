Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D72C147C62
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 10:52:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388054AbgAXJvc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 04:51:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:52884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388050AbgAXJvb (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 04:51:31 -0500
Received: from localhost (unknown [145.15.244.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4A56024125;
        Fri, 24 Jan 2020 09:51:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579859490;
        bh=A0YMtqc8frXIm998POH4sdRlFGpWgiy9qw0wdwY2cGc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1kdCkgR8h0yZ4hd/ZU93z9mGuWHZZ2nBRuOV4y49C4jPZsRL6IRn80gwfU8l9Y0Gd
         Y1bQDCU6ACjk37/GjrbEv04sNlp21eD4BxH0p4+nmxvPIzYERusaH6Zj3awSre0Dgv
         peoqtEEvwPn7FUXxbhqIfP2P7oUSVhQecTzbDpwk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Axel Lin <axel.lin@ingics.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 116/343] regulator: pv88090: Fix array out-of-bounds access
Date:   Fri, 24 Jan 2020 10:28:54 +0100
Message-Id: <20200124092935.304018151@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124092919.490687572@linuxfoundation.org>
References: <20200124092919.490687572@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Axel Lin <axel.lin@ingics.com>

[ Upstream commit a5455c9159414748bed4678184bf69989a4f7ba3 ]

Fix off-by-one while iterating current_limits array.
The valid index should be 0 ~ n_current_limits -1.

Fixes: c90456e36d9c ("regulator: pv88090: new regulator driver")
Signed-off-by: Axel Lin <axel.lin@ingics.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/pv88090-regulator.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/pv88090-regulator.c b/drivers/regulator/pv88090-regulator.c
index 7a0c15957bd0b..2302b0df7630f 100644
--- a/drivers/regulator/pv88090-regulator.c
+++ b/drivers/regulator/pv88090-regulator.c
@@ -157,7 +157,7 @@ static int pv88090_set_current_limit(struct regulator_dev *rdev, int min,
 	int i;
 
 	/* search for closest to maximum */
-	for (i = info->n_current_limits; i >= 0; i--) {
+	for (i = info->n_current_limits - 1; i >= 0; i--) {
 		if (min <= info->current_limits[i]
 			&& max >= info->current_limits[i]) {
 			return regmap_update_bits(rdev->regmap,
-- 
2.20.1




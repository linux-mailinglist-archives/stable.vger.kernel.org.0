Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F914E9F94
	for <lists+stable@lfdr.de>; Wed, 30 Oct 2019 16:51:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727524AbfJ3Ptw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Oct 2019 11:49:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:50400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727504AbfJ3Ptu (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 30 Oct 2019 11:49:50 -0400
Received: from sasha-vm.mshome.net (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7853320856;
        Wed, 30 Oct 2019 15:49:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572450589;
        bh=vEco0Qc5gNZWgnkrLje5461Udlzws/Ff4y+WCVIP6Ug=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PvQ6BtJrvjs6yD24Au8DSlvZV23nbJUTM7ggj/E0jJcFEiLZOY/LDT3/O9IWyETeC
         eJZ833aiM3MeSaP36F9Tv/68xD0xsFgjiMheI/cIV4sUn0+U5aFiE9JT8gCJm0BKh4
         iZGYELpQ5iuuR+i5UXg6zOMUS14TVcTgCvYycWyk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Axel Lin <axel.lin@ingics.com>, Nishanth Menon <nm@ti.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.3 10/81] regulator: ti-abb: Fix timeout in ti_abb_wait_txdone/ti_abb_clear_all_txdone
Date:   Wed, 30 Oct 2019 11:48:16 -0400
Message-Id: <20191030154928.9432-10-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191030154928.9432-1-sashal@kernel.org>
References: <20191030154928.9432-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Axel Lin <axel.lin@ingics.com>

[ Upstream commit f64db548799e0330897c3203680c2ee795ade518 ]

ti_abb_wait_txdone() may return -ETIMEDOUT when ti_abb_check_txdone()
returns true in the latest iteration of the while loop because the timeout
value is abb->settling_time + 1. Similarly, ti_abb_clear_all_txdone() may
return -ETIMEDOUT when ti_abb_check_txdone() returns false in the latest
iteration of the while loop. Fix it.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
Acked-by: Nishanth Menon <nm@ti.com>
Link: https://lore.kernel.org/r/20190929095848.21960-1-axel.lin@ingics.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/ti-abb-regulator.c | 26 ++++++++------------------
 1 file changed, 8 insertions(+), 18 deletions(-)

diff --git a/drivers/regulator/ti-abb-regulator.c b/drivers/regulator/ti-abb-regulator.c
index cced1ffb896c1..89b9314d64c9d 100644
--- a/drivers/regulator/ti-abb-regulator.c
+++ b/drivers/regulator/ti-abb-regulator.c
@@ -173,19 +173,14 @@ static int ti_abb_wait_txdone(struct device *dev, struct ti_abb *abb)
 	while (timeout++ <= abb->settling_time) {
 		status = ti_abb_check_txdone(abb);
 		if (status)
-			break;
+			return 0;
 
 		udelay(1);
 	}
 
-	if (timeout > abb->settling_time) {
-		dev_warn_ratelimited(dev,
-				     "%s:TRANXDONE timeout(%duS) int=0x%08x\n",
-				     __func__, timeout, readl(abb->int_base));
-		return -ETIMEDOUT;
-	}
-
-	return 0;
+	dev_warn_ratelimited(dev, "%s:TRANXDONE timeout(%duS) int=0x%08x\n",
+			     __func__, timeout, readl(abb->int_base));
+	return -ETIMEDOUT;
 }
 
 /**
@@ -205,19 +200,14 @@ static int ti_abb_clear_all_txdone(struct device *dev, const struct ti_abb *abb)
 
 		status = ti_abb_check_txdone(abb);
 		if (!status)
-			break;
+			return 0;
 
 		udelay(1);
 	}
 
-	if (timeout > abb->settling_time) {
-		dev_warn_ratelimited(dev,
-				     "%s:TRANXDONE timeout(%duS) int=0x%08x\n",
-				     __func__, timeout, readl(abb->int_base));
-		return -ETIMEDOUT;
-	}
-
-	return 0;
+	dev_warn_ratelimited(dev, "%s:TRANXDONE timeout(%duS) int=0x%08x\n",
+			     __func__, timeout, readl(abb->int_base));
+	return -ETIMEDOUT;
 }
 
 /**
-- 
2.20.1


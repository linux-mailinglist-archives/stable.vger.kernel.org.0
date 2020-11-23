Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E7152C0AED
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:55:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731021AbgKWMcL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:32:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:43266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731028AbgKWMcK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:32:10 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 302F72076E;
        Mon, 23 Nov 2020 12:32:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606134729;
        bh=WnoWaPOliwfCDnB34vVQAmgvOEREp88/2DhlefrORCw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sqYRfAPx0b5PKGaic6gatV1Qk/4BULBkASq3KjLp095u7sbcYngSmf9gknTdqZZzJ
         z8bV842HzZtRqS3CsR2Qtn+yPakfpfSW9lVLyFdwWVn+TPGZZgZl9OwGG8SYQbOFnH
         wnA9kdVLvLS4ML7/3JI2DpbfQ2xEk8Ed+Ic6n0WM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Naresh Kamboju <naresh.kamboju@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Nishanth Menon <nm@ti.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 61/91] regulator: ti-abb: Fix array out of bound read access on the first transition
Date:   Mon, 23 Nov 2020 13:22:21 +0100
Message-Id: <20201123121812.287151293@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121809.285416732@linuxfoundation.org>
References: <20201123121809.285416732@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nishanth Menon <nm@ti.com>

[ Upstream commit 2ba546ebe0ce2af47833d8912ced9b4a579f13cb ]

At the start of driver initialization, we do not know what bias
setting the bootloader has configured the system for and we only know
for certain the very first time we do a transition.

However, since the initial value of the comparison index is -EINVAL,
this negative value results in an array out of bound access on the
very first transition.

Since we don't know what the setting is, we just set the bias
configuration as there is nothing to compare against. This prevents
the array out of bound access.

NOTE: Even though we could use a more relaxed check of "< 0" the only
valid values(ignoring cosmic ray induced bitflips) are -EINVAL, 0+.

Fixes: 40b1936efebd ("regulator: Introduce TI Adaptive Body Bias(ABB) on-chip LDO driver")
Link: https://lore.kernel.org/linux-mm/CA+G9fYuk4imvhyCN7D7T6PMDH6oNp6HDCRiTUKMQ6QXXjBa4ag@mail.gmail.com/
Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Nishanth Menon <nm@ti.com>
Link: https://lore.kernel.org/r/20201118145009.10492-1-nm@ti.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/ti-abb-regulator.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/regulator/ti-abb-regulator.c b/drivers/regulator/ti-abb-regulator.c
index 89b9314d64c9d..016330f909c09 100644
--- a/drivers/regulator/ti-abb-regulator.c
+++ b/drivers/regulator/ti-abb-regulator.c
@@ -342,8 +342,17 @@ static int ti_abb_set_voltage_sel(struct regulator_dev *rdev, unsigned sel)
 		return ret;
 	}
 
-	/* If data is exactly the same, then just update index, no change */
 	info = &abb->info[sel];
+	/*
+	 * When Linux kernel is starting up, we are'nt sure of the
+	 * Bias configuration that bootloader has configured.
+	 * So, we get to know the actual setting the first time
+	 * we are asked to transition.
+	 */
+	if (abb->current_info_idx == -EINVAL)
+		goto just_set_abb;
+
+	/* If data is exactly the same, then just update index, no change */
 	oinfo = &abb->info[abb->current_info_idx];
 	if (!memcmp(info, oinfo, sizeof(*info))) {
 		dev_dbg(dev, "%s: Same data new idx=%d, old idx=%d\n", __func__,
@@ -351,6 +360,7 @@ static int ti_abb_set_voltage_sel(struct regulator_dev *rdev, unsigned sel)
 		goto out;
 	}
 
+just_set_abb:
 	ret = ti_abb_set_opp(rdev, abb, info);
 
 out:
-- 
2.27.0




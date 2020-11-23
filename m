Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58B682C05E9
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 13:41:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729959AbgKWMZ3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:25:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:35148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729995AbgKWMZ2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:25:28 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D49112076E;
        Mon, 23 Nov 2020 12:25:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606134326;
        bh=93VrMVYKxpRP0ORf3ecOd7y7hC7tY7W+PyTw58cxmMg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Wo4CIZQF9VZiz0zjH+6mNoTGbWT4Q0z03ryhxVb8RtzTk+fbdWI+9rxRCVBr3uxfT
         Eo528dwvxkviRSwAerq/6u+yhR5axyW8rguagVg0+9ImnVNR8A//CbmMS62s2uYWhO
         ISOgspe8qOvu7hR32Tc9Pf+XRpojbXM5CjBeyyQI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Naresh Kamboju <naresh.kamboju@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Nishanth Menon <nm@ti.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 31/47] regulator: ti-abb: Fix array out of bound read access on the first transition
Date:   Mon, 23 Nov 2020 13:22:17 +0100
Message-Id: <20201123121807.058405502@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121805.530891002@linuxfoundation.org>
References: <20201123121805.530891002@linuxfoundation.org>
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
index 6d17357b3a248..5f5f63eb8c762 100644
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




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5A6113E1A7
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 17:50:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729148AbgAPQpR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 11:45:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:54012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726706AbgAPQpQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 11:45:16 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E834B2073A;
        Thu, 16 Jan 2020 16:45:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579193115;
        bh=E7LdTDXRcMDIR9XTPRTisJS7cMCBikPmWuoa6iCKbk8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PzUeK30yKKt48KSPR7dTZ0ZtZwvk2z2XQ2v8/WJDUQu3b1Cs7TMRhmd5nxDfxHARJ
         J0niG+YMzetaMQ5Fl1ndXpY9Ea7uxAX6fZTo/QGMIyvInrIDm2BjUDIjZuPxtWwdBF
         x5QxZci35Vo8KGHwikizpehvmj8Knp1tcgdbtVfM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Colin Ian King <colin.king@canonical.com>,
        Tony Lindgren <tony@atomide.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-gpio@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 027/205] pinctl: ti: iodelay: fix error checking on pinctrl_count_index_with_args call
Date:   Thu, 16 Jan 2020 11:40:02 -0500
Message-Id: <20200116164300.6705-27-sashal@kernel.org>
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

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit 5ff8aca906f3a7a7db79fad92f2a4401107ef50d ]

The call to pinctrl_count_index_with_args checks for a -EINVAL return
however this function calls pinctrl_get_list_and_count and this can
return -ENOENT. Rather than check for a specific error, fix this by
checking for any error return to catch the -ENOENT case.

Addresses-Coverity: ("Improper use of negative")
Fixes: 003910ebc83b ("pinctrl: Introduce TI IOdelay configuration driver")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Link: https://lore.kernel.org/r/20190920122030.14340-1-colin.king@canonical.com
Acked-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/ti/pinctrl-ti-iodelay.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/ti/pinctrl-ti-iodelay.c b/drivers/pinctrl/ti/pinctrl-ti-iodelay.c
index e5e7f1f22813..b522ca010332 100644
--- a/drivers/pinctrl/ti/pinctrl-ti-iodelay.c
+++ b/drivers/pinctrl/ti/pinctrl-ti-iodelay.c
@@ -496,7 +496,7 @@ static int ti_iodelay_dt_node_to_map(struct pinctrl_dev *pctldev,
 		return -EINVAL;
 
 	rows = pinctrl_count_index_with_args(np, name);
-	if (rows == -EINVAL)
+	if (rows < 0)
 		return rows;
 
 	*map = devm_kzalloc(iod->dev, sizeof(**map), GFP_KERNEL);
-- 
2.20.1


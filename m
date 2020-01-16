Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1C1A13E8A8
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 18:33:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404589AbgAPRda (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 12:33:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:43058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404245AbgAPRa1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:30:27 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CE90224726;
        Thu, 16 Jan 2020 17:30:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579195826;
        bh=D4koUEZyoEWnZ7PH6TZzuDnLbMuD8YMIatB3LvF3vQo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Wezxv6d3p8dF3sAolIjNA+iX49Sw8FWf4SUEFLIr0YIYOdCR1V40twa0V32wkVOaZ
         ht4msTpWOY8LK8aEj9Qtj4YR48xswkovGZO0r8Cqv2/tijOO4yTYie5G0GDTRd9elM
         /vLZa7DY3U7HGuAby9dIh0iYA0k8r0z0PuIaZ7os=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Colin Ian King <colin.king@canonical.com>,
        Tony Lindgren <tony@atomide.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-gpio@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 334/371] pinctl: ti: iodelay: fix error checking on pinctrl_count_index_with_args call
Date:   Thu, 16 Jan 2020 12:23:26 -0500
Message-Id: <20200116172403.18149-277-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116172403.18149-1-sashal@kernel.org>
References: <20200116172403.18149-1-sashal@kernel.org>
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
index 5c1b6325d80d..8ac1f1ce4442 100644
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


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93E8A26F454
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 05:14:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730682AbgIRDNo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 23:13:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:46538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726546AbgIRCBx (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:01:53 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C6BD021973;
        Fri, 18 Sep 2020 02:01:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600394512;
        bh=TbwRRcbFWiuMB8dfF8YlJolXDH48+LAChbI07sEfkpw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cjtqmMaMvz67F9mJQ/qrGrmcar9QdL8HRSfFiQO3zB1gIkfanYyNNWdE+m2HQadSY
         CPVO1rDRzG4E7d2hh3FMWCyKFYFhGKL0L5C5p9Vi74zcfMXnANUwtYKq7XLmOjL6wR
         yvfkbLOPRf22NStlS4bPb2REbXr0bwKpeecnjRI8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Stephen Kitt <steve@sk2.org>, Tony Lindgren <tony@atomide.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-omap@vger.kernel.org,
        linux-clk@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 035/330] clk/ti/adpll: allocate room for terminating null
Date:   Thu, 17 Sep 2020 21:56:15 -0400
Message-Id: <20200918020110.2063155-35-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020110.2063155-1-sashal@kernel.org>
References: <20200918020110.2063155-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stephen Kitt <steve@sk2.org>

[ Upstream commit 7f6ac72946b88b89ee44c1c527aa8591ac5ffcbe ]

The buffer allocated in ti_adpll_clk_get_name doesn't account for the
terminating null. This patch switches to devm_kasprintf to avoid
overflowing.

Signed-off-by: Stephen Kitt <steve@sk2.org>
Link: https://lkml.kernel.org/r/20191019140634.15596-1-steve@sk2.org
Acked-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/ti/adpll.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/drivers/clk/ti/adpll.c b/drivers/clk/ti/adpll.c
index fdfb90058504c..bb2f2836dab22 100644
--- a/drivers/clk/ti/adpll.c
+++ b/drivers/clk/ti/adpll.c
@@ -194,15 +194,8 @@ static const char *ti_adpll_clk_get_name(struct ti_adpll_data *d,
 		if (err)
 			return NULL;
 	} else {
-		const char *base_name = "adpll";
-		char *buf;
-
-		buf = devm_kzalloc(d->dev, 8 + 1 + strlen(base_name) + 1 +
-				    strlen(postfix), GFP_KERNEL);
-		if (!buf)
-			return NULL;
-		sprintf(buf, "%08lx.%s.%s", d->pa, base_name, postfix);
-		name = buf;
+		name = devm_kasprintf(d->dev, GFP_KERNEL, "%08lx.adpll.%s",
+				      d->pa, postfix);
 	}
 
 	return name;
-- 
2.25.1


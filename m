Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D96729C63B
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 19:27:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1825942AbgJ0SOs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 14:14:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:34466 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756418AbgJ0ONG (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:13:06 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E08F7206F7;
        Tue, 27 Oct 2020 14:13:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603807986;
        bh=kGDbJpILW1RdbePrEXsk6EWHy+WZdjQNB7twtxBVuV8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zl8N3eTVKxhZppTrTarDiOO47pEJxZf8eBTB2pWpUlPmKI6FMpgNJ8EhoulUNZSm3
         EXVMuplZ/8BVq7mmwf4M7fVw9NnSJOJmi5Sd4MNYrOhRzz82aaootzhJDzF0mjZ9UX
         qYUIxnnPMS4AC4sOcCwPkGfWmiJX5U4Tx+IbeFv8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Navid Emamdoost <navid.emamdoost@gmail.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 115/191] clk: bcm2835: add missing release if devm_clk_hw_register fails
Date:   Tue, 27 Oct 2020 14:49:30 +0100
Message-Id: <20201027134915.236362780@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027134909.701581493@linuxfoundation.org>
References: <20201027134909.701581493@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Navid Emamdoost <navid.emamdoost@gmail.com>

[ Upstream commit f6c992ca7dd4f49042eec61f3fb426c94d901675 ]

In the implementation of bcm2835_register_pll(), the allocated pll is
leaked if devm_clk_hw_register() fails to register hw. Release pll if
devm_clk_hw_register() fails.

Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
Link: https://lore.kernel.org/r/20200809231202.15811-1-navid.emamdoost@gmail.com
Fixes: 41691b8862e2 ("clk: bcm2835: Add support for programming the audio domain clocks")
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/bcm/clk-bcm2835.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/bcm/clk-bcm2835.c b/drivers/clk/bcm/clk-bcm2835.c
index 6db4204e5d5d5..98295b9703178 100644
--- a/drivers/clk/bcm/clk-bcm2835.c
+++ b/drivers/clk/bcm/clk-bcm2835.c
@@ -1354,8 +1354,10 @@ static struct clk_hw *bcm2835_register_pll(struct bcm2835_cprman *cprman,
 	pll->hw.init = &init;
 
 	ret = devm_clk_hw_register(cprman->dev, &pll->hw);
-	if (ret)
+	if (ret) {
+		kfree(pll);
 		return NULL;
+	}
 	return &pll->hw;
 }
 
-- 
2.25.1




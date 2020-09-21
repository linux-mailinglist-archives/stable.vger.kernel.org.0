Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CCA7272887
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 16:44:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727806AbgIUOkh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 10:40:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:49202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727499AbgIUOkg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 10:40:36 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DBABB23718;
        Mon, 21 Sep 2020 14:40:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600699235;
        bh=hlCTEfeCQncgpBOMjD101cTzGYTMWM+Cj52a8KqvpF4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U8O9W0WTbXKk5tbDZC+Rm7geFkXvURdAtwNzJ02go78CprNUhXBicFKk7Fp7ZO5An
         lkRM8M5RvS4j4KRvoX+m1O5y0nMlCX1O7Jcu7m7mUpUDYmT/hFsqN42W6MmLA9LpBU
         8u/wqTTpLup1E8wY6LufG4bw0ga93+RGVhTqp6T0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sumera Priyadarsini <sylphrenadin@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-clk@vger.kernel.org
Subject: [PATCH AUTOSEL 5.8 06/20] clk: versatile: Add of_node_put() before return statement
Date:   Mon, 21 Sep 2020 10:40:13 -0400
Message-Id: <20200921144027.2135390-6-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200921144027.2135390-1-sashal@kernel.org>
References: <20200921144027.2135390-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sumera Priyadarsini <sylphrenadin@gmail.com>

[ Upstream commit da9c43dc0e2ec5c42a3d414e389feb30467000e2 ]

Every iteration of for_each_available_child_of_node() decrements
the reference count of the previous node, however when control is
transferred from the middle of the loop, as in the case of a return
or break or goto, there is no decrement thus ultimately resulting in
a memory leak.

Fix a potential memory leak in clk-impd1.c by inserting
of_node_put() before a return statement.

Issue found with Coccinelle.

Signed-off-by: Sumera Priyadarsini <sylphrenadin@gmail.com>
Link: https://lore.kernel.org/r/20200829175704.GA10998@Kaladin
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/versatile/clk-impd1.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/versatile/clk-impd1.c b/drivers/clk/versatile/clk-impd1.c
index ca798249544d0..85c395df9c008 100644
--- a/drivers/clk/versatile/clk-impd1.c
+++ b/drivers/clk/versatile/clk-impd1.c
@@ -109,8 +109,10 @@ static int integrator_impd1_clk_probe(struct platform_device *pdev)
 
 	for_each_available_child_of_node(np, child) {
 		ret = integrator_impd1_clk_spawn(dev, np, child);
-		if (ret)
+		if (ret) {
+			of_node_put(child);
 			break;
+		}
 	}
 
 	return ret;
-- 
2.25.1


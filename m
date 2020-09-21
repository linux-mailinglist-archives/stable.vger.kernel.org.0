Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D1CB272D9E
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 18:41:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728662AbgIUQlr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 12:41:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:45094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729422AbgIUQla (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:41:30 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5B6C0239D0;
        Mon, 21 Sep 2020 16:41:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600706489;
        bh=MlW8wP7YSPkTk34orQp0KO224TajDrzSOTXPip8C5mM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mktxxM4Q9O6++7XXudYSHWEJXRwlG8PCqPTh0BKMTRi32JU0sHztstrsrduTcpecO
         fOpqRqiwD2FSR/WI2G53EfcUwwk4NjJvaN4YTWK7ZkvwFmu9lCHEPm5jkKtU+xuXPO
         HM7M8SZXAhvE7Nbjk4R2i2gp1c8xiKPqt/UGdJ0g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        David Lechner <david@lechnology.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 26/49] clk: davinci: Use the correct size when allocating memory
Date:   Mon, 21 Sep 2020 18:28:10 +0200
Message-Id: <20200921162035.812003433@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921162034.660953761@linuxfoundation.org>
References: <20200921162034.660953761@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 3dabfa2bda48dab717986609762ce2a49335eb99 ]

'sizeof(*pllen)' should be used in place of 'sizeof(*pllout)' to avoid a
small over-allocation.

Fixes: 2d1726915159 ("clk: davinci: New driver for davinci PLL clocks")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Link: https://lore.kernel.org/r/20200809144959.747986-1-christophe.jaillet@wanadoo.fr
Reviewed-by: David Lechner <david@lechnology.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/davinci/pll.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/davinci/pll.c b/drivers/clk/davinci/pll.c
index 1c99e992d6388..796b428998ae0 100644
--- a/drivers/clk/davinci/pll.c
+++ b/drivers/clk/davinci/pll.c
@@ -491,7 +491,7 @@ struct clk *davinci_pll_clk_register(struct device *dev,
 		parent_name = postdiv_name;
 	}
 
-	pllen = kzalloc(sizeof(*pllout), GFP_KERNEL);
+	pllen = kzalloc(sizeof(*pllen), GFP_KERNEL);
 	if (!pllen) {
 		ret = -ENOMEM;
 		goto err_unregister_postdiv;
-- 
2.25.1




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDA96272E89
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 18:50:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729975AbgIUQuL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 12:50:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:58292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729970AbgIUQuB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:50:01 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0C85F20874;
        Mon, 21 Sep 2020 16:49:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600707000;
        bh=CZh8RPqswjviyEN5jt4B+U9jLib2epKqAgVrpbhD7pM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NSmWjAbik2P/Q7v3K9vg/Sd3GiBNXKX2LEcge2vc1CeS2fiMbuv0ni3JHqQu4NhTE
         jy/Khm0K4pkdj/P0WPG2vZmas8tSxMZgOHZVXv1BoBFAZ/0IX8ADQD/81b9mHEUsKS
         OfEEV6RQ5gruAXyxUNHioGkPHhv3AzoCZ0/OrmrY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        David Lechner <david@lechnology.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 28/72] clk: davinci: Use the correct size when allocating memory
Date:   Mon, 21 Sep 2020 18:31:07 +0200
Message-Id: <20200921163123.206646502@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921163121.870386357@linuxfoundation.org>
References: <20200921163121.870386357@linuxfoundation.org>
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
index 1ac11b6a47a37..2ec48d030fda7 100644
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




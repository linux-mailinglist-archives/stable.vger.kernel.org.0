Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FD27272F76
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 18:57:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728247AbgIUQ5X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 12:57:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:49116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729667AbgIUQoE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:44:04 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 57D62235F9;
        Mon, 21 Sep 2020 16:44:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600706643;
        bh=wt31Z0JEQyepmi32aURY1zh2BUPEpENmefglZNnu+4w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2Zgxnr2vCugCGlb1F8x9jSxC4QlvazCe+sVHUfhiJkvymt1ff6zkREf0PDFEszTmX
         rEko2kBKzI4cbxMM0lqeDYj1HCWU7VXDz/y8joAtOBITnaGNGC9A4SUH0Wc0dkmP9O
         LSeLOsmCitr58tpR10UuIXsaO9gXQXmM3LHwcasM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        David Lechner <david@lechnology.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 036/118] clk: davinci: Use the correct size when allocating memory
Date:   Mon, 21 Sep 2020 18:27:28 +0200
Message-Id: <20200921162037.983085125@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921162036.324813383@linuxfoundation.org>
References: <20200921162036.324813383@linuxfoundation.org>
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
index 8a23d5dfd1f8d..5f063e1be4b14 100644
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




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A6B72E67F7
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:32:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728648AbgL1NGY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:06:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:32854 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730687AbgL1NGD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:06:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DC2C122582;
        Mon, 28 Dec 2020 13:05:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609160748;
        bh=6H5pjMjHihSttCdD9uwYDZanw03bglRNU90wlsoq1jY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Nofjy6AlF0TyYESRIPTyB7+nne0Smy2r0MRt79qyH1g9l6HZnF7vs3HEFViGdlQHs
         rTKisTlzm3YCv15JZcgbr1T+gPZHUrxVLaUBUlBkxhQpBfCQ/sjP+gHmHe3Fs4Brn0
         8tjK9sNdBpAM7BLUCFTR3hUXricJM/vTIwhcanjY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 127/175] clk: s2mps11: Fix a resource leak in error handling paths in the probe function
Date:   Mon, 28 Dec 2020 13:49:40 +0100
Message-Id: <20201228124859.407962502@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124853.216621466@linuxfoundation.org>
References: <20201228124853.216621466@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit d2d94fc567624f96187e8b52083795620f93e69f ]

Some resource should be released in the error handling path of the probe
function, as already done in the remove function.

The remove function was fixed in commit bf416bd45738 ("clk: s2mps11: Add
missing of_node_put and of_clk_del_provider")

Fixes: 7cc560dea415 ("clk: s2mps11: Add support for s2mps11")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Link: https://lore.kernel.org/r/20201212122818.86195-1-christophe.jaillet@wanadoo.fr
Reviewed-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/clk-s2mps11.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clk/clk-s2mps11.c b/drivers/clk/clk-s2mps11.c
index f5d74e8db4327..1803af6230b27 100644
--- a/drivers/clk/clk-s2mps11.c
+++ b/drivers/clk/clk-s2mps11.c
@@ -211,6 +211,7 @@ static int s2mps11_clk_probe(struct platform_device *pdev)
 	return ret;
 
 err_reg:
+	of_node_put(s2mps11_clks[0].clk_np);
 	while (--i >= 0)
 		clkdev_drop(s2mps11_clks[i].lookup);
 
-- 
2.27.0




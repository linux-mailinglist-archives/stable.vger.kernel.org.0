Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A990329B725
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 16:33:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1798656AbgJ0P3c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:29:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:45814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1760280AbgJ0P31 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:29:27 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 381F020728;
        Tue, 27 Oct 2020 15:29:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603812565;
        bh=GEWsL5kHeaGNnM9fbhUycWFM/b/snUlx/WOb6hN3K6s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZrQ3j+GLnWAyvWFEbSs/600E2TjvV3srJK1CiPpCvp68gSNINr080t2zqLQXZijA4
         aKG7OQKKya5VcAs8ZPFPyuyPQNCce8/iXV8IaMU7LcKcyGNCOdLF/EgrmiaqNPp1hH
         xudlOP9BFUHq/iQZTNzclnFzlpEBACUN5UIsnyyM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Thomas Preston <thomas.preston@codethink.co.uk>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 255/757] pinctrl: mcp23s08: Fix mcp23x17 precious range
Date:   Tue, 27 Oct 2020 14:48:25 +0100
Message-Id: <20201027135502.533761359@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Preston <thomas.preston@codethink.co.uk>

[ Upstream commit b9b7fb29433b906635231d0a111224efa009198c ]

On page 23 of the datasheet [0] it says "The register remains unchanged
until the interrupt is cleared via a read of INTCAP or GPIO." Include
INTCAPA and INTCAPB registers in precious range, so that they aren't
accidentally cleared when we read via debugfs.

[0] https://ww1.microchip.com/downloads/en/DeviceDoc/20001952C.pdf

Fixes: 8f38910ba4f6 ("pinctrl: mcp23s08: switch to regmap caching")
Signed-off-by: Thomas Preston <thomas.preston@codethink.co.uk>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Link: https://lore.kernel.org/r/20200828213226.1734264-3-thomas.preston@codethink.co.uk
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/pinctrl-mcp23s08.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/pinctrl-mcp23s08.c b/drivers/pinctrl/pinctrl-mcp23s08.c
index 87cde8fb08dd9..7edb067f5e76a 100644
--- a/drivers/pinctrl/pinctrl-mcp23s08.c
+++ b/drivers/pinctrl/pinctrl-mcp23s08.c
@@ -109,7 +109,7 @@ static const struct regmap_access_table mcp23x17_volatile_table = {
 };
 
 static const struct regmap_range mcp23x17_precious_range = {
-	.range_min = MCP_GPIO << 1,
+	.range_min = MCP_INTCAP << 1,
 	.range_max = MCP_GPIO << 1,
 };
 
-- 
2.25.1




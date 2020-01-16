Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 427BF13E65D
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 18:20:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391385AbgAPRT7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 12:19:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:45100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390359AbgAPRSN (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:18:13 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 96F44246C6;
        Thu, 16 Jan 2020 17:18:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579195092;
        bh=+wjsP+BL3zBz0Sf8nVBdYXWxBkY7p2jY+SVK1Rd4QWA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m7FEicedoWbX3dCl9UF+kfSI9DKXD/OXBldXkTRzJdi3++AST7wq9zAUdXn4zMXvp
         iV9dDCfk2tT/pEk9xVGV70SmrH5H+SJBa6BNj+KkhgS2ynb1xmoab6x5YDiNs76QMZ
         wYat3p8WDYlZ2GyNnMeKiIRXTMkBl4IKU29aOBR0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yangtao Li <tiny.windzz@gmail.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-samsung-soc@vger.kernel.org, linux-clk@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 4.14 039/371] clk: samsung: exynos4: fix refcount leak in exynos4_get_xom()
Date:   Thu, 16 Jan 2020 12:11:47 -0500
Message-Id: <20200116171719.16965-39-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116171719.16965-1-sashal@kernel.org>
References: <20200116171719.16965-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yangtao Li <tiny.windzz@gmail.com>

[ Upstream commit cee82eb9532090cd1dc953e845d71f9b1445c84e ]

The of_find_compatible_node() returns a node pointer with refcount
incremented, but there is the lack of use of the of_node_put() when
done. Add the missing of_node_put() to release the refcount.

Signed-off-by: Yangtao Li <tiny.windzz@gmail.com>
Fixes: e062b571777f ("clk: exynos4: register clocks using common clock framework")
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/samsung/clk-exynos4.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clk/samsung/clk-exynos4.c b/drivers/clk/samsung/clk-exynos4.c
index d8d3cb67b402..3d3026221927 100644
--- a/drivers/clk/samsung/clk-exynos4.c
+++ b/drivers/clk/samsung/clk-exynos4.c
@@ -1240,6 +1240,7 @@ static unsigned long __init exynos4_get_xom(void)
 			xom = readl(chipid_base + 8);
 
 		iounmap(chipid_base);
+		of_node_put(np);
 	}
 
 	return xom;
-- 
2.20.1


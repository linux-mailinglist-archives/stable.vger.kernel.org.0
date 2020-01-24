Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA68B147FAB
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:04:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387464AbgAXLEO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:04:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:38246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732911AbgAXLEN (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:04:13 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D0E852075D;
        Fri, 24 Jan 2020 11:04:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579863852;
        bh=nkkf95ea/BDSSPL0jBXW7TgmO+WtcFuRflf4gNVfrs4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TeRcux0rEurVUMls1WSFRKLZx84jy9lIBK+OVqeo56SREo5AsOIvjv+rGLNSY6XoM
         cbVjOkGEByWa58tz7pD+MhFvBC9t9BQE6W69tYLV8xXx9LCIuSceMd1iqYOdA8k73+
         x6ySPjABBr1nVM53xDuoINWTjZU/hqhCtwpvxQWI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yangtao Li <tiny.windzz@gmail.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 105/639] clk: samsung: exynos4: fix refcount leak in exynos4_get_xom()
Date:   Fri, 24 Jan 2020 10:24:35 +0100
Message-Id: <20200124093100.508173202@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 0421960eb9633..442309b569203 100644
--- a/drivers/clk/samsung/clk-exynos4.c
+++ b/drivers/clk/samsung/clk-exynos4.c
@@ -1226,6 +1226,7 @@ static unsigned long __init exynos4_get_xom(void)
 			xom = readl(chipid_base + 8);
 
 		iounmap(chipid_base);
+		of_node_put(np);
 	}
 
 	return xom;
-- 
2.20.1




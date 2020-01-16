Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01EE713EC9D
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 18:57:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394081AbgAPR5m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 12:57:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:33406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405807AbgAPRnV (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:43:21 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C11672469C;
        Thu, 16 Jan 2020 17:43:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579196600;
        bh=/bCCfSmxJZv3TMBHVGhlziVPqCKsegMIwgEErJMuXQ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d7T39uP/7UsD8UyZg5gB124o4xBdlfknCBszknm0YPB2+7M0znqGWhNclq4Bc2PmZ
         jdtdnraGZ97r9fg1c1N5uZv9OhRVsDXHn21oE+I7/Abxmz7wKps2HQl4hy3DDUDw8A
         6Z2RLcwFVHke6AEt45VnPpD6XaYHAff10heaRaTM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yangtao Li <tiny.windzz@gmail.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-samsung-soc@vger.kernel.org, linux-clk@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 4.4 022/174] clk: samsung: exynos4: fix refcount leak in exynos4_get_xom()
Date:   Thu, 16 Jan 2020 12:40:19 -0500
Message-Id: <20200116174251.24326-22-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116174251.24326-1-sashal@kernel.org>
References: <20200116174251.24326-1-sashal@kernel.org>
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
index 7f370d3e0983..6c8e45e007c8 100644
--- a/drivers/clk/samsung/clk-exynos4.c
+++ b/drivers/clk/samsung/clk-exynos4.c
@@ -1224,6 +1224,7 @@ static unsigned long exynos4_get_xom(void)
 			xom = readl(chipid_base + 8);
 
 		iounmap(chipid_base);
+		of_node_put(np);
 	}
 
 	return xom;
-- 
2.20.1


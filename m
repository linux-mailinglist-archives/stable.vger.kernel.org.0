Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD2A03788AF
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:48:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234351AbhEJLXC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:23:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:46932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237071AbhEJLLR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:11:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D12566101B;
        Mon, 10 May 2021 11:06:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620644810;
        bh=VYfmhFt2W1DZcgIXrOOh7ooiC4aHcLCuxvOApxAU6hY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J/knbo/wBRo417Cva2OD2fBd99kc5zXwsEg/dCcEm/9pTckc8FNJTpQvXFmsfKJlN
         CIJXq+edblMZIL6nbHl7m87KyZAzFWTxUK8mVmQ6tf7kFWTabjxbkKSQykSGUuCxw9
         DCLzks6WTZlY2TMZEXAG4PUwosFuGycISxA+Od94=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Dinh Nguyen <dinguyen@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 226/384] clk: socfpga: arria10: Fix memory leak of socfpga_clk on error return
Date:   Mon, 10 May 2021 12:20:15 +0200
Message-Id: <20210510102022.355436465@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102014.849075526@linuxfoundation.org>
References: <20210510102014.849075526@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit 657d4d1934f75a2d978c3cf2086495eaa542e7a9 ]

There is an error return path that is not kfree'ing socfpga_clk leading
to a memory leak. Fix this by adding in the missing kfree call.

Addresses-Coverity: ("Resource leak")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Link: https://lore.kernel.org/r/20210406170115.430990-1-colin.king@canonical.com
Acked-by: Dinh Nguyen <dinguyen@kernel.org>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/socfpga/clk-gate-a10.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clk/socfpga/clk-gate-a10.c b/drivers/clk/socfpga/clk-gate-a10.c
index cd5df9103614..d62778884208 100644
--- a/drivers/clk/socfpga/clk-gate-a10.c
+++ b/drivers/clk/socfpga/clk-gate-a10.c
@@ -146,6 +146,7 @@ static void __init __socfpga_gate_init(struct device_node *node,
 		if (IS_ERR(socfpga_clk->sys_mgr_base_addr)) {
 			pr_err("%s: failed to find altr,sys-mgr regmap!\n",
 					__func__);
+			kfree(socfpga_clk);
 			return;
 		}
 	}
-- 
2.30.2




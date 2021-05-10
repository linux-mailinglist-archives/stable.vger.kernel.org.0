Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2CD437863A
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:31:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234632AbhEJLFI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:05:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:53004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235044AbhEJK5d (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:57:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B87446195D;
        Mon, 10 May 2021 10:51:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620643889;
        bh=VYfmhFt2W1DZcgIXrOOh7ooiC4aHcLCuxvOApxAU6hY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FI5mHc2ZuS9n9J/F5M/VREyxlAVDB+P2LRrjIY2GAVLliC9iI10FIipVuLaIO9lMH
         Uoazj5ljqhmhj2ayQp7dhAG4plBtFF+J4S0B9sL5CdEiPixO3g1x6fA+kBue7Ka1BU
         U9Q7kDYDj7XjPjo7N2mwarTuAbbx6smU9ZIjrZXs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Dinh Nguyen <dinguyen@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 200/342] clk: socfpga: arria10: Fix memory leak of socfpga_clk on error return
Date:   Mon, 10 May 2021 12:19:50 +0200
Message-Id: <20210510102016.697160074@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102010.096403571@linuxfoundation.org>
References: <20210510102010.096403571@linuxfoundation.org>
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




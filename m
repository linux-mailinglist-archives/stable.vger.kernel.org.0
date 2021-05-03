Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86D80371D29
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 19:01:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234597AbhECQ6E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 12:58:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:45140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235189AbhECQz4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 12:55:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B813261971;
        Mon,  3 May 2021 16:43:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620060191;
        bh=aVlOtKwCDPxINj7HQcYw/DTsDeNva4fCUjEGyQMqxy0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FTtyVWwCxt3tgoEKw1vB+TJK/MHkFA0UG/d1sq7wLP9h/0u3FIc0cmei/EXeCYAIV
         t52vWRmxq0LKbQF3vxkIYlbo1wioEeWf2ExhdNpL0aOBgKn1d0/PqFDWD1FnRTnRsR
         3NEDecVydl8ZGsDNs+87axCwE0zxryMvXNNNCiVTHv1mk/lgsomiqQCzSDEZbrj1Y6
         HoRpmDVlgjvW4wA/Ek/wN9Ig0GjEzkaoTso7zkgyUVsoRkgEc+gV2CWOvlJmmjpYO/
         n+YoqDRI5qxDwq5/kOIfJARSEfpwJY97ZwGQCl8MoQiBatB/5MFmPVQCeBe7vNi1wh
         X9pBJZ8aUMwgA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Colin Ian King <colin.king@canonical.com>,
        Dinh Nguyen <dinguyen@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-clk@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 13/24] clk: socfpga: arria10: Fix memory leak of socfpga_clk on error return
Date:   Mon,  3 May 2021 12:42:41 -0400
Message-Id: <20210503164252.2854487-13-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210503164252.2854487-1-sashal@kernel.org>
References: <20210503164252.2854487-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index c2d572748167..7913dbedba89 100644
--- a/drivers/clk/socfpga/clk-gate-a10.c
+++ b/drivers/clk/socfpga/clk-gate-a10.c
@@ -157,6 +157,7 @@ static void __init __socfpga_gate_init(struct device_node *node,
 		if (IS_ERR(socfpga_clk->sys_mgr_base_addr)) {
 			pr_err("%s: failed to find altr,sys-mgr regmap!\n",
 					__func__);
+			kfree(socfpga_clk);
 			return;
 		}
 	}
-- 
2.30.2


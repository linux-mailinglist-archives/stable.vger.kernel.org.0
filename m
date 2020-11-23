Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32E9A2C0A9F
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:54:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729584AbgKWMXS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:23:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:60272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729572AbgKWMXS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:23:18 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 24BE620857;
        Mon, 23 Nov 2020 12:23:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606134197;
        bh=6G96lTmXj/W6vNWEBzMKYkq9VDMFPXQwqddNz/jj3mU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Vbn7P8HKspjigULTPJtQoVdYHNvwsD2kCUwsIKcwomIEZKVLLpNkUwFR7lVWIXF//
         nNkCowhjN6nazuYFsss8efcTgNvoCA+78lHmctHhUTQnTfHzKV/o5onkzpv50Ao/YL
         eTq0Mc9CNLbJDS7R4VABYj+Si+gPxHAvqeyl3+E0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Zhang Qilong <zhangqilong3@huawei.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 23/38] MIPS: Alchemy: Fix memleak in alchemy_clk_setup_cpu
Date:   Mon, 23 Nov 2020 13:22:09 +0100
Message-Id: <20201123121805.420534567@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121804.306030358@linuxfoundation.org>
References: <20201123121804.306030358@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Qilong <zhangqilong3@huawei.com>

[ Upstream commit ac3b57adf87ad9bac7e33ca26bbbb13fae1ed62b ]

If the clk_register fails, we should free h before
function returns to prevent memleak.

Fixes: 474402291a0ad ("MIPS: Alchemy: clock framework integration of onchip clocks")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/alchemy/common/clock.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/mips/alchemy/common/clock.c b/arch/mips/alchemy/common/clock.c
index bd34f4093cd9f..7b0dec333c964 100644
--- a/arch/mips/alchemy/common/clock.c
+++ b/arch/mips/alchemy/common/clock.c
@@ -151,6 +151,7 @@ static struct clk __init *alchemy_clk_setup_cpu(const char *parent_name,
 {
 	struct clk_init_data id;
 	struct clk_hw *h;
+	struct clk *clk;
 
 	h = kzalloc(sizeof(*h), GFP_KERNEL);
 	if (!h)
@@ -163,7 +164,13 @@ static struct clk __init *alchemy_clk_setup_cpu(const char *parent_name,
 	id.ops = &alchemy_clkops_cpu;
 	h->init = &id;
 
-	return clk_register(NULL, h);
+	clk = clk_register(NULL, h);
+	if (IS_ERR(clk)) {
+		pr_err("failed to register clock\n");
+		kfree(h);
+	}
+
+	return clk;
 }
 
 /* AUXPLLs ************************************************************/
-- 
2.27.0




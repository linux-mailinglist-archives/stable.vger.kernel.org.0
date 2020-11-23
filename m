Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 607312C0743
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 13:44:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732172AbgKWMjE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:39:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:51606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732156AbgKWMjA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:39:00 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D6D392065E;
        Mon, 23 Nov 2020 12:38:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135137;
        bh=7JO9uOpcLBR7PUZiMnMGHVYjoeNjrgGy7T35VmKE4Uk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r55s+8W6Qmjl8YrQNJXVrO34oI2tLe0HZoHIrn23m7S/GyMTXjHjkisrIsFO265HT
         FWYAb3F2X/cxCZHHrW/cfcRZEMfU8s4reYhEEACm/HbSaRaqitcPFLoJITBHwIbzae
         z78wkKJDQAe0CyuQzpTe20nqSUER+eOsqCpq3MMg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Zhang Qilong <zhangqilong3@huawei.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 090/158] MIPS: Alchemy: Fix memleak in alchemy_clk_setup_cpu
Date:   Mon, 23 Nov 2020 13:21:58 +0100
Message-Id: <20201123121824.273280943@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121819.943135899@linuxfoundation.org>
References: <20201123121819.943135899@linuxfoundation.org>
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
index a95a894aceaf1..f0c8303371047 100644
--- a/arch/mips/alchemy/common/clock.c
+++ b/arch/mips/alchemy/common/clock.c
@@ -152,6 +152,7 @@ static struct clk __init *alchemy_clk_setup_cpu(const char *parent_name,
 {
 	struct clk_init_data id;
 	struct clk_hw *h;
+	struct clk *clk;
 
 	h = kzalloc(sizeof(*h), GFP_KERNEL);
 	if (!h)
@@ -164,7 +165,13 @@ static struct clk __init *alchemy_clk_setup_cpu(const char *parent_name,
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




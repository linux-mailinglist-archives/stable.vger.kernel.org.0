Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7326B1CAB8B
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 14:44:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729205AbgEHMog (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:44:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:43116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729202AbgEHMof (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:44:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AF6B02145D;
        Fri,  8 May 2020 12:44:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941875;
        bh=HJHN5sj1vd4/4NzFiddp91u6CB25GJ+psBJotnAwsvg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=08OohzFhl39jOtzsNFPH5hpBmQybK8TwW2eUiK47VWIOv2ybTgS/FChTIM+smv0uX
         zKrn+V1EKRDPHlN++1dbg+RAeCIby8dD9vyDZUxpvXUtvRTdTzsMjUS0f0kVqBiy/2
         vAtOgftoPkohlWUBhg3xY2qwo5Ga2ocEzPzus4SU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Laura Abbott <labbott@redhat.com>,
        Loc Ho <lho@apm.com>, Stephen Boyd <sboyd@codeaurora.org>
Subject: [PATCH 4.4 207/312] clk: xgene: Dont call __pa on ioremaped address
Date:   Fri,  8 May 2020 14:33:18 +0200
Message-Id: <20200508123138.976378561@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Laura Abbott <labbott@redhat.com>

commit 06b113e9f28f8657715919087a3f54b77d1634ed upstream.

ioremaped addresses are not linearly mapped so the physical
address can not be figured out via __pa. More generally, there
is no guarantee that backing value of an ioremapped address
is a physical address at all. The value here is only used
for debugging so just drop the call to __pa on the ioremapped
address.

Fixes: 6ae5fd381251 ("clk: xgene: Silence sparse warnings")
Signed-off-by: Laura Abbott <labbott@redhat.com>
Acked-by: Loc Ho <lho@apm.com>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/clk/clk-xgene.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

--- a/drivers/clk/clk-xgene.c
+++ b/drivers/clk/clk-xgene.c
@@ -218,22 +218,20 @@ static int xgene_clk_enable(struct clk_h
 	struct xgene_clk *pclk = to_xgene_clk(hw);
 	unsigned long flags = 0;
 	u32 data;
-	phys_addr_t reg;
 
 	if (pclk->lock)
 		spin_lock_irqsave(pclk->lock, flags);
 
 	if (pclk->param.csr_reg != NULL) {
 		pr_debug("%s clock enabled\n", clk_hw_get_name(hw));
-		reg = __pa(pclk->param.csr_reg);
 		/* First enable the clock */
 		data = xgene_clk_read(pclk->param.csr_reg +
 					pclk->param.reg_clk_offset);
 		data |= pclk->param.reg_clk_mask;
 		xgene_clk_write(data, pclk->param.csr_reg +
 					pclk->param.reg_clk_offset);
-		pr_debug("%s clock PADDR base %pa clk offset 0x%08X mask 0x%08X value 0x%08X\n",
-			clk_hw_get_name(hw), &reg,
+		pr_debug("%s clk offset 0x%08X mask 0x%08X value 0x%08X\n",
+			clk_hw_get_name(hw),
 			pclk->param.reg_clk_offset, pclk->param.reg_clk_mask,
 			data);
 
@@ -243,8 +241,8 @@ static int xgene_clk_enable(struct clk_h
 		data &= ~pclk->param.reg_csr_mask;
 		xgene_clk_write(data, pclk->param.csr_reg +
 					pclk->param.reg_csr_offset);
-		pr_debug("%s CSR RESET PADDR base %pa csr offset 0x%08X mask 0x%08X value 0x%08X\n",
-			clk_hw_get_name(hw), &reg,
+		pr_debug("%s csr offset 0x%08X mask 0x%08X value 0x%08X\n",
+			clk_hw_get_name(hw),
 			pclk->param.reg_csr_offset, pclk->param.reg_csr_mask,
 			data);
 	}



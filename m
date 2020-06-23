Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 087F120652E
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:33:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390874AbgFWVcA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 17:32:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:54528 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388958AbgFWUMo (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:12:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0B2EA206C3;
        Tue, 23 Jun 2020 20:12:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592943164;
        bh=a38lPOpHUJ/67OKP3OGm3D7iGuZwJscGVBxvosVKr6E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cO/Eycs/mDhe/j5xojREF4rM5uf3rX9NJaBjr4C7IG8Ggq9n/apMFe795QEQMzjGF
         L5s43SboDB8fLZokXsDlyq82iRPVAR1kl/i1aPVmkLPJwspaSITF61tlTpg7stwA4f
         JzZX7gxhN0+D0X4Ue+O3ubMqVuyEOP5HXOlhubU4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chunyan Zhang <chunyan.zhang@unisoc.com>,
        Baolin Wang <baolin.wang7@gmail.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 285/477] clk: sprd: return correct type of value for _sprd_pll_recalc_rate
Date:   Tue, 23 Jun 2020 21:54:42 +0200
Message-Id: <20200623195421.042731722@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195407.572062007@linuxfoundation.org>
References: <20200623195407.572062007@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chunyan Zhang <chunyan.zhang@unisoc.com>

[ Upstream commit c2f30986d418f26abefc2eec90ebf06716c970d2 ]

The function _sprd_pll_recalc_rate() defines return value to unsigned
long, but it would return a negative value when malloc fail, changing
to return its parent_rate makes more sense, since if the callback
.recalc_rate() is not set, the framework returns the parent_rate as
well.

Fixes: 3e37b005580b ("clk: sprd: add adjustable pll support")
Signed-off-by: Chunyan Zhang <chunyan.zhang@unisoc.com>
Link: https://lkml.kernel.org/r/20200519030036.1785-2-zhang.lyra@gmail.com
Reviewed-by: Baolin Wang <baolin.wang7@gmail.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/sprd/pll.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/sprd/pll.c b/drivers/clk/sprd/pll.c
index 15791484388fa..13a322b2535ac 100644
--- a/drivers/clk/sprd/pll.c
+++ b/drivers/clk/sprd/pll.c
@@ -106,7 +106,7 @@ static unsigned long _sprd_pll_recalc_rate(const struct sprd_pll *pll,
 
 	cfg = kcalloc(regs_num, sizeof(*cfg), GFP_KERNEL);
 	if (!cfg)
-		return -ENOMEM;
+		return parent_rate;
 
 	for (i = 0; i < regs_num; i++)
 		cfg[i] = sprd_pll_read(pll, i);
-- 
2.25.1




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CEAC4800C1
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 16:51:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240153AbhL0PtQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 10:49:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236541AbhL0PrJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 10:47:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA1E1C061785;
        Mon, 27 Dec 2021 07:43:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 78BECB810CC;
        Mon, 27 Dec 2021 15:43:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDA7BC36AEA;
        Mon, 27 Dec 2021 15:43:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640619782;
        bh=AzjYiV6KVWJ7DaCiw9CNUEJKIYrg7SBxHWE5S844QuA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1vyYapadyHnrPnagVXhfsSuTARJOkm2CtpgJNQ0/kg5/BU665eGoFVq8MTeFtimU4
         s/Vl1M+u4Lt/Nom2UQ8cWipVbgQqPL+0c69B+5l5mvBwhfoBVLdYR7QB8WpsJT92po
         mr1dBvpN3e7x+9sRXauLXY7tPAC1SN90LO8psxyg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Yuji Ishikawa <yuji2.ishikawa@toshiba.co.jp>,
        Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 050/128] net: stmmac: dwmac-visconti: Fix value of ETHER_CLK_SEL_FREQ_SEL_2P5M
Date:   Mon, 27 Dec 2021 16:30:25 +0100
Message-Id: <20211227151333.183853017@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227151331.502501367@linuxfoundation.org>
References: <20211227151331.502501367@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>

[ Upstream commit 391e5975c0208ce3739587b33eba08be3e473d79 ]

ETHER_CLK_SEL_FREQ_SEL_2P5M is not 0 bit of the register. This is a
value, which is 0. Fix from BIT(0) to 0.

Reported-by: Yuji Ishikawa <yuji2.ishikawa@toshiba.co.jp>
Fixes: b38dd98ff8d0 ("net: stmmac: Add Toshiba Visconti SoCs glue driver")
Signed-off-by: Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Link: https://lore.kernel.org/r/20211223073633.101306-1-nobuhiro1.iwamatsu@toshiba.co.jp
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-visconti.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-visconti.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-visconti.c
index d046e33b8a297..fac788718c045 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-visconti.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-visconti.c
@@ -26,7 +26,7 @@
 #define ETHER_CLK_SEL_FREQ_SEL_125M	(BIT(9) | BIT(8))
 #define ETHER_CLK_SEL_FREQ_SEL_50M	BIT(9)
 #define ETHER_CLK_SEL_FREQ_SEL_25M	BIT(8)
-#define ETHER_CLK_SEL_FREQ_SEL_2P5M	BIT(0)
+#define ETHER_CLK_SEL_FREQ_SEL_2P5M	0
 #define ETHER_CLK_SEL_TX_CLK_EXT_SEL_IN BIT(0)
 #define ETHER_CLK_SEL_TX_CLK_EXT_SEL_TXC BIT(10)
 #define ETHER_CLK_SEL_TX_CLK_EXT_SEL_DIV BIT(11)
-- 
2.34.1




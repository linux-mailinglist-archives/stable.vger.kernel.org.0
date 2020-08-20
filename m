Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD7CD24BECA
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 15:32:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728691AbgHTNcR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 09:32:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:42902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727859AbgHTJbO (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:31:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1511F208E4;
        Thu, 20 Aug 2020 09:31:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597915873;
        bh=Ot+IlbwWoYcMtGQlRqjPHSZwBDd0x0OKpAG8nmv7J4g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m+Fj59qV2nZXhUcTxywvpke6sa+YEyLANVuz+vTkKKJf7WgO+QLTf2V8pxXRBn4+S
         kL0P/SP6H8/MLuSz3igxD4ad4oYANMr/vJMtrKinOai4UE/fY3p2vJZpnzbIg7/MQE
         Q+Ean9MFg/509RrvUpGJHnJP7Hs345xhz23HJjCE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Konrad Dybcio <konradybcio@gmail.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 165/232] clk: qcom: gcc-sdm660: Fix up gcc_mss_mnoc_bimc_axi_clk
Date:   Thu, 20 Aug 2020 11:20:16 +0200
Message-Id: <20200820091620.802984528@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091612.692383444@linuxfoundation.org>
References: <20200820091612.692383444@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Konrad Dybcio <konradybcio@gmail.com>

[ Upstream commit 3386af51d3bcebcba3f7becdb1ef2e384abe90cf ]

Add missing halt_check, hwcg_reg and hwcg_bit properties.
These were likely omitted when porting the driver upstream.

Signed-off-by: Konrad Dybcio <konradybcio@gmail.com>
Link: https://lore.kernel.org/r/20200726111215.22361-9-konradybcio@gmail.com
Fixes: f2a76a2955c0 ("clk: qcom: Add Global Clock controller (GCC) driver for SDM660")
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gcc-sdm660.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/clk/qcom/gcc-sdm660.c b/drivers/clk/qcom/gcc-sdm660.c
index bf5730832ef3d..c6fb57cd576f5 100644
--- a/drivers/clk/qcom/gcc-sdm660.c
+++ b/drivers/clk/qcom/gcc-sdm660.c
@@ -1715,6 +1715,9 @@ static struct clk_branch gcc_mss_cfg_ahb_clk = {
 
 static struct clk_branch gcc_mss_mnoc_bimc_axi_clk = {
 	.halt_reg = 0x8a004,
+	.halt_check = BRANCH_HALT,
+	.hwcg_reg = 0x8a004,
+	.hwcg_bit = 1,
 	.clkr = {
 		.enable_reg = 0x8a004,
 		.enable_mask = BIT(0),
-- 
2.25.1




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60B1D24B3AC
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 11:51:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729760AbgHTJut (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 05:50:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:58996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729756AbgHTJur (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:50:47 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 83CD62067C;
        Thu, 20 Aug 2020 09:50:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597917047;
        bh=Ot+IlbwWoYcMtGQlRqjPHSZwBDd0x0OKpAG8nmv7J4g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y77ZM5iD6PCIdm7XwkjucTFhbRJWalgtI9evsFTi4u51UcabTpUj06QjC5eG8zZpG
         l705r4Lz7KiGLq06V1mzTCqfv/5xoqtEXgwPkX+eBlbTXCux6QgF1oXM3mlUwSlfd4
         a7rjGWvM0e58D+JlLa6E9mfDYhuWeqrNYVUrKUOc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Konrad Dybcio <konradybcio@gmail.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 110/152] clk: qcom: gcc-sdm660: Fix up gcc_mss_mnoc_bimc_axi_clk
Date:   Thu, 20 Aug 2020 11:21:17 +0200
Message-Id: <20200820091559.405855518@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091553.615456912@linuxfoundation.org>
References: <20200820091553.615456912@linuxfoundation.org>
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




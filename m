Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6E8849A2D1
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:01:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2365987AbiAXXwF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 18:52:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1843485AbiAXXED (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 18:04:03 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35D90C06C5B5;
        Mon, 24 Jan 2022 13:15:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EF778B80CCF;
        Mon, 24 Jan 2022 21:15:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A11C3C340E4;
        Mon, 24 Jan 2022 21:15:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058945;
        bh=ZTrTILL+jVZqYLfi1HTYLKwvvvtqq9rneJNTbYsC+Cc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aKh1gYRSsDwVu7Yl+znqypXGnHKHALv6GMGDso0G9bRSJGaIdIm9n+8WN4d5Oqge3
         fVcLL6s1uB5QccBOAnU8Yht1wEzIomrWjZVMsNoo2YheqLMYP72P4qslCaygE1nrAx
         yxd3LVlcwNuqF6iM+vmVq09ACP6y8IyXTZNwRDFs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adam Ford <aford173@gmail.com>,
        Fabio Estevam <festevam@gmail.com>,
        Abel Vesa <abel.vesa@nxp.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0454/1039] clk: imx8mn: Fix imx8mn_clko1_sels
Date:   Mon, 24 Jan 2022 19:37:23 +0100
Message-Id: <20220124184140.560309215@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adam Ford <aford173@gmail.com>

[ Upstream commit 570727e9acfac1c2330a01dd5e1272e9c3acec08 ]

When attempting to use sys_pll1_80m as the parent for clko1, the
system hangs.  This is due to the fact that the source select
for sys_pll1_80m was incorrectly pointing to m7_alt_pll_clk, which
doesn't yet exist.

According to Rev 3 of the TRM, The imx8mn_clko1_sels also incorrectly
references an osc_27m which does not exist, nor does an entry for
source select bits 010b.  Fix both by inserting a dummy clock into
the missing space in the table and renaming the incorrectly name clock
with dummy.

Fixes: 96d6392b54db ("clk: imx: Add support for i.MX8MN clock driver")
Signed-off-by: Adam Ford <aford173@gmail.com>
Reviewed-by: Fabio Estevam <festevam@gmail.com>
Link: https://lore.kernel.org/r/20211117133202.775633-1-aford173@gmail.com
Signed-off-by: Abel Vesa <abel.vesa@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/imx/clk-imx8mn.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/clk/imx/clk-imx8mn.c b/drivers/clk/imx/clk-imx8mn.c
index c55577604e16a..021355a247081 100644
--- a/drivers/clk/imx/clk-imx8mn.c
+++ b/drivers/clk/imx/clk-imx8mn.c
@@ -277,9 +277,9 @@ static const char * const imx8mn_pdm_sels[] = {"osc_24m", "sys_pll2_100m", "audi
 
 static const char * const imx8mn_dram_core_sels[] = {"dram_pll_out", "dram_alt_root", };
 
-static const char * const imx8mn_clko1_sels[] = {"osc_24m", "sys_pll1_800m", "osc_27m",
-						 "sys_pll1_200m", "audio_pll2_out", "vpu_pll",
-						 "sys_pll1_80m", };
+static const char * const imx8mn_clko1_sels[] = {"osc_24m", "sys_pll1_800m", "dummy",
+						 "sys_pll1_200m", "audio_pll2_out", "sys_pll2_500m",
+						 "dummy", "sys_pll1_80m", };
 static const char * const imx8mn_clko2_sels[] = {"osc_24m", "sys_pll2_200m", "sys_pll1_400m",
 						 "sys_pll2_166m", "sys_pll3_out", "audio_pll1_out",
 						 "video_pll1_out", "osc_32k", };
-- 
2.34.1




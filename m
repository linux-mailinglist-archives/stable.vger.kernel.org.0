Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD93549A34E
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:02:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2366233AbiAXXwc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 18:52:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1845410AbiAXXMO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 18:12:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29579C067A50;
        Mon, 24 Jan 2022 13:19:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BCBAA614D9;
        Mon, 24 Jan 2022 21:19:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6E25C340E4;
        Mon, 24 Jan 2022 21:19:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643059160;
        bh=Q1kC21dAegmZRgPiBknkj/MgOmMj2SG0aFo5rzmAtLA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ijf8I1lwug+Q/kVSN3XxQMRw7WEuHyvdYszkCVj8E9n3A7C4azJko1e/2Oe7Taqhk
         f1WsXLjl32VD/wbrsBthzAXdJ8SryT3f7I3xmz1DKM2radhojXdgKVcGZOJC3AB5Sl
         kKODdzhJrAIZXjejjdJmdCHSBL3dFLPQSGIlfe9E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Taniya Das <tdas@codeaurora.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0524/1039] clk: qcom: gcc-sc7280: Mark gcc_cfg_noc_lpass_clk always enabled
Date:   Mon, 24 Jan 2022 19:38:33 +0100
Message-Id: <20220124184142.900566554@linuxfoundation.org>
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

From: Taniya Das <tdas@codeaurora.org>

[ Upstream commit 9c337073d9d81a145434b22f42dc3128ecd17730 ]

The gcc cfg noc lpass clock is required to be always enabled for the
LPASS core and audio drivers to be functional.

Fixes: a3cc092196ef ("clk: qcom: Add Global Clock controller (GCC) driver for SC7280")
Signed-off-by: Taniya Das <tdas@codeaurora.org>
Link: https://lore.kernel.org/r/1640018638-19436-4-git-send-email-tdas@codeaurora.org
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gcc-sc7280.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/qcom/gcc-sc7280.c b/drivers/clk/qcom/gcc-sc7280.c
index 8fb6bd69f240e..423627d49719c 100644
--- a/drivers/clk/qcom/gcc-sc7280.c
+++ b/drivers/clk/qcom/gcc-sc7280.c
@@ -2917,7 +2917,7 @@ static struct clk_branch gcc_cfg_noc_lpass_clk = {
 		.enable_mask = BIT(0),
 		.hw.init = &(struct clk_init_data){
 			.name = "gcc_cfg_noc_lpass_clk",
-			.ops = &clk_branch2_ops,
+			.ops = &clk_branch2_aon_ops,
 		},
 	},
 };
-- 
2.34.1




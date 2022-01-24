Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 631FC49A97C
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 05:24:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1322619AbiAYDWK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 22:22:10 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:37312 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351174AbiAXUcE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:32:04 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 143E3B812A7;
        Mon, 24 Jan 2022 20:32:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 483F9C340E5;
        Mon, 24 Jan 2022 20:32:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643056321;
        bh=H3JgWIkK9aF+AOG0Q3SJH7ksdWnhv7n/DB0Ug8t9JDI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0CcOV3uGvgvMaHWkcSEyPSnqsLgtV3Vf2R+9nJVcfiZKbf8pyP1DNlc/SmARbTlKR
         MhgACVsQJ3gEYO1Cc05Vf80CzmvIu8RO1f0xWdgufVkdWDxGiXsPHobE9XOFJ9QoFS
         5mwmbyeSNTiaXr3DBP+XGb8J3dzBJNo5pPC1THaU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Taniya Das <tdas@codeaurora.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 446/846] clk: qcom: gcc-sc7280: Mark gcc_cfg_noc_lpass_clk always enabled
Date:   Mon, 24 Jan 2022 19:39:23 +0100
Message-Id: <20220124184116.371930653@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
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
index 6cefcdc869905..ce7c5ba2b9b7a 100644
--- a/drivers/clk/qcom/gcc-sc7280.c
+++ b/drivers/clk/qcom/gcc-sc7280.c
@@ -2998,7 +2998,7 @@ static struct clk_branch gcc_cfg_noc_lpass_clk = {
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




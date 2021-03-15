Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1345F33B9AB
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:08:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234929AbhCOOG3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:06:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:37670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233431AbhCOOBk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:01:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F145464F8E;
        Mon, 15 Mar 2021 14:01:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816881;
        bh=tHm/Kk0U1CPkbj8AoDeHlXex1E0wOapV0Zh4pO31GUk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CYF061RhxIqccrBHZOYqRLw3BSpcSl6AuykdeQU4YzA/PZpFy4RRjb7tvnzCREbc0
         nmG0QR/WWi4o+Ptru7opO9gzNV9NDpv0n7WB+Pzw+ELYXch08fuo8NVROLHTV+rs6z
         HKhhj71uY7S3YgE0jhdXbIKvLq4ggtI87W3ghcNc=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@somainline.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 166/290] clk: qcom: gpucc-msm8998: Add resets, cxc, fix flags on gpu_gx_gdsc
Date:   Mon, 15 Mar 2021 14:54:19 +0100
Message-Id: <20210315135547.511249559@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135541.921894249@linuxfoundation.org>
References: <20210315135541.921894249@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: AngeloGioacchino Del Regno <angelogioacchino.delregno@somainline.org>

[ Upstream commit a59c16c80bd791878cf81d1d5aae508eeb2e73f1 ]

The GPU GX GDSC has GPU_GX_BCR reset and gfx3d_clk CXC, as stated
on downstream kernels (and as verified upstream, because otherwise
random lockups happen).
Also, add PWRSTS_RET and NO_RET_PERIPH: also as found downstream,
and also as verified here, to avoid GPU related lockups it is
necessary to force retain mem, but *not* peripheral when enabling
this GDSC (and, of course, the inverse on disablement).

With this change, the GPU finally works flawlessly on my four
different MSM8998 devices from two different manufacturers.

Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@somainline.org>
Link: https://lore.kernel.org/r/20210114221059.483390-11-angelogioacchino.delregno@somainline.org
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gpucc-msm8998.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/qcom/gpucc-msm8998.c b/drivers/clk/qcom/gpucc-msm8998.c
index 9b3923af02a1..1a518c4915b4 100644
--- a/drivers/clk/qcom/gpucc-msm8998.c
+++ b/drivers/clk/qcom/gpucc-msm8998.c
@@ -253,12 +253,16 @@ static struct gdsc gpu_cx_gdsc = {
 static struct gdsc gpu_gx_gdsc = {
 	.gdscr = 0x1094,
 	.clamp_io_ctrl = 0x130,
+	.resets = (unsigned int []){ GPU_GX_BCR },
+	.reset_count = 1,
+	.cxcs = (unsigned int []){ 0x1098 },
+	.cxc_count = 1,
 	.pd = {
 		.name = "gpu_gx",
 	},
 	.parent = &gpu_cx_gdsc.pd,
-	.pwrsts = PWRSTS_OFF_ON,
-	.flags = CLAMP_IO | AON_RESET,
+	.pwrsts = PWRSTS_OFF_ON | PWRSTS_RET,
+	.flags = CLAMP_IO | SW_RESET | AON_RESET | NO_RET_PERIPH,
 };
 
 static struct clk_regmap *gpucc_msm8998_clocks[] = {
-- 
2.30.1




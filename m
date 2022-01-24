Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B29C949A03E
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 00:25:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1843576AbiAXXE6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 18:04:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382519AbiAXW4D (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 17:56:03 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4457AC055AA3;
        Mon, 24 Jan 2022 13:10:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 010F2B8121C;
        Mon, 24 Jan 2022 21:10:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F551C340E5;
        Mon, 24 Jan 2022 21:10:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058648;
        bh=3Fu7+CpOM2je09bja5KFR0o3WRmslcWj3YAGQSVyIFU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Hd2uPuG6f380x4G1oKDviaDJyiSvLbpPX4upUnxzhrJg7JgDwpoNH55TWhf4jqg8m
         6vgHfGfda9mEGxjbh+cPOJEFPO8j0cGEURXvVvX0Xckv51Fqvjz9WVqimmVqxp4+z9
         Pqm2MoLICdSVsAOVmVXTKimbctWIVD15qkNvFQ1g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Marijn Suijten <marijn.suijten@somainline.org>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@somainline.org>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0357/1039] regulator: qcom-labibb: OCP interrupts are not a failure while disabled
Date:   Mon, 24 Jan 2022 19:35:46 +0100
Message-Id: <20220124184137.282853958@linuxfoundation.org>
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

From: Marijn Suijten <marijn.suijten@somainline.org>

[ Upstream commit d27bb69dc83f00f86a830298c967052cded6e784 ]

Receiving the Over-Current Protection interrupt while the regulator is
disabled does not count as unhandled/failure (IRQ_NONE, or 0 as it were)
but a "fake event", usually due to inrush as the is regulator about to
be enabled.

Fixes: 390af53e0411 ("regulator: qcom-labibb: Implement short-circuit and over-current IRQs")
Signed-off-by: Marijn Suijten <marijn.suijten@somainline.org>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@somainline.org>
Link: https://lore.kernel.org/r/20211224113450.107958-1-marijn.suijten@somainline.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/qcom-labibb-regulator.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/qcom-labibb-regulator.c b/drivers/regulator/qcom-labibb-regulator.c
index b3da0dc58782f..639b71eb41ffe 100644
--- a/drivers/regulator/qcom-labibb-regulator.c
+++ b/drivers/regulator/qcom-labibb-regulator.c
@@ -260,7 +260,7 @@ static irqreturn_t qcom_labibb_ocp_isr(int irq, void *chip)
 
 	/* If the regulator is not enabled, this is a fake event */
 	if (!ops->is_enabled(vreg->rdev))
-		return 0;
+		return IRQ_HANDLED;
 
 	/* If we tried to recover for too many times it's not getting better */
 	if (vreg->ocp_irq_count > LABIBB_MAX_OCP_COUNT)
-- 
2.34.1




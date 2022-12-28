Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66CF1657EF3
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:59:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234225AbiL1P7d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:59:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234223AbiL1P7c (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:59:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18F4A18E14
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:59:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A8BB661562
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:59:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBA09C433EF;
        Wed, 28 Dec 2022 15:59:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672243171;
        bh=W/Xnmc97F+AtLcG8E2pp6biNEpuKZmfhp14G8o0Nryc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BfmANrE4gpzhCWCQ9GNmH0iX9KsdoIVDQtqKScvTs3C2veWqiNk6YvFPBkgFGFYhS
         jyojUN/ZGbN4V3VFuLhsM0Z9U9FDMiOsDbMoMo1MVsI3fMKwwao6cS6uCCN/A0SoGS
         Uo7JzopNioNrsXUyVK3hHt9aev55pFQrKPNsy5xk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yuan Can <yuancan@huawei.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0497/1073] regulator: qcom-labibb: Fix missing of_node_put() in qcom_labibb_regulator_probe()
Date:   Wed, 28 Dec 2022 15:34:45 +0100
Message-Id: <20221228144341.534325280@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yuan Can <yuancan@huawei.com>

[ Upstream commit cf34ac6aa2b12fb0c3aacfdcae8acd7904b949ec ]

The reg_node needs to be released through of_node_put() in the error
handling path when of_irq_get_byname() failed.

Fixes: 390af53e0411 ("regulator: qcom-labibb: Implement short-circuit and over-current IRQs")
Signed-off-by: Yuan Can <yuancan@huawei.com>
Link: https://lore.kernel.org/r/20221203062109.115043-1-yuancan@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/qcom-labibb-regulator.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/regulator/qcom-labibb-regulator.c b/drivers/regulator/qcom-labibb-regulator.c
index 639b71eb41ff..bcf7140f3bc9 100644
--- a/drivers/regulator/qcom-labibb-regulator.c
+++ b/drivers/regulator/qcom-labibb-regulator.c
@@ -822,6 +822,7 @@ static int qcom_labibb_regulator_probe(struct platform_device *pdev)
 			if (irq == 0)
 				irq = -EINVAL;
 
+			of_node_put(reg_node);
 			return dev_err_probe(vreg->dev, irq,
 					     "Short-circuit irq not found.\n");
 		}
-- 
2.35.1




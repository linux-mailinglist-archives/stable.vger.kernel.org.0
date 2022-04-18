Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2CD45055EC
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 15:29:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241062AbiDRNbQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 09:31:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244168AbiDRNaG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 09:30:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DCCB40E7D;
        Mon, 18 Apr 2022 05:54:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9A514B80E44;
        Mon, 18 Apr 2022 12:54:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09F97C385A1;
        Mon, 18 Apr 2022 12:54:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650286449;
        bh=pEFGY82kW++W5E6RdEZX1L0cTVXtC2pmpTFDmucn2x0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NR3mEj8v8z3MRawVz2YUEE8qahlL9enj3FbUYnuPPXHs5drBE1KHaq09Yd8AJtcF7
         LWrx9hwF8w8uY8iBU8/TdATxDSBmtyVRTsbv9lS+l0bdsK2bQwv5bDS6u3ldecBq0H
         Z62pWN4JDEeVSrGWczf6yDaIGEf+KzkU4bp59RNE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Thierry Reding <treding@nvidia.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 139/284] clk: tegra: tegra124-emc: Fix missing put_device() call in emc_ensure_emc_driver
Date:   Mon, 18 Apr 2022 14:12:00 +0200
Message-Id: <20220418121215.395941274@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121210.689577360@linuxfoundation.org>
References: <20220418121210.689577360@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit 6d6ef58c2470da85a99119f74d34216c8074b9f0 ]

The reference taken by 'of_find_device_by_node()' must be released when
not needed anymore.
Add the corresponding 'put_device()' in the error handling path.

Fixes: 2db04f16b589 ("clk: tegra: Add EMC clock driver")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Acked-by: Thierry Reding <treding@nvidia.com>
Link: https://lore.kernel.org/r/20220112104501.30655-1-linmq006@gmail.com
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/tegra/clk-emc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clk/tegra/clk-emc.c b/drivers/clk/tegra/clk-emc.c
index 11a5066e5c27..8b47d57cad17 100644
--- a/drivers/clk/tegra/clk-emc.c
+++ b/drivers/clk/tegra/clk-emc.c
@@ -190,6 +190,7 @@ static struct tegra_emc *emc_ensure_emc_driver(struct tegra_clk_emc *tegra)
 
 	tegra->emc = platform_get_drvdata(pdev);
 	if (!tegra->emc) {
+		put_device(&pdev->dev);
 		pr_err("%s: cannot find EMC driver\n", __func__);
 		return NULL;
 	}
-- 
2.34.1




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDCB55F2B50
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 09:57:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232235AbiJCH5q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 03:57:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229592AbiJCH5S (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 03:57:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E1F952477;
        Mon,  3 Oct 2022 00:34:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D1BDE60FA6;
        Mon,  3 Oct 2022 07:24:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4BFBC433C1;
        Mon,  3 Oct 2022 07:24:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664781882;
        bh=M19qWWpj7hIxF4l2BwUhgVu2KARdWE1WxgabXLaQQLQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O8VKCrUM+v0FlcZdSaHfJCgvBPJzlOc0HWrOT2BIfcDSaJXjNzj9aZ5epH+ncPQ8v
         JWm9gWxHddiyGiYEP2CpLTU3zQ3mzgVHCMyivIpTnl1Vsr7TDh5IDqYM9v3fMFYhD1
         rCsZclkbecjwDg1S8gbnPZnF5q+MZ0qun8DnGFfg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jernej Skrabec <jernej.skrabec@gmail.com>,
        Samuel Holland <samuel@sholland.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 15/25] soc: sunxi: sram: Actually claim SRAM regions
Date:   Mon,  3 Oct 2022 09:12:18 +0200
Message-Id: <20221003070715.861345549@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221003070715.406550966@linuxfoundation.org>
References: <20221003070715.406550966@linuxfoundation.org>
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

From: Samuel Holland <samuel@sholland.org>

[ Upstream commit fd362baad2e659ef0fb5652f023a606b248f1781 ]

sunxi_sram_claim() checks the sram_desc->claimed flag before updating
the register, with the intent that only one device can claim a region.
However, this was ineffective because the flag was never set.

Fixes: 4af34b572a85 ("drivers: soc: sunxi: Introduce SoC driver to map SRAMs")
Reviewed-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Signed-off-by: Samuel Holland <samuel@sholland.org>
Reviewed-by: Heiko Stuebner <heiko@sntech.de>
Tested-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Link: https://lore.kernel.org/r/20220815041248.53268-4-samuel@sholland.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/sunxi/sunxi_sram.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/soc/sunxi/sunxi_sram.c b/drivers/soc/sunxi/sunxi_sram.c
index b4b0f3480bd3..51148704af49 100644
--- a/drivers/soc/sunxi/sunxi_sram.c
+++ b/drivers/soc/sunxi/sunxi_sram.c
@@ -264,6 +264,7 @@ int sunxi_sram_claim(struct device *dev)
 	writel(val | ((device << sram_data->offset) & mask),
 	       base + sram_data->reg);
 
+	sram_desc->claimed = true;
 	spin_unlock(&sram_lock);
 
 	return 0;
-- 
2.35.1




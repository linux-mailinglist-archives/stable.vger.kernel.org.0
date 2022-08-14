Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B2BA5924FE
	for <lists+stable@lfdr.de>; Sun, 14 Aug 2022 18:38:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243031AbiHNQho (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Aug 2022 12:37:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243118AbiHNQg1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Aug 2022 12:36:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D904114B;
        Sun, 14 Aug 2022 09:28:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 123C7B80B7F;
        Sun, 14 Aug 2022 16:28:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05F4EC433C1;
        Sun, 14 Aug 2022 16:28:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660494521;
        bh=Tk9LT+HrDnbOlJPHsnH1De79aKhn4cnXYFiHb95IRw8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HQb2K9zx6zEeKQgTrASNF6vjkBiGU/vZVatVzdQRQA4wjYeNFJQEQEZeWukS+sYvB
         kIZ0iGMP/secvBRl54YpQW77MdmKEmoNdEOQeuP/NzV5u8l6/BAE7AV7W9Eb5teutZ
         rVP6yXi4sVHxmE3kQvIN6sXsY9V0qLZIlhcoLIeI64DwK/pSQBgf4Re3Lnd8OHm4jm
         ZhxfHdvOyhbPQpjCnXXeCpDRaRoJFobF/luXu4yCxC5ErF0xllS7eJRLfoLtZTtj++
         7eSL+BuMxovr6G4cb4XZ0ffE1FKZOsCp1DnHdqXq/mPHi4Sa6PptW6Q6gxgrmc/Wxw
         TMASmD3eKFJ4A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Liang He <windhl@126.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>, ye.guojin@zte.com.cn,
        linux-mips@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 04/16] mips: cavium-octeon: Fix missing of_node_put() in octeon2_usb_clocks_start
Date:   Sun, 14 Aug 2022 12:28:19 -0400
Message-Id: <20220814162833.2398478-4-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220814162833.2398478-1-sashal@kernel.org>
References: <20220814162833.2398478-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Liang He <windhl@126.com>

[ Upstream commit 7a9f743ceead60ed454c46fbc3085ee9a79cbebb ]

We should call of_node_put() for the reference 'uctl_node' returned by
of_get_parent() which will increase the refcount. Otherwise, there will
be a refcount leak bug.

Signed-off-by: Liang He <windhl@126.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/cavium-octeon/octeon-platform.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/mips/cavium-octeon/octeon-platform.c b/arch/mips/cavium-octeon/octeon-platform.c
index c214fe4e678b..04bc34714727 100644
--- a/arch/mips/cavium-octeon/octeon-platform.c
+++ b/arch/mips/cavium-octeon/octeon-platform.c
@@ -86,11 +86,12 @@ static void octeon2_usb_clocks_start(struct device *dev)
 					 "refclk-frequency", &clock_rate);
 		if (i) {
 			dev_err(dev, "No UCTL \"refclk-frequency\"\n");
+			of_node_put(uctl_node);
 			goto exit;
 		}
 		i = of_property_read_string(uctl_node,
 					    "refclk-type", &clock_type);
-
+		of_node_put(uctl_node);
 		if (!i && strcmp("crystal", clock_type) == 0)
 			is_crystal_clock = true;
 	}
-- 
2.35.1


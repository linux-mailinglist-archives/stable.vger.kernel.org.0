Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 202D259253E
	for <lists+stable@lfdr.de>; Sun, 14 Aug 2022 18:40:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243109AbiHNQja (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Aug 2022 12:39:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242938AbiHNQio (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Aug 2022 12:38:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98B3561119;
        Sun, 14 Aug 2022 09:29:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2590A60FBF;
        Sun, 14 Aug 2022 16:29:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0AFBC433C1;
        Sun, 14 Aug 2022 16:29:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660494569;
        bh=H8zKAP2GVQ+txb/T0C5yinAoxu0tC3loh6dAjeV3vrg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BLEhyyhb7HQmt+KkS6YfRKkfBWu/4IzrGu5/HXv9vqEVsSlznlJBGrhHVdSblKDm3
         CK3AVjMQHL4dqIyOY5qH0X4N6mrEI00c8RJETuDaVuqeXuZjvJU9OBcKgq8S5W2mHS
         w81Vs+8uJU23JZYe1fKv6wEkYG5lqi8aBhnRE7E/lwwYaz5SlTC7yChA7y0GjZxyZX
         WMgLJ20GqTKUZaltqmcyqArOJPAtcAZi9fTQ1mkr1XH4ypr9xi3X0xT+LO1knqC54G
         S2HdZYw7pl5kh4Nj5YauKU0pCKSe7Ynf3aFfQ/8eJmFmYFRw3IjyVH3OfGWSL2GtXW
         f3kfJrmg/mrbw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Liang He <windhl@126.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>, ye.guojin@zte.com.cn,
        linux-mips@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 04/14] mips: cavium-octeon: Fix missing of_node_put() in octeon2_usb_clocks_start
Date:   Sun, 14 Aug 2022 12:29:10 -0400
Message-Id: <20220814162922.2398723-4-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220814162922.2398723-1-sashal@kernel.org>
References: <20220814162922.2398723-1-sashal@kernel.org>
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
index 4d83f5bc7211..54c8389decda 100644
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


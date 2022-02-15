Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFC7B4B709D
	for <lists+stable@lfdr.de>; Tue, 15 Feb 2022 17:39:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240698AbiBOPf1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Feb 2022 10:35:27 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239682AbiBOPej (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Feb 2022 10:34:39 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6688AB5633;
        Tue, 15 Feb 2022 07:30:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F37F6614C2;
        Tue, 15 Feb 2022 15:30:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50428C340EB;
        Tue, 15 Feb 2022 15:30:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644939040;
        bh=0ajMXluSAqvhHBE5hWclvfBMFrRyAUrOhetBDh6ThaM=;
        h=From:To:Cc:Subject:Date:From;
        b=MQBZPDrxAJrydvRcbrXPxvbJ56uh3QtfceL5Q/5efzXOm7cLexRkuqDZniKxgd6pB
         8xvQWIxn92zmVlCKcC2IwLBfrbivnAkkwwHdhuV8npFeLTSTQsVwkQyartYKMqLFsV
         8tcawSD/lP20rVx0Z+fT5rreeI6ThD1KZdtqo5oFSyw0+bBfNgxInxyGctvoYIRSE6
         Psl2ozXJxU+yGLrFCI9gLDh2nRxqTX2mZk4XbFWX7whzXb5UdnGa2YIv7FE8p6wXu2
         ZLUjbXag3nts888b79sXmE5OCWuVSbn05lAUn4KGa4NxyIiL+zhPAxjEq/QQDCLqRs
         G6WvLsctYQq7Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wan Jiabing <wanjiabing@vivo.com>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>, bcousson@baylibre.com,
        paul@pwsan.com, linux@armlinux.org.uk, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 01/17] ARM: OMAP2+: hwmod: Add of_node_put() before break
Date:   Tue, 15 Feb 2022 10:30:21 -0500
Message-Id: <20220215153037.581579-1-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
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

From: Wan Jiabing <wanjiabing@vivo.com>

[ Upstream commit 80c469a0a03763f814715f3d12b6f3964c7423e8 ]

Fix following coccicheck warning:
./arch/arm/mach-omap2/omap_hwmod.c:753:1-23: WARNING: Function
for_each_matching_node should have of_node_put() before break

Early exits from for_each_matching_node should decrement the
node reference counter.

Signed-off-by: Wan Jiabing <wanjiabing@vivo.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-omap2/omap_hwmod.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mach-omap2/omap_hwmod.c b/arch/arm/mach-omap2/omap_hwmod.c
index 6289b288d60a6..202b740adee0e 100644
--- a/arch/arm/mach-omap2/omap_hwmod.c
+++ b/arch/arm/mach-omap2/omap_hwmod.c
@@ -782,8 +782,10 @@ static int __init _init_clkctrl_providers(void)
 
 	for_each_matching_node(np, ti_clkctrl_match_table) {
 		ret = _setup_clkctrl_provider(np);
-		if (ret)
+		if (ret) {
+			of_node_put(np);
 			break;
+		}
 	}
 
 	return ret;
-- 
2.34.1


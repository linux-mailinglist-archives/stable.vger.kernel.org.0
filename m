Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C65DF59DCDD
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:25:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353279AbiHWKXv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 06:23:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354372AbiHWKVU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 06:21:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 574ECDEE1;
        Tue, 23 Aug 2022 02:02:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D3F2A6157B;
        Tue, 23 Aug 2022 09:02:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4D8FC433D6;
        Tue, 23 Aug 2022 09:02:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661245364;
        bh=ah1xJbcTpET9sBuUevAzr/FyNFl2c5CRKuewIOVWH6c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Vw0+sSl2FeQIeAxevnJnSoZIGMMKJ4XD+rwyHMK5Ff3ec5p2q974Ji7gVxlHhq+ET
         rMPgTmdrZ9eKNQkY7PI9Y7EUwHfXAbMIAVrC3QwOfedslwZZjwg3KVVL9BpeOBukDo
         Z/TUiYlA6imhAllmNlX36tadSZKJWe8fNrPhSZK4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 055/287] ARM: bcm: Fix refcount leak in bcm_kona_smc_init
Date:   Tue, 23 Aug 2022 10:23:44 +0200
Message-Id: <20220823080102.093867472@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080100.268827165@linuxfoundation.org>
References: <20220823080100.268827165@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit cb23389a2458c2e4bfd6c86a513cbbe1c4d35e76 ]

of_find_matching_node() returns a node pointer with refcount
incremented, we should use of_node_put() on it when not need anymore.
Add missing of_node_put() to avoid refcount leak.

Fixes: b8eb35fd594a ("ARM: bcm281xx: Add L2 cache enable code")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-bcm/bcm_kona_smc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/mach-bcm/bcm_kona_smc.c b/arch/arm/mach-bcm/bcm_kona_smc.c
index a55a7ecf146a..dd0b4195e629 100644
--- a/arch/arm/mach-bcm/bcm_kona_smc.c
+++ b/arch/arm/mach-bcm/bcm_kona_smc.c
@@ -54,6 +54,7 @@ int __init bcm_kona_smc_init(void)
 		return -ENODEV;
 
 	prop_val = of_get_address(node, 0, &prop_size, NULL);
+	of_node_put(node);
 	if (!prop_val)
 		return -EINVAL;
 
-- 
2.35.1




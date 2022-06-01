Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AACAE53A8C0
	for <lists+stable@lfdr.de>; Wed,  1 Jun 2022 16:12:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345922AbiFAOLz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jun 2022 10:11:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354845AbiFAOKF (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Jun 2022 10:10:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C326010FC6;
        Wed,  1 Jun 2022 07:01:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5ECF5615E9;
        Wed,  1 Jun 2022 14:01:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFD9CC385A5;
        Wed,  1 Jun 2022 14:01:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654092078;
        bh=Web0D2RT+WjSuITvbC651iGdO+wK1BU0c4P35f/fpqw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JDzDKHxW/xh/fck++riW5RLfKfUoNQfiQBxoNOlCryuRQi8UPJ28KhwRkvm7ZJ48E
         4jkQFFy5aB1GHwTeWc/LEht6tAi5nM/0sip2W7PYjQKypTzPeGFNdMigeazCyEctFp
         OhoU7wxgA8xDCgZBaHlU5h3JA9a4Zlqk++iRaYEVF+DBKwDkEriSWDNxwmq+xDbhKj
         zon7VXhtZi9BfHxRO3jD6sOFZCqcThV0/dZPD4M1M8M6PDBCCQ8T9eAbvCMbjrs6HH
         J32S0CZyqh5LU7eO0OhBqREFxu9d03cPP9gcrfcCIxicH2djoPItBSmVPoV4NHqdVs
         BnOMYL8fsnWbw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lv Ruyi <lv.ruyi@zte.com.cn>, Zeal Robot <zealci@zte.com.cn>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, maz@kernel.org,
        nick.child@ibm.com, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 4.9 09/11] powerpc/xics: fix refcount leak in icp_opal_init()
Date:   Wed,  1 Jun 2022 10:00:58 -0400
Message-Id: <20220601140100.2005469-9-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220601140100.2005469-1-sashal@kernel.org>
References: <20220601140100.2005469-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Lv Ruyi <lv.ruyi@zte.com.cn>

[ Upstream commit 5dd9e27ea4a39f7edd4bf81e9e70208e7ac0b7c9 ]

The of_find_compatible_node() function returns a node pointer with
refcount incremented, use of_node_put() on it when done.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Lv Ruyi <lv.ruyi@zte.com.cn>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20220402013419.2410298-1-lv.ruyi@zte.com.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/sysdev/xics/icp-opal.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/powerpc/sysdev/xics/icp-opal.c b/arch/powerpc/sysdev/xics/icp-opal.c
index b53f80f0b4d8..80a4fa6dcc55 100644
--- a/arch/powerpc/sysdev/xics/icp-opal.c
+++ b/arch/powerpc/sysdev/xics/icp-opal.c
@@ -199,6 +199,7 @@ int icp_opal_init(void)
 
 	printk("XICS: Using OPAL ICP fallbacks\n");
 
+	of_node_put(np);
 	return 0;
 }
 
-- 
2.35.1


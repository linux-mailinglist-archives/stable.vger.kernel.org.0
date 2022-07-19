Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14AC1579E5A
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 15:01:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243287AbiGSNAw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 09:00:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242607AbiGSM7N (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:59:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49DE69B542;
        Tue, 19 Jul 2022 05:24:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C0517B81B1A;
        Tue, 19 Jul 2022 12:23:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D592C341C6;
        Tue, 19 Jul 2022 12:23:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658233437;
        bh=kljyRoFz+3KUUUd3bQlrQWVQc83iAkC23StdOGnlkig=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i/dP4qqdtpc/xx9BaNL5z3MYLdX6Rw3ihcXd1k7MhrDjV7ZTv7kt838ymgURAcNFe
         FA4GskyBD24kGMlcQvlaDwjTjdEfYwGF0qeA8U3yyPJXYMd1Gy8Cx3BRYXmNYjAh1B
         FxWN4JIez7k0sHSqggFTDssZk+RTXsBGx5qweHy0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yevhen Orlov <yevhen.orlov@plvision.eu>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 096/231] net: marvell: prestera: fix missed deinit sequence
Date:   Tue, 19 Jul 2022 13:53:01 +0200
Message-Id: <20220719114722.824466935@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114714.247441733@linuxfoundation.org>
References: <20220719114714.247441733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yevhen Orlov <yevhen.orlov@plvision.eu>

[ Upstream commit f946964a9f79f8dcb5a6329265281eebfc23aee5 ]

Add unregister_fib_notifier as rollback of register_fib_notifier.

Fixes: 4394fbcb78cf ("net: marvell: prestera: handle fib notifications")
Signed-off-by: Yevhen Orlov <yevhen.orlov@plvision.eu>
Link: https://lore.kernel.org/r/20220710122021.7642-1-yevhen.orlov@plvision.eu
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/prestera/prestera_router.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera_router.c b/drivers/net/ethernet/marvell/prestera/prestera_router.c
index 6c5618cf4f08..97d9012db189 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_router.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_router.c
@@ -587,6 +587,7 @@ int prestera_router_init(struct prestera_switch *sw)
 
 void prestera_router_fini(struct prestera_switch *sw)
 {
+	unregister_fib_notifier(&init_net, &sw->router->fib_nb);
 	unregister_inetaddr_notifier(&sw->router->inetaddr_nb);
 	unregister_inetaddr_validator_notifier(&sw->router->inetaddr_valid_nb);
 	rhashtable_destroy(&sw->router->kern_fib_cache_ht);
-- 
2.35.1




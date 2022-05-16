Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BF49529092
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 22:45:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348161AbiEPUC5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 16:02:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346807AbiEPT4B (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 15:56:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21EAA47AC0;
        Mon, 16 May 2022 12:49:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 21754B81613;
        Mon, 16 May 2022 19:49:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 834A2C385AA;
        Mon, 16 May 2022 19:49:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652730555;
        bh=AhnYl+ZcmT/1PsCkh76SmPzD+wrnGfBbdCPSpLDGwLs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E2xGjpU1ibEwvJEEdfsIGAlVM68RZA+3FTVLqAWA/6FbAFaP4CTdqXEasNyO9SkaN
         dIPVlZ2j0K32+5wDxbqNfVkXJkOyjrIrikD8rM+kgWGNbn9DcMLQ9nAhn2pwQZml6r
         T8zpZCSqDwXlU0UfREnQRRlVY6TMX2597HdfdImw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yang Yingliang <yangyingliang@huawei.com>,
        Felix Fietkau <nbd@nbd.name>, Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 036/102] net: ethernet: mediatek: ppe: fix wrong size passed to memset()
Date:   Mon, 16 May 2022 21:36:10 +0200
Message-Id: <20220516193625.036877528@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220516193623.989270214@linuxfoundation.org>
References: <20220516193623.989270214@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 00832b1d1a393dfb1b9491d085e5b27e8c25d103 ]

'foe_table' is a pointer, the real size of struct mtk_foe_entry
should be pass to memset().

Fixes: ba37b7caf1ed ("net: ethernet: mtk_eth_soc: add support for initializing the PPE")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Acked-by: Felix Fietkau <nbd@nbd.name>
Link: https://lore.kernel.org/r/20220511030829.3308094-1-yangyingliang@huawei.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mediatek/mtk_ppe.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_ppe.c b/drivers/net/ethernet/mediatek/mtk_ppe.c
index 3ad10c793308..66298e2235c9 100644
--- a/drivers/net/ethernet/mediatek/mtk_ppe.c
+++ b/drivers/net/ethernet/mediatek/mtk_ppe.c
@@ -395,7 +395,7 @@ static void mtk_ppe_init_foe_table(struct mtk_ppe *ppe)
 	static const u8 skip[] = { 12, 25, 38, 51, 76, 89, 102 };
 	int i, k;
 
-	memset(ppe->foe_table, 0, MTK_PPE_ENTRIES * sizeof(ppe->foe_table));
+	memset(ppe->foe_table, 0, MTK_PPE_ENTRIES * sizeof(*ppe->foe_table));
 
 	if (!IS_ENABLED(CONFIG_SOC_MT7621))
 		return;
-- 
2.35.1




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D4665EA48A
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 13:47:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236493AbiIZLrZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 07:47:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238253AbiIZLpi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 07:45:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB2D474DC2;
        Mon, 26 Sep 2022 03:47:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 609CA6068C;
        Mon, 26 Sep 2022 10:47:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75059C433C1;
        Mon, 26 Sep 2022 10:47:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664189247;
        bh=xXaYM+/QW243fqLUdMzgr5aSFHN50zkuiC7q6wscQzg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ylln0ij+JAcJZzt0Xc7TNb5RcQ9apNtIPU+IWmwsyrnLG0sdSQS9aCzCDLEEOp7Eq
         KQ1nLeSGq2kvgaUWW5Sm5wQuDcFhknfpBdTHAX8w8fyqoJRaXYFR1/xIbjlHdTOPHl
         rhMF77T7LkVy0ck9igV7CqdO0wGhe1464gC3kgTM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shailend Chand <shailend@google.com>,
        Jeroen de Borst <jeroendb@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 122/207] gve: Fix GFP flags when allocing pages
Date:   Mon, 26 Sep 2022 12:11:51 +0200
Message-Id: <20220926100812.032687082@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100806.522017616@linuxfoundation.org>
References: <20220926100806.522017616@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shailend Chand <shailend@google.com>

[ Upstream commit 8ccac4edc8da764389d4fc18b1df740892006557 ]

Use GFP_ATOMIC when allocating pages out of the hotpath,
continue to use GFP_KERNEL when allocating pages during setup.

GFP_KERNEL will allow blocking which allows it to succeed
more often in a low memory enviornment but in the hotpath we do
not want to allow the allocation to block.

Fixes: 9b8dd5e5ea48b ("gve: DQO: Add RX path")
Signed-off-by: Shailend Chand <shailend@google.com>
Signed-off-by: Jeroen de Borst <jeroendb@google.com>
Link: https://lore.kernel.org/r/20220913000901.959546-1-jeroendb@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/google/gve/gve_rx_dqo.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/google/gve/gve_rx_dqo.c b/drivers/net/ethernet/google/gve/gve_rx_dqo.c
index 8c939628e2d8..2e6461b0ea8b 100644
--- a/drivers/net/ethernet/google/gve/gve_rx_dqo.c
+++ b/drivers/net/ethernet/google/gve/gve_rx_dqo.c
@@ -157,7 +157,7 @@ static int gve_alloc_page_dqo(struct gve_priv *priv,
 	int err;
 
 	err = gve_alloc_page(priv, &priv->pdev->dev, &buf_state->page_info.page,
-			     &buf_state->addr, DMA_FROM_DEVICE, GFP_KERNEL);
+			     &buf_state->addr, DMA_FROM_DEVICE, GFP_ATOMIC);
 	if (err)
 		return err;
 
-- 
2.35.1




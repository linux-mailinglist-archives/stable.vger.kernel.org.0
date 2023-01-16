Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 539C666C52F
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:02:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231991AbjAPQCj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:02:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232119AbjAPQCW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:02:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08A0023C7D
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:01:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B7B4CB81060
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:01:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2867AC433D2;
        Mon, 16 Jan 2023 16:01:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673884916;
        bh=AtDXUXTep2VDDNmGKsPCXJkv6DS9oTrhh+ZSMB8DqW4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rwnvsl6cr/+VWRIWyt5z1+0xBa+yx0TnKvlxFfdbzSzRmXU4CRKtwXHrZMdKILFtN
         n0cEo0S9qDskLNE+ode4U8rBTE3144GblbI5nalE9sOvRHTRYb3b4jWSWQhvgRY1Z+
         4JaaMltsl2QaJTj8GMO/zJi1xXDJBpWCY1A9E+KA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Andy Gospodarek <gospo@broadcom.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 171/183] bnxt: make sure we return pages to the pool
Date:   Mon, 16 Jan 2023 16:51:34 +0100
Message-Id: <20230116154810.521164006@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154803.321528435@linuxfoundation.org>
References: <20230116154803.321528435@linuxfoundation.org>
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

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 97f5e03a4a27d27ee4fed0cdb1658c81cf2784db ]

Before the commit under Fixes the page would have been released
from the pool before the napi_alloc_skb() call, so normal page
freeing was fine (released page == no longer in the pool).

After the change we just mark the page for recycling so it's still
in the pool if the skb alloc fails, we need to recycle.

Same commit added the same bug in the new bnxt_rx_multi_page_skb().

Fixes: 1dc4c557bfed ("bnxt: adding bnxt_xdp_build_skb to build skb from multibuffer xdp_buff")
Reviewed-by: Andy Gospodarek <gospo@broadcom.com>
Link: https://lore.kernel.org/r/20230111042547.987749-1-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index f5a8bae8d79a..edca16b5f9e3 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -990,7 +990,7 @@ static struct sk_buff *bnxt_rx_multi_page_skb(struct bnxt *bp,
 			     DMA_ATTR_WEAK_ORDERING);
 	skb = build_skb(page_address(page), PAGE_SIZE);
 	if (!skb) {
-		__free_page(page);
+		page_pool_recycle_direct(rxr->page_pool, page);
 		return NULL;
 	}
 	skb_mark_for_recycle(skb);
@@ -1028,7 +1028,7 @@ static struct sk_buff *bnxt_rx_page_skb(struct bnxt *bp,
 
 	skb = napi_alloc_skb(&rxr->bnapi->napi, payload);
 	if (!skb) {
-		__free_page(page);
+		page_pool_recycle_direct(rxr->page_pool, page);
 		return NULL;
 	}
 
-- 
2.35.1




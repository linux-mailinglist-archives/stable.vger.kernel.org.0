Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19DA659D5FE
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 11:10:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244596AbiHWIhF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 04:37:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347504AbiHWIga (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 04:36:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E50C977543;
        Tue, 23 Aug 2022 01:17:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A8952B81BF8;
        Tue, 23 Aug 2022 08:17:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0441EC433D6;
        Tue, 23 Aug 2022 08:17:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661242636;
        bh=5fy4IkzWjl1hfPLwkmTOIHwX1kHx3B1rb3uQ4pKYwEc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TlmPiX+M3fiMMfcs8P2CwxPtvb1WNYqLiLBj9oxm8r7gEhNGNmMOZxdsg5AFKHVSI
         foPUfSip99r8sU+EsYbnVgWBG5r2a4EhaiCKZaF4r8V+Ltge6ulvE/RyHpNGREP6YP
         hcHPnlWDvIveYxy79FEVUUKpH3mWEARMgkQmHBbk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.19 150/365] tsnep: Fix tsnep_tx_unmap() error path usage
Date:   Tue, 23 Aug 2022 10:00:51 +0200
Message-Id: <20220823080124.506387071@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080118.128342613@linuxfoundation.org>
References: <20220823080118.128342613@linuxfoundation.org>
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

From: Gerhard Engleder <gerhard@engleder-embedded.com>

commit b3bb8628bf64440065976c71e4ab09186c393597 upstream.

If tsnep_tx_map() fails, then tsnep_tx_unmap() shall start at the write
index like tsnep_tx_map(). This is different to the normal operation.
Thus, add an additional parameter to tsnep_tx_unmap() to enable start at
different positions for successful TX and failed TX.

Fixes: 403f69bbdbad ("tsnep: Add TSN endpoint Ethernet MAC driver")
Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/engleder/tsnep_main.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/engleder/tsnep_main.c b/drivers/net/ethernet/engleder/tsnep_main.c
index d98199f3414b..a5f7152a1716 100644
--- a/drivers/net/ethernet/engleder/tsnep_main.c
+++ b/drivers/net/ethernet/engleder/tsnep_main.c
@@ -340,14 +340,14 @@ static int tsnep_tx_map(struct sk_buff *skb, struct tsnep_tx *tx, int count)
 	return 0;
 }
 
-static void tsnep_tx_unmap(struct tsnep_tx *tx, int count)
+static void tsnep_tx_unmap(struct tsnep_tx *tx, int index, int count)
 {
 	struct device *dmadev = tx->adapter->dmadev;
 	struct tsnep_tx_entry *entry;
 	int i;
 
 	for (i = 0; i < count; i++) {
-		entry = &tx->entry[(tx->read + i) % TSNEP_RING_SIZE];
+		entry = &tx->entry[(index + i) % TSNEP_RING_SIZE];
 
 		if (entry->len) {
 			if (i == 0)
@@ -395,7 +395,7 @@ static netdev_tx_t tsnep_xmit_frame_ring(struct sk_buff *skb,
 
 	retval = tsnep_tx_map(skb, tx, count);
 	if (retval != 0) {
-		tsnep_tx_unmap(tx, count);
+		tsnep_tx_unmap(tx, tx->write, count);
 		dev_kfree_skb_any(entry->skb);
 		entry->skb = NULL;
 
@@ -464,7 +464,7 @@ static bool tsnep_tx_poll(struct tsnep_tx *tx, int napi_budget)
 		if (skb_shinfo(entry->skb)->nr_frags > 0)
 			count += skb_shinfo(entry->skb)->nr_frags;
 
-		tsnep_tx_unmap(tx, count);
+		tsnep_tx_unmap(tx, tx->read, count);
 
 		if ((skb_shinfo(entry->skb)->tx_flags & SKBTX_IN_PROGRESS) &&
 		    (__le32_to_cpu(entry->desc_wb->properties) &
-- 
2.37.2




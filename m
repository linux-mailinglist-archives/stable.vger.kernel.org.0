Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3A1B54141D
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 22:13:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359431AbiFGUNC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 16:13:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359207AbiFGUJj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 16:09:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A41216ABDE;
        Tue,  7 Jun 2022 11:27:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EEC72B81FF8;
        Tue,  7 Jun 2022 18:27:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 508F5C385A2;
        Tue,  7 Jun 2022 18:27:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654626423;
        bh=/5rQ7ewDoC/Eso2+1Trr7JRLy65QvGDpVxwx+TL4Axk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Pdy3JSqbAkvqkRjl20wwlufD30PxjmwxuQd2C+HvspgtHZz/odxxsWlde1k+xBm1Y
         tKG4zLGeaVCO2vF38tquM453uKSLnzr/UCQ7F8pTIIruMsmeFvzE1CC0uR99AEjxr0
         jQqh2SlSpYStka5u6QFvBCslV3h71U/vx/TP6kiU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Felix Fietkau <nbd@nbd.name>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 372/772] mt76: do not attempt to reorder received 802.3 packets without agg session
Date:   Tue,  7 Jun 2022 18:59:24 +0200
Message-Id: <20220607164959.976474564@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 3968a66475b40691c37b5e6c76975f699671e10e ]

Fixes potential latency / packet drop issues in cases where a BA session has
not (yet) been established.

Fixes: e195dad14115 ("mt76: add support for 802.3 rx frames")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/agg-rx.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/agg-rx.c b/drivers/net/wireless/mediatek/mt76/agg-rx.c
index 72622220051b..6c8b44194579 100644
--- a/drivers/net/wireless/mediatek/mt76/agg-rx.c
+++ b/drivers/net/wireless/mediatek/mt76/agg-rx.c
@@ -162,8 +162,9 @@ void mt76_rx_aggr_reorder(struct sk_buff *skb, struct sk_buff_head *frames)
 	if (!sta)
 		return;
 
-	if (!status->aggr && !(status->flag & RX_FLAG_8023)) {
-		mt76_rx_aggr_check_ctl(skb, frames);
+	if (!status->aggr) {
+		if (!(status->flag & RX_FLAG_8023))
+			mt76_rx_aggr_check_ctl(skb, frames);
 		return;
 	}
 
-- 
2.35.1




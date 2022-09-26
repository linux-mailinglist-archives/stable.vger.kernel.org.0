Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C4E15EA1AD
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 12:55:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236673AbiIZKzW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 06:55:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237175AbiIZKys (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 06:54:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D400249B6D;
        Mon, 26 Sep 2022 03:29:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 60F3060B7E;
        Mon, 26 Sep 2022 10:29:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C0D3C433C1;
        Mon, 26 Sep 2022 10:29:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664188140;
        bh=pgUBEW38cvf7GaBuVmf2IMfJQ1xcGYl2YKHH8NdCYa0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s+hUrgazOMb7JFmK2luRUl4B7PErLGgUtFK4Y4eNPJUPXy38Ehjng5c02ebXDUBJo
         J2Rpx4eBPJm+54w4E8iJ+VeUAJ7k+a2Lvs5GKHiDUWKIo9tK14E2ZGcjzDl1KEg3zK
         6+qztVdqaie+hJsgbMn6D5RjOuWpWjcEQvSZC0WQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Felix Fietkau <nbd@nbd.name>,
        Kalle Valo <kvalo@kernel.org>
Subject: [PATCH 5.10 052/141] wifi: mt76: fix reading current per-tid starting sequence number for aggregation
Date:   Mon, 26 Sep 2022 12:11:18 +0200
Message-Id: <20220926100756.336187085@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100754.639112000@linuxfoundation.org>
References: <20220926100754.639112000@linuxfoundation.org>
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

From: Felix Fietkau <nbd@nbd.name>

commit c3a510e2b53785df31d882a773c4c0780b4c825f upstream.

The code was accidentally shifting register values down by tid % 32 instead of
(tid * field_size) % 32.

Cc: stable@vger.kernel.org
Fixes: a28bef561a5c ("mt76: mt7615: re-enable offloading of sequence number assignment")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20220826182329.18155-1-nbd@nbd.name
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/mediatek/mt76/mt7615/mac.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
@@ -950,7 +950,7 @@ u32 mt7615_mac_get_sta_tid_sn(struct mt7
 	offset %= 32;
 
 	val = mt76_rr(dev, addr);
-	val >>= (tid % 32);
+	val >>= offset;
 
 	if (offset > 20) {
 		addr += 4;



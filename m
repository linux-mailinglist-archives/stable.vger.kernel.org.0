Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2BC64F373A
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 16:19:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352547AbiDELLf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:11:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348921AbiDEJsr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:48:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45FB5EE4ED;
        Tue,  5 Apr 2022 02:37:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D5F6061368;
        Tue,  5 Apr 2022 09:37:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5452C385A2;
        Tue,  5 Apr 2022 09:37:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649151452;
        bh=PcI19hqCNDQNOO07Q9W/VnngPzZoICRke9OEaBIjGf0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xzl2g0MTsShWMOO67zbjV3v7wJyONiMqkWi+cr7ZRHvSpkQXGayTgAk/ZeTgBUVo5
         39vytaA1OcNmfiCBtp9rP7Ps4fKxw/LkmjgX+XtsyjYpJHCU1hQhzQNTA5gxu50Qk+
         veDnk3gxMWOcE/lUJD0CVQwBng37TvergU61kfz8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lorenzo Bianconi <lorenzo@kernel.org>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 421/913] mt76: connac: fix sta_rec_wtbl tag len
Date:   Tue,  5 Apr 2022 09:24:43 +0200
Message-Id: <20220405070352.465463203@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit 74c337ec0905d99111fc63a15f2e0784b9ed5503 ]

Similar to mt7915 driver, fix tag len error for sta_rec_wtbl, which
causes fw parsing error for the tags placed behind it.

Fixes: d0e274af2f2e4 ("mt76: mt76_connac: create mcu library")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
index d25b50e76932..017bd59c4ea8 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
@@ -295,7 +295,7 @@ mt76_connac_mcu_alloc_wtbl_req(struct mt76_dev *dev, struct mt76_wcid *wcid,
 	}
 
 	if (sta_hdr)
-		sta_hdr->len = cpu_to_le16(sizeof(hdr));
+		le16_add_cpu(&sta_hdr->len, sizeof(hdr));
 
 	return skb_put_data(nskb, &hdr, sizeof(hdr));
 }
-- 
2.34.1




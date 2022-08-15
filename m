Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4828A5948AD
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:09:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354363AbiHOXr7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:47:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354991AbiHOXq4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:46:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8CA3C2775;
        Mon, 15 Aug 2022 13:15:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A4DA960F71;
        Mon, 15 Aug 2022 20:15:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8709EC433D6;
        Mon, 15 Aug 2022 20:15:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660594510;
        bh=b7hS5d454oaulv4KcfZU56i0AKfffymxFdCbBxiLZoY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FPDN+0R5u5Jo9wpq+/vBY1ZLuvLeK9+pYDOnyAAxhkKNaESPhwE9xhmnqbjbnyFS0
         cKMeUEKQOafabV50bZdfjVALOfqEIXRdBu2i1NuntanMjIxrFxKR5F74JtcI44/7ni
         DBjO20q8RtfTpvZcjjOK6iDrwUl3YzFkHwSee/38=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gergo Koteles <soyer@irl.hu>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0469/1157] mt76: mt76x02u: fix possible memory leak in __mt76x02u_mcu_send_msg
Date:   Mon, 15 Aug 2022 19:57:05 +0200
Message-Id: <20220815180458.362823876@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
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

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit cffd93411575afd987788e2ec3cb8eaff70f0215 ]

Free the skb if mt76u_bulk_msg fails in __mt76x02u_mcu_send_msg routine.

Fixes: 4c89ff2c74e39 ("mt76: split __mt76u_mcu_send_msg and mt76u_mcu_send_msg routines")
Co-developed-by: Gergo Koteles <soyer@irl.hu>
Signed-off-by: Gergo Koteles <soyer@irl.hu>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt76x02_usb_mcu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_usb_mcu.c b/drivers/net/wireless/mediatek/mt76/mt76x02_usb_mcu.c
index 2953df7d8388..c6c16fe8ee85 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_usb_mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_usb_mcu.c
@@ -108,7 +108,7 @@ __mt76x02u_mcu_send_msg(struct mt76_dev *dev, struct sk_buff *skb,
 	ret = mt76u_bulk_msg(dev, skb->data, skb->len, NULL, 500,
 			     MT_EP_OUT_INBAND_CMD);
 	if (ret)
-		return ret;
+		goto out;
 
 	if (wait_resp)
 		ret = mt76x02u_mcu_wait_resp(dev, seq);
-- 
2.35.1




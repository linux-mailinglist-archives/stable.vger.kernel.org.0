Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D120E59E1B8
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:40:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354144AbiHWKZO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 06:25:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355249AbiHWKXW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 06:23:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 535929BB50;
        Tue, 23 Aug 2022 02:04:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B38A1B81C53;
        Tue, 23 Aug 2022 09:04:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E8FCC433D7;
        Tue, 23 Aug 2022 09:04:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661245457;
        bh=C+xVUrKAbI48SofDpEDFTkF7+biqsKNrNaN/gh1hoQc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0HplqmVhL0t585CKXFkwjcN0Bs/zJ008zhfkiJATppZwZE5I8FhJJAcVjT538/e1e
         rE5RrwtWds4xWr2GC/UNNfYF+veYgzA2X13wn9F7SEsi0Mpaj8lRMCPC3ACy3LkyMN
         2LE0mxBAFmAwOY0eeCqgKgChmlJqoqZwPUob3jIk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liang He <windhl@126.com>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 085/287] mediatek: mt76: mac80211: Fix missing of_node_put() in mt76_led_init()
Date:   Tue, 23 Aug 2022 10:24:14 +0200
Message-Id: <20220823080103.154616692@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080100.268827165@linuxfoundation.org>
References: <20220823080100.268827165@linuxfoundation.org>
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

From: Liang He <windhl@126.com>

[ Upstream commit 0a14c1d0113f121151edf34333cdf212dd209190 ]

We should use of_node_put() for the reference 'np' returned by
of_get_child_by_name() which will increase the refcount.

Fixes: 17f1de56df05 ("mt76: add common code shared between multiple chipsets")
Signed-off-by: Liang He <windhl@126.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mac80211.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mac80211.c b/drivers/net/wireless/mediatek/mt76/mac80211.c
index 1b5abd4816ed..203b888f38d8 100644
--- a/drivers/net/wireless/mediatek/mt76/mac80211.c
+++ b/drivers/net/wireless/mediatek/mt76/mac80211.c
@@ -114,6 +114,7 @@ static int mt76_led_init(struct mt76_dev *dev)
 		if (!of_property_read_u32(np, "led-sources", &led_pin))
 			dev->led_pin = led_pin;
 		dev->led_al = of_property_read_bool(np, "led-active-low");
+		of_node_put(np);
 	}
 
 	return devm_led_classdev_register(dev->dev, &dev->led_cdev);
-- 
2.35.1




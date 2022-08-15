Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E998593941
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 21:33:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230189AbiHOS6a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 14:58:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245157AbiHOS4w (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 14:56:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C89B32DBB;
        Mon, 15 Aug 2022 11:31:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CECF3B81082;
        Mon, 15 Aug 2022 18:31:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 053A9C433C1;
        Mon, 15 Aug 2022 18:31:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660588312;
        bh=UNse/8MvXDfLtiLsFDhl/AJsP8hoheWPNg98s6jZGdA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=abxF6zHlVgj2Md8Kd/Jk2TmmxKYxhaFPe169wY3AgtaA+Cj8w9/HeIFbww7dItNE6
         KdcJrr3wikOzN2LLWxWIGxnLWETJP4XWiHHEF6F+H6u/oTYKIGlMr/Re2DglE0r2u3
         5Lv1df24yXD/r8nYaNS3fwiRxDuDG0PlKmfXLBJQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liang He <windhl@126.com>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 332/779] mediatek: mt76: eeprom: fix missing of_node_put() in mt76_find_power_limits_node()
Date:   Mon, 15 Aug 2022 19:59:36 +0200
Message-Id: <20220815180351.473557798@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
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

[ Upstream commit 3bd53ea02d77917c2314ec7be9e2d05be22f87d3 ]

We should use of_node_put() for the reference 'np' returned by
of_get_child_by_name() which will increase the refcount.

Fixes: 22b980badc0f ("mt76: add functions for parsing rate power limits from DT")
Signed-off-by: Liang He <windhl@126.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/eeprom.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/eeprom.c b/drivers/net/wireless/mediatek/mt76/eeprom.c
index 3b47e85e95e7..db0cd56c8dc7 100644
--- a/drivers/net/wireless/mediatek/mt76/eeprom.c
+++ b/drivers/net/wireless/mediatek/mt76/eeprom.c
@@ -146,10 +146,13 @@ mt76_find_power_limits_node(struct mt76_dev *dev)
 		}
 
 		if (mt76_string_prop_find(country, dev->alpha2) ||
-		    mt76_string_prop_find(regd, region_name))
+		    mt76_string_prop_find(regd, region_name)) {
+			of_node_put(np);
 			return cur;
+		}
 	}
 
+	of_node_put(np);
 	return fallback;
 }
 
-- 
2.35.1




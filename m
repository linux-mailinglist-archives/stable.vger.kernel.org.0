Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 646A9594767
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 01:59:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354410AbiHOXsL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:48:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355123AbiHOXrH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:47:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FCC88C020;
        Mon, 15 Aug 2022 13:15:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7EEF06069F;
        Mon, 15 Aug 2022 20:15:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BB52C433C1;
        Mon, 15 Aug 2022 20:15:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660594519;
        bh=kdc5HuFAFYp4Arr4949hQSaFEZ+/ws9O0bBEGlivX/o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QgCpAtYcW6oEwt8usTKRTRjzCwWIICeAeJGt2HrGLFTY5JnWnst9jBKoqvyXB1suH
         0eJveydUBoWW+ymVfw5dgAdIVLDjlFByYw0BLXS96UmTYHK7blZuvsj/Pwlx0q9bpI
         9kNeT6SxHs+UeXwG60euEoai4hf5K7R05uqqMBQc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Wang <sean.wang@mediatek.com>,
        Deren Wu <deren.wu@mediatek.com>, Felix Fietkau <nbd@nbd.name>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0472/1157] mt76: mt7921: not support beacon offload disable command
Date:   Mon, 15 Aug 2022 19:57:08 +0200
Message-Id: <20220815180458.487674833@linuxfoundation.org>
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

From: Deren Wu <deren.wu@mediatek.com>

[ Upstream commit c149d3a9058616ff942a6e44b6e968e18a84dd5a ]

Beacon disable flow would be handled in bss stop handler automatically.
Force return -EOPNOTSUPP in disable case.

Fixes: 116c69603b01 ("mt76: mt7921: Add AP mode support")
Reviewed-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Deren Wu <deren.wu@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7921/mcu.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
index 71cbb9073485..3765b345b741 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
@@ -1256,8 +1256,11 @@ mt7921_mcu_uni_add_beacon_offload(struct mt7921_dev *dev,
 	};
 	struct sk_buff *skb;
 
+	/* support enable/update process only
+	 * disable flow would be handled in bss stop handler automatically
+	 */
 	if (!enable)
-		goto out;
+		return -EOPNOTSUPP;
 
 	skb = ieee80211_beacon_get_template(mt76_hw(dev), vif, &offs);
 	if (!skb)
@@ -1283,7 +1286,6 @@ mt7921_mcu_uni_add_beacon_offload(struct mt7921_dev *dev,
 	}
 	dev_kfree_skb(skb);
 
-out:
 	return mt76_mcu_send_msg(&dev->mt76, MCU_UNI_CMD(BSS_INFO_UPDATE),
 				 &req, sizeof(req), true);
 }
-- 
2.35.1




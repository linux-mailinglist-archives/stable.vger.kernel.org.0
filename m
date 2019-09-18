Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C638B5CB0
	for <lists+stable@lfdr.de>; Wed, 18 Sep 2019 08:29:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726034AbfIRG00 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Sep 2019 02:26:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:47790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728779AbfIRG0X (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Sep 2019 02:26:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 236F3218AF;
        Wed, 18 Sep 2019 06:26:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568787982;
        bh=2Rhxi2ltz1jn8ido4NNuE6OMfLR8wk+kLgKNquYOYH0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZAKuEauRprcy26jykmIRlSbm4QW910voQiE724STMuGyHdwjrIBZwiJRpyiTCmfh8
         H+A/GIn1yxKrMaV0hhuihwTVbyC8RUVqHC+H1s0mrZYYDWL2eWkx4coF9GxMLz8CO1
         kQ52BsT+a/W+MQynVt137pkrgH8RgU4JTTZfuegg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Felix Fietkau <nbd@nbd.name>
Subject: [PATCH 5.2 57/85] mt76: mt7615: Use after free in mt7615_mcu_set_bcn()
Date:   Wed, 18 Sep 2019 08:19:15 +0200
Message-Id: <20190918061235.909909051@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190918061234.107708857@linuxfoundation.org>
References: <20190918061234.107708857@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 9db1aec0c2d72a3b7b115ba56e8dbb5b46855333 upstream.

We dereference "skb" when we assign:

	req.pkt_len = cpu_to_le16(MT_TXD_SIZE + skb->len);
                                                ^^^^^^^^
So this patch just moves the dev_kfree_skb() down a bit to avoid the
use after free.

Fixes: 04b8e65922f6 ("mt76: add mac80211 driver for MT7615 PCIe-based chipsets")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/mediatek/mt76/mt7615/mcu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
@@ -1270,7 +1270,6 @@ int mt7615_mcu_set_bcn(struct mt7615_dev
 	mt7615_mac_write_txwi(dev, (__le32 *)(req.pkt), skb, wcid, NULL,
 			      0, NULL);
 	memcpy(req.pkt + MT_TXD_SIZE, skb->data, skb->len);
-	dev_kfree_skb(skb);
 
 	req.omac_idx = mvif->omac_idx;
 	req.enable = en;
@@ -1281,6 +1280,7 @@ int mt7615_mcu_set_bcn(struct mt7615_dev
 	req.pkt_len = cpu_to_le16(MT_TXD_SIZE + skb->len);
 	req.tim_ie_pos = cpu_to_le16(MT_TXD_SIZE + tim_off);
 
+	dev_kfree_skb(skb);
 	skb = mt7615_mcu_msg_alloc(&req, sizeof(req));
 
 	return mt7615_mcu_msg_send(dev, skb, MCU_EXT_CMD_BCN_OFFLOAD,



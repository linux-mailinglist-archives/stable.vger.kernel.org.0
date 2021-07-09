Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F4F93C24EF
	for <lists+stable@lfdr.de>; Fri,  9 Jul 2021 15:23:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233086AbhGINZu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 09:25:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:56330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233029AbhGINZh (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 09:25:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B169D61377;
        Fri,  9 Jul 2021 13:22:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1625836974;
        bh=u0DPRHnA81eONtWYWsapGza7NAVDu4368Xw5ICQf5XQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=unhkiDYgZ6SsvjasGGIaPen71TjIFlMQE1Rf2bvwIbeguzUqWoBr1gpowjab5uWgD
         YNn0r/Ap6kMil/Q3OHDK5qz3qZZKqsqHFR5mxHkWnoAi+FiOdHW0EEUdc/uczFKmHh
         AVW03c10edeIyLuQHrUE+iptz5rHHEmnaL2XN+zU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lorenzo Bianconi <lorenzo@kernel.org>,
        Felix Fietkau <nbd@nbd.name>, Deren Wu <deren.wu@mediatek.com>
Subject: [PATCH 5.12 11/11] mt76: mt7921: get rid of mcu_reset function pointer
Date:   Fri,  9 Jul 2021 15:21:48 +0200
Message-Id: <20210709131604.189244317@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210709131549.679160341@linuxfoundation.org>
References: <20210709131549.679160341@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>

commit d43b3257621dfe57c71d875afd3f624b9a042fc5 upstream.

since mcu_reset it used only by mt7921, move the reset callback to
mt7921_mcu_parse_response routine and get rid of the function pointer.

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Link: https://lore.kernel.org/linux-wireless/364293ec8609dd254067d8173c1599526ffd662c.1619000828.git.lorenzo@kernel.org/
Signed-off-by: Deren Wu <deren.wu@mediatek.com>
Cc: <stable@vger.kernel.org> # 5.12: f92f81d35ac2 mt76: mt7921: check mcu returned values in mt7921_start
Cc: <stable@vger.kernel.org> # 5.12: d32464e68ffc mt76: mt7921: introduce mt7921_run_firmware utility routine.
Cc: <stable@vger.kernel.org> # 5.12: 1f7396acfef4 mt76: mt7921: introduce __mt7921_start utility routine
Cc: <stable@vger.kernel.org> # 5.12: 3990465db682 mt76: dma: introduce mt76_dma_queue_reset routine
Cc: <stable@vger.kernel.org> # 5.12: c001df978e4c mt76: dma: export mt76_dma_rx_cleanup routine
Cc: <stable@vger.kernel.org> # 5.12: 0c1ce9884607 mt76: mt7921: add wifi reset support
Cc: <stable@vger.kernel.org> # 5.12: e513ae49088b mt76: mt7921: abort uncompleted scan by wifi reset
Cc: <stable@vger.kernel.org> # 5.12
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/mediatek/mt76/mt7921/mcu.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
@@ -161,6 +161,8 @@ mt7921_mcu_parse_response(struct mt76_de
 	if (!skb) {
 		dev_err(mdev->dev, "Message %d (seq %d) timeout\n",
 			cmd, seq);
+		mt7921_reset(mdev);
+
 		return -ETIMEDOUT;
 	}
 
@@ -952,7 +954,6 @@ int mt7921_mcu_init(struct mt7921_dev *d
 		.mcu_skb_send_msg = mt7921_mcu_send_message,
 		.mcu_parse_response = mt7921_mcu_parse_response,
 		.mcu_restart = mt7921_mcu_restart,
-		.mcu_reset = mt7921_reset,
 	};
 
 	dev->mt76.mcu_ops = &mt7921_mcu_ops;



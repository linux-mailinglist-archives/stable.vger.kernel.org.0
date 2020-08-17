Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78C27246C02
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 18:07:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388421AbgHQQHj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 12:07:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:53418 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731064AbgHQQG5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 12:06:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CFE3220882;
        Mon, 17 Aug 2020 16:06:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597680414;
        bh=NPfbp15bh9CH0gddA0aWvMO12NsbtK0Qat2afiSpc6w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YwSjpynZ8019AkuaSHO14GEMZcS97JQvjBWbdfJJTa+EI+QfFUtf4FN9l5mlPgZ7h
         NU381rvDnxIk+pOT4V7VHSLfn0hy6MkXu/vYNjJRMNEtnzpMmMl05mQSnMEPxGV4Qp
         lOts2l/nx4cx6+/9ZDPKVR5/ARH9WYZcXpBn3DDo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lorenzo Bianconi <lorenzo@kernel.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 160/270] mt76: mt7615: fix potential memory leak in mcu message handler
Date:   Mon, 17 Aug 2020 17:16:01 +0200
Message-Id: <20200817143803.808649374@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143755.807583758@linuxfoundation.org>
References: <20200817143755.807583758@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Wang <sean.wang@mediatek.com>

[ Upstream commit 9248c08c3fc4ef816c82aa49d01123f4746d349f ]

Fix potential memory leak in mcu message handler on error condition.

Fixes: 0e6a29e477f3 ("mt76: mt7615: add support to read temperature from mcu")
Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7615/mcu.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
index 842cd81704db6..b6867d93c0e34 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
@@ -119,8 +119,10 @@ mt7615_mcu_parse_response(struct mt7615_dev *dev, int cmd,
 	struct mt7615_mcu_rxd *rxd = (struct mt7615_mcu_rxd *)skb->data;
 	int ret = 0;
 
-	if (seq != rxd->seq)
-		return -EAGAIN;
+	if (seq != rxd->seq) {
+		ret = -EAGAIN;
+		goto out;
+	}
 
 	switch (cmd) {
 	case -MCU_CMD_PATCH_SEM_CONTROL:
@@ -134,6 +136,7 @@ mt7615_mcu_parse_response(struct mt7615_dev *dev, int cmd,
 	default:
 		break;
 	}
+out:
 	dev_kfree_skb(skb);
 
 	return ret;
-- 
2.25.1




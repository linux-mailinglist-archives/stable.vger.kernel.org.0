Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3102A24761F
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 21:33:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730014AbgHQPar (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 11:30:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:52802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730213AbgHQPam (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:30:42 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6334C2245C;
        Mon, 17 Aug 2020 15:30:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597678241;
        bh=fJL/l3YfGc/gPwQbdodajskzq+mBQmY7RH0VafRmsnA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ANpKm++Iq3jV8cJQMThpquo5oL/H8pzYGI3gntTlRuLLbUQRMkPv+5ck0I19HtE5E
         ZmrvLZHtq3tO4Ae4y8lr/iKB+/Zm5odt26/z9XxxL2WQC6FvAFWrkFdAWSxgcreas2
         sjusnYyZ0cuWCd77G5hzDYDu5HF627i0KXa+5qQQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Wang <sean.wang@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 267/464] mt76: mt7663u: fix memory leak in set key
Date:   Mon, 17 Aug 2020 17:13:40 +0200
Message-Id: <20200817143846.576307361@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143833.737102804@linuxfoundation.org>
References: <20200817143833.737102804@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Wang <sean.wang@mediatek.com>

[ Upstream commit 4a850f8dc68b8c4a20333521b31600c9d31ccb5d ]

Fix memory leak in set key.

Fixes: eb99cc95c3b6 ("mt76: mt7615: introduce mt7663u support")
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/mediatek/mt76/mt7615/usb.c   | 21 ++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/usb.c b/drivers/net/wireless/mediatek/mt76/mt7615/usb.c
index 5be6704770ad0..7906e6a71c5b9 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/usb.c
@@ -166,12 +166,16 @@ __mt7663u_mac_set_key(struct mt7615_dev *dev,
 
 	lockdep_assert_held(&dev->mt76.mutex);
 
-	if (!sta)
-		return -EINVAL;
+	if (!sta) {
+		err = -EINVAL;
+		goto out;
+	}
 
 	cipher = mt7615_mac_get_cipher(key->cipher);
-	if (cipher == MT_CIPHER_NONE)
-		return -EOPNOTSUPP;
+	if (cipher == MT_CIPHER_NONE) {
+		err = -EOPNOTSUPP;
+		goto out;
+	}
 
 	wcid = &wd->sta->wcid;
 
@@ -179,19 +183,22 @@ __mt7663u_mac_set_key(struct mt7615_dev *dev,
 	err = mt7615_mac_wtbl_update_key(dev, wcid, key->key, key->keylen,
 					 cipher, key->cmd);
 	if (err < 0)
-		return err;
+		goto out;
 
 	err = mt7615_mac_wtbl_update_pk(dev, wcid, cipher, key->keyidx,
 					key->cmd);
 	if (err < 0)
-		return err;
+		goto out;
 
 	if (key->cmd == SET_KEY)
 		wcid->cipher |= BIT(cipher);
 	else
 		wcid->cipher &= ~BIT(cipher);
 
-	return 0;
+out:
+	kfree(key->key);
+
+	return err;
 }
 
 void mt7663u_wtbl_work(struct work_struct *work)
-- 
2.25.1




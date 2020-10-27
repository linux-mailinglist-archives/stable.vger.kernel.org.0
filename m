Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 598CE29B836
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:08:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1799895AbgJ0Pd4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:33:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:51604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1799888AbgJ0Pd4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:33:56 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 843692225E;
        Tue, 27 Oct 2020 15:33:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603812835;
        bh=+4H4WFq6iqLkSP8MU5R91dl1aEP8ONEACrLwNZUsAag=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RClo11j7oMK4Y+yJYzK/6jmrMzM7DDmzkhOlb3OQ3o5jjfHsDs2jQVvipH3YUu6qM
         u36zrcJsVpY/wHcRXLHy14gpL7kja28CnVJRz4eUBCJPTB+Eb2EoEQFfOZ/vfYhzQl
         +rhcnsgmhLGWsiVYaU7yCCOfYTJxTqaPWO/0MElw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lorenzo Bianconi <lorenzo@kernel.org>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 315/757] mt76: mt7615: hold mt76 lock queueing wd in mt7615_queue_key_update
Date:   Tue, 27 Oct 2020 14:49:25 +0100
Message-Id: <20201027135505.316423767@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit cddaaa56375615c256eb6960d3092ddb8a7a9154 ]

wq queue is always updated holding mt76 spinlock. Grab mt76 lock in
mt7615_queue_key_update() before putting a new element at the end of the
queue.

Fixes: eb99cc95c3b65 ("mt76: mt7615: introduce mt7663u support")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7615/main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/main.c b/drivers/net/wireless/mediatek/mt76/mt7615/main.c
index 2d0b1f49fdbcf..bafe2bdeb5eb4 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/main.c
@@ -361,7 +361,10 @@ mt7615_queue_key_update(struct mt7615_dev *dev, enum set_key_cmd cmd,
 	wd->key.keylen = key->keylen;
 	wd->key.cmd = cmd;
 
+	spin_lock_bh(&dev->mt76.lock);
 	list_add_tail(&wd->node, &dev->wd_head);
+	spin_unlock_bh(&dev->mt76.lock);
+
 	queue_work(dev->mt76.wq, &dev->wtbl_work);
 
 	return 0;
-- 
2.25.1




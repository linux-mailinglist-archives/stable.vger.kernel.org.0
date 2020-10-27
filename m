Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 779CA29B763
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 16:33:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1799614AbgJ0Pc0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:32:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:49578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1799610AbgJ0PcZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:32:25 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 06029206D4;
        Tue, 27 Oct 2020 15:32:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603812744;
        bh=NI1KlFo+3eQwq2WU9SuNO6K26Gtdvyw5xwvm1g5BTyo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZG9adlCfSFiHrUAo6DqvIaZ+1HDAQ+kk9nHtliBAL5QkuhovS0q7qR1pdZkye7alM
         ZAdbJ+BmoTOF+5izetqQgXXgHTGfRl8MTm9oUL2cqL4ulRRkbZWG43UuV6qyDhksV2
         T8vNkUJdLqGcmNSF/RHOFmeuku5dDm2bhnMyVTX0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 316/757] mt76: mt7615: release mutex in mt7615_reset_test_set
Date:   Tue, 27 Oct 2020 14:49:26 +0100
Message-Id: <20201027135505.361704387@linuxfoundation.org>
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

[ Upstream commit 346f810e22428cdf73ee5cf2e0ce1b79d5671de5 ]

Reduce scope of mutex_acquire/mutex_release in mt7615_reset_test_set
routine in order to fix the following static checker warning:

drivers/net/wireless/mediatek/mt76/mt7615/debugfs.c:179
mt7615_reset_test_set()
warn: inconsistent returns 'dev->mt76.mutex'.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Fixes: ea4906c4be49 ("mt76: mt7615: wake device before accessing regmap in debugfs")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7615/debugfs.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/debugfs.c b/drivers/net/wireless/mediatek/mt76/mt7615/debugfs.c
index 88931658a9fbb..937cb71bed642 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/debugfs.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/debugfs.c
@@ -165,15 +165,14 @@ mt7615_reset_test_set(void *data, u64 val)
 	if (!mt7615_wait_for_mcu_init(dev))
 		return 0;
 
-	mt7615_mutex_acquire(dev);
-
 	skb = alloc_skb(1, GFP_KERNEL);
 	if (!skb)
 		return -ENOMEM;
 
 	skb_put(skb, 1);
-	mt76_tx_queue_skb_raw(dev, 0, skb, 0);
 
+	mt7615_mutex_acquire(dev);
+	mt76_tx_queue_skb_raw(dev, 0, skb, 0);
 	mt7615_mutex_release(dev);
 
 	return 0;
-- 
2.25.1




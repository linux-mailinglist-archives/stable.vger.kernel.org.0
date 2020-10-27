Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E11829BBF0
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:31:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1759190AbgJ0Q34 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 12:29:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:52294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1802674AbgJ0Puu (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:50:50 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CC762204EF;
        Tue, 27 Oct 2020 15:50:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603813850;
        bh=Il9Br0hKPkszm54/JVjOqIIyHlDSaKWZbOXM3vOFJvM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K8t9vqxp3OsetbpacbZwQz+DNzS0OtdzoNuLnclorDlboY2yPCmKfM2iUMGZ55d55
         H0jyXO2Vo3pSQPj9ejowmPZvM4kWpbtq0V77a3jb76uczwKWKMZOPsCdGZpRnOhK9J
         ixO3Zaz3sXC0ZzaqD3hSb5LemJ4WnkHe/cskBCho=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Felix Fietkau <nbd@nbd.name>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 692/757] mt76: mt7915: do not do any work in napi poll after calling napi_complete_done()
Date:   Tue, 27 Oct 2020 14:55:42 +0100
Message-Id: <20201027135522.983863838@linuxfoundation.org>
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

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 38b04398c532e9bb9aa90fc07846ad0b0845fe94 ]

Fixes a race condition where multiple tx cleanup or sta poll tasks could run
in parallel.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7915/dma.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/dma.c b/drivers/net/wireless/mediatek/mt76/mt7915/dma.c
index a8832c5e60041..8a1ae08d9572e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/dma.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/dma.c
@@ -95,16 +95,13 @@ static int mt7915_poll_tx(struct napi_struct *napi, int budget)
 	dev = container_of(napi, struct mt7915_dev, mt76.tx_napi);
 
 	mt7915_tx_cleanup(dev);
-
-	if (napi_complete_done(napi, 0))
-		mt7915_irq_enable(dev, MT_INT_TX_DONE_ALL);
-
-	mt7915_tx_cleanup(dev);
-
 	mt7915_mac_sta_poll(dev);
 
 	tasklet_schedule(&dev->mt76.tx_tasklet);
 
+	if (napi_complete_done(napi, 0))
+		mt7915_irq_enable(dev, MT_INT_TX_DONE_ALL);
+
 	return 0;
 }
 
-- 
2.25.1




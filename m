Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5632E27C8EC
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:06:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730328AbgI2MFv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 08:05:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:49816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730266AbgI2Lhh (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:37:37 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 689D523BEC;
        Tue, 29 Sep 2020 11:36:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379416;
        bh=EkxvQKN2BiZLqAT9vobDmZp+Guijf7tsfKu/d3ty/Qs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dstMRoRsVPiUCXBVVM/p6w6sGUoNPAe9Lue5pTSmQJPOyeURNWtsf9QoGeviqWCMH
         xjoApS2gejWSdK8fVF/cIwUriI99h3gj/G9BV2iZ23/z6pyxxGdYBizBPVGly/61pH
         jM/5XF0Ou0cWxbLUDW55+2wrgkaMKUji3YdXm2PU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Felix Fietkau <nbd@nbd.name>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 123/388] mt76: clear skb pointers from rx aggregation reorder buffer during cleanup
Date:   Tue, 29 Sep 2020 12:57:34 +0200
Message-Id: <20200929110016.422495969@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929110010.467764689@linuxfoundation.org>
References: <20200929110010.467764689@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 9379df2fd9234e3b67a23101c2370c99f6af6d77 ]

During the cleanup of the aggregation session, a rx handler (or release timer)
on another CPU might still hold a pointer to the reorder buffer and could
attempt to release some packets.
Clearing pointers during cleanup avoids a theoretical use-after-free bug here.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/agg-rx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/mediatek/mt76/agg-rx.c b/drivers/net/wireless/mediatek/mt76/agg-rx.c
index cbff0dfc96311..f8441fd65400c 100644
--- a/drivers/net/wireless/mediatek/mt76/agg-rx.c
+++ b/drivers/net/wireless/mediatek/mt76/agg-rx.c
@@ -268,6 +268,7 @@ static void mt76_rx_aggr_shutdown(struct mt76_dev *dev, struct mt76_rx_tid *tid)
 		if (!skb)
 			continue;
 
+		tid->reorder_buf[i] = NULL;
 		tid->nframes--;
 		dev_kfree_skb(skb);
 	}
-- 
2.25.1




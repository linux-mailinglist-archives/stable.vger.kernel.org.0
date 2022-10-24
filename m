Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96A3760AD41
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 16:20:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234886AbiJXOUH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 10:20:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236847AbiJXOT2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 10:19:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16FAB22B14;
        Mon, 24 Oct 2022 05:56:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7C19AB8196E;
        Mon, 24 Oct 2022 12:40:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D98CAC433C1;
        Mon, 24 Oct 2022 12:40:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666615235;
        bh=+rDO5cY7vNMKCSwNy+M5iefI71iEu1L68p75lPoL+pg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CbYTBJdroFPt+1ATYZqlGmJHYI4nYkBSKLKlsQ7xnygPh0HhVPu9MBai3TAHWmFAa
         YcaIno08fxYArgGBShnQX9n+NlXZL6CMT5XzmzusmA5KlsVlYgJIuBsIoDHOrNBY6a
         WVXNK44/rPQ0zWUlK20cO9utNwy4zPWXWXL1DV5w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Wang <sean.wang@mediatek.com>,
        YN Chen <yn.chen@mediatek.com>, Felix Fietkau <nbd@nbd.name>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 174/530] wifi: mt76: sdio: fix transmitting packet hangs
Date:   Mon, 24 Oct 2022 13:28:38 +0200
Message-Id: <20221024113052.899210374@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113044.976326639@linuxfoundation.org>
References: <20221024113044.976326639@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: YN Chen <yn.chen@mediatek.com>

[ Upstream commit 250b1827205846ff346a76044955cb79d4963f70 ]

Fix transmitting packets hangs with continuing to pull the pending packet
from mac80211 queues when receiving Tx status notification from the device.

Fixes: aac5104bf631 ("mt76: sdio: do not run mt76_txq_schedule directly")
Acked-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: YN Chen <yn.chen@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/sdio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/sdio.c b/drivers/net/wireless/mediatek/mt76/sdio.c
index 783a15635ec5..9e639d0b9c63 100644
--- a/drivers/net/wireless/mediatek/mt76/sdio.c
+++ b/drivers/net/wireless/mediatek/mt76/sdio.c
@@ -213,7 +213,7 @@ static void mt76s_status_worker(struct mt76_worker *w)
 	} while (nframes > 0);
 
 	if (resched)
-		mt76_worker_schedule(&dev->sdio.txrx_worker);
+		mt76_worker_schedule(&dev->tx_worker);
 }
 
 static void mt76s_tx_status_data(struct work_struct *work)
-- 
2.35.1




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7473604867
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 15:56:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233685AbiJSN4Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 09:56:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231302AbiJSNxc (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 09:53:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C0B31CBAA1;
        Wed, 19 Oct 2022 06:36:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 594F2B82397;
        Wed, 19 Oct 2022 08:50:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C949FC4314D;
        Wed, 19 Oct 2022 08:50:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169440;
        bh=2K8Ly1+cLGZDbnIHbo7zA+ju2+Kk+NzBIKrGvopcenM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tsibVVdaloTosFNd05+uqZ09lvFMf1NtJ9RYhn0FOd3GCJjUZa7kGeeqXzleZKsgz
         T3f/zvHuLCJNwrbxDNRFvbhs6Nlf+WJdyiuZKCknIWiuz60F8KSEnCwr6HSHBjWpWl
         h6pxaBNSiXzh/0iArATo6j6EFp6kPPi5xodBlMlc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, YN Chen <YN.Chen@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 278/862] wifi: mt76: sdio: fix the deadlock caused by sdio->stat_work
Date:   Wed, 19 Oct 2022 10:26:05 +0200
Message-Id: <20221019083302.305602434@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Wang <sean.wang@mediatek.com>

[ Upstream commit e5d78fd998be94fb459a3d625df7367849b997b8 ]

Because wake_work and sdio->stat_work share the same workqueue mt76->wq,
if sdio->stat_work cannot acquire the mutex lock such as that was possibly
held up by [mt7615, mt7921]_mutex_acquire. Additionally, if
[mt7615, mt7921]_mutex_acquire was called by sdio->stat_work self, the wake
would be blocked by itself. Thus, we move the stat_work into
ieee80211_workqueue instead to break the deadlock.

Fixes: d39b52e31aa6 ("mt76: introduce mt76_sdio module")
Co-developed-by: YN Chen <YN.Chen@mediatek.com>
Signed-off-by: YN Chen <YN.Chen@mediatek.com>
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/sdio.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/sdio.c b/drivers/net/wireless/mediatek/mt76/sdio.c
index aba2a9865821..fb2caeae6dba 100644
--- a/drivers/net/wireless/mediatek/mt76/sdio.c
+++ b/drivers/net/wireless/mediatek/mt76/sdio.c
@@ -481,7 +481,7 @@ static void mt76s_status_worker(struct mt76_worker *w)
 		if (dev->drv->tx_status_data &&
 		    !test_and_set_bit(MT76_READING_STATS, &dev->phy.state) &&
 		    !test_bit(MT76_STATE_SUSPEND, &dev->phy.state))
-			queue_work(dev->wq, &dev->sdio.stat_work);
+			ieee80211_queue_work(dev->hw, &dev->sdio.stat_work);
 	} while (nframes > 0);
 
 	if (resched)
@@ -508,7 +508,7 @@ static void mt76s_tx_status_data(struct work_struct *work)
 	}
 
 	if (count && test_bit(MT76_STATE_RUNNING, &dev->phy.state))
-		queue_work(dev->wq, &sdio->stat_work);
+		ieee80211_queue_work(dev->hw, &sdio->stat_work);
 	else
 		clear_bit(MT76_READING_STATS, &dev->phy.state);
 }
-- 
2.35.1




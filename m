Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A55B7608681
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 09:50:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231650AbiJVHuH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 03:50:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231854AbiJVHt0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 03:49:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B20D7173FD5;
        Sat, 22 Oct 2022 00:45:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 549EAB82E13;
        Sat, 22 Oct 2022 07:44:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3C07C433C1;
        Sat, 22 Oct 2022 07:44:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666424690;
        bh=A50efcMezfHBVBM3mdxcEfLUQK/RuFshzE7sArVfLNU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vMvlb3I6pdwJSsQUOGxoaMPkI7PShgbivu6h84KGQD4Z3UclDqkWWIAn1wDSOMeoi
         I6jmCH+zXkywMH7Sl/lYZnv704KNRZa8NHsDBACqo4zsLsogDrHfIH7r1jVbZVCKVm
         4OrBVOiyw6KySDrE/qEf0V2jdpXm91Fa3N5tHBG8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, YN Chen <YN.Chen@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 240/717] wifi: mt76: sdio: fix the deadlock caused by sdio->stat_work
Date:   Sat, 22 Oct 2022 09:21:59 +0200
Message-Id: <20221022072457.410525308@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index def7f325f5c5..574687ca93a9 100644
--- a/drivers/net/wireless/mediatek/mt76/sdio.c
+++ b/drivers/net/wireless/mediatek/mt76/sdio.c
@@ -483,7 +483,7 @@ static void mt76s_status_worker(struct mt76_worker *w)
 		if (dev->drv->tx_status_data &&
 		    !test_and_set_bit(MT76_READING_STATS, &dev->phy.state) &&
 		    !test_bit(MT76_STATE_SUSPEND, &dev->phy.state))
-			queue_work(dev->wq, &dev->sdio.stat_work);
+			ieee80211_queue_work(dev->hw, &dev->sdio.stat_work);
 	} while (nframes > 0);
 
 	if (resched)
@@ -510,7 +510,7 @@ static void mt76s_tx_status_data(struct work_struct *work)
 	}
 
 	if (count && test_bit(MT76_STATE_RUNNING, &dev->phy.state))
-		queue_work(dev->wq, &sdio->stat_work);
+		ieee80211_queue_work(dev->hw, &sdio->stat_work);
 	else
 		clear_bit(MT76_READING_STATS, &dev->phy.state);
 }
-- 
2.35.1




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65B394FD7F5
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:34:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355739AbiDLH3R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:29:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353682AbiDLHP5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:15:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41BA13B56D;
        Mon, 11 Apr 2022 23:57:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EBC33B81B35;
        Tue, 12 Apr 2022 06:57:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 492A8C385A1;
        Tue, 12 Apr 2022 06:57:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649746635;
        bh=fcJRBXGqnmr7nRK5T3/UjEytHL/YIEOJuInmNXpHaI0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MeHOlk96lv6uDslBky6yt2lfIuUsHqqdqyiXLhoyTMYHU+OD8Z0heBLGNQWDZZot9
         q1eH2GGJ4Tuf1xHoZjaGkpQZ4UVib2nDU3tl25T7h+cBTzMUWEmlBdHDif1Rrd+CpI
         jLb65DctE5HxrWp2b5FiKLvmYQLRqmO2H0VmVkiI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ben Greear <greearb@candelatech.com>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 036/285] mt76: mt7921: fix crash when startup fails.
Date:   Tue, 12 Apr 2022 08:28:13 +0200
Message-Id: <20220412062944.718314628@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062943.670770901@linuxfoundation.org>
References: <20220412062943.670770901@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ben Greear <greearb@candelatech.com>

[ Upstream commit 827e7799c61b978fbc2cc9dac66cb62401b2b3f0 ]

If the nic fails to start, it is possible that the
reset_work has already been scheduled.  Ensure the
work item is canceled so we do not have use-after-free
crash in case cleanup is called before the work item
is executed.

This fixes crash on my x86_64 apu2 when mt7921k radio
fails to work.  Radio still fails, but OS does not
crash.

Signed-off-by: Ben Greear <greearb@candelatech.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7921/main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/main.c b/drivers/net/wireless/mediatek/mt76/mt7921/main.c
index 8c55562c1a8d..b3bd090a13f4 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/main.c
@@ -260,6 +260,7 @@ static void mt7921_stop(struct ieee80211_hw *hw)
 
 	cancel_delayed_work_sync(&dev->pm.ps_work);
 	cancel_work_sync(&dev->pm.wake_work);
+	cancel_work_sync(&dev->reset_work);
 	mt76_connac_free_pending_tx_skbs(&dev->pm, NULL);
 
 	mt7921_mutex_acquire(dev);
-- 
2.35.1




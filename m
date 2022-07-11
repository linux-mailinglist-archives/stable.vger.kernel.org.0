Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 314D556FCAB
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:46:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233533AbiGKJqj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:46:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233903AbiGKJpI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:45:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D193599C6;
        Mon, 11 Jul 2022 02:22:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A1334612B7;
        Mon, 11 Jul 2022 09:22:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE153C34115;
        Mon, 11 Jul 2022 09:22:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657531355;
        bh=ibPMo5ETyDCzk+1MyI+Rq7SjNwIpy1QqCC3YTqmPCyw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A6TsF78SRTRePvCtn0nteNW/SmwmfCK1flXwwcCOwMRpZoUcOAdwfePY+a5kciGGi
         nnAxvrcBdiH34rjE3X21fftE/LJfZrEPSI2z19yeIvipizJOqjD+NOSEZTYSS5aKWY
         xafLFz0ebtTBRjvx8TpSsdbunqBJ/YEqc3P+CwAI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lorenzo Bianconi <lorenzo@kernel.org>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 074/230] mt76: mt7921: do not always disable fw runtime-pm
Date:   Mon, 11 Jul 2022 11:05:30 +0200
Message-Id: <20220711090606.175784253@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090604.055883544@linuxfoundation.org>
References: <20220711090604.055883544@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit b44eeb8cbdf2b88f2844f11e4f263b0abed5b5b0 ]

After commit 'd430dffbe9dd ("mt76: mt7921: fix a possible race
enabling/disabling runtime-pm")', runtime-pm is always disabled in the
fw even if the user requests to enable it toggling debugfs node since
mt7921_pm_interface_iter routine will use pm->enable to configure the fw.
Fix the issue moving enable variable configuration before running
mt7921_pm_interface_iter routine.

Fixes: d430dffbe9dd ("mt76: mt7921: fix a possible race enabling/disabling runtime-pm")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7921/debugfs.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/debugfs.c b/drivers/net/wireless/mediatek/mt76/mt7921/debugfs.c
index b9f25599227d..cfcf7964c688 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/debugfs.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/debugfs.c
@@ -291,13 +291,12 @@ mt7921_pm_set(void *data, u64 val)
 	pm->enable = false;
 	mt76_connac_pm_wake(&dev->mphy, pm);
 
+	pm->enable = val;
 	ieee80211_iterate_active_interfaces(mt76_hw(dev),
 					    IEEE80211_IFACE_ITER_RESUME_ALL,
 					    mt7921_pm_interface_iter, dev);
 
 	mt76_connac_mcu_set_deep_sleep(&dev->mt76, pm->ds_enable);
-
-	pm->enable = val;
 	mt76_connac_power_save_sched(&dev->mphy, pm);
 out:
 	mutex_unlock(&dev->mt76.mutex);
-- 
2.35.1




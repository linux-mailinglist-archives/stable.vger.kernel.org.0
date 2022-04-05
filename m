Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 576664F31CE
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:46:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237303AbiDEJbi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:31:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245196AbiDEIyN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:54:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5739F114E;
        Tue,  5 Apr 2022 01:52:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E9A89614E5;
        Tue,  5 Apr 2022 08:52:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02641C385A1;
        Tue,  5 Apr 2022 08:51:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649148720;
        bh=xZqW6bhmtjzrBnDxdcWjv2+8BAXwYVWbAoDYitT4kk0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GNQl/O/Q1rb71iRzTPSfOggBECPh+YvTQfcQOATymqBFYOZFn7ldiYJfB6x7wAzx6
         ZKT0tGKaCKr6WzjM9CaSXABZxBphulJJ5HXKEytVipy+imNF+jwk1fCwX26RJFJa12
         OMXJw1W9qdR9p58flyjUxwNGijqAzKqGlBsDTUqo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lorenzo Bianconi <lorenzo@kernel.org>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0456/1017] mt76: mt7921: do not always disable fw runtime-pm
Date:   Tue,  5 Apr 2022 09:22:49 +0200
Message-Id: <20220405070407.834793000@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
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
index 86fd7292b229..45a393070e46 100644
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
2.34.1




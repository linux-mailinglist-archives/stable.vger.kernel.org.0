Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFDEF594F95
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 06:30:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229670AbiHPEaZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 00:30:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229844AbiHPEaF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 00:30:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D624FC6965;
        Mon, 15 Aug 2022 13:17:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6590F60FBE;
        Mon, 15 Aug 2022 20:17:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6713BC433B5;
        Mon, 15 Aug 2022 20:17:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660594663;
        bh=rU1y07mAIyrTMQHU+dQcmkqMDRY7dbELlamSQsWDnxU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=shvLvS+Eg/Hj3XI1Qlw29uq9r6VPpIRv2316IdeFcYUpzpWlw4fJ2O3Uki0QkcF+g
         NeYSiyQigajbSb22mHh7as+tZlZhZ4Fq3oPiiGP88WB07u9azdvDwiVcueCl/o/+lS
         sY7nkqUaylX4Mw/hJ7lj41XTLEj3vaSNz0d7vLe8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lorenzo Bianconi <lorenzo@kernel.org>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0476/1157] mt76: mt7615: do not update pm stats in case of error
Date:   Mon, 15 Aug 2022 19:57:12 +0200
Message-Id: <20220815180458.670636541@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
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

[ Upstream commit 79717c4eeeae9dec894794fbe8af72f08f03ebdd ]

Do not update pm stats if mt7615_mcu_fw_pmctrl returns an error.

Fixes: abe912ae3cd42 ("mt76: mt7663: add awake and doze time accounting")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7615/mcu.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
index 8fb6c9d735dc..d2dd1260382c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
@@ -350,10 +350,11 @@ static int mt7615_mcu_fw_pmctrl(struct mt7615_dev *dev)
 	}
 
 	mt7622_trigger_hif_int(dev, false);
-
-	pm->stats.last_doze_event = jiffies;
-	pm->stats.awake_time += pm->stats.last_doze_event -
-				pm->stats.last_wake_event;
+	if (!err) {
+		pm->stats.last_doze_event = jiffies;
+		pm->stats.awake_time += pm->stats.last_doze_event -
+					pm->stats.last_wake_event;
+	}
 out:
 	mutex_unlock(&pm->mutex);
 
-- 
2.35.1




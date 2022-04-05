Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3FB44F3744
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 16:19:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352658AbiDELMF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:12:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348923AbiDEJss (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:48:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A584EE4F2;
        Tue,  5 Apr 2022 02:37:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 364B66164D;
        Tue,  5 Apr 2022 09:37:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 438BFC385A0;
        Tue,  5 Apr 2022 09:37:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649151460;
        bh=FsqVb7UY4dwPIR3FljaqZy0qpdr4pSnoSN/L8zEspPU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=grJ19rz0icPRHRPlUAGg4Ko8/e8hXQnMo1YHSokXGaGtvdzavduBsOS0KngDesZT6
         sdGM2trRwAbeKycC1Y8UlvLCNubV5ZLCN1oex67UzMPM/qoKSXzpoEVUyjvCalx+yB
         hpKJcwQ0Jgco7p44UjD8wmchhl/EsTcWr7V0lk8U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lorenzo Bianconi <lorenzo@kernel.org>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 424/913] mt76: mt7921: fix a leftover race in runtime-pm
Date:   Tue,  5 Apr 2022 09:24:46 +0200
Message-Id: <20220405070352.554938115@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
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

[ Upstream commit 591cdccebdd4d02eb46d400dea911136400cc567 ]

Fix a possible race in mt7921_pm_power_save_work() if rx/tx napi
schedules ps_work and we are currently accessing device register
on a different cpu.

Fixes: 1d8efc741df8 ("mt76: mt7921: introduce Runtime PM support")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7921/mac.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/mac.c b/drivers/net/wireless/mediatek/mt76/mt7921/mac.c
index 04a288029c98..c093920a597d 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mac.c
@@ -1550,6 +1550,14 @@ void mt7921_pm_power_save_work(struct work_struct *work)
 	    test_bit(MT76_HW_SCHED_SCANNING, &mphy->state))
 		goto out;
 
+	if (mutex_is_locked(&dev->mt76.mutex))
+		/* if mt76 mutex is held we should not put the device
+		 * to sleep since we are currently accessing device
+		 * register map. We need to wait for the next power_save
+		 * trigger.
+		 */
+		goto out;
+
 	if (time_is_after_jiffies(dev->pm.last_activity + delta)) {
 		delta = dev->pm.last_activity + delta - jiffies;
 		goto out;
-- 
2.34.1




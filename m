Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A739A4F3741
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 16:19:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352612AbiDELL6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:11:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348926AbiDEJss (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:48:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3ADCFA0BED;
        Tue,  5 Apr 2022 02:37:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E06E6B81C6C;
        Tue,  5 Apr 2022 09:37:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3795CC385A4;
        Tue,  5 Apr 2022 09:37:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649151463;
        bh=HQ8WKX/MD7XlNHXrBNKlaeo+5o71NqqaQvKlW8Fz6Qo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2wEt2sbL2OQLRjsDnUzkStMFXSmEV7fjX3fc9uFtyw6WAFvE6ZbTCB/VV0RF47BSD
         qUpBqjrWZj6bpOVnVaT42okPdJZf2/cU5xmNMZQMIqkDKg48ZY/zvtS16L87BS7N1m
         St7ZxGojZmtxDV6AaYieOqYJvtF7w/Cpv4g8IDXE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lorenzo Bianconi <lorenzo@kernel.org>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 425/913] mt76: mt7615: fix a leftover race in runtime-pm
Date:   Tue,  5 Apr 2022 09:24:47 +0200
Message-Id: <20220405070352.584530780@linuxfoundation.org>
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

[ Upstream commit 42ce8d3b623162f3248db50a38359f294e6b06fd ]

Fix a possible race in mt7615_pm_power_save_work() if rx/tx napi
schedules ps_work and we are currently accessing device register
on a different cpu.

Fixes: db928f1ab9789 ("mt76: mt7663: rely on mt76_connac_pm_ref/mt76_connac_pm_unref in tx/rx napi")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7615/mac.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/mac.c b/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
index f2704149834a..eb7bda91f2b3 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
@@ -2000,6 +2000,14 @@ void mt7615_pm_power_save_work(struct work_struct *work)
 	    test_bit(MT76_HW_SCHED_SCANNING, &dev->mphy.state))
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




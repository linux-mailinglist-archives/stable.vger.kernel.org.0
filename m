Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D4436AE89A
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:17:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230262AbjCGRRq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:17:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230061AbjCGRR2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:17:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BBD832E58
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:13:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8790BB8199A
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:13:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7601C433EF;
        Tue,  7 Mar 2023 17:13:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678209182;
        bh=xHbBuNxWjVUg/u4qn98DcnMncgxaOy5Wry++go2UTJk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YYLCjpkwLz4BYo7aUOmL2aBv4l+VIkvUmOKo56CpGynuP2r/Zff4mPkneJEKpvmF0
         Wo/j5GvSI84g0tHr3XqW1RMSN41PL+f8BOP5S/gek7zfDqMt40rPJt47BOF0xKarf2
         qeS0LdVVE/NYkgt9hnG0ioQzzV2XPMwtn8ZZTwZ0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        coverity-bot <keescook+coverity-bot@chromium.org>,
        Ryder Lee <ryder.lee@mediatek.com>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0137/1001] wifi: mt76: mt7996: fix integer handling issue of mt7996_rf_regval_set()
Date:   Tue,  7 Mar 2023 17:48:29 +0100
Message-Id: <20230307170028.012098093@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ryder Lee <ryder.lee@mediatek.com>

[ Upstream commit aab169ad3a7aa8678aed90d7fdbc243e3d4b32a6 ]

This code is supposed to set a u32 value, but casting will not work on
big endian systems.

Reported-by: coverity-bot <keescook+coverity-bot@chromium.org>
Addresses-Coverity-ID: 1527816 ("Integer handling issues")
Fixes: 98686cd21624 ("wifi: mt76: mt7996: add driver for MediaTek Wi-Fi 7 (802.11be) devices")
Signed-off-by: Ryder Lee <ryder.lee@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/debugfs.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/debugfs.c b/drivers/net/wireless/mediatek/mt76/mt7996/debugfs.c
index 2e4a8909b9e80..99b23aef53a50 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/debugfs.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/debugfs.c
@@ -653,8 +653,9 @@ static int
 mt7996_rf_regval_set(void *data, u64 val)
 {
 	struct mt7996_dev *dev = data;
+	u32 val32 = val;
 
-	return mt7996_mcu_rf_regval(dev, dev->mt76.debugfs_reg, (u32 *)&val, true);
+	return mt7996_mcu_rf_regval(dev, dev->mt76.debugfs_reg, &val32, true);
 }
 
 DEFINE_DEBUGFS_ATTRIBUTE(fops_rf_regval, mt7996_rf_regval_get,
-- 
2.39.2




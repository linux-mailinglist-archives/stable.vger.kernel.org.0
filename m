Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA4446AEE87
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:13:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232413AbjCGSM4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:12:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232512AbjCGSMc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:12:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2533D30C9
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:07:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D77F2B8191D
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:07:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 012E1C433A7;
        Tue,  7 Mar 2023 18:07:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678212475;
        bh=QWEmMxkuvGLgluY3PuYXNmUEJIPRZp7ba5rvn9DpFoc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GzLaKYOit0TWs2lS8fyjXAp6wA0WMxbB3GprBQK4coAdDWeHBAu7U4pYbe0kOcwl8
         bho5rzC2V+AKSNf942YEj7O75owxCAyuDtm2Q0qPeT9ZYbbPtAztbTBhe1k1nTVdzZ
         gM4qTvPCngR6NGVBH6HIEwvqvyij2x9iyTIK9hlY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Sujuan Chen <sujuan.chen@mediatek.com>,
        Ryder Lee <ryder.lee@mediatek.com>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 195/885] wifi: mt76: mt7915: fix WED TxS reporting
Date:   Tue,  7 Mar 2023 17:52:09 +0100
Message-Id: <20230307170010.488601856@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
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

[ Upstream commit 0d7084e209a9e2c924cb0d6e7f1f978db2a54127 ]

The previous commit forgot to remove a leftover check.

Fixes: 43eaa3689507 ("wifi: mt76: add PPDU based TxS support for WED device")
Reported-By: Sujuan Chen <sujuan.chen@mediatek.com>
Signed-off-by: Ryder Lee <ryder.lee@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7915/mac.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mac.c b/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
index e6bf6e04d4b9c..1f3b7e7f48d50 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
@@ -997,9 +997,6 @@ static void mt7915_mac_add_txs(struct mt7915_dev *dev, void *data)
 	u16 wcidx;
 	u8 pid;
 
-	if (le32_get_bits(txs_data[0], MT_TXS0_TXS_FORMAT) > 1)
-		return;
-
 	wcidx = le32_get_bits(txs_data[2], MT_TXS2_WCID);
 	pid = le32_get_bits(txs_data[3], MT_TXS3_PID);
 
-- 
2.39.2




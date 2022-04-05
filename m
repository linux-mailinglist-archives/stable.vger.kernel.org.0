Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A24C64F3258
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:56:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241984AbiDEIgQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:36:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239318AbiDEIT6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:19:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF5C382D07;
        Tue,  5 Apr 2022 01:11:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5E4F5609AD;
        Tue,  5 Apr 2022 08:11:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 697ABC385A1;
        Tue,  5 Apr 2022 08:11:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649146263;
        bh=VS76bT+X+G8by7uHjwM4STzGKCQS21k7e4HRKUp3dr8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ee6hG/ajFHaHSC/YrHMMLb9V/0LddQkCAPP/7cLoWThs/7CuF3qQnefFLawkV3cqD
         xE7Z64fveRva845Y9D/0Xjg4hI3o1okrJpGVd+fXB3Ah88aeKBScn1dvu6sdt3Ir49
         CM1wzXtH7A81EvXRUgmUI42W1/TtZXEdNJO0gxtk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lorenzo Bianconi <lorenzo@kernel.org>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0674/1126] mt76: mt7921: fix mt7921_queues_acq implementation
Date:   Tue,  5 Apr 2022 09:23:41 +0200
Message-Id: <20220405070427.408600610@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
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

[ Upstream commit 849ee6ac9dd3efd0a57cbc98b9a9d6ae87374aff ]

Fix mt7921_queues_acq implementation according to the vendor sdk.

Fixes: 474a9f21e2e20 ("mt76: mt7921: add debugfs support")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7921/debugfs.c | 13 ++++++-------
 drivers/net/wireless/mediatek/mt76/mt7921/regs.h    | 11 +++++------
 2 files changed, 11 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/debugfs.c b/drivers/net/wireless/mediatek/mt76/mt7921/debugfs.c
index 45a393070e46..196b50e616fe 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/debugfs.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/debugfs.c
@@ -129,23 +129,22 @@ mt7921_queues_acq(struct seq_file *s, void *data)
 
 	mt7921_mutex_acquire(dev);
 
-	for (i = 0; i < 16; i++) {
-		int j, acs = i / 4, index = i % 4;
+	for (i = 0; i < 4; i++) {
 		u32 ctrl, val, qlen = 0;
+		int j;
 
-		val = mt76_rr(dev, MT_PLE_AC_QEMPTY(acs, index));
-		ctrl = BIT(31) | BIT(15) | (acs << 8);
+		val = mt76_rr(dev, MT_PLE_AC_QEMPTY(i));
+		ctrl = BIT(31) | BIT(11) | (i << 24);
 
 		for (j = 0; j < 32; j++) {
 			if (val & BIT(j))
 				continue;
 
-			mt76_wr(dev, MT_PLE_FL_Q0_CTRL,
-				ctrl | (j + (index << 5)));
+			mt76_wr(dev, MT_PLE_FL_Q0_CTRL, ctrl | j);
 			qlen += mt76_get_field(dev, MT_PLE_FL_Q3_CTRL,
 					       GENMASK(11, 0));
 		}
-		seq_printf(s, "AC%d%d: queued=%d\n", acs, index, qlen);
+		seq_printf(s, "AC%d: queued=%d\n", i, qlen);
 	}
 
 	mt7921_mutex_release(dev);
diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/regs.h b/drivers/net/wireless/mediatek/mt76/mt7921/regs.h
index cbd38122c510..c8c92faa4624 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/regs.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/regs.h
@@ -17,13 +17,12 @@
 #define MT_PLE_BASE			0x820c0000
 #define MT_PLE(ofs)			(MT_PLE_BASE + (ofs))
 
-#define MT_PLE_FL_Q0_CTRL		MT_PLE(0x1b0)
-#define MT_PLE_FL_Q1_CTRL		MT_PLE(0x1b4)
-#define MT_PLE_FL_Q2_CTRL		MT_PLE(0x1b8)
-#define MT_PLE_FL_Q3_CTRL		MT_PLE(0x1bc)
+#define MT_PLE_FL_Q0_CTRL		MT_PLE(0x3e0)
+#define MT_PLE_FL_Q1_CTRL		MT_PLE(0x3e4)
+#define MT_PLE_FL_Q2_CTRL		MT_PLE(0x3e8)
+#define MT_PLE_FL_Q3_CTRL		MT_PLE(0x3ec)
 
-#define MT_PLE_AC_QEMPTY(ac, n)		MT_PLE(0x300 + 0x10 * (ac) + \
-					       ((n) << 2))
+#define MT_PLE_AC_QEMPTY(_n)		MT_PLE(0x500 + 0x40 * (_n))
 #define MT_PLE_AMSDU_PACK_MSDU_CNT(n)	MT_PLE(0x10e0 + ((n) << 2))
 
 #define MT_MDP_BASE			0x820cd000
-- 
2.34.1




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 576AC5940B3
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:49:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240889AbiHOVJg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 17:09:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347928AbiHOVHq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 17:07:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 868322B185;
        Mon, 15 Aug 2022 12:16:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 25FE360EF0;
        Mon, 15 Aug 2022 19:16:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CD65C433D6;
        Mon, 15 Aug 2022 19:16:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660591005;
        bh=fQvQWAEajSJ2fek1XKvOZ9Xp2q9da3v0Jkxxl0TpCXM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HDePn8L7hGWqNFR45EmmLcDFKQl4TR74nnn/nWqzKW3cccco0Stwrg4SjHIIHd38e
         avy49tC11yW+l1dtQNCY47YJKbK8erIjqyV/8Ty9ljvwDUQ8/e0uxha9b/C2qP8twX
         6EjILPXHLKGM4ZsnQYmV8tuRVI1NIYTBKvOybFvk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, YN Chen <yn.chen@mediatek.com>,
        Deren Wu <deren.wu@mediatek.com>, Felix Fietkau <nbd@nbd.name>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0442/1095] mt76: mt7921s: fix firmware download random fail
Date:   Mon, 15 Aug 2022 19:57:21 +0200
Message-Id: <20220815180447.939220294@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
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

From: YN Chen <yn.chen@mediatek.com>

[ Upstream commit a55a0c701c129f8e448f0ec1eb811dba728ace64 ]

To avoid racing problems in chip, mt7921s should reacquire drv-own after
firmware semaphore is released.

Fixes: 78b217580c509 ("mt76: mt7921s: fix bus hang with wrong privilege")
Signed-off-by: YN Chen <yn.chen@mediatek.com>
Signed-off-by: Deren Wu <deren.wu@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7921/mcu.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
index da2be050ed7c..2a609b25561c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
@@ -538,13 +538,6 @@ static int mt7921_load_patch(struct mt7921_dev *dev)
 	if (ret)
 		dev_err(dev->mt76.dev, "Failed to start patch\n");
 
-	if (mt76_is_sdio(&dev->mt76)) {
-		/* activate again */
-		ret = __mt7921_mcu_fw_pmctrl(dev);
-		if (!ret)
-			ret = __mt7921_mcu_drv_pmctrl(dev);
-	}
-
 out:
 	sem = mt76_connac_mcu_patch_sem_ctrl(&dev->mt76, false);
 	switch (sem) {
@@ -555,6 +548,14 @@ static int mt7921_load_patch(struct mt7921_dev *dev)
 		dev_err(dev->mt76.dev, "Failed to release patch semaphore\n");
 		break;
 	}
+
+	if (!ret && mt76_is_sdio(&dev->mt76)) {
+		/* activate again */
+		ret = __mt7921_mcu_fw_pmctrl(dev);
+		if (!ret)
+			ret = __mt7921_mcu_drv_pmctrl(dev);
+	}
+
 	release_firmware(fw);
 
 	return ret;
-- 
2.35.1




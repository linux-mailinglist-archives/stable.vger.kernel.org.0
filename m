Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21F574F28C5
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 10:21:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239918AbiDEIVz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:21:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233848AbiDEILO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:11:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEF0E6D958;
        Tue,  5 Apr 2022 01:02:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 05ACFB81B7F;
        Tue,  5 Apr 2022 08:02:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B51BC385A0;
        Tue,  5 Apr 2022 08:02:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649145772;
        bh=4MTiWijwlGUxq4wU1Rr947Nq2Su7l0ulz9oWKLVR2/Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GyCqO+JLzz4pBHS8rO9puXFe3AehkhIkJC+j5xgWGnDxK20zl+g9RuHQ+UdluuP+G
         LApGGq+1jKrv0lFW56uKajZI2hUFNJKl4AZs78VLTwOihVCBCTRTSqw6lfX1NOzQ22
         G7XgI1OQ/iEyid3+k+lRY77tbiKASeKgN8NarqJQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lorenzo Bianconi <lorenzo@kernel.org>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0507/1126] mt76: mt7921s: fix a possible memory leak in mt7921_load_patch
Date:   Tue,  5 Apr 2022 09:20:54 +0200
Message-Id: <20220405070422.509561156@linuxfoundation.org>
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

[ Upstream commit 11005b18f453aa192d035d410c11d07edcba5a45 ]

Always release fw data at the end of mt7921_load_patch routine.

Fixes: 78b217580c509 ("mt76: mt7921s: fix bus hang with wrong privilege")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7921/mcu.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
index 152e7579f77d..e82545a7fcc1 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
@@ -707,12 +707,8 @@ static int mt7921_load_patch(struct mt7921_dev *dev)
 	if (mt76_is_sdio(&dev->mt76)) {
 		/* activate again */
 		ret = __mt7921_mcu_fw_pmctrl(dev);
-		if (ret)
-			return ret;
-
-		ret = __mt7921_mcu_drv_pmctrl(dev);
-		if (ret)
-			return ret;
+		if (!ret)
+			ret = __mt7921_mcu_drv_pmctrl(dev);
 	}
 
 out:
-- 
2.34.1




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A68A5541AE5
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:39:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381119AbiFGVjs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:39:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379560AbiFGVif (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:38:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C69328725;
        Tue,  7 Jun 2022 12:05:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E3E9561277;
        Tue,  7 Jun 2022 19:05:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC3DDC385A2;
        Tue,  7 Jun 2022 19:05:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654628731;
        bh=XRdlFyv+l3XGOOPJ1/GlOwJ8FsDzpPl1DlTotQCzzgk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CDHKf3gbSUIup9J/iDExCts24GKbrAL0/wS3W7QMlbpBuTi5kCT3MEQGW3wXMOWKt
         MPJx4anKj2s26qpUQuXJMvP2CauogHTp9BplVmHCH83lsKjwmNuGHn9z54eq+7BOvK
         7Y0qnvTU9pLsZvKMcW1aedr9bDotb2l9cI0EbPPA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lorenzo Bianconi <lorenzo@kernel.org>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 435/879] mt76: mt7915: do not pass data pointer to mt7915_mcu_muru_debug_set
Date:   Tue,  7 Jun 2022 18:59:13 +0200
Message-Id: <20220607165015.497497087@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit badb6ffaa1439fce30fc6ef10571dcf45a622b44 ]

Fix typo in mt7915_muru_debug_set routine and pass muru_debug value to
mt7915_mcu_muru_debug_set() instead of data pointer.

Fixes: 1966a5078f2d ("mt76: mt7915: add mu-mimo and ofdma debugfs knobs")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7915/debugfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/debugfs.c b/drivers/net/wireless/mediatek/mt76/mt7915/debugfs.c
index 4e1ecaec8f4f..dece0a6e00b3 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/debugfs.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/debugfs.c
@@ -95,7 +95,7 @@ mt7915_muru_debug_set(void *data, u64 val)
 	struct mt7915_dev *dev = data;
 
 	dev->muru_debug = val;
-	mt7915_mcu_muru_debug_set(dev, data);
+	mt7915_mcu_muru_debug_set(dev, dev->muru_debug);
 
 	return 0;
 }
-- 
2.35.1




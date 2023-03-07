Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D99BB6AEE84
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:12:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232495AbjCGSMu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:12:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230183AbjCGSMZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:12:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE1CD9AFF6
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:07:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 23561B8191D
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:07:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49B09C433EF;
        Tue,  7 Mar 2023 18:07:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678212468;
        bh=dsCcGYjIWJiv+AwY674h8zQE3S360WSWGlFPIQPykko=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WIbdTax6Nx/6RUPTbgSf57Ve/0KBntgOBmnGlwGhj4HoaHeu/fEDmPlm8VWqO7P4F
         12Sp74KWwvQBVvcamaJqOFthpF0VtEBwfdKCH0kmmlDCj4FWX7OX1/F/H/fpNFRGBB
         JzgsxRVxYW05O+4mqBbQvP+3aOvD45DMLIp6jczs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Lorenzo Bianconi <lorenzo@kernel.org>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 194/885] wifi: mt76: mt7915: fix memory leak in mt7915_mcu_exit
Date:   Tue,  7 Mar 2023 17:52:08 +0100
Message-Id: <20230307170010.452245533@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit 49bd78282e79ad177d14f37f4049f0605bf92dad ]

Always purge mcu skb queues in mt7915_mcu_exit routine even if
mt7915_firmware_state fails.

Fixes: e57b7901469f ("mt76: add mac80211 driver for MT7915 PCIe-based chipsets")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
index c4843f4de34ff..bcfc30d669c20 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
@@ -2299,13 +2299,14 @@ void mt7915_mcu_exit(struct mt7915_dev *dev)
 	__mt76_mcu_restart(&dev->mt76);
 	if (mt7915_firmware_state(dev, false)) {
 		dev_err(dev->mt76.dev, "Failed to exit mcu\n");
-		return;
+		goto out;
 	}
 
 	mt76_wr(dev, MT_TOP_LPCR_HOST_BAND(0), MT_TOP_LPCR_HOST_FW_OWN);
 	if (dev->hif2)
 		mt76_wr(dev, MT_TOP_LPCR_HOST_BAND(1),
 			MT_TOP_LPCR_HOST_FW_OWN);
+out:
 	skb_queue_purge(&dev->mt76.mcu.res_q);
 }
 
-- 
2.39.2




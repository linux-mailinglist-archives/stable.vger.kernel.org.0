Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98E7D657E46
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:52:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233672AbiL1Pwc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:52:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233654AbiL1PwP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:52:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34895186D9
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:52:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D816FB81732
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:52:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49E0EC433D2;
        Wed, 28 Dec 2022 15:52:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672242723;
        bh=zK5RTB56eEkFgp0quFy23i6FgJ6xr0MJOsoiN8iWKPQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zPQy5JTIU7Sl1XWw3HscA8E1g66ay0SIUCuGLBIH1IDLnuODzOn4MaNMPgjdvniiu
         UL8Y1tyMuBeKf9RBtqLHE7+c9e+dTgK08dWh6bxP6FtwnNfUNn1xVNpfxTuShQ7wPt
         6UvcdUM6gbnxy0xcVC7VDfl+rmjjlYYqcYqn4Hyg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Nicolas Cavallari <nicolas.cavallari@green-communications.fr>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0444/1073] wifi: mt76: mt7915: Fix chainmask calculation on mt7915 DBDC
Date:   Wed, 28 Dec 2022 15:33:52 +0100
Message-Id: <20221228144340.090030660@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicolas Cavallari <nicolas.cavallari@green-communications.fr>

[ Upstream commit de147cc28985a2a09e5d6d179fc5ef59b22fc058 ]

mt7915 does not have a per-band number of chains unlike the other chips,
it only has a total number of chains.  Yet the current code would
consider the total number as a per-band number.

For example, it would report that a 2x2 + 2x2 DBDC card have 4 chains on
each band and set chainmask to 0b1111 for the first interface and
0b11110000 for the second.

Fixes: 99ad32a4ca3a ("mt76: mt7915: add support for MT7986")
Co-developed-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Nicolas Cavallari <nicolas.cavallari@green-communications.fr>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7915/eeprom.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/eeprom.c b/drivers/net/wireless/mediatek/mt76/mt7915/eeprom.c
index 83bced0c0785..0bce0ce51be0 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/eeprom.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/eeprom.c
@@ -194,6 +194,7 @@ void mt7915_eeprom_parse_hw_cap(struct mt7915_dev *dev,
 	nss = path;
 	if (dev->dbdc_support) {
 		if (is_mt7915(&dev->mt76)) {
+			path = min_t(u8, path, 2);
 			nss = FIELD_GET(MT_EE_WIFI_CONF3_TX_PATH_B0,
 					eeprom[MT_EE_WIFI_CONF + 3]);
 			if (phy->band_idx)
-- 
2.35.1




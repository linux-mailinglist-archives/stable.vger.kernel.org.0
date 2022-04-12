Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 751324FD16F
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 08:57:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351533AbiDLG6f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 02:58:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351906AbiDLGyk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 02:54:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FE0C2E089;
        Mon, 11 Apr 2022 23:44:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2E005B81B49;
        Tue, 12 Apr 2022 06:44:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 729F8C385A6;
        Tue, 12 Apr 2022 06:44:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649745854;
        bh=xzKKvEPIb9KjNF/wwMwEYc2tMJfBK/HAkE92Z6kXDEo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xjWN075Ox/n7rF2vQKH7aqrLyXVNXimodONtU8lVXRccjReArdNpOXah1tZYjHD8D
         y08YISjVSya0PwO1ZRw30cROiPUZan3MX7oGy7/XlrFUFR7SS0XT7rCUFaR4e81VoK
         j2VeD7QRILoDldGct3/45Qw2H8e9duCBtqy0MaMc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Johan Almbladh <johan.almbladh@anyfinetworks.com>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 072/277] mt76: mt7915: fix injected MPDU transmission to not use HW A-MSDU
Date:   Tue, 12 Apr 2022 08:27:55 +0200
Message-Id: <20220412062944.130405039@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062942.022903016@linuxfoundation.org>
References: <20220412062942.022903016@linuxfoundation.org>
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

From: Johan Almbladh <johan.almbladh@anyfinetworks.com>

[ Upstream commit 28225a6ef80ebf46c46e5fbd5b1ee231a0b2b5b7 ]

Before, the hardware would be allowed to transmit injected 802.11 MPDUs
as A-MSDU. This resulted in corrupted frames being transmitted. Now,
injected MPDUs are transmitted as-is, without A-MSDU.

The fix was verified with frame injection on MT7915 hardware, both with
and without the injected frame being encrypted.

If the hardware cannot do A-MSDU aggregation on MPDUs, this problem
would also be present in the TX path where mac80211 does the 802.11
encapsulation. However, I have not observed any such problem when
disabling IEEE80211_HW_SUPPORTS_TX_ENCAP_OFFLOAD to force that mode.
Therefore this fix is isolated to injected frames only.

The same A-MSDU logic is also present in the mt7921 driver, so it is
likely that this fix should be applied there too. I do not have access
to mt7921 hardware so I have not been able to test that.

Signed-off-by: Johan Almbladh <johan.almbladh@anyfinetworks.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7915/mac.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mac.c b/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
index ff613d705611..7691292526e0 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
@@ -899,6 +899,7 @@ mt7915_mac_write_txwi_80211(struct mt7915_dev *dev, __le32 *txwi,
 		val = MT_TXD3_SN_VALID |
 		      FIELD_PREP(MT_TXD3_SEQ, IEEE80211_SEQ_TO_SN(seqno));
 		txwi[3] |= cpu_to_le32(val);
+		txwi[7] &= ~cpu_to_le32(MT_TXD7_HW_AMSDU);
 	}
 
 	val = FIELD_PREP(MT_TXD7_TYPE, fc_type) |
-- 
2.35.1




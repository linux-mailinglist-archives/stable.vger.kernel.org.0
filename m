Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18D72499C88
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 23:09:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1579585AbiAXWGB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 17:06:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1577766AbiAXWBE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 17:01:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7351FC0C0935;
        Mon, 24 Jan 2022 12:40:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2FC53B80FA3;
        Mon, 24 Jan 2022 20:40:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52C04C340E5;
        Mon, 24 Jan 2022 20:39:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643056799;
        bh=Jd9oFnu1UwqtGlIyClGK8Td1CpNta7zjTC6uatIv4MY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QhAD4yD/QWv/5E4sayVnRc9xCV1CPLC7T6VYqC63fukq+xwnK7SLNUmdI5Sjl7Aaw
         1VVuzK6p2Ch8mPpNw+GfbmiytLHpWJzOL9dhIigUMyO99fogSej0wIXD/dGLlz9N9K
         ZWMiyHm+0nq4M0/D0DO8WWE85H5bGgHmHtS9vbPE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ilan Peer <ilan.peer@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 577/846] iwlwifi: mvm: Fix calculation of frame length
Date:   Mon, 24 Jan 2022 19:41:34 +0100
Message-Id: <20220124184120.938006086@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ilan Peer <ilan.peer@intel.com>

[ Upstream commit 40a0b38d7a7f91a6027287e0df54f5f547e8d27e ]

The RADA might include in the Rx frame the MIC and CRC bytes.
These bytes should be removed for non monitor interfaces and
should not be passed to mac80211.

Fix the Rx processing to remove the extra bytes on non monitor
cases.

Signed-off-by: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Link: https://lore.kernel.org/r/iwlwifi.20211219121514.098be12c801e.I1d81733d8a75b84c3b20eb6e0d14ab3405ca6a86@changeid
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c | 27 +++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
index c12f303cf652c..efccdd3f33773 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
@@ -121,12 +121,39 @@ static int iwl_mvm_create_skb(struct iwl_mvm *mvm, struct sk_buff *skb,
 	struct iwl_rx_mpdu_desc *desc = (void *)pkt->data;
 	unsigned int headlen, fraglen, pad_len = 0;
 	unsigned int hdrlen = ieee80211_hdrlen(hdr->frame_control);
+	u8 mic_crc_len = u8_get_bits(desc->mac_flags1,
+				     IWL_RX_MPDU_MFLG1_MIC_CRC_LEN_MASK) << 1;
 
 	if (desc->mac_flags2 & IWL_RX_MPDU_MFLG2_PAD) {
 		len -= 2;
 		pad_len = 2;
 	}
 
+	/*
+	 * For non monitor interface strip the bytes the RADA might not have
+	 * removed. As monitor interface cannot exist with other interfaces
+	 * this removal is safe.
+	 */
+	if (mic_crc_len && !ieee80211_hw_check(mvm->hw, RX_INCLUDES_FCS)) {
+		u32 pkt_flags = le32_to_cpu(pkt->len_n_flags);
+
+		/*
+		 * If RADA was not enabled then decryption was not performed so
+		 * the MIC cannot be removed.
+		 */
+		if (!(pkt_flags & FH_RSCSR_RADA_EN)) {
+			if (WARN_ON(crypt_len > mic_crc_len))
+				return -EINVAL;
+
+			mic_crc_len -= crypt_len;
+		}
+
+		if (WARN_ON(mic_crc_len > len))
+			return -EINVAL;
+
+		len -= mic_crc_len;
+	}
+
 	/* If frame is small enough to fit in skb->head, pull it completely.
 	 * If not, only pull ieee80211_hdr (including crypto if present, and
 	 * an additional 8 bytes for SNAP/ethertype, see below) so that
-- 
2.34.1




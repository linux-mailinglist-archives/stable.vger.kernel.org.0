Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE5933D61FC
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:15:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232438AbhGZPdp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:33:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:48254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233188AbhGZPcL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:32:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2FDF960F6B;
        Mon, 26 Jul 2021 16:12:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627315938;
        bh=W1bGz6A82bEqY/+wCZCf5+pdrKBaUCUwYowAFAan5c4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L+ZVvKkYRyHsgdPRtdhlFtEXBN8qXeL+SLXEuURJ1mDnrJaejohVmenG46csLTbLL
         Bod653PCGfdNwfVXWql1mcFszvpBMMdBS4JfiuevjAXAkjP/cRotL7pl5CtO+L8CPq
         z/elegm5KXH2+mEt31/9iRpKE0/JHmW6CzDUZXGU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Somnath Kotur <somnath.kotur@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 108/223] bnxt_en: Validate vlan protocol ID on RX packets
Date:   Mon, 26 Jul 2021 17:38:20 +0200
Message-Id: <20210726153849.812349524@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153846.245305071@linuxfoundation.org>
References: <20210726153846.245305071@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Chan <michael.chan@broadcom.com>

[ Upstream commit 96bdd4b9ea7ef9a12db8fdd0ce90e37dffbd3703 ]

Only pass supported VLAN protocol IDs for stripped VLAN tags to the
stack.  The stack will hit WARN() if the protocol ID is unsupported.

Existing firmware sets up the chip to strip 0x8100, 0x88a8, 0x9100.
Only the 1st two protocols are supported by the kernel.

Fixes: a196e96bb68f ("bnxt_en: clean up VLAN feature bit handling")
Reviewed-by: Somnath Kotur <somnath.kotur@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 49aca3289c00..be36dee65f90 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -1640,11 +1640,16 @@ static inline struct sk_buff *bnxt_tpa_end(struct bnxt *bp,
 
 	if ((tpa_info->flags2 & RX_CMP_FLAGS2_META_FORMAT_VLAN) &&
 	    (skb->dev->features & BNXT_HW_FEATURE_VLAN_ALL_RX)) {
-		u16 vlan_proto = tpa_info->metadata >>
-			RX_CMP_FLAGS2_METADATA_TPID_SFT;
+		__be16 vlan_proto = htons(tpa_info->metadata >>
+					  RX_CMP_FLAGS2_METADATA_TPID_SFT);
 		u16 vtag = tpa_info->metadata & RX_CMP_FLAGS2_METADATA_TCI_MASK;
 
-		__vlan_hwaccel_put_tag(skb, htons(vlan_proto), vtag);
+		if (eth_type_vlan(vlan_proto)) {
+			__vlan_hwaccel_put_tag(skb, vlan_proto, vtag);
+		} else {
+			dev_kfree_skb(skb);
+			return NULL;
+		}
 	}
 
 	skb_checksum_none_assert(skb);
@@ -1865,9 +1870,15 @@ static int bnxt_rx_pkt(struct bnxt *bp, struct bnxt_cp_ring_info *cpr,
 	    (skb->dev->features & BNXT_HW_FEATURE_VLAN_ALL_RX)) {
 		u32 meta_data = le32_to_cpu(rxcmp1->rx_cmp_meta_data);
 		u16 vtag = meta_data & RX_CMP_FLAGS2_METADATA_TCI_MASK;
-		u16 vlan_proto = meta_data >> RX_CMP_FLAGS2_METADATA_TPID_SFT;
+		__be16 vlan_proto = htons(meta_data >>
+					  RX_CMP_FLAGS2_METADATA_TPID_SFT);
 
-		__vlan_hwaccel_put_tag(skb, htons(vlan_proto), vtag);
+		if (eth_type_vlan(vlan_proto)) {
+			__vlan_hwaccel_put_tag(skb, vlan_proto, vtag);
+		} else {
+			dev_kfree_skb(skb);
+			goto next_rx;
+		}
 	}
 
 	skb_checksum_none_assert(skb);
-- 
2.30.2




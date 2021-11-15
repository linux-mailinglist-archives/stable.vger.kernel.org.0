Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 435B8450B7B
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 18:22:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237602AbhKORY7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 12:24:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:50944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237651AbhKORXm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:23:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3973D6120F;
        Mon, 15 Nov 2021 17:18:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636996691;
        bh=6mSSn/xqljK7ibJ3H7VIvI+12LG/Piudv8Yll6ovQ6E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v8TOYLDYkrEKLWvWJxgyg+Lw6fDz68RREhs4dqCSmSHJ1qZrS572wERzjVAcv/WKa
         CktpDFkQF2ZH4boFiFMgg007LQVxZWVNOj4R0YJmVhd8kbhtpcdbPrTjw8yhZoqpau
         YFhnevRE5pdNMJmg+ZMciA0nlCWZDTlnFg6PDcrY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Jonas=20Dre=C3=9Fler?= <verdre@v0yd.nl>,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 232/355] mwifiex: Send DELBA requests according to spec
Date:   Mon, 15 Nov 2021 18:02:36 +0100
Message-Id: <20211115165321.259432954@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165313.549179499@linuxfoundation.org>
References: <20211115165313.549179499@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonas Dreßler <verdre@v0yd.nl>

[ Upstream commit cc8a8bc37466f79b24d972555237f3d591150602 ]

While looking at on-air packets using Wireshark, I noticed we're never
setting the initiator bit when sending DELBA requests to the AP: While
we set the bit on our del_ba_param_set bitmask, we forget to actually
copy that bitmask over to the command struct, which means we never
actually set the initiator bit.

Fix that and copy the bitmask over to the host_cmd_ds_11n_delba command
struct.

Fixes: 5e6e3a92b9a4 ("wireless: mwifiex: initial commit for Marvell mwifiex driver")
Signed-off-by: Jonas Dreßler <verdre@v0yd.nl>
Acked-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20211016153244.24353-5-verdre@v0yd.nl
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/marvell/mwifiex/11n.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/11n.c b/drivers/net/wireless/marvell/mwifiex/11n.c
index e435f801bc912..acbef9f1a83b6 100644
--- a/drivers/net/wireless/marvell/mwifiex/11n.c
+++ b/drivers/net/wireless/marvell/mwifiex/11n.c
@@ -657,14 +657,15 @@ int mwifiex_send_delba(struct mwifiex_private *priv, int tid, u8 *peer_mac,
 	uint16_t del_ba_param_set;
 
 	memset(&delba, 0, sizeof(delba));
-	delba.del_ba_param_set = cpu_to_le16(tid << DELBA_TID_POS);
 
-	del_ba_param_set = le16_to_cpu(delba.del_ba_param_set);
+	del_ba_param_set = tid << DELBA_TID_POS;
+
 	if (initiator)
 		del_ba_param_set |= IEEE80211_DELBA_PARAM_INITIATOR_MASK;
 	else
 		del_ba_param_set &= ~IEEE80211_DELBA_PARAM_INITIATOR_MASK;
 
+	delba.del_ba_param_set = cpu_to_le16(del_ba_param_set);
 	memcpy(&delba.peer_mac_addr, peer_mac, ETH_ALEN);
 
 	/* We don't wait for the response of this command */
-- 
2.33.0




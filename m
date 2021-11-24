Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E9A945BA15
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:05:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241457AbhKXMHZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:07:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:33246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242233AbhKXMGg (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:06:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0001E60F5D;
        Wed, 24 Nov 2021 12:03:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637755407;
        bh=HsEloWLUjPuL9/6uGs2l/ld0R+4N7e1poR7DefDRvrs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YeFMHadrqDJPQAhETgoR7t2d9l3g8WFpeH2ojHskh8MQ9Qx7PQCQiOYE6BrwEAYOi
         dIEFFyBhPRa9Q7SDOU4aIxg5sZLoSR/uDQkTAE0IevfQUr8DppqzWuZ6JhuMrw4kCd
         iKXtVZlqUmf65elRcorUBVhZED2Om1HsOUnhUHm8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Jonas=20Dre=C3=9Fler?= <verdre@v0yd.nl>,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 083/162] mwifiex: Send DELBA requests according to spec
Date:   Wed, 24 Nov 2021 12:56:26 +0100
Message-Id: <20211124115701.009615752@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115658.328640564@linuxfoundation.org>
References: <20211124115658.328640564@linuxfoundation.org>
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
 drivers/net/wireless/mwifiex/11n.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/11n.c b/drivers/net/wireless/mwifiex/11n.c
index c174e79e6df2b..b70eac7d2dd79 100644
--- a/drivers/net/wireless/mwifiex/11n.c
+++ b/drivers/net/wireless/mwifiex/11n.c
@@ -630,14 +630,15 @@ int mwifiex_send_delba(struct mwifiex_private *priv, int tid, u8 *peer_mac,
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




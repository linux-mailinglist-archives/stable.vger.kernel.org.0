Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF1D113802C
	for <lists+stable@lfdr.de>; Sat, 11 Jan 2020 11:26:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729303AbgAKK0m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 05:26:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:59650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731043AbgAKK0l (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Jan 2020 05:26:41 -0500
Received: from localhost (unknown [62.119.166.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E6A8320842;
        Sat, 11 Jan 2020 10:26:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578738400;
        bh=2m/b3YaV30WQP7EmUHqtvR2SDpsnEF7V/wpRmsP9GRw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Bp3wLSwT02m3i2ibJBlkxmpTb7Q10W8wIF4UkySQbZ6CO+JVEEaqGJosVoaA9FRDy
         mRbH7777dmlkqaomAqKor1AhRp2D3ywa7fZRENYIwWpENUvhqk+6losm7cFvVbI+le
         4wbYepS883laCByNWqtpumAsLA13Pikm9WVfeDBM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Fredrik Olofsson <fredrik.olofsson@anyfinetworks.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 069/165] mac80211: fix TID field in monitor mode transmit
Date:   Sat, 11 Jan 2020 10:49:48 +0100
Message-Id: <20200111094926.915883486@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200111094921.347491861@linuxfoundation.org>
References: <20200111094921.347491861@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fredrik Olofsson <fredrik.olofsson@anyfinetworks.com>

[ Upstream commit 753ffad3d6243303994227854d951ff5c70fa9e0 ]

Fix overwriting of the qos_ctrl.tid field for encrypted frames injected on
a monitor interface. While qos_ctrl.tid is not encrypted, it's used as an
input into the encryption algorithm so it's protected, and thus cannot be
modified after encryption. For injected frames, the encryption may already
have been done in userspace, so we cannot change any fields.

Before passing the frame to the driver, the qos_ctrl.tid field is updated
from skb->priority. Prior to dbd50a851c50 skb->priority was updated in
ieee80211_select_queue_80211(), but this function is no longer always
called.

Update skb->priority in ieee80211_monitor_start_xmit() so that the value
is stored, and when later code 'modifies' the TID it really sets it to
the same value as before, preserving the encryption.

Fixes: dbd50a851c50 ("mac80211: only allocate one queue when using iTXQs")
Signed-off-by: Fredrik Olofsson <fredrik.olofsson@anyfinetworks.com>
Link: https://lore.kernel.org/r/20191119133451.14711-1-fredrik.olofsson@anyfinetworks.com
[rewrite commit message based on our discussion]
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/tx.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 1fa422782905..cbd273c0b275 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2263,6 +2263,15 @@ netdev_tx_t ieee80211_monitor_start_xmit(struct sk_buff *skb,
 						    payload[7]);
 	}
 
+	/*
+	 * Initialize skb->priority for QoS frames. This is put in the TID field
+	 * of the frame before passing it to the driver.
+	 */
+	if (ieee80211_is_data_qos(hdr->frame_control)) {
+		u8 *p = ieee80211_get_qos_ctl(hdr);
+		skb->priority = *p & IEEE80211_QOS_CTL_TAG1D_MASK;
+	}
+
 	memset(info, 0, sizeof(*info));
 
 	info->flags = IEEE80211_TX_CTL_REQ_TX_STATUS |
-- 
2.20.1




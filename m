Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5D134520F0
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:54:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241341AbhKPA5P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:57:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:44640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245627AbhKOTU5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:20:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DA624632E3;
        Mon, 15 Nov 2021 18:38:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637001495;
        bh=j4DogJZl2Vu+zsxMLerayzNIup6aEJcDiqFmY097EUs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vYvp0okJ40e8LUAW095hF2kp2ZEynB3YPNW0WCeFCc8YjfElHimlhtUH0WuDJwjmf
         Hd4vEU78Ykvs+2wI7TznLzpJgswdTtyViEXEdf4SucXjGVzpeQWN8j1d5O+3/zPS7v
         6lKNTtu6bkeyCPy2gvCgtb9ZJfsqJSIOhmNWN8zk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sriram R <srirrama@codeaurora.org>,
        Jouni Malinen <jouni@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 213/917] ath11k: Avoid reg rules update during firmware recovery
Date:   Mon, 15 Nov 2021 17:55:08 +0100
Message-Id: <20211115165436.015449274@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sriram R <srirrama@codeaurora.org>

[ Upstream commit 69a0fcf8a9f2273040d03e5ee77c9689c09e9d3a ]

During firmware recovery, the default reg rules which are
received via WMI_REG_CHAN_LIST_CC_EVENT can overwrite
the currently configured user regd.

See below snap for example,

root@OpenWrt:/# iw reg get | grep country
country FR: DFS-ETSI
country FR: DFS-ETSI
country FR: DFS-ETSI
country FR: DFS-ETSI

root@OpenWrt:/# echo assert > /sys/kernel/debug/ath11k/ipq8074\ hw2.0/simulate_f
w_crash
<snip>
[ 5290.471696] ath11k c000000.wifi1: pdev 1 successfully recovered

root@OpenWrt:/# iw reg get | grep country
country FR: DFS-ETSI
country US: DFS-FCC
country US: DFS-FCC
country US: DFS-FCC

In the above, the user configured country 'FR' is overwritten
when the rules of default country 'US' are received and updated during
recovery. Hence avoid processing of these rules in general
during firmware recovery as they have been already applied during
driver registration or after last set user country is configured.

This scenario applies for both AP and STA devices basically because
cfg80211 is not aware of the recovery and only the driver recovers, but
changing or resetting of the reg domain during recovery is not needed so
as to continue with the configured regdomain currently in use.

Tested-on: IPQ8074 hw2.0 AHB WLAN.HK.2.4.0.1-01460-QCAHKSWPL_SILICONZ-1

Signed-off-by: Sriram R <srirrama@codeaurora.org>
Signed-off-by: Jouni Malinen <jouni@codeaurora.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20210721212029.142388-3-jouni@codeaurora.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/wmi.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/net/wireless/ath/ath11k/wmi.c b/drivers/net/wireless/ath/ath11k/wmi.c
index 27c060dd3fb47..fa27115483c6c 100644
--- a/drivers/net/wireless/ath/ath11k/wmi.c
+++ b/drivers/net/wireless/ath/ath11k/wmi.c
@@ -5793,6 +5793,17 @@ static int ath11k_reg_chan_list_event(struct ath11k_base *ab, struct sk_buff *sk
 
 	pdev_idx = reg_info->phy_id;
 
+	/* Avoid default reg rule updates sent during FW recovery if
+	 * it is already available
+	 */
+	spin_lock(&ab->base_lock);
+	if (test_bit(ATH11K_FLAG_RECOVERY, &ab->dev_flags) &&
+	    ab->default_regd[pdev_idx]) {
+		spin_unlock(&ab->base_lock);
+		goto mem_free;
+	}
+	spin_unlock(&ab->base_lock);
+
 	if (pdev_idx >= ab->num_radios) {
 		/* Process the event for phy0 only if single_pdev_only
 		 * is true. If pdev_idx is valid but not 0, discard the
-- 
2.33.0




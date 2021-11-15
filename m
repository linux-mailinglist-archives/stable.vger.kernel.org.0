Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EA71451068
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:44:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242916AbhKOSr2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 13:47:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:48826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242761AbhKOSpH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:45:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 12B0663379;
        Mon, 15 Nov 2021 18:06:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636999600;
        bh=Jbsx+rM9hFxuplVSuLxfUZvNb+Nkbihw7ISuExHsNQg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N+i7HZdvzvf4/mASAzzQXzIQCorxrImWRsJE/6RFhOrARFNG5bxZ9nBaSmjpfBydg
         J6gk3paPaDD9y7xarNhWS+p2Xfa7TGokK4F4doXgsk4KzVBelIprEbEVMBJPUxFA40
         XHyBZtmIz8k9HQWiHY+3RTkO9ZoBRZ+G9CYU+mtg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Loic Poulain <loic.poulain@linaro.org>,
        Bryan ODonoghue <bryan.odonoghue@linaro.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 323/849] wcn36xx: Fix packet drop on resume
Date:   Mon, 15 Nov 2021 17:56:46 +0100
Message-Id: <20211115165431.168584231@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Loic Poulain <loic.poulain@linaro.org>

[ Upstream commit df0697801d8aa2eebfe7f0b7388879639f8fe7cc ]

If the system is resumed because of an incoming packet, the wcn36xx RX
interrupts is fired before actual resuming of the wireless/mac80211
stack, causing any received packets to be simply dropped. E.g. a ping
request causes a system resume, but is dropped and so never forwarded
to the IP stack.

This change fixes that, disabling DMA interrupts on suspend to no pass
packets until mac80211 is resumed and ready to handle them.

Note that it's not incompatible with RX irq wake.

Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
Reviewed-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/1635150496-19290-1-git-send-email-loic.poulain@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/wcn36xx/main.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/net/wireless/ath/wcn36xx/main.c b/drivers/net/wireless/ath/wcn36xx/main.c
index 457fdf365b2d1..f98b44c257c61 100644
--- a/drivers/net/wireless/ath/wcn36xx/main.c
+++ b/drivers/net/wireless/ath/wcn36xx/main.c
@@ -1115,6 +1115,13 @@ static int wcn36xx_suspend(struct ieee80211_hw *hw, struct cfg80211_wowlan *wow)
 			goto out;
 		ret = wcn36xx_smd_wlan_host_suspend_ind(wcn);
 	}
+
+	/* Disable IRQ, we don't want to handle any packet before mac80211 is
+	 * resumed and ready to receive packets.
+	 */
+	disable_irq(wcn->tx_irq);
+	disable_irq(wcn->rx_irq);
+
 out:
 	mutex_unlock(&wcn->conf_mutex);
 	return ret;
@@ -1137,6 +1144,10 @@ static int wcn36xx_resume(struct ieee80211_hw *hw)
 		wcn36xx_smd_ipv6_ns_offload(wcn, vif, false);
 		wcn36xx_smd_arp_offload(wcn, vif, false);
 	}
+
+	enable_irq(wcn->tx_irq);
+	enable_irq(wcn->rx_irq);
+
 	mutex_unlock(&wcn->conf_mutex);
 
 	return 0;
-- 
2.33.0




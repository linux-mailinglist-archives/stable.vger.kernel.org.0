Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF575201277
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 17:56:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392429AbgFSPVa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:21:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:52682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392844AbgFSPVX (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:21:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DD55521548;
        Fri, 19 Jun 2020 15:21:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592580082;
        bh=oka/rNmtiRJwDwVogsEa+EcBiai5h5lBqQBMHdewr8A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ECnz0empwOUoVz2Jvc/jRoz3S2tC/JzTuhWOIrPwkcOWRo3v4QcRTCIcV9oWdhQK8
         WkKrL3JA5re3FmSuwXXdn3vbrYJwmNJ07c68SE1pB8APhy0rtf9Dsd2UUa29mtUGMi
         LrYL+rDYngOODoQ6WxMwHLpg7bwYzDBd3pIN8nUY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sriram R <srirrama@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 085/376] ath11k: Avoid mgmt tx count underflow
Date:   Fri, 19 Jun 2020 16:30:03 +0200
Message-Id: <20200619141714.368063613@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141710.350494719@linuxfoundation.org>
References: <20200619141710.350494719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sriram R <srirrama@codeaurora.org>

[ Upstream commit 800113ff4b1d277c2b66ffc04d4d38f202a0d187 ]

The mgmt tx count reference is incremented/decremented on every mgmt tx and on
tx completion event from firmware.
In case of an unexpected mgmt tx completion event from firmware,
the counter would underflow. Avoid this by decrementing
only when the tx count is greater than 0.

Signed-off-by: Sriram R <srirrama@codeaurora.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/1585567028-9242-1-git-send-email-srirrama@codeaurora.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/wmi.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/wmi.c b/drivers/net/wireless/ath/ath11k/wmi.c
index 6fec62846279..73beca6d6b5f 100644
--- a/drivers/net/wireless/ath/ath11k/wmi.c
+++ b/drivers/net/wireless/ath/ath11k/wmi.c
@@ -3740,8 +3740,9 @@ static int wmi_process_mgmt_tx_comp(struct ath11k *ar, u32 desc_id,
 
 	ieee80211_tx_status_irqsafe(ar->hw, msdu);
 
-	WARN_ON_ONCE(atomic_read(&ar->num_pending_mgmt_tx) == 0);
-	atomic_dec(&ar->num_pending_mgmt_tx);
+	/* WARN when we received this event without doing any mgmt tx */
+	if (atomic_dec_if_positive(&ar->num_pending_mgmt_tx) < 0)
+		WARN_ON_ONCE(1);
 
 	return 0;
 }
-- 
2.25.1




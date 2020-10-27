Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF1E729C50A
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 19:08:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1824112AbgJ0SDG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 14:03:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:43638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757453AbgJ0OTi (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:19:38 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0B4A9206F7;
        Tue, 27 Oct 2020 14:19:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603808377;
        bh=OvyAEcjmGRXi4EIo5m0OaiYKZDLv2M2HFcYz5ObsZtU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YJcP2eeUq2wLqKdDBfxjrsar5VtgurbBgigkUBbci3/UBpWnqQmoXaj9T5BR8ngXQ
         lzmPNIGIL8vLHu85lWqoK//xxgyCxF6SADjyhnuk1nDoJ7CW8/ogrjjkTFYT63o5QB
         I6gs6yociQ5U6hT6ZabURFr3OUUjHnfpVBfrg5a0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 068/264] ath6kl: prevent potential array overflow in ath6kl_add_new_sta()
Date:   Tue, 27 Oct 2020 14:52:06 +0100
Message-Id: <20201027135433.881627038@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135430.632029009@linuxfoundation.org>
References: <20201027135430.632029009@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 54f9ab7b870934b70e5a21786d951fbcf663970f ]

The value for "aid" comes from skb->data so Smatch marks it as
untrusted.  If it's invalid then it can result in an out of bounds array
access in ath6kl_add_new_sta().

Fixes: 572e27c00c9d ("ath6kl: Fix AP mode connect event parsing and TIM updates")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20200813141315.GB457408@mwanda
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath6kl/main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/ath/ath6kl/main.c b/drivers/net/wireless/ath/ath6kl/main.c
index 0c61dbaa62a41..702c4761006ca 100644
--- a/drivers/net/wireless/ath/ath6kl/main.c
+++ b/drivers/net/wireless/ath/ath6kl/main.c
@@ -429,6 +429,9 @@ void ath6kl_connect_ap_mode_sta(struct ath6kl_vif *vif, u16 aid, u8 *mac_addr,
 
 	ath6kl_dbg(ATH6KL_DBG_TRC, "new station %pM aid=%d\n", mac_addr, aid);
 
+	if (aid < 1 || aid > AP_MAX_NUM_STA)
+		return;
+
 	if (assoc_req_len > sizeof(struct ieee80211_hdr_3addr)) {
 		struct ieee80211_mgmt *mgmt =
 			(struct ieee80211_mgmt *) assoc_info;
-- 
2.25.1




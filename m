Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A6CA29C09A
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:18:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1817956AbgJ0RRF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 13:17:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:55544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1781140AbgJ0OzD (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:55:03 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E996B22202;
        Tue, 27 Oct 2020 14:55:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603810502;
        bh=n5Oauafp7LEVZC9i3ohVAscmQu/4U9GxIJvoTryhYg0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qCPCr7wV4phmzPBYr4p/N6nFkjohSKY3xG+P6FN3W4tgehn8ez3LuMu4UVu3Z8msF
         1ZS1+flfXdTQ3qi3ua97+DtyiYURB0uD4gg/O79Q+kzm+SXEYL4arZwxsdssV7heVK
         feBfxsqUOXyi99j+Mpisy4NAYjtiYPxIe+B5cAVc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 161/633] ath6kl: prevent potential array overflow in ath6kl_add_new_sta()
Date:   Tue, 27 Oct 2020 14:48:24 +0100
Message-Id: <20201027135530.229399839@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
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
index 5e7ea838a9218..814131a0680a4 100644
--- a/drivers/net/wireless/ath/ath6kl/main.c
+++ b/drivers/net/wireless/ath/ath6kl/main.c
@@ -430,6 +430,9 @@ void ath6kl_connect_ap_mode_sta(struct ath6kl_vif *vif, u16 aid, u8 *mac_addr,
 
 	ath6kl_dbg(ATH6KL_DBG_TRC, "new station %pM aid=%d\n", mac_addr, aid);
 
+	if (aid < 1 || aid > AP_MAX_NUM_STA)
+		return;
+
 	if (assoc_req_len > sizeof(struct ieee80211_hdr_3addr)) {
 		struct ieee80211_mgmt *mgmt =
 			(struct ieee80211_mgmt *) assoc_info;
-- 
2.25.1




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C57D037CA93
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:54:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241826AbhELQay (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:30:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:42392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240834AbhELQZo (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:25:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 451AF61CA9;
        Wed, 12 May 2021 15:48:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620834510;
        bh=JiSwBk7n+z9UDxHWijuW9vbtAqoFPPUFO5JE7rJFJas=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ep3fk3k0iZN4bM/bpd1bwFfUZgfS2DZ+X5Scnijm4HuTXzOkL3FCXQSWfFn6jDr0Q
         mUbqTtPrwFxotzmDvdBoRE4UugM5WZGYno3uX7jd5wxQMpxHVOmySLKPUHTZIBpOYq
         7f/iQha8u74oPQyTTaTDc/ZaPGvMJ+4Og27lxEDw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 556/601] ath10k: Fix ath10k_wmi_tlv_op_pull_peer_stats_info() unlock without lock
Date:   Wed, 12 May 2021 16:50:33 +0200
Message-Id: <20210512144846.165198540@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shuah Khan <skhan@linuxfoundation.org>

[ Upstream commit eaaf52e4b866f265eb791897d622961293fd48c1 ]

ath10k_wmi_tlv_op_pull_peer_stats_info() could try to unlock RCU lock
winthout locking it first when peer reason doesn't match the valid
cases for this function.

Add a default case to return without unlocking.

Fixes: 09078368d516 ("ath10k: hold RCU lock when calling ieee80211_find_sta_by_ifaddr()")
Reported-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20210406230228.31301-1-skhan@linuxfoundation.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath10k/wmi-tlv.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.c b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
index e7072fc4f487..4f2fbc610d79 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.c
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
@@ -592,6 +592,9 @@ static void ath10k_wmi_event_tdls_peer(struct ath10k *ar, struct sk_buff *skb)
 					GFP_ATOMIC
 					);
 		break;
+	default:
+		kfree(tb);
+		return;
 	}
 
 exit:
-- 
2.30.2




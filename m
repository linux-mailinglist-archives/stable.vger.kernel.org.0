Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75E9E328A8B
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:20:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239678AbhCASSX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:18:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:34234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239367AbhCASL6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:11:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 22DC864F7C;
        Mon,  1 Mar 2021 17:08:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614618511;
        bh=sgpoTDeMHXbQua+lS2BnMkLkTPRZ47VR4rlXPMeXSvI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hxQxxg1cpmAX4kVmZRyr0PeUtxyVR92HmiHZ/mTN+MvJC/yh7LY2ZVxlG8cipMlJB
         XScgaLg0XijaRqvbQWOUJ+E6kYbi/Ko5z3OsX2WIgkBsSdw5k5Bd28ednW5mERT9NT
         ZU/KDpTOLwKffF3WYMb7wQhczwRqMHwtlKkWBNKM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 114/663] mac80211: fix potential overflow when multiplying to u32 integers
Date:   Mon,  1 Mar 2021 17:06:02 +0100
Message-Id: <20210301161147.381865950@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit 6194f7e6473be78acdc5d03edd116944bdbb2c4e ]

The multiplication of the u32 variables tx_time and estimated_retx is
performed using a 32 bit multiplication and the result is stored in
a u64 result. This has a potential u32 overflow issue, so avoid this
by casting tx_time to a u64 to force a 64 bit multiply.

Addresses-Coverity: ("Unintentional integer overflow")
Fixes: 050ac52cbe1f ("mac80211: code for on-demand Hybrid Wireless Mesh Protocol")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Link: https://lore.kernel.org/r/20210205175352.208841-1-colin.king@canonical.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/mesh_hwmp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
index 313eee12410ec..3db514c4c63ab 100644
--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -356,7 +356,7 @@ u32 airtime_link_metric_get(struct ieee80211_local *local,
 	 */
 	tx_time = (device_constant + 10 * test_frame_len / rate);
 	estimated_retx = ((1 << (2 * ARITH_SHIFT)) / (s_unit - err));
-	result = (tx_time * estimated_retx) >> (2 * ARITH_SHIFT);
+	result = ((u64)tx_time * estimated_retx) >> (2 * ARITH_SHIFT);
 	return (u32)result;
 }
 
-- 
2.27.0




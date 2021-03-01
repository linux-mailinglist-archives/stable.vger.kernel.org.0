Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0099E328532
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 17:52:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234748AbhCAQuT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 11:50:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:46814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235132AbhCAQnK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 11:43:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E1B9064F45;
        Mon,  1 Mar 2021 16:29:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614616190;
        bh=n51F1MoN36qtB0JkCbdX+vfS5gpEkfHxqyNDS/heVHE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1mh0kIVTvUV4XVcOmruWXqM7HJJSKNG/DNq9APcPyujSAMNk7SmE6gur/PuYS0O5W
         BQwrui5RB1GLxRn/2dTkjyhbQ2Ref6LlNOcqFH/2cfcLUg1LUHH6yjLr5PERSe23EA
         MeEk9jXz3vRuucDlD27Z3GpTwLDAFkR+zOVwcWYE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 035/176] mac80211: fix potential overflow when multiplying to u32 integers
Date:   Mon,  1 Mar 2021 17:11:48 +0100
Message-Id: <20210301161022.721373161@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161020.931630716@linuxfoundation.org>
References: <20210301161020.931630716@linuxfoundation.org>
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
index fe65701fe95cc..f57232bcd4057 100644
--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -355,7 +355,7 @@ static u32 airtime_link_metric_get(struct ieee80211_local *local,
 	 */
 	tx_time = (device_constant + 10 * test_frame_len / rate);
 	estimated_retx = ((1 << (2 * ARITH_SHIFT)) / (s_unit - err));
-	result = (tx_time * estimated_retx) >> (2 * ARITH_SHIFT);
+	result = ((u64)tx_time * estimated_retx) >> (2 * ARITH_SHIFT);
 	return (u32)result;
 }
 
-- 
2.27.0




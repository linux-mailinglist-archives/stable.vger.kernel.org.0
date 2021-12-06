Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6631F469E65
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:39:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356613AbhLFPiV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:38:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350561AbhLFPgU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:36:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0217C08EA71;
        Mon,  6 Dec 2021 07:21:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8FC11612D3;
        Mon,  6 Dec 2021 15:21:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78F7AC341C2;
        Mon,  6 Dec 2021 15:21:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638804075;
        bh=4rOMTa11pO6R2lkZBjdHH9MLqHmmey/N047Y90HAVy4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NelzG8n3fEwclLtFleI7k3MFH2341rZXiODQvbsYhJJGb6rrMWJLXdKxkd8zqkzTA
         XlztwgpyvtS2zHYE0VDsI1B86yVfPN8CF7hVEnyFia1cy0sqcvA6uEVqEERWGqZoaf
         7rFwr3jtDAyH5Pt2+xniO/LNNfdy5v91/Q4ZyNC0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xing Song <xing.song@mediatek.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 018/207] mac80211: do not access the IV when it was stripped
Date:   Mon,  6 Dec 2021 15:54:32 +0100
Message-Id: <20211206145610.838456462@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145610.172203682@linuxfoundation.org>
References: <20211206145610.172203682@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xing Song <xing.song@mediatek.com>

[ Upstream commit 77dfc2bc0bb4b8376ecd7a430f27a4a8fff6a5a0 ]

ieee80211_get_keyid() will return false value if IV has been stripped,
such as return 0 for IP/ARP frames due to LLC header, and return -EINVAL
for disassociation frames due to its length... etc. Don't try to access
it if it's not present.

Signed-off-by: Xing Song <xing.song@mediatek.com>
Link: https://lore.kernel.org/r/20211101024657.143026-1-xing.song@mediatek.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/rx.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 419f06ef8c986..315a3e8e95496 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1952,7 +1952,8 @@ ieee80211_rx_h_decrypt(struct ieee80211_rx_data *rx)
 		int keyid = rx->sta->ptk_idx;
 		sta_ptk = rcu_dereference(rx->sta->ptk[keyid]);
 
-		if (ieee80211_has_protected(fc)) {
+		if (ieee80211_has_protected(fc) &&
+		    !(status->flag & RX_FLAG_IV_STRIPPED)) {
 			cs = rx->sta->cipher_scheme;
 			keyid = ieee80211_get_keyid(rx->skb, cs);
 
-- 
2.33.0




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98083420DA0
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:15:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236304AbhJDNRB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:17:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:55160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235548AbhJDNPI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:15:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2F7BE61BD1;
        Mon,  4 Oct 2021 13:05:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633352758;
        bh=9jEm1yE0hS0ESTlUSb5Eh33dPcp2i2Y5ZNtxQBt7tT0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DS41e3btIljkbF+kCqrOayMY1vIS3y7d61Cf3+GHG4SM8/twFvoC+kUMaa8pHUCDf
         cHXyJp6HY+3YraPLl2VFI3Z6Ml52jOPXY3HDJRCyB4itf5SSoFYE5RjlugvQTv3XpM
         1Cyv8OBqrQDtrdid4J8uAYkcZNXq/EDINKakJAjo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chih-Kang Chang <gary.chang@realtek.com>,
        Zong-Zhe Yang <kevin_yang@realtek.com>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 15/56] mac80211: Fix ieee80211_amsdu_aggregate frag_tail bug
Date:   Mon,  4 Oct 2021 14:52:35 +0200
Message-Id: <20211004125030.492839710@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125030.002116402@linuxfoundation.org>
References: <20211004125030.002116402@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chih-Kang Chang <gary.chang@realtek.com>

[ Upstream commit fe94bac626d9c1c5bc98ab32707be8a9d7f8adba ]

In ieee80211_amsdu_aggregate() set a pointer frag_tail point to the
end of skb_shinfo(head)->frag_list, and use it to bind other skb in
the end of this function. But when execute ieee80211_amsdu_aggregate()
->ieee80211_amsdu_realloc_pad()->pskb_expand_head(), the address of
skb_shinfo(head)->frag_list will be changed. However, the
ieee80211_amsdu_aggregate() not update frag_tail after call
pskb_expand_head(). That will cause the second skb can't bind to the
head skb appropriately.So we update the address of frag_tail to fix it.

Fixes: 6e0456b54545 ("mac80211: add A-MSDU tx support")
Signed-off-by: Chih-Kang Chang <gary.chang@realtek.com>
Signed-off-by: Zong-Zhe Yang <kevin_yang@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://lore.kernel.org/r/20210830073240.12736-1-pkshih@realtek.com
[reword comment]
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/tx.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 4dfac7a25e5a..eb87ed0146d1 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -3325,6 +3325,14 @@ static bool ieee80211_amsdu_aggregate(struct ieee80211_sub_if_data *sdata,
 	if (!ieee80211_amsdu_prepare_head(sdata, fast_tx, head))
 		goto out;
 
+	/* If n == 2, the "while (*frag_tail)" loop above didn't execute
+	 * and  frag_tail should be &skb_shinfo(head)->frag_list.
+	 * However, ieee80211_amsdu_prepare_head() can reallocate it.
+	 * Reload frag_tail to have it pointing to the correct place.
+	 */
+	if (n == 2)
+		frag_tail = &skb_shinfo(head)->frag_list;
+
 	/*
 	 * Pad out the previous subframe to a multiple of 4 by adding the
 	 * padding to the next one, that's being added. Note that head->len
-- 
2.33.0




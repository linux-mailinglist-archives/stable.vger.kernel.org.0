Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 422F540952D
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:41:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345415AbhIMOid (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:38:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:56442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345612AbhIMOgP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:36:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 84F2E61BBF;
        Mon, 13 Sep 2021 13:54:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631541243;
        bh=onCAfNTIpeyAUmbShx7dHJVAFwLK2CNoIZ7fNSvftQ4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rNXTmV45ZhVW9rTPj0DvybwsmunmUkFth74jnlfiCWoEpfiT5LSFJbVBEVoENOfFa
         8AclgPO7ctFT7MF7d95pBF8B+Q5yQ4m5+XLS3V5nyqwoEYaoYdG+Iukfemy8GwJbbI
         ypH6i8e4kIGBQf85BqZakCXGxWrZ+S7b8VvHRu/k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 203/334] mac80211: remove unnecessary NULL check in ieee80211_register_hw()
Date:   Mon, 13 Sep 2021 15:14:17 +0200
Message-Id: <20210913131120.269219360@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131113.390368911@linuxfoundation.org>
References: <20210913131113.390368911@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 4a11174d6dbd0bde6d5a1d6efb0d70f58811db55 ]

The address "&sband->iftype_data[i]" points to an array at the end of
struct.  It can't be NULL and so the check can be removed.

Fixes: bac2fd3d7534 ("mac80211: remove use of ieee80211_get_he_sta_cap()")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Link: https://lore.kernel.org/r/YNmgHi7Rh3SISdog@mwanda
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index fcae76ddd586..45fb517591ee 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -1020,7 +1020,7 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 
 			iftd = &sband->iftype_data[i];
 
-			supp_he = supp_he || (iftd && iftd->he_cap.has_he);
+			supp_he = supp_he || iftd->he_cap.has_he;
 		}
 
 		/* HT, VHT, HE require QoS, thus >= 4 queues */
-- 
2.30.2




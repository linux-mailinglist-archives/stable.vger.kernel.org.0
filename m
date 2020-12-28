Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC8462E6808
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:33:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2441883AbgL1QcA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 11:32:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:60478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730478AbgL1NEh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:04:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 40845206ED;
        Mon, 28 Dec 2020 13:04:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609160661;
        bh=KAdRFZxSPzTbzgYK5MTMyvP0raa//39Om0pDEf/P3Tc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RHsyq4urOBtWXeJ4uD2Ar/8/w1lVUNVJw5BjkmoqLF05msLFcOndHtNnZdsZixVFw
         W97MUhAv+yTtzxUp8R1+cdJ0mkfQE6zSZZlGwPUC5Ay4agNLRVAqx94XTV4dngP3dK
         FWy+uPQ3I8pyxkjdCKn1o0V6DEdA1caqYmYFebLw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 128/175] cfg80211: initialize rekey_data
Date:   Mon, 28 Dec 2020 13:49:41 +0100
Message-Id: <20201228124859.457006011@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124853.216621466@linuxfoundation.org>
References: <20201228124853.216621466@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sara Sharon <sara.sharon@intel.com>

[ Upstream commit f495acd8851d7b345e5f0e521b2645b1e1f928a0 ]

In case we have old supplicant, the akm field is uninitialized.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Link: https://lore.kernel.org/r/iwlwifi.20201129172929.930f0ab7ebee.Ic546e384efab3f4a89f318eafddc3eb7d556aecb@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/nl80211.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 5bd89f536720d..ab8bca39afa3f 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -10428,7 +10428,7 @@ static int nl80211_set_rekey_data(struct sk_buff *skb, struct genl_info *info)
 	struct net_device *dev = info->user_ptr[1];
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct nlattr *tb[NUM_NL80211_REKEY_DATA];
-	struct cfg80211_gtk_rekey_data rekey_data;
+	struct cfg80211_gtk_rekey_data rekey_data = {};
 	int err;
 
 	if (!info->attrs[NL80211_ATTR_REKEY_DATA])
-- 
2.27.0




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F5A127C6CC
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:49:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731164AbgI2Lsl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:48:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:51020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731148AbgI2Lsb (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:48:31 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CAA732083B;
        Tue, 29 Sep 2020 11:48:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601380111;
        bh=x11w+LY5QJBSdM5krXK2rz3FcZrsr4Rjn84i83jltlk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YwG4u5nRxQANdsCoQw6Bkxb/SuSan5UkWGzeN0x7xhWOUsE2+xMg5CdD3CEZpMEjn
         Y3nkg0pAoIE/myT5N1zjwSSD6rL8lKh7OUj43OBXSPtzO9ty2D0NoAAjem2ob0EZyu
         streS3b5l/wjGMrP0kZ6zBUG1NxLMTTheVkLxn0U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Amar <asinghal@codeaurora.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 55/99] cfg80211: fix 6 GHz channel conversion
Date:   Tue, 29 Sep 2020 13:01:38 +0200
Message-Id: <20200929105932.431479822@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105929.719230296@linuxfoundation.org>
References: <20200929105929.719230296@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit c0de8776af6543e10d1a5c8969679fd9f6b66fa9 ]

We shouldn't accept any channels bigger than 233, fix that.

Reported-by: Amar <asinghal@codeaurora.org>
Fixes: d1a1646c0de7 ("cfg80211: adapt to new channelization of the 6GHz band")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Link: https://lore.kernel.org/r/20200917115222.312ba6f1d461.I3a8c8fbcc3cc019814fd9cd0aced7eb591626136@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/util.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/wireless/util.c b/net/wireless/util.c
index a72d2ad6ade8b..0f95844e73d80 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -95,7 +95,7 @@ u32 ieee80211_channel_to_freq_khz(int chan, enum nl80211_band band)
 		/* see 802.11ax D6.1 27.3.23.2 */
 		if (chan == 2)
 			return MHZ_TO_KHZ(5935);
-		if (chan <= 253)
+		if (chan <= 233)
 			return MHZ_TO_KHZ(5950 + chan * 5);
 		break;
 	case NL80211_BAND_60GHZ:
-- 
2.25.1




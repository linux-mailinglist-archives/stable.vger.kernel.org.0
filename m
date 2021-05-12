Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7879037C219
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:05:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232874AbhELPGf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:06:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:56088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233400AbhELPFS (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:05:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DFC1D6194C;
        Wed, 12 May 2021 15:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620831614;
        bh=JnMTwQBXdOGAb2QN0xc3vP9rfU446/io+sj55gkFHGM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2NMmGezrp3vRMU7UYk4p7+gy/YI9k+8ERl0ULCb3pK5oabTi4M+huD5ZQXnz1lH3f
         UuE/8/d868Cy8d3KWEZnwoV5qINyaaf9VxZfQH+8UiZFaUpTHKVJx3YwD3HJ4Cfb2y
         k+Gha2ForM71Pmxx3S8mNAfaOHjU2b650l+TIjOA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 189/244] mac80211: bail out if cipher schemes are invalid
Date:   Wed, 12 May 2021 16:49:20 +0200
Message-Id: <20210512144749.045919231@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144743.039977287@linuxfoundation.org>
References: <20210512144743.039977287@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit db878e27a98106a70315d264cc92230d84009e72 ]

If any of the cipher schemes specified by the driver are invalid, bail
out and fail the registration rather than just warning.  Otherwise, we
might later crash when we try to use the invalid cipher scheme, e.g.
if the hdr_len is (significantly) less than the pn_offs + pn_len, we'd
have an out-of-bounds access in RX validation.

Fixes: 2475b1cc0d52 ("mac80211: add generic cipher scheme support")
Link: https://lore.kernel.org/r/20210408143149.38a3a13a1b19.I6b7f5790fa0958ed8049cf02ac2a535c61e9bc96@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/main.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 5b3189a37680..f215218a88c9 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -1113,8 +1113,11 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 	if (local->hw.wiphy->max_scan_ie_len)
 		local->hw.wiphy->max_scan_ie_len -= local->scan_ies_len;
 
-	WARN_ON(!ieee80211_cs_list_valid(local->hw.cipher_schemes,
-					 local->hw.n_cipher_schemes));
+	if (WARN_ON(!ieee80211_cs_list_valid(local->hw.cipher_schemes,
+					     local->hw.n_cipher_schemes))) {
+		result = -EINVAL;
+		goto fail_workqueue;
+	}
 
 	result = ieee80211_init_cipher_suites(local);
 	if (result < 0)
-- 
2.30.2




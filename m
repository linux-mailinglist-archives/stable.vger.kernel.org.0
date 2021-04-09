Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8262F359AF5
	for <lists+stable@lfdr.de>; Fri,  9 Apr 2021 12:07:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233914AbhDIKHF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Apr 2021 06:07:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:51394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233795AbhDIKDK (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Apr 2021 06:03:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EF2E861279;
        Fri,  9 Apr 2021 10:00:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617962430;
        bh=LIe91PbXxmYaa+uJZH40oawnusFW6+Dym81ZSP6p2YY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dqylAxcDO3cV2EcceyiVaw/vcMex7bDrL0zauRCjkVHpOzhR0loArdnkf0Xtch0p3
         CAhR5r/HkNWUmtpUJmOS91iFMHDnpfNghV0Ap//X7r3W1h16vcwmFICqLmh05/t35u
         qaK5IOfZHd/PeeJT/7VLg8ebhUoWW3JMlQy3sdvU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Karthikeyan Kathirvel <kathirve@codeaurora.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 13/45] mac80211: choose first enabled channel for monitor
Date:   Fri,  9 Apr 2021 11:53:39 +0200
Message-Id: <20210409095305.825871023@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210409095305.397149021@linuxfoundation.org>
References: <20210409095305.397149021@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Karthikeyan Kathirvel <kathirve@codeaurora.org>

[ Upstream commit 041c881a0ba8a75f71118bd9766b78f04beed469 ]

Even if the first channel from sband channel list is invalid
or disabled mac80211 ends up choosing it as the default channel
for monitor interfaces, making them not usable.

Fix this by assigning the first available valid or enabled
channel instead.

Signed-off-by: Karthikeyan Kathirvel <kathirve@codeaurora.org>
Link: https://lore.kernel.org/r/1615440547-7661-1-git-send-email-kathirve@codeaurora.org
[reword commit message, comment, code cleanups]
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/main.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index dee88ec566ad..d1023188ef37 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -970,8 +970,19 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 			continue;
 
 		if (!dflt_chandef.chan) {
+			/*
+			 * Assign the first enabled channel to dflt_chandef
+			 * from the list of channels
+			 */
+			for (i = 0; i < sband->n_channels; i++)
+				if (!(sband->channels[i].flags &
+						IEEE80211_CHAN_DISABLED))
+					break;
+			/* if none found then use the first anyway */
+			if (i == sband->n_channels)
+				i = 0;
 			cfg80211_chandef_create(&dflt_chandef,
-						&sband->channels[0],
+						&sband->channels[i],
 						NL80211_CHAN_NO_HT);
 			/* init channel we're on */
 			if (!local->use_chanctx && !local->_oper_chandef.chan) {
-- 
2.30.2




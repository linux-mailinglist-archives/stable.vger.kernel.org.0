Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A356283A3E
	for <lists+stable@lfdr.de>; Mon,  5 Oct 2020 17:32:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728049AbgJEPcl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Oct 2020 11:32:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:60346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728046AbgJEPck (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Oct 2020 11:32:40 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B57E020B80;
        Mon,  5 Oct 2020 15:32:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601911960;
        bh=Teh2OF51j5GQpR2E2cre2gfVUdcI0zZAKAiH2EDcWUQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qX2E3dWrDdSs8Xd+pU6yo2MrTrWrX//pF2srReexCjwubkbhx6YB7XUa+Jjam9DoX
         M+Gtvk04r5dHJKRnL1xqVkNCrREU6lOGQ2cZKaruBoz5Icy0BxmtMjzOXR1dubv/JV
         bOmew232973vr4gGUsW8mtOuaXnMR/3t2u5yL98E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aloka Dixit <alokad@codeaurora.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 39/85] mac80211: Fix radiotap header channel flag for 6GHz band
Date:   Mon,  5 Oct 2020 17:26:35 +0200
Message-Id: <20201005142116.611543754@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201005142114.732094228@linuxfoundation.org>
References: <20201005142114.732094228@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aloka Dixit <alokad@codeaurora.org>

[ Upstream commit 412a84b5714af56f3eb648bba155107b5edddfdf ]

Radiotap header field 'Channel flags' has '2 GHz spectrum' set to
'true' for 6GHz packet.
Change it to 5GHz as there isn't a separate option available for 6GHz.

Signed-off-by: Aloka Dixit <alokad@codeaurora.org>
Link: https://lore.kernel.org/r/010101747ab7b703-1d7c9851-1594-43bf-81f7-f79ce7a67cc6-000000@us-west-2.amazonses.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/rx.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 5c5af4b5fc080..f2c3ac648fc08 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -451,7 +451,8 @@ ieee80211_add_rx_radiotap_header(struct ieee80211_local *local,
 	else if (status->bw == RATE_INFO_BW_5)
 		channel_flags |= IEEE80211_CHAN_QUARTER;
 
-	if (status->band == NL80211_BAND_5GHZ)
+	if (status->band == NL80211_BAND_5GHZ ||
+	    status->band == NL80211_BAND_6GHZ)
 		channel_flags |= IEEE80211_CHAN_OFDM | IEEE80211_CHAN_5GHZ;
 	else if (status->encoding != RX_ENC_LEGACY)
 		channel_flags |= IEEE80211_CHAN_DYN | IEEE80211_CHAN_2GHZ;
-- 
2.25.1




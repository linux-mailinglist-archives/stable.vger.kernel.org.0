Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D974829C1D9
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:31:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1760897AbgJ0Og6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:36:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:35830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1760890AbgJ0Og6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:36:58 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 67BCE207BB;
        Tue, 27 Oct 2020 14:36:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603809417;
        bh=GuRof7UemjKwMckMqBGPC3r/wH0n1swkFXl7GccUEgM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NSj/X6DQgpumsYINrEsmaJZA6UY7IatDo6+2zq9v1IjxhEXYTizdfTuz9cn0XQDmA
         xhKkv1ptFicc8OR5q5yXAVzfqqG9fQf27SAEHoR0n/radNUuWa2M0NldYYQfN2uNw1
         +ZZahxrXD2Yf5EoXF59w+E1nBpje/M8oKBocN4nU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 181/408] nl80211: fix non-split wiphy information
Date:   Tue, 27 Oct 2020 14:51:59 +0100
Message-Id: <20201027135503.495262354@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135455.027547757@linuxfoundation.org>
References: <20201027135455.027547757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit ab10c22bc3b2024f0c9eafa463899a071eac8d97 ]

When dumping wiphy information, we try to split the data into
many submessages, but for old userspace we still support the
old mode where this doesn't happen.

However, in this case we were not resetting our state correctly
and dumping multiple messages for each wiphy, which would have
broken such older userspace.

This was broken pretty much immediately afterwards because it
only worked in the original commit where non-split dumps didn't
have any more data than split dumps...

Fixes: fe1abafd942f ("nl80211: re-add channel width and extended capa advertising")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Link: https://lore.kernel.org/r/20200928130717.3e6d9c6bada2.Ie0f151a8d0d00a8e1e18f6a8c9244dd02496af67@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/nl80211.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 3faad3b147376..672b70730e898 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -2227,7 +2227,10 @@ static int nl80211_send_wiphy(struct cfg80211_registered_device *rdev,
 		 * case we'll continue with more data in the next round,
 		 * but break unconditionally so unsplit data stops here.
 		 */
-		state->split_start++;
+		if (state->split)
+			state->split_start++;
+		else
+			state->split_start = 0;
 		break;
 	case 9:
 		if (rdev->wiphy.extended_capabilities &&
-- 
2.25.1




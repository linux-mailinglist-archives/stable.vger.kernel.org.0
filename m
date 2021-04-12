Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC10335BE3B
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 10:57:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238796AbhDLI5Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 04:57:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:47052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238987AbhDLIzR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 04:55:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8804761263;
        Mon, 12 Apr 2021 08:54:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618217660;
        bh=4wbeKZkoyAOU2fztr/DIcBWidLILZA3OAF2I2RO21SY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bTmfxq7gifUutQUa+jY1MoVgwlPKbYhY82mtNBesVTTRl05g5OaNlTTltlnKXEnUy
         DLJB1t0I+JsHjI0linET62xx1gKQ84KReEOD5yppMAeQOJLlVagjNZSgS8EtjC/Ouu
         R9sO+MD3TvMrynhijYyFDBdR18k6NZZN3K5pRb4g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>,
        syzbot+72b99dcf4607e8c770f3@syzkaller.appspotmail.com
Subject: [PATCH 5.10 063/188] nl80211: fix beacon head validation
Date:   Mon, 12 Apr 2021 10:39:37 +0200
Message-Id: <20210412084015.753371404@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084013.643370347@linuxfoundation.org>
References: <20210412084013.643370347@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

commit 9a6847ba1747858ccac53c5aba3e25c54fbdf846 upstream.

If the beacon head attribute (NL80211_ATTR_BEACON_HEAD)
is too short to even contain the frame control field,
we access uninitialized data beyond the buffer. Fix this
by checking the minimal required size first. We used to
do this until S1G support was added, where the fixed
data portion has a different size.

Reported-and-tested-by: syzbot+72b99dcf4607e8c770f3@syzkaller.appspotmail.com
Suggested-by: Eric Dumazet <eric.dumazet@gmail.com>
Fixes: 1d47f1198d58 ("nl80211: correctly validate S1G beacon head")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Link: https://lore.kernel.org/r/20210408154518.d9b06d39b4ee.Iff908997b2a4067e8d456b3cb96cab9771d252b8@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/wireless/nl80211.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -209,9 +209,13 @@ static int validate_beacon_head(const st
 	unsigned int len = nla_len(attr);
 	const struct element *elem;
 	const struct ieee80211_mgmt *mgmt = (void *)data;
-	bool s1g_bcn = ieee80211_is_s1g_beacon(mgmt->frame_control);
 	unsigned int fixedlen, hdrlen;
+	bool s1g_bcn;
 
+	if (len < offsetofend(typeof(*mgmt), frame_control))
+		goto err;
+
+	s1g_bcn = ieee80211_is_s1g_beacon(mgmt->frame_control);
 	if (s1g_bcn) {
 		fixedlen = offsetof(struct ieee80211_ext,
 				    u.s1g_beacon.variable);



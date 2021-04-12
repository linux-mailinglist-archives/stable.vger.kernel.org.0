Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5615635BFBD
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 11:20:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239083AbhDLJGe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 05:06:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:54616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239231AbhDLJEG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 05:04:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F11A161221;
        Mon, 12 Apr 2021 09:01:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618218098;
        bh=4wbeKZkoyAOU2fztr/DIcBWidLILZA3OAF2I2RO21SY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SpIkNOv+MujoVhm4HFFRSqfMZBu61bIt1qD8RHGfldKmFfLO21iq+BLbFD7O0n18X
         IHO7IKP2gKAnhxOkcw8Ko+eiTeTlaqpUZFkyYIXnS3BLH6jOAaPOG2mAlf3h+qovgK
         a0A1gE8a6Pn2f9Jvj3f/C620MEcm+mHwxjSSgNXs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>,
        syzbot+72b99dcf4607e8c770f3@syzkaller.appspotmail.com
Subject: [PATCH 5.11 070/210] nl80211: fix beacon head validation
Date:   Mon, 12 Apr 2021 10:39:35 +0200
Message-Id: <20210412084018.341444114@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084016.009884719@linuxfoundation.org>
References: <20210412084016.009884719@linuxfoundation.org>
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



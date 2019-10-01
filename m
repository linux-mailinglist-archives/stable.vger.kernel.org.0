Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4AD2CC2F97
	for <lists+stable@lfdr.de>; Tue,  1 Oct 2019 11:05:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729787AbfJAJFS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Oct 2019 05:05:18 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:57416 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729642AbfJAJFS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Oct 2019 05:05:18 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.92.2)
        (envelope-from <johannes@sipsolutions.net>)
        id 1iFE5r-00038M-7q; Tue, 01 Oct 2019 11:05:15 +0200
Message-ID: <518b07d7e8495603aa7ffb989eb4868491efdfd4.camel@sipsolutions.net>
Subject: Re: [PATCH 1/2] nl80211: validate beacon head
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Sasha Levin <sashal@kernel.org>, linux-wireless@vger.kernel.org
Cc:     Will Deacon <will@kernel.org>, Kees Cook <keescook@chromium.org>,
        stable@vger.kernel.org
Date:   Tue, 01 Oct 2019 11:05:14 +0200
In-Reply-To: <20190921120621.375E420820@mail.kernel.org>
References: <1569009255-I7ac7fbe9436e9d8733439eab8acbbd35e55c74ef@changeid>
         <20190921120621.375E420820@mail.kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

> This commit has been processed because it contains a "Fixes:" tag,
> fixing commit: ed1b6cc7f80f cfg80211/nl80211: add beacon settings.

[...]

> NOTE: The patch will not be queued to stable trees until it is upstream.
> 
> How should we proceed with this patch?

You tell me! I can make a backport (below), but I don't know what to do
with it until the real commit actually makes it upstream ... where did
you even find it?

You also need to cherry-pick
0f3b07f027f8 ("cfg80211: add and use strongly typed element iteration macros")
7388afe09143 ("cfg80211: Use const more consistently in for_each_element macros")

as dependencies - the latter doesn't apply cleanly as it has a change
that doesn't apply, but that part of the change isn't necessary.

johannes


From 35b3085c0087933b77e36e28776cffac9cf27338 Mon Sep 17 00:00:00 2001
From: Johannes Berg <johannes.berg@intel.com>
Date: Fri, 20 Sep 2019 22:31:24 +0300
Subject: [PATCH] nl80211: validate beacon head

Commit 8a3347aa110c76a7f87771999aed491d1d8779a8 upstream.

We currently don't validate the beacon head, i.e. the header,
fixed part and elements that are to go in front of the TIM
element. This means that the variable elements there can be
malformed, e.g. have a length exceeding the buffer size, but
most downstream code from this assumes that this has already
been checked.

Add the necessary checks to the netlink policy.

Cc: stable@vger.kernel.org
Fixes: ed1b6cc7f80f ("cfg80211/nl80211: add beacon settings")
Link: https://lore.kernel.org/r/1569009255-I7ac7fbe9436e9d8733439eab8acbbd35e55c74ef@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/nl80211.c | 38 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 2a85bff6a8f3..58d1b0d5cc84 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -200,6 +200,38 @@ cfg80211_get_dev_from_info(struct net *netns, struct genl_info *info)
 	return __cfg80211_rdev_from_attrs(netns, info->attrs);
 }
 
+static int validate_beacon_head(const struct nlattr *attr,
+				struct netlink_ext_ack *extack)
+{
+	const u8 *data = nla_data(attr);
+	unsigned int len = nla_len(attr);
+	const struct element *elem;
+	const struct ieee80211_mgmt *mgmt = (void *)data;
+	unsigned int fixedlen = offsetof(struct ieee80211_mgmt,
+					 u.beacon.variable);
+
+	if (len < fixedlen)
+		goto err;
+
+	if (ieee80211_hdrlen(mgmt->frame_control) !=
+	    offsetof(struct ieee80211_mgmt, u.beacon))
+		goto err;
+
+	data += fixedlen;
+	len -= fixedlen;
+
+	for_each_element(elem, data, len) {
+		/* nothing */
+	}
+
+	if (for_each_element_completed(elem, data, len))
+		return 0;
+
+err:
+	NL_SET_ERR_MSG_ATTR(extack, attr, "malformed beacon head");
+	return -EINVAL;
+}
+
 /* policy for the attributes */
 static const struct nla_policy nl80211_policy[NUM_NL80211_ATTR] = {
 	[NL80211_ATTR_WIPHY] = { .type = NLA_U32 },
@@ -4014,6 +4046,12 @@ static int nl80211_parse_beacon(struct nlattr *attrs[],
 	memset(bcn, 0, sizeof(*bcn));
 
 	if (attrs[NL80211_ATTR_BEACON_HEAD]) {
+		int ret = validate_beacon_head(attrs[NL80211_ATTR_BEACON_HEAD],
+					       NULL);
+
+		if (ret)
+			return ret;
+
 		bcn->head = nla_data(attrs[NL80211_ATTR_BEACON_HEAD]);
 		bcn->head_len = nla_len(attrs[NL80211_ATTR_BEACON_HEAD]);
 		if (!bcn->head_len)
-- 
2.20.1



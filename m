Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09A9D1161F5
	for <lists+stable@lfdr.de>; Sun,  8 Dec 2019 14:56:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727298AbfLHN4Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Dec 2019 08:56:24 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:60364 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726841AbfLHNyo (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 8 Dec 2019 08:54:44 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1idx1F-0007gC-6Q; Sun, 08 Dec 2019 13:54:41 +0000
Received: from ben by deadeye with local (Exim 4.93-RC1)
        (envelope-from <ben@decadent.org.uk>)
        id 1idx1D-0002OW-IK; Sun, 08 Dec 2019 13:54:39 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Johannes Berg" <johannes.berg@intel.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Date:   Sun, 08 Dec 2019 13:53:35 +0000
Message-ID: <lsq.1575813165.948194023@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 51/72] nl80211: validate beacon head
In-Reply-To: <lsq.1575813164.154362148@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.79-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

commit f88eb7c0d002a67ef31aeb7850b42ff69abc46dc upstream.

We currently don't validate the beacon head, i.e. the header,
fixed part and elements that are to go in front of the TIM
element. This means that the variable elements there can be
malformed, e.g. have a length exceeding the buffer size, but
most downstream code from this assumes that this has already
been checked.

Add the necessary checks to the netlink policy.

Fixes: ed1b6cc7f80f ("cfg80211/nl80211: add beacon settings")
Link: https://lore.kernel.org/r/1569009255-I7ac7fbe9436e9d8733439eab8acbbd35e55c74ef@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/wireless/nl80211.c | 35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -208,6 +208,36 @@ cfg80211_get_dev_from_info(struct net *n
 	return __cfg80211_rdev_from_attrs(netns, info->attrs);
 }
 
+static int validate_beacon_head(const struct nlattr *attr)
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
+	return -EINVAL;
+}
+
 /* policy for the attributes */
 static const struct nla_policy nl80211_policy[NL80211_ATTR_MAX+1] = {
 	[NL80211_ATTR_WIPHY] = { .type = NLA_U32 },
@@ -3125,6 +3155,11 @@ static int nl80211_parse_beacon(struct n
 	memset(bcn, 0, sizeof(*bcn));
 
 	if (attrs[NL80211_ATTR_BEACON_HEAD]) {
+		int ret = validate_beacon_head(attrs[NL80211_ATTR_BEACON_HEAD]);
+
+		if (ret)
+			return ret;
+
 		bcn->head = nla_data(attrs[NL80211_ATTR_BEACON_HEAD]);
 		bcn->head_len = nla_len(attrs[NL80211_ATTR_BEACON_HEAD]);
 		if (!bcn->head_len)


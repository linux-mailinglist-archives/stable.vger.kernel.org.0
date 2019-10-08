Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4193CFFF8
	for <lists+stable@lfdr.de>; Tue,  8 Oct 2019 19:34:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727365AbfJHReH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Oct 2019 13:34:07 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:39583 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726066AbfJHReH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Oct 2019 13:34:07 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id D268E21AD0;
        Tue,  8 Oct 2019 13:34:05 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Tue, 08 Oct 2019 13:34:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=2w3Hf8
        tSoasJaiAK6Jiu6yLrJEyjNomhmWLyJa3wuKI=; b=tFYwGvhkGOkZ5YPQbODWie
        QjlioOxX46C/Xrd+VMGYuYOjBUkXJabMONMF6TfKmoJ0H8l3qJsJ2idHqxfD5/2J
        AOUsy+3JUWmF4VIUlJ+1MFTxcsC5RuA/lgSKnmltz+jgKrICnyEQzeflqBsTjh9g
        CjPBENhVgYHkwIamdXrpsbAuObc2fpCHqKvcniX/S5wBySmMKm6LUkp0Jm05jpa2
        ll4bfPV+5Ga0zCipIp3MgMmLlvNZu1K2Cf+ZN8UZUEdvJ2V3XE6V82UvmZ+0j5Iv
        vsMZhRCSB6EUrR63wKrT1ItKBPmvpJu710jYvvK5mqRAb0QKjsNU30e3hTOabtXw
        ==
X-ME-Sender: <xms:jcicXVoQ3Uw-IFkDqRH5Zjte5M0ORYlDb1fCSDXLA8Hv9jclxkwXqA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrheelgdduudejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrkeelrd
    dutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhen
    ucevlhhushhtvghrufhiiigvpedu
X-ME-Proxy: <xmx:jcicXeMSERzIGsK29mx2-5dlYqxuwPSiFi2PDSIAL5Vfkk34NedltQ>
    <xmx:jcicXfYoCv81H234FBwyZDEEM1ZgWsi8dbhieuZY8fYxNH2_kfQI2Q>
    <xmx:jcicXS9WHdyx_VUjP00r2_3n5VzIN4zKJCVyn4coKjfaMOfGzhdgsg>
    <xmx:jcicXdayJcQP2NUscGP77fxtF3uZXzYlTVhG5pVSqgtjkeh-bx8Sjw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 70FA0D60067;
        Tue,  8 Oct 2019 13:34:05 -0400 (EDT)
Subject: FAILED: patch "[PATCH] nl80211: validate beacon head" failed to apply to 4.9-stable tree
To:     johannes.berg@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 08 Oct 2019 19:33:54 +0200
Message-ID: <1570556034139232@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From f88eb7c0d002a67ef31aeb7850b42ff69abc46dc Mon Sep 17 00:00:00 2001
From: Johannes Berg <johannes.berg@intel.com>
Date: Fri, 20 Sep 2019 21:54:17 +0200
Subject: [PATCH] nl80211: validate beacon head

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

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index d21b1581a665..7386421e2ad3 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -201,6 +201,38 @@ cfg80211_get_dev_from_info(struct net *netns, struct genl_info *info)
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
 static int validate_ie_attr(const struct nlattr *attr,
 			    struct netlink_ext_ack *extack)
 {
@@ -338,8 +370,9 @@ const struct nla_policy nl80211_policy[NUM_NL80211_ATTR] = {
 
 	[NL80211_ATTR_BEACON_INTERVAL] = { .type = NLA_U32 },
 	[NL80211_ATTR_DTIM_PERIOD] = { .type = NLA_U32 },
-	[NL80211_ATTR_BEACON_HEAD] = { .type = NLA_BINARY,
-				       .len = IEEE80211_MAX_DATA_LEN },
+	[NL80211_ATTR_BEACON_HEAD] =
+		NLA_POLICY_VALIDATE_FN(NLA_BINARY, validate_beacon_head,
+				       IEEE80211_MAX_DATA_LEN),
 	[NL80211_ATTR_BEACON_TAIL] =
 		NLA_POLICY_VALIDATE_FN(NLA_BINARY, validate_ie_attr,
 				       IEEE80211_MAX_DATA_LEN),


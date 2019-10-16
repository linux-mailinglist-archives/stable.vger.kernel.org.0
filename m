Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0B4ADA165
	for <lists+stable@lfdr.de>; Thu, 17 Oct 2019 00:27:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394813AbfJPVxE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 17:53:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:41640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2394807AbfJPVxE (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Oct 2019 17:53:04 -0400
Received: from localhost (unknown [192.55.54.58])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4B50A20872;
        Wed, 16 Oct 2019 21:53:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571262783;
        bh=4E/fwMhWXnNPiCefYxw9M5HEvuky75pkNVwbx78a4sQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HXsl/IUVPRy7WCs4+YtifPqLUr9K0b4jOTM5TNe7kfhS8ap83z/0GzqrwMyF+qhTf
         r8Ium1iyyAhE6DCjDArAEBL/QU9F4QTe4KrFjRUrDr7o3oFARdRMb88uOPR1AWXN16
         qqp6ZhHrH3CQeP2ZVIhoFHqptcbaOrZlUSOQHu7Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 4.4 24/79] cfg80211: add and use strongly typed element iteration macros
Date:   Wed, 16 Oct 2019 14:49:59 -0700
Message-Id: <20191016214752.956130121@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191016214729.758892904@linuxfoundation.org>
References: <20191016214729.758892904@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

commit 0f3b07f027f87a38ebe5c436490095df762819be upstream.

Rather than always iterating elements from frames with pure
u8 pointers, add a type "struct element" that encapsulates
the id/datalen/data format of them.

Then, add the element iteration macros
 * for_each_element
 * for_each_element_id
 * for_each_element_extid

which take, as their first 'argument', such a structure and
iterate through a given u8 array interpreting it as elements.

While at it and since we'll need it, also add
 * for_each_subelement
 * for_each_subelement_id
 * for_each_subelement_extid

which instead of taking data/length just take an outer element
and use its data/datalen.

Also add for_each_element_completed() to determine if any of
the loops above completed, i.e. it was able to parse all of
the elements successfully and no data remained.

Use for_each_element_id() in cfg80211_find_ie_match() as the
first user of this.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/ieee80211.h |   53 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 53 insertions(+)

--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -2550,4 +2550,57 @@ static inline bool ieee80211_action_cont
 	return true;
 }
 
+struct element {
+	u8 id;
+	u8 datalen;
+	u8 data[];
+};
+
+/* element iteration helpers */
+#define for_each_element(element, _data, _datalen)			\
+	for (element = (void *)(_data);					\
+	     (u8 *)(_data) + (_datalen) - (u8 *)element >=		\
+		sizeof(*element) &&					\
+	     (u8 *)(_data) + (_datalen) - (u8 *)element >=		\
+		sizeof(*element) + element->datalen;			\
+	     element = (void *)(element->data + element->datalen))
+
+#define for_each_element_id(element, _id, data, datalen)		\
+	for_each_element(element, data, datalen)			\
+		if (element->id == (_id))
+
+#define for_each_element_extid(element, extid, data, datalen)		\
+	for_each_element(element, data, datalen)			\
+		if (element->id == WLAN_EID_EXTENSION &&		\
+		    element->datalen > 0 &&				\
+		    element->data[0] == (extid))
+
+#define for_each_subelement(sub, element)				\
+	for_each_element(sub, (element)->data, (element)->datalen)
+
+#define for_each_subelement_id(sub, id, element)			\
+	for_each_element_id(sub, id, (element)->data, (element)->datalen)
+
+#define for_each_subelement_extid(sub, extid, element)			\
+	for_each_element_extid(sub, extid, (element)->data, (element)->datalen)
+
+/**
+ * for_each_element_completed - determine if element parsing consumed all data
+ * @element: element pointer after for_each_element() or friends
+ * @data: same data pointer as passed to for_each_element() or friends
+ * @datalen: same data length as passed to for_each_element() or friends
+ *
+ * This function returns %true if all the data was parsed or considered
+ * while walking the elements. Only use this if your for_each_element()
+ * loop cannot be broken out of, otherwise it always returns %false.
+ *
+ * If some data was malformed, this returns %false since the last parsed
+ * element will not fill the whole remaining data.
+ */
+static inline bool for_each_element_completed(const struct element *element,
+					      const void *data, size_t datalen)
+{
+	return (u8 *)element == (u8 *)data + datalen;
+}
+
 #endif /* LINUX_IEEE80211_H */



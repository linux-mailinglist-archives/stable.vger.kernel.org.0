Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F0111161F7
	for <lists+stable@lfdr.de>; Sun,  8 Dec 2019 14:56:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727000AbfLHN4d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Dec 2019 08:56:33 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:60370 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726843AbfLHNyo (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 8 Dec 2019 08:54:44 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1idx1E-0007gA-TR; Sun, 08 Dec 2019 13:54:40 +0000
Received: from ben by deadeye with local (Exim 4.93-RC1)
        (envelope-from <ben@decadent.org.uk>)
        id 1idx1D-0002OR-Bp; Sun, 08 Dec 2019 13:54:39 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Johannes Berg" <johannes.berg@intel.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Date:   Sun, 08 Dec 2019 13:53:34 +0000
Message-ID: <lsq.1575813165.68561352@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 50/72] cfg80211: add and use strongly typed element
 iteration macros
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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 include/linux/ieee80211.h | 53 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 53 insertions(+)

--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -2358,4 +2358,57 @@ static inline bool ieee80211_check_tim(c
 #define TU_TO_JIFFIES(x)	(usecs_to_jiffies((x) * 1024))
 #define TU_TO_EXP_TIME(x)	(jiffies + TU_TO_JIFFIES(x))
 
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


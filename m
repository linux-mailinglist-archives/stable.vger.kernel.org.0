Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F1C8D24FA
	for <lists+stable@lfdr.de>; Thu, 10 Oct 2019 11:01:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387826AbfJJIwK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Oct 2019 04:52:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:59950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389884AbfJJIwI (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Oct 2019 04:52:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1085B20B7C;
        Thu, 10 Oct 2019 08:52:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570697528;
        bh=uWYCfQmlT5KxQXn7nWo6QYGrYNwoG1CM8QcUPAxUwL0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BCfJrqLH/F0j6PQxRzVadTpMJUYx5hG8fvrYEfTtpiFmohP1I1JB4tb466Pywq74r
         Lsqlha06dSjWRvHAihMnJePrjbNFqyYFwQTkHF6L4IjTrmj7iJeQS/Yv1FC8ao13t6
         YxgO/baYI45TW3lGS18rssGLwXEOBL+jUuseWEC8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jouni Malinen <j@w1.fi>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 4.14 59/61] cfg80211: Use const more consistently in for_each_element macros
Date:   Thu, 10 Oct 2019 10:37:24 +0200
Message-Id: <20191010083527.108834856@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191010083449.500442342@linuxfoundation.org>
References: <20191010083449.500442342@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jouni Malinen <j@w1.fi>

commit 7388afe09143210f555bdd6c75035e9acc1fab96 upstream.

Enforce the first argument to be a correct type of a pointer to struct
element and avoid unnecessary typecasts from const to non-const pointers
(the change in validate_ie_attr() is needed to make this part work). In
addition, avoid signed/unsigned comparison within for_each_element() and
mark struct element packed just in case.

Signed-off-by: Jouni Malinen <j@w1.fi>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/ieee80211.h |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -2747,16 +2747,16 @@ struct element {
 	u8 id;
 	u8 datalen;
 	u8 data[];
-};
+} __packed;
 
 /* element iteration helpers */
-#define for_each_element(element, _data, _datalen)			\
-	for (element = (void *)(_data);					\
-	     (u8 *)(_data) + (_datalen) - (u8 *)element >=		\
-		sizeof(*element) &&					\
-	     (u8 *)(_data) + (_datalen) - (u8 *)element >=		\
-		sizeof(*element) + element->datalen;			\
-	     element = (void *)(element->data + element->datalen))
+#define for_each_element(_elem, _data, _datalen)			\
+	for (_elem = (const struct element *)(_data);			\
+	     (const u8 *)(_data) + (_datalen) - (const u8 *)_elem >=	\
+		(int)sizeof(*_elem) &&					\
+	     (const u8 *)(_data) + (_datalen) - (const u8 *)_elem >=	\
+		(int)sizeof(*_elem) + _elem->datalen;			\
+	     _elem = (const struct element *)(_elem->data + _elem->datalen))
 
 #define for_each_element_id(element, _id, data, datalen)		\
 	for_each_element(element, data, datalen)			\
@@ -2793,7 +2793,7 @@ struct element {
 static inline bool for_each_element_completed(const struct element *element,
 					      const void *data, size_t datalen)
 {
-	return (u8 *)element == (u8 *)data + datalen;
+	return (const u8 *)element == (const u8 *)data + datalen;
 }
 
 #endif /* LINUX_IEEE80211_H */



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 17DB423357
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 14:16:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732652AbfETMQI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 08:16:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:56788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731553AbfETMQI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 May 2019 08:16:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4563A20656;
        Mon, 20 May 2019 12:16:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558354567;
        bh=2Y742oHnH+HGTWCwRcOZUm06XA9gz/E0XA7OEu+zDac=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WnGqP2CuxK66tz+AQ6P/4j3TUtGxsGXphUzv2W6nZj8AwUfEXrtNpTMNdEgnrRBvo
         LafqO69AdsLGw6Inr4u5/r6NsaxEq9Ekm3fozHSrJY+iHUP3DdtCcwXLFn1/sJosBT
         dbozyA63j1+7TSlV/9f9XUZyiKVmC/JbvzCayeiU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Edward Cree <ecree@solarflare.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 01/44] net: core: another layer of lists, around PF_MEMALLOC skb handling
Date:   Mon, 20 May 2019 14:13:50 +0200
Message-Id: <20190520115231.080664115@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190520115230.720347034@linuxfoundation.org>
References: <20190520115230.720347034@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 78ed8cc25986ac5c21762eeddc1e86e94d422e36 ]

First example of a layer splitting the list (rather than merely taking
 individual packets off it).
Involves new list.h function, list_cut_before(), like list_cut_position()
 but cuts on the other side of the given entry.

Signed-off-by: Edward Cree <ecree@solarflare.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
[sl: cut out non list.h bits, we only want list_cut_before]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/list.h | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/include/linux/list.h b/include/linux/list.h
index 5809e9a2de5b2..6f935018ea056 100644
--- a/include/linux/list.h
+++ b/include/linux/list.h
@@ -271,6 +271,36 @@ static inline void list_cut_position(struct list_head *list,
 		__list_cut_position(list, head, entry);
 }
 
+/**
+ * list_cut_before - cut a list into two, before given entry
+ * @list: a new list to add all removed entries
+ * @head: a list with entries
+ * @entry: an entry within head, could be the head itself
+ *
+ * This helper moves the initial part of @head, up to but
+ * excluding @entry, from @head to @list.  You should pass
+ * in @entry an element you know is on @head.  @list should
+ * be an empty list or a list you do not care about losing
+ * its data.
+ * If @entry == @head, all entries on @head are moved to
+ * @list.
+ */
+static inline void list_cut_before(struct list_head *list,
+				   struct list_head *head,
+				   struct list_head *entry)
+{
+	if (head->next == entry) {
+		INIT_LIST_HEAD(list);
+		return;
+	}
+	list->next = head->next;
+	list->next->prev = list;
+	list->prev = entry->prev;
+	list->prev->next = list;
+	head->next = entry;
+	entry->prev = head;
+}
+
 static inline void __list_splice(const struct list_head *list,
 				 struct list_head *prev,
 				 struct list_head *next)
-- 
2.20.1




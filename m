Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D2103A95C
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 19:10:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388302AbfFIRC4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 13:02:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:41100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388328AbfFIRC4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 13:02:56 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 13BFA212F5;
        Sun,  9 Jun 2019 17:02:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560099774;
        bh=t/NdbxeV71+mFzOAr7RDuesFYIu+muv8mr/fCfGlYGE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HU1vIL0eoO8OgE1798ol56set5Rr3Z1/4JTfEk0E6Jv5Ty0wJjkDOwlB2LVIwVqyq
         fJzRCrIlwyveY+lhHw0LpdqvSDQDqI5IjuuoOgo6kTGHVvsOdof+Abg4XGpIxOHUPr
         GLgGeeAtfRsNcHZzLHf3BcUjuqzEJohJLKk6AO3s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nicolas Saenz Julienne <nsaenzjulienne@suse.de>,
        Terry Junge <terry.junge@poly.com>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 161/241] HID: core: move Usage Page concatenation to Main item
Date:   Sun,  9 Jun 2019 18:41:43 +0200
Message-Id: <20190609164152.418849487@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190609164147.729157653@linuxfoundation.org>
References: <20190609164147.729157653@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 58e75155009cc800005629955d3482f36a1e0eec ]

As seen on some USB wireless keyboards manufactured by Primax, the HID
parser was using some assumptions that are not always true. In this case
it's s the fact that, inside the scope of a main item, an Usage Page
will always precede an Usage.

The spec is not pretty clear as 6.2.2.7 states "Any usage that follows
is interpreted as a Usage ID and concatenated with the Usage Page".
While 6.2.2.8 states "When the parser encounters a main item it
concatenates the last declared Usage Page with a Usage to form a
complete usage value." Being somewhat contradictory it was decided to
match Window's implementation, which follows 6.2.2.8.

In summary, the patch moves the Usage Page concatenation from the local
item parsing function to the main item parsing function.

Signed-off-by: Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
Reviewed-by: Terry Junge <terry.junge@poly.com>
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-core.c | 36 ++++++++++++++++++++++++------------
 include/linux/hid.h    |  1 +
 2 files changed, 25 insertions(+), 12 deletions(-)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 4564ecf711815..9b2b41d683dea 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -200,13 +200,14 @@ static unsigned hid_lookup_collection(struct hid_parser *parser, unsigned type)
  * Add a usage to the temporary parser table.
  */
 
-static int hid_add_usage(struct hid_parser *parser, unsigned usage)
+static int hid_add_usage(struct hid_parser *parser, unsigned usage, u8 size)
 {
 	if (parser->local.usage_index >= HID_MAX_USAGES) {
 		hid_err(parser->device, "usage index exceeded\n");
 		return -1;
 	}
 	parser->local.usage[parser->local.usage_index] = usage;
+	parser->local.usage_size[parser->local.usage_index] = size;
 	parser->local.collection_index[parser->local.usage_index] =
 		parser->collection_stack_ptr ?
 		parser->collection_stack[parser->collection_stack_ptr - 1] : 0;
@@ -463,10 +464,7 @@ static int hid_parser_local(struct hid_parser *parser, struct hid_item *item)
 			return 0;
 		}
 
-		if (item->size <= 2)
-			data = (parser->global.usage_page << 16) + data;
-
-		return hid_add_usage(parser, data);
+		return hid_add_usage(parser, data, item->size);
 
 	case HID_LOCAL_ITEM_TAG_USAGE_MINIMUM:
 
@@ -475,9 +473,6 @@ static int hid_parser_local(struct hid_parser *parser, struct hid_item *item)
 			return 0;
 		}
 
-		if (item->size <= 2)
-			data = (parser->global.usage_page << 16) + data;
-
 		parser->local.usage_minimum = data;
 		return 0;
 
@@ -488,9 +483,6 @@ static int hid_parser_local(struct hid_parser *parser, struct hid_item *item)
 			return 0;
 		}
 
-		if (item->size <= 2)
-			data = (parser->global.usage_page << 16) + data;
-
 		count = data - parser->local.usage_minimum;
 		if (count + parser->local.usage_index >= HID_MAX_USAGES) {
 			/*
@@ -510,7 +502,7 @@ static int hid_parser_local(struct hid_parser *parser, struct hid_item *item)
 		}
 
 		for (n = parser->local.usage_minimum; n <= data; n++)
-			if (hid_add_usage(parser, n)) {
+			if (hid_add_usage(parser, n, item->size)) {
 				dbg_hid("hid_add_usage failed\n");
 				return -1;
 			}
@@ -524,6 +516,22 @@ static int hid_parser_local(struct hid_parser *parser, struct hid_item *item)
 	return 0;
 }
 
+/*
+ * Concatenate Usage Pages into Usages where relevant:
+ * As per specification, 6.2.2.8: "When the parser encounters a main item it
+ * concatenates the last declared Usage Page with a Usage to form a complete
+ * usage value."
+ */
+
+static void hid_concatenate_usage_page(struct hid_parser *parser)
+{
+	int i;
+
+	for (i = 0; i < parser->local.usage_index; i++)
+		if (parser->local.usage_size[i] <= 2)
+			parser->local.usage[i] += parser->global.usage_page << 16;
+}
+
 /*
  * Process a main item.
  */
@@ -533,6 +541,8 @@ static int hid_parser_main(struct hid_parser *parser, struct hid_item *item)
 	__u32 data;
 	int ret;
 
+	hid_concatenate_usage_page(parser);
+
 	data = item_udata(item);
 
 	switch (item->tag) {
@@ -746,6 +756,8 @@ static int hid_scan_main(struct hid_parser *parser, struct hid_item *item)
 	__u32 data;
 	int i;
 
+	hid_concatenate_usage_page(parser);
+
 	data = item_udata(item);
 
 	switch (item->tag) {
diff --git a/include/linux/hid.h b/include/linux/hid.h
index fd86687f81196..5f31318851366 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -372,6 +372,7 @@ struct hid_global {
 
 struct hid_local {
 	unsigned usage[HID_MAX_USAGES]; /* usage array */
+	u8 usage_size[HID_MAX_USAGES]; /* usage size array */
 	unsigned collection_index[HID_MAX_USAGES]; /* collection index array */
 	unsigned usage_index;
 	unsigned usage_minimum;
-- 
2.20.1




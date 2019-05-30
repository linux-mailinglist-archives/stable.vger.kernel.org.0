Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1167B2F071
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:04:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727016AbfE3EEJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 00:04:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:48276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731317AbfE3DRx (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:17:53 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B7B6C2473B;
        Thu, 30 May 2019 03:17:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186272;
        bh=wSuc4b6uTiISnE3BZXVFg0KIQizJKVckQn+jaVcmCpc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KAf+3+aq4t/JZjP4AUcnBSEDhAXJeyFI8JGXDJM9Deys9g1NL43Ig7KCdDihFTQMa
         oymw2O/6R9jRfz0alJuW87guXzq7OMn8nOletfWhxxarJdNAEE13kbeFB+5wwawwbF
         odq8TXHDStnhGHmeqjqVkFm5i9U9Bj4IBNNByhYw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nicolas Saenz Julienne <nsaenzjulienne@suse.de>,
        Terry Junge <terry.junge@poly.com>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 213/276] HID: core: move Usage Page concatenation to Main item
Date:   Wed, 29 May 2019 20:06:11 -0700
Message-Id: <20190530030538.454681387@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030523.133519668@linuxfoundation.org>
References: <20190530030523.133519668@linuxfoundation.org>
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
index 44564f61e9cc3..861375561156c 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -215,13 +215,14 @@ static unsigned hid_lookup_collection(struct hid_parser *parser, unsigned type)
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
@@ -482,10 +483,7 @@ static int hid_parser_local(struct hid_parser *parser, struct hid_item *item)
 			return 0;
 		}
 
-		if (item->size <= 2)
-			data = (parser->global.usage_page << 16) + data;
-
-		return hid_add_usage(parser, data);
+		return hid_add_usage(parser, data, item->size);
 
 	case HID_LOCAL_ITEM_TAG_USAGE_MINIMUM:
 
@@ -494,9 +492,6 @@ static int hid_parser_local(struct hid_parser *parser, struct hid_item *item)
 			return 0;
 		}
 
-		if (item->size <= 2)
-			data = (parser->global.usage_page << 16) + data;
-
 		parser->local.usage_minimum = data;
 		return 0;
 
@@ -507,9 +502,6 @@ static int hid_parser_local(struct hid_parser *parser, struct hid_item *item)
 			return 0;
 		}
 
-		if (item->size <= 2)
-			data = (parser->global.usage_page << 16) + data;
-
 		count = data - parser->local.usage_minimum;
 		if (count + parser->local.usage_index >= HID_MAX_USAGES) {
 			/*
@@ -529,7 +521,7 @@ static int hid_parser_local(struct hid_parser *parser, struct hid_item *item)
 		}
 
 		for (n = parser->local.usage_minimum; n <= data; n++)
-			if (hid_add_usage(parser, n)) {
+			if (hid_add_usage(parser, n, item->size)) {
 				dbg_hid("hid_add_usage failed\n");
 				return -1;
 			}
@@ -543,6 +535,22 @@ static int hid_parser_local(struct hid_parser *parser, struct hid_item *item)
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
@@ -552,6 +560,8 @@ static int hid_parser_main(struct hid_parser *parser, struct hid_item *item)
 	__u32 data;
 	int ret;
 
+	hid_concatenate_usage_page(parser);
+
 	data = item_udata(item);
 
 	switch (item->tag) {
@@ -761,6 +771,8 @@ static int hid_scan_main(struct hid_parser *parser, struct hid_item *item)
 	__u32 data;
 	int i;
 
+	hid_concatenate_usage_page(parser);
+
 	data = item_udata(item);
 
 	switch (item->tag) {
diff --git a/include/linux/hid.h b/include/linux/hid.h
index d44a783629425..8b3e5e8a72fbc 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -414,6 +414,7 @@ struct hid_global {
 
 struct hid_local {
 	unsigned usage[HID_MAX_USAGES]; /* usage array */
+	u8 usage_size[HID_MAX_USAGES]; /* usage size array */
 	unsigned collection_index[HID_MAX_USAGES]; /* collection index array */
 	unsigned usage_index;
 	unsigned usage_minimum;
-- 
2.20.1




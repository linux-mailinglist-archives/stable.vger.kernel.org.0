Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B775111331E
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 19:16:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730995AbfLDSOh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Dec 2019 13:14:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:43970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728271AbfLDSOg (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Dec 2019 13:14:36 -0500
Received: from localhost (unknown [217.68.49.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C0D842084B;
        Wed,  4 Dec 2019 18:14:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575483275;
        bh=eTLW9auAY7BPKUpSarCQ9h6zUJRvDEvNCM/3/FLyHYA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X+J4M5XJ0K/9vaSCO0rcJErJGGHOKoQHJKnv4va8eCWXRg+TKQ1izcaKxiSyR6iIX
         SfTWGjtvCPPDfBLsmvMyPdyf7sNkapr8bEEzj7jrH4wnlUhW9banUC1YTw173rOmu9
         +0O5Zd3mW9sZ4NbvGMrYkS99RfX+TSec7MPjKP0w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Candle Sun <candle.sun@unisoc.com>,
        Nianfu Bai <nianfu.bai@unisoc.com>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>,
        Siarhei Vishniakou <svv@google.com>
Subject: [PATCH 4.9 122/125] HID: core: check whether Usage Page item is after Usage ID items
Date:   Wed,  4 Dec 2019 18:57:07 +0100
Message-Id: <20191204175326.782124825@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191204175308.377746305@linuxfoundation.org>
References: <20191204175308.377746305@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Candle Sun <candle.sun@unisoc.com>

commit 1cb0d2aee26335d0bccf29100c7bed00ebece851 upstream.

Upstream commit 58e75155009c ("HID: core: move Usage Page concatenation
to Main item") adds support for Usage Page item after Usage ID items
(such as keyboards manufactured by Primax).

Usage Page concatenation in Main item works well for following report
descriptor patterns:

    USAGE_PAGE (Keyboard)                   05 07
    USAGE_MINIMUM (Keyboard LeftControl)    19 E0
    USAGE_MAXIMUM (Keyboard Right GUI)      29 E7
    LOGICAL_MINIMUM (0)                     15 00
    LOGICAL_MAXIMUM (1)                     25 01
    REPORT_SIZE (1)                         75 01
    REPORT_COUNT (8)                        95 08
    INPUT (Data,Var,Abs)                    81 02

-------------

    USAGE_MINIMUM (Keyboard LeftControl)    19 E0
    USAGE_MAXIMUM (Keyboard Right GUI)      29 E7
    LOGICAL_MINIMUM (0)                     15 00
    LOGICAL_MAXIMUM (1)                     25 01
    REPORT_SIZE (1)                         75 01
    REPORT_COUNT (8)                        95 08
    USAGE_PAGE (Keyboard)                   05 07
    INPUT (Data,Var,Abs)                    81 02

But it makes the parser act wrong for the following report
descriptor pattern(such as some Gamepads):

    USAGE_PAGE (Button)                     05 09
    USAGE (Button 1)                        09 01
    USAGE (Button 2)                        09 02
    USAGE (Button 4)                        09 04
    USAGE (Button 5)                        09 05
    USAGE (Button 7)                        09 07
    USAGE (Button 8)                        09 08
    USAGE (Button 14)                       09 0E
    USAGE (Button 15)                       09 0F
    USAGE (Button 13)                       09 0D
    USAGE_PAGE (Consumer Devices)           05 0C
    USAGE (Back)                            0a 24 02
    USAGE (HomePage)                        0a 23 02
    LOGICAL_MINIMUM (0)                     15 00
    LOGICAL_MAXIMUM (1)                     25 01
    REPORT_SIZE (1)                         75 01
    REPORT_COUNT (11)                       95 0B
    INPUT (Data,Var,Abs)                    81 02

With Usage Page concatenation in Main item, parser recognizes all the
11 Usages as consumer keys, it is not the HID device's real intention.

This patch checks whether Usage Page is really defined after Usage ID
items by comparing usage page using status.

Usage Page concatenation on currently defined Usage Page will always
do in local parsing when Usage ID items encountered.

When Main item is parsing, concatenation will do again with last
defined Usage Page if this page has not been used in the previous
usages concatenation.

Signed-off-by: Candle Sun <candle.sun@unisoc.com>
Signed-off-by: Nianfu Bai <nianfu.bai@unisoc.com>
Cc: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Cc: Siarhei Vishniakou <svv@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hid/hid-core.c |   51 +++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 45 insertions(+), 6 deletions(-)

--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -197,6 +197,18 @@ static unsigned hid_lookup_collection(st
 }
 
 /*
+ * Concatenate usage which defines 16 bits or less with the
+ * currently defined usage page to form a 32 bit usage
+ */
+
+static void complete_usage(struct hid_parser *parser, unsigned int index)
+{
+	parser->local.usage[index] &= 0xFFFF;
+	parser->local.usage[index] |=
+		(parser->global.usage_page & 0xFFFF) << 16;
+}
+
+/*
  * Add a usage to the temporary parser table.
  */
 
@@ -207,6 +219,14 @@ static int hid_add_usage(struct hid_pars
 		return -1;
 	}
 	parser->local.usage[parser->local.usage_index] = usage;
+
+	/*
+	 * If Usage item only includes usage id, concatenate it with
+	 * currently defined usage page
+	 */
+	if (size <= 2)
+		complete_usage(parser, parser->local.usage_index);
+
 	parser->local.usage_size[parser->local.usage_index] = size;
 	parser->local.collection_index[parser->local.usage_index] =
 		parser->collection_stack_ptr ?
@@ -523,13 +543,32 @@ static int hid_parser_local(struct hid_p
  * usage value."
  */
 
-static void hid_concatenate_usage_page(struct hid_parser *parser)
+static void hid_concatenate_last_usage_page(struct hid_parser *parser)
 {
 	int i;
+	unsigned int usage_page;
+	unsigned int current_page;
+
+	if (!parser->local.usage_index)
+		return;
 
-	for (i = 0; i < parser->local.usage_index; i++)
-		if (parser->local.usage_size[i] <= 2)
-			parser->local.usage[i] += parser->global.usage_page << 16;
+	usage_page = parser->global.usage_page;
+
+	/*
+	 * Concatenate usage page again only if last declared Usage Page
+	 * has not been already used in previous usages concatenation
+	 */
+	for (i = parser->local.usage_index - 1; i >= 0; i--) {
+		if (parser->local.usage_size[i] > 2)
+			/* Ignore extended usages */
+			continue;
+
+		current_page = parser->local.usage[i] >> 16;
+		if (current_page == usage_page)
+			break;
+
+		complete_usage(parser, i);
+	}
 }
 
 /*
@@ -541,7 +580,7 @@ static int hid_parser_main(struct hid_pa
 	__u32 data;
 	int ret;
 
-	hid_concatenate_usage_page(parser);
+	hid_concatenate_last_usage_page(parser);
 
 	data = item_udata(item);
 
@@ -756,7 +795,7 @@ static int hid_scan_main(struct hid_pars
 	__u32 data;
 	int i;
 
-	hid_concatenate_usage_page(parser);
+	hid_concatenate_last_usage_page(parser);
 
 	data = item_udata(item);
 



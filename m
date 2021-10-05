Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E505D42287F
	for <lists+stable@lfdr.de>; Tue,  5 Oct 2021 15:51:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235469AbhJENwl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Oct 2021 09:52:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:59672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235401AbhJENwh (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 5 Oct 2021 09:52:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C662061507;
        Tue,  5 Oct 2021 13:50:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633441846;
        bh=YTbHAH8Ua0A1AFT7YLouuXcef6ol2k5GX5NuXWheHAA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WEj+hRu7aGcRxzvfMv5J2pNxZEWGwmoUPLJhT28zAbeSMMozx4DGb8qOTpz1OScAy
         cxpSXTmQss+HgFRNdsWeFnUP0V+PAYYG7EyMMq7ZLm78w+s1n7VN8xncmH437Lx919
         UZ+OqU/A+O7i7oMYQ2nrrGlzTESNb1lUllKLz9T8tS0Gbl4M4BRF28ZzMSbih02iVo
         kdo8Ix67/Ygpis5WNvfH0JwISS4IDTjuA60AfjwcGxqCzhbOzKljVVKHmMg4eIEnN3
         9MEt7oGaDcF95O8XNzkx+N+tGJqXwzA+2eCHcFvXQh5KW3mk/Hm1QJRknCShFynre0
         zrwpGvOcvXKbA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mizuho Mori <morimolymoly@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>,
        jikos@kernel.org, benjamin.tissoires@redhat.com,
        linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 11/40] HID: apple: Fix logical maximum and usage maximum of Magic Keyboard JIS
Date:   Tue,  5 Oct 2021 09:49:50 -0400
Message-Id: <20211005135020.214291-11-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211005135020.214291-1-sashal@kernel.org>
References: <20211005135020.214291-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mizuho Mori <morimolymoly@gmail.com>

[ Upstream commit 67fd71ba16a37c663d139f5ba5296f344d80d072 ]

Apple Magic Keyboard(JIS)'s Logical Maximum and Usage Maximum are wrong.

Below is a report descriptor.

0x05, 0x01,         /*  Usage Page (Desktop),                           */
0x09, 0x06,         /*  Usage (Keyboard),                               */
0xA1, 0x01,         /*  Collection (Application),                       */
0x85, 0x01,         /*      Report ID (1),                              */
0x05, 0x07,         /*      Usage Page (Keyboard),                      */
0x15, 0x00,         /*      Logical Minimum (0),                        */
0x25, 0x01,         /*      Logical Maximum (1),                        */
0x19, 0xE0,         /*      Usage Minimum (KB Leftcontrol),             */
0x29, 0xE7,         /*      Usage Maximum (KB Right GUI),               */
0x75, 0x01,         /*      Report Size (1),                            */
0x95, 0x08,         /*      Report Count (8),                           */
0x81, 0x02,         /*      Input (Variable),                           */
0x95, 0x05,         /*      Report Count (5),                           */
0x75, 0x01,         /*      Report Size (1),                            */
0x05, 0x08,         /*      Usage Page (LED),                           */
0x19, 0x01,         /*      Usage Minimum (01h),                        */
0x29, 0x05,         /*      Usage Maximum (05h),                        */
0x91, 0x02,         /*      Output (Variable),                          */
0x95, 0x01,         /*      Report Count (1),                           */
0x75, 0x03,         /*      Report Size (3),                            */
0x91, 0x03,         /*      Output (Constant, Variable),                */
0x95, 0x08,         /*      Report Count (8),                           */
0x75, 0x01,         /*      Report Size (1),                            */
0x15, 0x00,         /*      Logical Minimum (0),                        */
0x25, 0x01,         /*      Logical Maximum (1),                        */

here is a report descriptor which is parsed one in kernel.
see sys/kernel/debug/hid/<dev>/rdesc

05 01 09 06 a1 01 85 01 05 07
15 00 25 01 19 e0 29 e7 75 01
95 08 81 02 95 05 75 01 05 08
19 01 29 05 91 02 95 01 75 03
91 03 95 08 75 01 15 00 25 01
06 00 ff 09 03 81 03 95 06 75
08 15 00 25 [65] 05 07 19 00 29
[65] 81 00 95 01 75 01 15 00 25
01 05 0c 09 b8 81 02 95 01 75
01 06 01 ff 09 03 81 02 95 01
75 06 81 03 06 02 ff 09 55 85
55 15 00 26 ff 00 75 08 95 40
b1 a2 c0 06 00 ff 09 14 a1 01
85 90 05 84 75 01 95 03 15 00
25 01 09 61 05 85 09 44 09 46
81 02 95 05 81 01 75 08 95 01
15 00 26 ff 00 09 65 81 02 c0
00

Position 64(Logical Maximum) and 70(Usage Maximum) are 101.
Both should be 0xE7 to support JIS specific keys(ろ, Eisu, Kana, |) support.
position 117 is also 101 but not related(it is Usage 65h).

There are no difference of product id between JIS and ANSI.
They are same 0x0267.

Signed-off-by: Mizuho Mori <morimolymoly@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-apple.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/hid/hid-apple.c b/drivers/hid/hid-apple.c
index dc6bd4299c54..87edcd4ce07c 100644
--- a/drivers/hid/hid-apple.c
+++ b/drivers/hid/hid-apple.c
@@ -322,12 +322,19 @@ static int apple_event(struct hid_device *hdev, struct hid_field *field,
 
 /*
  * MacBook JIS keyboard has wrong logical maximum
+ * Magic Keyboard JIS has wrong logical maximum
  */
 static __u8 *apple_report_fixup(struct hid_device *hdev, __u8 *rdesc,
 		unsigned int *rsize)
 {
 	struct apple_sc *asc = hid_get_drvdata(hdev);
 
+	if(*rsize >=71 && rdesc[70] == 0x65 && rdesc[64] == 0x65) {
+		hid_info(hdev,
+			 "fixing up Magic Keyboard JIS report descriptor\n");
+		rdesc[64] = rdesc[70] = 0xe7;
+	}
+
 	if ((asc->quirks & APPLE_RDESC_JIS) && *rsize >= 60 &&
 			rdesc[53] == 0x65 && rdesc[59] == 0x65) {
 		hid_info(hdev,
-- 
2.33.0


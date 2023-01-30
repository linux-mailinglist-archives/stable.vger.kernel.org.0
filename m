Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABC5268118F
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:14:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237267AbjA3OOf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:14:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237308AbjA3OOe (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:14:34 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0E761ABE3
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:14:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6D9C2B8117B
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:14:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5FC5C433EF;
        Mon, 30 Jan 2023 14:14:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675088069;
        bh=N/ZEUfMEHi/7Ti8SnwWQXS17rCalQc//wZIl1EmhCqI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ll98011BK7CpSAbKfB6jCKioFFnTJT1iyy6mW8UT+3+hdqqe2G8olidh0j/1DmPHA
         9LFKNcfh09BXRYdBByVn3y5XwCXeynZA4b0H7ji2XP7yCoDMddJq0ptP/Vn/8rxM9x
         /zeWRM9utT7edi/tXcVBQ7s405FsTxFAvs0tGu1c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Pietro Borrello <borrello@diag.uniroma1.it>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 074/204] HID: betop: check shape of output reports
Date:   Mon, 30 Jan 2023 14:50:39 +0100
Message-Id: <20230130134319.589139531@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134316.327556078@linuxfoundation.org>
References: <20230130134316.327556078@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pietro Borrello <borrello@diag.uniroma1.it>

[ Upstream commit 3782c0d6edf658b71354a64d60aa7a296188fc90 ]

betopff_init() only checks the total sum of the report counts for each
report field to be at least 4, but hid_betopff_play() expects 4 report
fields.
A device advertising an output report with one field and 4 report counts
would pass the check but crash the kernel with a NULL pointer dereference
in hid_betopff_play().

Fixes: 52cd7785f3cd ("HID: betop: add drivers/hid/hid-betopff.c")
Signed-off-by: Pietro Borrello <borrello@diag.uniroma1.it>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-betopff.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/hid/hid-betopff.c b/drivers/hid/hid-betopff.c
index 467d789f9bc2..25ed7b9a917e 100644
--- a/drivers/hid/hid-betopff.c
+++ b/drivers/hid/hid-betopff.c
@@ -60,7 +60,6 @@ static int betopff_init(struct hid_device *hid)
 	struct list_head *report_list =
 			&hid->report_enum[HID_OUTPUT_REPORT].report_list;
 	struct input_dev *dev;
-	int field_count = 0;
 	int error;
 	int i, j;
 
@@ -86,19 +85,21 @@ static int betopff_init(struct hid_device *hid)
 	 * -----------------------------------------
 	 * Do init them with default value.
 	 */
+	if (report->maxfield < 4) {
+		hid_err(hid, "not enough fields in the report: %d\n",
+				report->maxfield);
+		return -ENODEV;
+	}
 	for (i = 0; i < report->maxfield; i++) {
+		if (report->field[i]->report_count < 1) {
+			hid_err(hid, "no values in the field\n");
+			return -ENODEV;
+		}
 		for (j = 0; j < report->field[i]->report_count; j++) {
 			report->field[i]->value[j] = 0x00;
-			field_count++;
 		}
 	}
 
-	if (field_count < 4) {
-		hid_err(hid, "not enough fields in the report: %d\n",
-				field_count);
-		return -ENODEV;
-	}
-
 	betopff = kzalloc(sizeof(*betopff), GFP_KERNEL);
 	if (!betopff)
 		return -ENOMEM;
-- 
2.39.0




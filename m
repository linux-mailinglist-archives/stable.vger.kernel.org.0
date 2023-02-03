Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5C0D6894E6
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 11:15:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231430AbjBCKOu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 05:14:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233203AbjBCKOt (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 05:14:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A77CE8F536
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 02:14:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 310EA61E4C
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 10:14:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26FBDC4339B;
        Fri,  3 Feb 2023 10:14:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675419287;
        bh=twGPChpdZ98XnD1BBqZMI3mT6NfYcmysUOtBNIE5HFQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iUPkDdFPFGakmBKkYdmZiwFPnLbLy8tlJwWlfneF1XGie6OfbKzOdUwkSxZq2gH6S
         TVEmvxQ955ueTIYXLTPK76Ph3lEAtaLY1bXPUd56sIEAXhkrSLbwOYcsYQ7MYAGszs
         7/JAksSaT7+CipkJRFmC35Nr1f6ciSALQYtrLm6U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Pietro Borrello <borrello@diag.uniroma1.it>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 19/62] HID: betop: check shape of output reports
Date:   Fri,  3 Feb 2023 11:12:15 +0100
Message-Id: <20230203101013.850514538@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230203101012.959398849@linuxfoundation.org>
References: <20230203101012.959398849@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
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
index 9b60efe6ec44..ba386e5aa055 100644
--- a/drivers/hid/hid-betopff.c
+++ b/drivers/hid/hid-betopff.c
@@ -63,7 +63,6 @@ static int betopff_init(struct hid_device *hid)
 	struct list_head *report_list =
 			&hid->report_enum[HID_OUTPUT_REPORT].report_list;
 	struct input_dev *dev;
-	int field_count = 0;
 	int error;
 	int i, j;
 
@@ -89,19 +88,21 @@ static int betopff_init(struct hid_device *hid)
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




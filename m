Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E2A06B4561
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:33:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232146AbjCJOdZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:33:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232192AbjCJOdE (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:33:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E04D11EE94
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:32:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 01EA7B822BB
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:32:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D8B0C4339B;
        Fri, 10 Mar 2023 14:32:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678458757;
        bh=SJmbUhMyu41Jh//7indMsy2/j/eEX2x4QM8shZ3SxJc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GcxECGsDkoqfBzmXCwWhTc2TusWeemxrUmjiyWq17AsmsTt+kEoWInAcbrsnx0t+B
         t+3gE4QkKNAWEPs5N1qNHUE8FOAt6lbGai9hWsfchn8xFh5gBdjLw5pArgYteq5cfu
         0iL69uoe1p0hqyz3bWXfbDVgfxTMrOhO8/QFD51w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Hans de Goede <hdegoede@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 135/357] HID: asus: Add report_size to struct asus_touchpad_info
Date:   Fri, 10 Mar 2023 14:37:04 +0100
Message-Id: <20230310133740.653837850@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133733.973883071@linuxfoundation.org>
References: <20230310133733.973883071@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit a61f9e428bf092349fdfebeee37ddefedd3f0fd1 ]

Add the report_size to struct asus_touchpad_info instead of calculating it.

This is a preparation patch for adding support for the multi-touch touchpad
found on the Medion Akoya E1239T's keyboard-dock, which uses the same
custom multi-touch protocol as the Asus keyboard-docks (same chipset
vendor, Integrated Technology Express / ITE).

The only difference in that the Akoya E1239T keyboard-dock's input-reports
have a 5 byte footer instead of a 1 byte footer, which requires the
report_size to be configurable per touchpad-model.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Stable-dep-of: 4ab3a086d10e ("HID: asus: use spinlock to safely schedule workers")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-asus.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/hid-asus.c b/drivers/hid/hid-asus.c
index 5ea4d678b7413..4d877b4581b40 100644
--- a/drivers/hid/hid-asus.c
+++ b/drivers/hid/hid-asus.c
@@ -103,6 +103,7 @@ struct asus_touchpad_info {
 	int res_y;
 	int contact_size;
 	int max_contacts;
+	int report_size;
 };
 
 struct asus_drvdata {
@@ -127,6 +128,7 @@ static const struct asus_touchpad_info asus_i2c_tp = {
 	.max_y = 1758,
 	.contact_size = 5,
 	.max_contacts = 5,
+	.report_size = 28 /* 2 byte header + 5 * 5 + 1 byte footer */,
 };
 
 static const struct asus_touchpad_info asus_t100ta_tp = {
@@ -136,6 +138,7 @@ static const struct asus_touchpad_info asus_t100ta_tp = {
 	.res_y = 27, /* units/mm */
 	.contact_size = 5,
 	.max_contacts = 5,
+	.report_size = 28 /* 2 byte header + 5 * 5 + 1 byte footer */,
 };
 
 static const struct asus_touchpad_info asus_t100ha_tp = {
@@ -145,6 +148,7 @@ static const struct asus_touchpad_info asus_t100ha_tp = {
 	.res_y = 29, /* units/mm */
 	.contact_size = 5,
 	.max_contacts = 5,
+	.report_size = 28 /* 2 byte header + 5 * 5 + 1 byte footer */,
 };
 
 static const struct asus_touchpad_info asus_t200ta_tp = {
@@ -154,6 +158,7 @@ static const struct asus_touchpad_info asus_t200ta_tp = {
 	.res_y = 28, /* units/mm */
 	.contact_size = 5,
 	.max_contacts = 5,
+	.report_size = 28 /* 2 byte header + 5 * 5 + 1 byte footer */,
 };
 
 static const struct asus_touchpad_info asus_t100chi_tp = {
@@ -163,6 +168,7 @@ static const struct asus_touchpad_info asus_t100chi_tp = {
 	.res_y = 29, /* units/mm */
 	.contact_size = 3,
 	.max_contacts = 4,
+	.report_size = 15 /* 2 byte header + 3 * 4 + 1 byte footer */,
 };
 
 static void asus_report_contact_down(struct asus_drvdata *drvdat,
@@ -230,7 +236,7 @@ static int asus_report_input(struct asus_drvdata *drvdat, u8 *data, int size)
 	int i, toolType = MT_TOOL_FINGER;
 	u8 *contactData = data + 2;
 
-	if (size != 3 + drvdat->tp->contact_size * drvdat->tp->max_contacts)
+	if (size != drvdat->tp->report_size)
 		return 0;
 
 	for (i = 0; i < drvdat->tp->max_contacts; i++) {
-- 
2.39.2




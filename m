Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A06D6B4560
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:33:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232618AbjCJOdY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:33:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232146AbjCJOdE (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:33:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A05211EE90
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:32:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0FAF1B822BF
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:32:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6111FC433EF;
        Fri, 10 Mar 2023 14:32:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678458754;
        bh=pKC5SUn+6r5WoKP321iL1CLINKrmo4rQjVPecAqjBgk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ia5Eg/Vbq3IWskHpOu8FFrR/iSolBMOKC2ieMHhjMpiIJZWQZRmaoqn6PElS5AjGq
         7uRaMPZL0akQpxAb1YTuYK6P/Mu5+fldJxCQpZSYYSZCcjnRlOeCC8Bfdi5T+phXhR
         IgDi2U9X+VlBCqjAr3lVN1WeEDEKl8UAZ6ofbYUE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Hans de Goede <hdegoede@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 134/357] HID: asus: Only set EV_REP if we are adding a mapping
Date:   Fri, 10 Mar 2023 14:37:03 +0100
Message-Id: <20230310133740.605929243@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133733.973883071@linuxfoundation.org>
References: <20230310133733.973883071@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 4e4c60f826772dfeaacdf718f64afa38f46b6875 ]

Make asus_input_mapping() only set EV_REP if we are adding a mapping.

The T100CHI bluetooth keyboard dock has a few input reports for which
we do not create any mappings (these input-reports are present in the
descriptors but never send).

The hid-asus code relies on the HID core not creating input devices for
input-reports without any mappings. But the present of the EV_REP but
counts as a mapping causing 6 /dev/input/event# nodes to be created for
the T100CHI bluetooth keyboard dock. This change brings the amount of
created /dev/input/event# nodes / input-devices down to 4.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Stable-dep-of: 4ab3a086d10e ("HID: asus: use spinlock to safely schedule workers")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-asus.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/hid/hid-asus.c b/drivers/hid/hid-asus.c
index e1e27d87c86be..5ea4d678b7413 100644
--- a/drivers/hid/hid-asus.c
+++ b/drivers/hid/hid-asus.c
@@ -714,7 +714,6 @@ static int asus_input_mapping(struct hid_device *hdev,
 
 	/* ASUS-specific keyboard hotkeys */
 	if ((usage->hid & HID_USAGE_PAGE) == 0xff310000) {
-		set_bit(EV_REP, hi->input->evbit);
 		switch (usage->hid & HID_USAGE) {
 		case 0x10: asus_map_key_clear(KEY_BRIGHTNESSDOWN);	break;
 		case 0x20: asus_map_key_clear(KEY_BRIGHTNESSUP);		break;
@@ -757,11 +756,11 @@ static int asus_input_mapping(struct hid_device *hdev,
 		if (drvdata->quirks & QUIRK_USE_KBD_BACKLIGHT)
 			drvdata->enable_backlight = true;
 
+		set_bit(EV_REP, hi->input->evbit);
 		return 1;
 	}
 
 	if ((usage->hid & HID_USAGE_PAGE) == HID_UP_MSVENDOR) {
-		set_bit(EV_REP, hi->input->evbit);
 		switch (usage->hid & HID_USAGE) {
 		case 0xff01: asus_map_key_clear(BTN_1);	break;
 		case 0xff02: asus_map_key_clear(BTN_2);	break;
@@ -784,6 +783,7 @@ static int asus_input_mapping(struct hid_device *hdev,
 			return 0;
 		}
 
+		set_bit(EV_REP, hi->input->evbit);
 		return 1;
 	}
 
-- 
2.39.2




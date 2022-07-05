Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2770A566D4B
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 14:22:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236810AbiGEMWG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 08:22:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237176AbiGEMSv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 08:18:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF9DF1A813;
        Tue,  5 Jul 2022 05:14:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5AB5B61988;
        Tue,  5 Jul 2022 12:14:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65284C341C7;
        Tue,  5 Jul 2022 12:14:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657023244;
        bh=HAHKvqO6ddqdbzuzqoWJr1Py4+nmgdEASbuixESpxY8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S5mZUiZRweR0oK76eelLLGY8usQ5OB3HHbV3tRPeZelHwqNzlLzMBjAsF6pV3oQF5
         NzAGZQrp6rFNqmFdyD0bdVLPscl5+v6eKsTWBKBEB68cULW0vexEcxlxf/acb8022/
         Vb7P9OQAxDs+CRU5Ohz26c9M7UPXdYYsbntH5mQY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Stefan Seyfried <seife+kernel@b1-systems.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 90/98] platform/x86: panasonic-laptop: de-obfuscate button codes
Date:   Tue,  5 Jul 2022 13:58:48 +0200
Message-Id: <20220705115620.124592430@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220705115617.568350164@linuxfoundation.org>
References: <20220705115617.568350164@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefan Seyfried <seife+kernel@b1-systems.com>

[ Upstream commit 65a3e6c8d3f7c346813a05f3d76fc46b640d76d6 ]

In the definition of panasonic_keymap[] the key codes are given in
decimal, later checks are done with hexadecimal values, which does
not help in understanding the code.
Additionally use two helper variables to shorten the code and make
the logic more obvious.

Fixes: ed83c9171829 ("platform/x86: panasonic-laptop: Resolve hotkey double trigger bug")
Signed-off-by: Stefan Seyfried <seife+kernel@b1-systems.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20220624112340.10130-3-hdegoede@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/panasonic-laptop.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/platform/x86/panasonic-laptop.c b/drivers/platform/x86/panasonic-laptop.c
index d4f444401496..84c16d9d9f8e 100644
--- a/drivers/platform/x86/panasonic-laptop.c
+++ b/drivers/platform/x86/panasonic-laptop.c
@@ -762,6 +762,8 @@ static void acpi_pcc_generate_keyinput(struct pcc_acpi *pcc)
 	struct input_dev *hotk_input_dev = pcc->input_dev;
 	int rc;
 	unsigned long long result;
+	unsigned int key;
+	unsigned int updown;
 
 	rc = acpi_evaluate_integer(pcc->handle, METHOD_HKEY_QUERY,
 				   NULL, &result);
@@ -770,18 +772,22 @@ static void acpi_pcc_generate_keyinput(struct pcc_acpi *pcc)
 		return;
 	}
 
+	key = result & 0xf;
+	updown = result & 0x80; /* 0x80 == key down; 0x00 = key up */
+
 	/* hack: some firmware sends no key down for sleep / hibernate */
-	if ((result & 0xf) == 0x7 || (result & 0xf) == 0xa) {
-		if (result & 0x80)
+	if (key == 7 || key == 10) {
+		if (updown)
 			sleep_keydown_seen = 1;
 		if (!sleep_keydown_seen)
 			sparse_keymap_report_event(hotk_input_dev,
-					result & 0xf, 0x80, false);
+					key, 0x80, false);
 	}
 
-	if ((result & 0xf) == 0x7 || (result & 0xf) == 0x9 || (result & 0xf) == 0xa) {
+	/* for the magic values, see panasonic_keymap[] above */
+	if (key == 7 || key == 9 || key == 10) {
 		if (!sparse_keymap_report_event(hotk_input_dev,
-						result & 0xf, result & 0x80, false))
+						key, updown, false))
 			pr_err("Unknown hotkey event: 0x%04llx\n", result);
 	}
 }
-- 
2.35.1




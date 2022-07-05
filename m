Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7534C566E37
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 14:35:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235065AbiGEMcD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 08:32:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237996AbiGEM0y (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 08:26:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 711A115727;
        Tue,  5 Jul 2022 05:19:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0D09E61A94;
        Tue,  5 Jul 2022 12:19:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13214C341C7;
        Tue,  5 Jul 2022 12:19:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657023573;
        bh=4dh2pOBs11NMVfHJBFXiMNBaUlkDzW5wZrYtXujrxOc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RilFHX+h7SAifGJku+mqvsnImpQvbhaI2BBLB4TAVZ23VL9cH3BjJkaIzhwy2xYMj
         3EG5ON8nG8yzpDrVqYAfe3PBtHZuEjJhqx/ihfn82kNl5jnsTGp/bcrKhuHpWHm80S
         2WFiISCespnfqswyxcY/+FWCF94B0O5JPZx4lVcY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Stefan Seyfried <seife+kernel@b1-systems.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 088/102] platform/x86: panasonic-laptop: de-obfuscate button codes
Date:   Tue,  5 Jul 2022 13:58:54 +0200
Message-Id: <20220705115620.919805596@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220705115618.410217782@linuxfoundation.org>
References: <20220705115618.410217782@linuxfoundation.org>
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
index 37850d07987d..ca6137f4000f 100644
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




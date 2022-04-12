Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 868594FD7BF
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:30:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237576AbiDLHsE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:48:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357125AbiDLHjs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:39:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58BD8E00A;
        Tue, 12 Apr 2022 00:12:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E933A61708;
        Tue, 12 Apr 2022 07:12:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08E9DC385A1;
        Tue, 12 Apr 2022 07:12:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649747548;
        bh=58NZpBGE/MdScoZVVTaWzcGrj8gsOfoLzLtXdcoy4iM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g+1jCzdlrrQwiNCVCZeWXslZC5cuCoqpkoQSzOmcojymYDeoCZdDnE+Vj/OifdD1W
         X5yYbeU6p3Vbf6dC9fB7sb6XxVn4PZf9RFPptE8fb9W0IMr2wmjQy+oieJABUOl2Me
         eVZSeJwq7kHT3NpVUtfCtIAnFEU4xEPxdbmVTvcQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Pearson <markpearson@lenovo.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 120/343] platform/x86: thinkpad_acpi: Add dual fan probe
Date:   Tue, 12 Apr 2022 08:28:58 +0200
Message-Id: <20220412062954.851180854@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062951.095765152@linuxfoundation.org>
References: <20220412062951.095765152@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Pearson <markpearson@lenovo.com>

[ Upstream commit bf779aaf56ea23864e39e9862b3b3a8436236e07 ]

Instead of having quirks for systems that have a second fan it would
be nice to detect this setup.
Unfortunately, confirmed by the Lenovo FW team, there is no way to
retrieve this information from the EC or BIOS. Recommendation was to
attempt to read the fan and if successful then assume a 2nd fan is
present.

The fans are also supposed to spin up on boot for some time, so in
theory we could check for a speed > 0. In testing this seems to hold
true but as I couldn't test on all platforms I've avoided implementing
this. It also breaks for the corner case where you load the module
once the fans are idle.

Tested on P1G4, P1G3, X1C9 and T14 (no fans) and it works correctly.
For the platforms with dual fans where it was confirmed to work I have
removed the quirks. Potentially this could be done for all platforms
but I've left untested platforms in for now. On these platforms the
fans will be enabled and then detected - so no impact.

Signed-off-by: Mark Pearson <markpearson@lenovo.com>
Link: https://lore.kernel.org/r/20220222185137.4325-1-markpearson@lenovo.com
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/thinkpad_acpi.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/platform/x86/thinkpad_acpi.c b/drivers/platform/x86/thinkpad_acpi.c
index 3424b080db77..3fb8cda31eb9 100644
--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -8699,10 +8699,7 @@ static const struct tpacpi_quirk fan_quirk_table[] __initconst = {
 	TPACPI_Q_LNV3('N', '2', 'N', TPACPI_FAN_2CTL),	/* P53 / P73 */
 	TPACPI_Q_LNV3('N', '2', 'E', TPACPI_FAN_2CTL),	/* P1 / X1 Extreme (1st gen) */
 	TPACPI_Q_LNV3('N', '2', 'O', TPACPI_FAN_2CTL),	/* P1 / X1 Extreme (2nd gen) */
-	TPACPI_Q_LNV3('N', '2', 'V', TPACPI_FAN_2CTL),	/* P1 / X1 Extreme (3nd gen) */
-	TPACPI_Q_LNV3('N', '4', '0', TPACPI_FAN_2CTL),	/* P1 / X1 Extreme (4nd gen) */
 	TPACPI_Q_LNV3('N', '3', '0', TPACPI_FAN_2CTL),	/* P15 (1st gen) / P15v (1st gen) */
-	TPACPI_Q_LNV3('N', '3', '2', TPACPI_FAN_2CTL),	/* X1 Carbon (9th gen) */
 	TPACPI_Q_LNV3('N', '3', '7', TPACPI_FAN_2CTL),  /* T15g (2nd gen) */
 	TPACPI_Q_LNV3('N', '1', 'O', TPACPI_FAN_NOFAN),	/* X1 Tablet (2nd gen) */
 };
@@ -8746,6 +8743,9 @@ static int __init fan_init(struct ibm_init_struct *iibm)
 		 * ThinkPad ECs supports the fan control register */
 		if (likely(acpi_ec_read(fan_status_offset,
 					&fan_control_initial_status))) {
+			int res;
+			unsigned int speed;
+
 			fan_status_access_mode = TPACPI_FAN_RD_TPEC;
 			if (quirks & TPACPI_FAN_Q1)
 				fan_quirk1_setup();
@@ -8758,6 +8758,15 @@ static int __init fan_init(struct ibm_init_struct *iibm)
 				tp_features.second_fan_ctl = 1;
 				pr_info("secondary fan control enabled\n");
 			}
+			/* Try and probe the 2nd fan */
+			res = fan2_get_speed(&speed);
+			if (res >= 0) {
+				/* It responded - so let's assume it's there */
+				tp_features.second_fan = 1;
+				tp_features.second_fan_ctl = 1;
+				pr_info("secondary fan control detected & enabled\n");
+			}
+
 		} else {
 			pr_err("ThinkPad ACPI EC access misbehaving, fan status and control unavailable\n");
 			return -ENODEV;
-- 
2.35.1




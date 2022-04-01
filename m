Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 281A44EF0FE
	for <lists+stable@lfdr.de>; Fri,  1 Apr 2022 16:39:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347732AbiDAOfq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Apr 2022 10:35:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348239AbiDAOdv (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Apr 2022 10:33:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D40A61DEC09;
        Fri,  1 Apr 2022 07:31:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 71DB861C0C;
        Fri,  1 Apr 2022 14:31:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBFAFC340F2;
        Fri,  1 Apr 2022 14:31:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648823484;
        bh=nb1BfveGHdAFBMBASJ1bcZjrexzu4aBwmM6gxjQV74k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=maYx76lwmgl+mjdSh1WCoyeFAuPr7hb1dTq6bFFITgZsF57XcN5XTt44IQLgUtYjp
         ODJWxeqRF36H72FkNjJ8uRdEMH7cxvv9wurOM70Q6IkpMnBxtb+INTEKVrB6fLPbl0
         R+5JKPwUVdxvpSwFyMGDBZNS8yIvihyi3avv+WvhPpVEDIHGeB5LiuKkXcP7mkE8Z/
         X88U26co5a75vGVD6od/KhDpNuycBqQDBkvFneK/TBP7hntH0f3dPO4OweVwBNvMn8
         3uqNYc/MCaT4Bv9Na7N0ZhT9CqTB3ZYxisFAqn3sn7DENo1f1tPBzmRUFPOKRZOd7E
         61UiykL6iBOfQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mark Pearson <markpearson@lenovo.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>, hmh@hmh.eng.br,
        markgross@kernel.org, ibm-acpi-devel@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 5.17 113/149] platform/x86: thinkpad_acpi: Add dual fan probe
Date:   Fri,  1 Apr 2022 10:25:00 -0400
Message-Id: <20220401142536.1948161-113-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220401142536.1948161-1-sashal@kernel.org>
References: <20220401142536.1948161-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
2.34.1


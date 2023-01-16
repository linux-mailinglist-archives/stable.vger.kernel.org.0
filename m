Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9652666C48C
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 16:56:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231435AbjAPP4G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 10:56:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231489AbjAPPzw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 10:55:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 486271D933
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 07:55:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D79CF61031
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 15:55:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE2C4C433EF;
        Mon, 16 Jan 2023 15:55:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673884550;
        bh=rZwZR5xWEjU3uCO4qal6hEjV02xwZLiT6T+SKI3RKzE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zZkE98ZHkUX1YLdixlEmzff5We0ITAFzbE1rM9XZTKhB2zie06gr0l5q+IZrtDRPL
         nFWHVy3deZ6JGK3usH30cCp4ZB/V2ZkOlQPw9XlBgDXtTWuN3Jn+tz4qi6WQ8u7H3v
         ojhW0OvSAWZ0ut72kFHL2B2zZVXfWHx0F2B3Lhz0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Mario Limonciello <mario.limonciello@amd.com>,
        Mark Pearson <mpearson-lenovo@squebb.ca>,
        Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 6.1 049/183] platform/x86: thinkpad_acpi: Fix profile mode display in AMT mode
Date:   Mon, 16 Jan 2023 16:49:32 +0100
Message-Id: <20230116154805.433087781@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154803.321528435@linuxfoundation.org>
References: <20230116154803.321528435@linuxfoundation.org>
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

From: Mark Pearson <mpearson-lenovo@squebb.ca>

commit fde5f74ccfc771941b018b5415fa9664426e10ad upstream.

Recently AMT mode was enabled (somewhat unexpectedly) on the Lenovo
Z13 platform. The FW is advertising it is available and the driver tries
to use it - unfortunately it reports the profile mode incorrectly.

Note, there is also some extra work needed to enable the dynamic aspect
of AMT support that I will be following up with; but more testing is
needed first. This patch just fixes things so the profiles are reported
correctly.

Link: https://gitlab.freedesktop.org/hadess/power-profiles-daemon/-/issues/115
Fixes: 46dcbc61b739 ("platform/x86: thinkpad-acpi: Add support for automatic mode transitions")

Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Mark Pearson <mpearson-lenovo@squebb.ca>
Link: https://lore.kernel.org/r/20230112221228.490946-1-mpearson-lenovo@squebb.ca
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/thinkpad_acpi.c |   23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -10315,9 +10315,11 @@ static DEFINE_MUTEX(dytc_mutex);
 static int dytc_capabilities;
 static bool dytc_mmc_get_available;
 
-static int convert_dytc_to_profile(int dytcmode, enum platform_profile_option *profile)
+static int convert_dytc_to_profile(int funcmode, int dytcmode,
+		enum platform_profile_option *profile)
 {
-	if (dytc_capabilities & BIT(DYTC_FC_MMC)) {
+	switch (funcmode) {
+	case DYTC_FUNCTION_MMC:
 		switch (dytcmode) {
 		case DYTC_MODE_MMC_LOWPOWER:
 			*profile = PLATFORM_PROFILE_LOW_POWER;
@@ -10333,8 +10335,7 @@ static int convert_dytc_to_profile(int d
 			return -EINVAL;
 		}
 		return 0;
-	}
-	if (dytc_capabilities & BIT(DYTC_FC_PSC)) {
+	case DYTC_FUNCTION_PSC:
 		switch (dytcmode) {
 		case DYTC_MODE_PSC_LOWPOWER:
 			*profile = PLATFORM_PROFILE_LOW_POWER;
@@ -10348,6 +10349,14 @@ static int convert_dytc_to_profile(int d
 		default: /* Unknown mode */
 			return -EINVAL;
 		}
+		return 0;
+	case DYTC_FUNCTION_AMT:
+		/* For now return balanced. It's the closest we have to 'auto' */
+		*profile =  PLATFORM_PROFILE_BALANCED;
+		return 0;
+	default:
+		/* Unknown function */
+		return -EOPNOTSUPP;
 	}
 	return 0;
 }
@@ -10496,6 +10505,7 @@ static int dytc_profile_set(struct platf
 		err = dytc_command(DYTC_SET_COMMAND(DYTC_FUNCTION_PSC, perfmode, 1), &output);
 		if (err)
 			goto unlock;
+
 		/* system supports AMT, activate it when on balanced */
 		if (dytc_capabilities & BIT(DYTC_FC_AMT))
 			dytc_control_amt(profile == PLATFORM_PROFILE_BALANCED);
@@ -10511,7 +10521,7 @@ static void dytc_profile_refresh(void)
 {
 	enum platform_profile_option profile;
 	int output, err = 0;
-	int perfmode;
+	int perfmode, funcmode;
 
 	mutex_lock(&dytc_mutex);
 	if (dytc_capabilities & BIT(DYTC_FC_MMC)) {
@@ -10526,8 +10536,9 @@ static void dytc_profile_refresh(void)
 	if (err)
 		return;
 
+	funcmode = (output >> DYTC_GET_FUNCTION_BIT) & 0xF;
 	perfmode = (output >> DYTC_GET_MODE_BIT) & 0xF;
-	convert_dytc_to_profile(perfmode, &profile);
+	convert_dytc_to_profile(funcmode, perfmode, &profile);
 	if (profile != dytc_current_profile) {
 		dytc_current_profile = profile;
 		platform_profile_notify();



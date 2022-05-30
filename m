Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 604CA5381D6
	for <lists+stable@lfdr.de>; Mon, 30 May 2022 16:33:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241170AbiE3OVN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 May 2022 10:21:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241384AbiE3ORc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 10:17:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 771088FF9C;
        Mon, 30 May 2022 06:46:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 20E20B80D6B;
        Mon, 30 May 2022 13:46:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F10D8C3411A;
        Mon, 30 May 2022 13:45:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653918359;
        bh=cXuTShtzdE1Ec3NbiD1d9uwgWXstvFOpe15uNRADvmQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gaT/Yx3v7mkbGqX6rLl/JhY5hpPjZ3Oe4NiudYGytWRLvtmP9RZ3flHYJo3KBU5AE
         0NnGublSahwr5fJR6AR7u8orTp49uruY+qY4mL9M8zOa84qRsz6teZ8eSs1seBzbb5
         M/yf2rT/GgT2xopifJlbCZOQDuQfanYkZy/ZC8HLeeLx2kVADZE1Mm71dBk7PxQh3q
         OFYq1gk7EdacDzDVQPVJT44J4ayWhe0uLr1v1c58Vak2cnllZeJeiTVOYYaGYGIWyM
         Sm8/wecWTjuNYcY/Soq3uB4M0lkpBbL7ZfMInV63nD0+/Er5WHQ+e9ybbMBoJ/A0Wg
         U7aAD1+pp/P7g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mario Limonciello <mario.limonciello@amd.com>,
        Jian-Hong Pan <jhp@endlessos.org>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, rafael@kernel.org,
        linux-acpi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 51/76] ACPI: PM: Block ASUS B1400CEAE from suspend to idle by default
Date:   Mon, 30 May 2022 09:43:41 -0400
Message-Id: <20220530134406.1934928-51-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220530134406.1934928-1-sashal@kernel.org>
References: <20220530134406.1934928-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit d52848620de00cde4a3a5df908e231b8c8868250 ]

ASUS B1400CEAE fails to resume from suspend to idle by default.  This was
bisected back to commit df4f9bc4fb9c ("nvme-pci: add support for ACPI
StorageD3Enable property") but this is a red herring to the problem.

Before this commit the system wasn't getting into deepest sleep state.
Presumably this commit is allowing entry into deepest sleep state as
advertised by firmware, but there are some other problems related to
the wakeup.

As it is confirmed the system works properly with S3, set the default for
this system to S3.

Reported-by: Jian-Hong Pan <jhp@endlessos.org>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=215742
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Tested-by: Jian-Hong Pan <jhp@endlessos.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/sleep.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/acpi/sleep.c b/drivers/acpi/sleep.c
index 503935b1deeb..cfda5720de02 100644
--- a/drivers/acpi/sleep.c
+++ b/drivers/acpi/sleep.c
@@ -377,6 +377,18 @@ static const struct dmi_system_id acpisleep_dmi_table[] __initconst = {
 		DMI_MATCH(DMI_PRODUCT_NAME, "20GGA00L00"),
 		},
 	},
+	/*
+	 * ASUS B1400CEAE hangs on resume from suspend (see
+	 * https://bugzilla.kernel.org/show_bug.cgi?id=215742).
+	 */
+	{
+	.callback = init_default_s3,
+	.ident = "ASUS B1400CEAE",
+	.matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
+		DMI_MATCH(DMI_PRODUCT_NAME, "ASUS EXPERTBOOK B1400CEAE"),
+		},
+	},
 	{},
 };
 
-- 
2.35.1


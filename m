Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD03F537F6E
	for <lists+stable@lfdr.de>; Mon, 30 May 2022 16:20:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239924AbiE3OKR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 May 2022 10:10:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240214AbiE3OGj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 10:06:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78F4240A12;
        Mon, 30 May 2022 06:42:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4F6FBB80D86;
        Mon, 30 May 2022 13:42:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F598C3411A;
        Mon, 30 May 2022 13:42:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653918123;
        bh=7rf3wff4WcrLDRT3DeHISJlEfMduB3IFzlJexm4+A7w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uKcD2UXVfCp4h/aGKqSwPa4jGbkprrAPOuWJ/eLrqiVukbsXfggATOY2kLrSIppHi
         VN9Y+DB/A+kqrKcKzd9vLQlgkh0JG9+GmiYuISgnzZMvV4r5EXlZcztAhK4Un9ED2g
         5UOd4ViosFctE2Olcmebs6QA+OgQfgcRZf3rzia2UPDc9+A8LGlSbJGuw+e4k0jAZb
         apP0qFRE+0iybMLaBt2aVL0vIaXestkQj2wsP/ksSsq5+7nTQ7f0Ooi9UrkB2URENP
         7H6CzW3/guq2Kl5fIA7q6C6PJCu9WZFLpl8StswGoM8GO1H46tYDWpeveBNT+9KZry
         Ze2oljiiIPk/g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mario Limonciello <mario.limonciello@amd.com>,
        Jian-Hong Pan <jhp@endlessos.org>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, rafael@kernel.org,
        linux-acpi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 070/109] ACPI: PM: Block ASUS B1400CEAE from suspend to idle by default
Date:   Mon, 30 May 2022 09:37:46 -0400
Message-Id: <20220530133825.1933431-70-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220530133825.1933431-1-sashal@kernel.org>
References: <20220530133825.1933431-1-sashal@kernel.org>
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
index 7ae09e4b4592..07515139141e 100644
--- a/drivers/acpi/sleep.c
+++ b/drivers/acpi/sleep.c
@@ -374,6 +374,18 @@ static const struct dmi_system_id acpisleep_dmi_table[] __initconst = {
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


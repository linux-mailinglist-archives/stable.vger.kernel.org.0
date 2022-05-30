Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F6F25380E0
	for <lists+stable@lfdr.de>; Mon, 30 May 2022 16:28:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238517AbiE3NxG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 May 2022 09:53:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239277AbiE3NvZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 09:51:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABF3D82150;
        Mon, 30 May 2022 06:35:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4863B60F2A;
        Mon, 30 May 2022 13:35:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE07FC3411C;
        Mon, 30 May 2022 13:35:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653917751;
        bh=7sCeoZZwV5ejs/MqSjcIaa9b6s3lSn4F1fmw+Hfrqx0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rAY/m+zyap1qztQ6EbE6tbz3tFNkcjLP3Xx8C3TjuGZKD5jycfm+Bc2DHMxRJLUah
         pa7PZTEd/2VtptfP5AAjAyONb9PzbCSDmEnSFICXDlclORjKmoCMZdi1uniRtah2zF
         PEGsuHATDs+ph1pjmmrQ0ZZ6hjnmrMioVcGQfXchADfaooJoxEJ7lBr9Clv51wTqBK
         Taxhltu82I0OVmelcMmIAeYzfFNsG3l/dx215MtDBPHcb1Pf+R0PI0j9eqC/YV1sYS
         C5hjShT1zo4QaQjRrcRtx6OWRqTYUW92/abPEVRoIDpU1Pk1TJUMyOX33INgiyWei7
         RRyKcybttKQZQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mario Limonciello <mario.limonciello@amd.com>,
        Jian-Hong Pan <jhp@endlessos.org>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, rafael@kernel.org,
        linux-acpi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.17 085/135] ACPI: PM: Block ASUS B1400CEAE from suspend to idle by default
Date:   Mon, 30 May 2022 09:30:43 -0400
Message-Id: <20220530133133.1931716-85-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220530133133.1931716-1-sashal@kernel.org>
References: <20220530133133.1931716-1-sashal@kernel.org>
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
index d4fbea91ab6b..8a5cb115fea8 100644
--- a/drivers/acpi/sleep.c
+++ b/drivers/acpi/sleep.c
@@ -373,6 +373,18 @@ static const struct dmi_system_id acpisleep_dmi_table[] __initconst = {
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


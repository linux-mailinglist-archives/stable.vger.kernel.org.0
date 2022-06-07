Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 514A0541861
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:12:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349504AbiFGVMG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:12:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380160AbiFGVLf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:11:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 948D9149A8C;
        Tue,  7 Jun 2022 11:53:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AEDDF616C2;
        Tue,  7 Jun 2022 18:53:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8A6AC36AFE;
        Tue,  7 Jun 2022 18:53:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654628000;
        bh=++FBKUrUNdenNgdg9O0dxiFbOQonQ6ctCVrjU7cnTw8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JSnTpldIPLH5+RXLMmk3lNyHpzIkK/rhyGJG77lD+9Uh7bVyAA8xubky911k50ECI
         0Z0ADLN7gQD0xrhHS1VTD89/LrSHlxjcXGtWd86LswSvdcwRXzEY59GiH0it8W19HI
         rrrhPFRDOfP8TEVwIJhI9wzTko7P/0cJXm638Hgo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jian-Hong Pan <jhp@endlessos.org>,
        Mario Limonciello <mario.limonciello@amd.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 153/879] ACPI: PM: Block ASUS B1400CEAE from suspend to idle by default
Date:   Tue,  7 Jun 2022 18:54:31 +0200
Message-Id: <20220607165007.147422801@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index c992e57b2c79..3147702710af 100644
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




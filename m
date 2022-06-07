Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 942C6540569
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 19:25:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345942AbiFGRZz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 13:25:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346780AbiFGRZ3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 13:25:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 868C9110478;
        Tue,  7 Jun 2022 10:23:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EBAEF60DDE;
        Tue,  7 Jun 2022 17:23:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07344C36AFE;
        Tue,  7 Jun 2022 17:23:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654622589;
        bh=cXuTShtzdE1Ec3NbiD1d9uwgWXstvFOpe15uNRADvmQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QSzh72tvI3WXBUJzifMIfIGT6QSKHcllvQDYFkE8KR6lJRaQ+qcal5oR3pMS6YwoS
         NFt5JxC5qW+YxZpn/yJWzK874Gl0Gtkwvfrmsymjy5poSa9D4BStjBxYceEfNcwJeR
         fyvDJYfQZAjkXNFeNRzTSMZJbvdFScKWamn07+0w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jian-Hong Pan <jhp@endlessos.org>,
        Mario Limonciello <mario.limonciello@amd.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 073/452] ACPI: PM: Block ASUS B1400CEAE from suspend to idle by default
Date:   Tue,  7 Jun 2022 18:58:50 +0200
Message-Id: <20220607164910.727471249@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164908.521895282@linuxfoundation.org>
References: <20220607164908.521895282@linuxfoundation.org>
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




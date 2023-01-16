Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACCDC66C0FF
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 15:06:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232006AbjAPOGq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 09:06:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231808AbjAPOFV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 09:05:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCA3223644;
        Mon, 16 Jan 2023 06:03:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4DF3B60FB3;
        Mon, 16 Jan 2023 14:03:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC56AC433F0;
        Mon, 16 Jan 2023 14:03:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673877801;
        bh=H0NsN2QesyNrQQ/ijKawHih+zCXoulU+adAbhoRDHwE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WNxQrkA1kAhr4DbQaHno6dYFnSjGB9owBT4Mjfv6ePL19qGylagpLjs8I0vcZyTJl
         3cFI2NdIP3QuhDwnEa76070Ctvjm8DAMxIpxyatyCdoUqK9jjkUG2fKZ1whwMxigyn
         HxmutdHxAGGtuc+99i7Potp//+E6fephSaPx1hd95EYIdedKqYAwTpI4WBsfj9QP7J
         Ru54uYvnYALyUj8Grmjdb8Vo2Sx5Yx9xRxFELo9bHqj5Y0n1/sEJqp0c5aXpvWCVaS
         aKN9V99eTfRxBAYQ131jWCjohIbuwxzh0pGkLib3VjJ0un8uWG9MW9KfKNJJ5WGEqz
         vPvjikv/iOwJQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tamim Khan <tamim@fusetak.com>, zelenat <zelenat@gmail.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, rafael@kernel.org,
        linux-acpi@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 34/53] ACPI: resource: Skip IRQ override on Asus Expertbook B2402CBA
Date:   Mon, 16 Jan 2023 09:01:34 -0500
Message-Id: <20230116140154.114951-34-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20230116140154.114951-1-sashal@kernel.org>
References: <20230116140154.114951-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tamim Khan <tamim@fusetak.com>

[ Upstream commit 77c7248882385397cd7dffe9e1437f59f32ce2de ]

Like the Asus Expertbook B2502CBA and various Asus Vivobook laptops,
the Asus Expertbook B2402CBA has an ACPI DSDT table that describes IRQ 1
as ActiveLow while the kernel overrides it to Edge_High. This prevents the
keyboard from working. To fix this issue, add this laptop to the
skip_override_table so that the kernel does not override IRQ 1.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=216864
Tested-by: zelenat <zelenat@gmail.com>
Signed-off-by: Tamim Khan <tamim@fusetak.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/resource.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/acpi/resource.c b/drivers/acpi/resource.c
index 16dcd31d124f..192d1784e409 100644
--- a/drivers/acpi/resource.c
+++ b/drivers/acpi/resource.c
@@ -432,6 +432,13 @@ static const struct dmi_system_id asus_laptop[] = {
 			DMI_MATCH(DMI_BOARD_NAME, "S5602ZA"),
 		},
 	},
+	{
+		.ident = "Asus ExpertBook B2402CBA",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
+			DMI_MATCH(DMI_BOARD_NAME, "B2402CBA"),
+		},
+	},
 	{
 		.ident = "Asus ExpertBook B2502",
 		.matches = {
-- 
2.35.1


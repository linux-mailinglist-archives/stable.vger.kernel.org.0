Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E75FB6D957E
	for <lists+stable@lfdr.de>; Thu,  6 Apr 2023 13:34:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236700AbjDFLeS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Apr 2023 07:34:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237960AbjDFLd2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Apr 2023 07:33:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81DEA977D;
        Thu,  6 Apr 2023 04:32:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5A479644A8;
        Thu,  6 Apr 2023 11:32:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E73F3C4339B;
        Thu,  6 Apr 2023 11:32:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680780767;
        bh=61CpfB4NPx3Sn2ArhV0R5wLaJ+ElHuIv6dOpo25OXQE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=exKFRcxvOpJiBcdvwNQxeCC+L+RpHpiTPAUYJv4bONohi+dbiiaTocnkap4gEhcqv
         K9EsadzF2LLoVkqNVqwD7HhKCiIerBO4j5cTDlqYKXvRVSoa6AHoaMs3G0w0zu6kgj
         EnfDCBb6w+d/Hmm1lIIqJQVII2mBiaw4qMHGNvZUwrrAWK00aEbuXvVWFVgU0cHr9X
         Y6LoQqkkkC0nulDhHpAbr51IZqZxC7cRBYR75rCFWtC0ZcaIrS7VN2ltUJREq9cpQ4
         V+jBlL1IqX8BHojefCdNAnYRdGGqDBgvwrMfgDFoEOmREwR3nbba54ou4wB7idY273
         CwY2+9BOFQvYQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     weiliang1503 <weiliang1503@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>, corentin.chary@gmail.com,
        markgross@kernel.org, acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 16/17] platform/x86: asus-nb-wmi: Add quirk_asus_tablet_mode to other ROG Flow X13 models
Date:   Thu,  6 Apr 2023 07:32:10 -0400
Message-Id: <20230406113211.648424-16-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230406113211.648424-1-sashal@kernel.org>
References: <20230406113211.648424-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: weiliang1503 <weiliang1503@gmail.com>

[ Upstream commit e352d685fde427a8fc9beb2ba30888f5d6f2e5e6 ]

Make quirk_asus_tablet_mode apply on other ROG Flow X13 devices,
which only affects the GV301Q model before.

Signed-off-by: weiliang1503 <weiliang1503@gmail.com>
Link: https://lore.kernel.org/r/20230330114943.15057-1-weiliang1503@gmail.com
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/asus-nb-wmi.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/x86/asus-nb-wmi.c b/drivers/platform/x86/asus-nb-wmi.c
index cb15acdf14a30..e2c9a68d12df9 100644
--- a/drivers/platform/x86/asus-nb-wmi.c
+++ b/drivers/platform/x86/asus-nb-wmi.c
@@ -464,7 +464,8 @@ static const struct dmi_system_id asus_quirks[] = {
 		.ident = "ASUS ROG FLOW X13",
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "GV301Q"),
+			/* Match GV301** */
+			DMI_MATCH(DMI_PRODUCT_NAME, "GV301"),
 		},
 		.driver_data = &quirk_asus_tablet_mode,
 	},
-- 
2.39.2


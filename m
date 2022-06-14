Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4BC554A57B
	for <lists+stable@lfdr.de>; Tue, 14 Jun 2022 04:22:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353614AbiFNCQb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 22:16:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353946AbiFNCOK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 22:14:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C2DB3B289;
        Mon, 13 Jun 2022 19:08:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 20E61B80AC1;
        Tue, 14 Jun 2022 02:08:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4C21C36B00;
        Tue, 14 Jun 2022 02:08:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655172494;
        bh=8el3SqLdZcIbqsykJyEZKxNlrqeGOrQgzCDXMo6yEMo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p0j16W7EGkbAEGjvsJHnnmfQp5oB4O4/Nua0rutk5sm0C1yM31wE0ujRloW55sw5u
         htfz+BnB8fJ4EAnF3u5JAXwm7KPIJPHVAo42mn5m9bs5VPIAcWRnyuy4wMM5fbByxB
         SaKkq6fia6UcNOWOPAh5ocfqN3pG7Ae/vB2GqTxsdnMxGBlbYiRX3YSAoUcAEkSh+F
         UOD117EP03A8tVZ9QqDwvg1M6rIbbrxe9ppjYH8UjvWDhqmZMYvuNowbLnh0b+C3o3
         zJYMOPszoCytu1ndMEG9H8q5E4RT6xFV2TcfM/ZDBukFrePITQGQhHs4GV0U6smGCq
         XY1QR3DBf+/hA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Duke Lee <krnhotwings@gmail.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>, dvhart@infradead.org,
        platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 41/41] platform/x86/intel: hid: Add Surface Go to VGBS allow list
Date:   Mon, 13 Jun 2022 22:07:06 -0400
Message-Id: <20220614020707.1099487-41-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220614020707.1099487-1-sashal@kernel.org>
References: <20220614020707.1099487-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Duke Lee <krnhotwings@gmail.com>

[ Upstream commit d4fe9cc4ff8656704b58cfd9363d7c3c9d65e519 ]

The Surface Go reports Chassis Type 9 (Laptop,) so the device needs to be
added to dmi_vgbs_allow_list to enable tablet mode when an attached Type
Cover is folded back.

BugLink: https://github.com/linux-surface/linux-surface/issues/837
Signed-off-by: Duke Lee <krnhotwings@gmail.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Link: https://lore.kernel.org/r/20220607213654.5567-1-krnhotwings@gmail.com
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel/hid.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/platform/x86/intel/hid.c b/drivers/platform/x86/intel/hid.c
index e9e8554147e0..d7d6782c40c2 100644
--- a/drivers/platform/x86/intel/hid.c
+++ b/drivers/platform/x86/intel/hid.c
@@ -129,6 +129,12 @@ static const struct dmi_system_id dmi_vgbs_allow_list[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "HP Spectre x360 Convertible 15-df0xxx"),
 		},
 	},
+	{
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Microsoft Corporation"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Surface Go"),
+		},
+	},
 	{ }
 };
 
-- 
2.35.1


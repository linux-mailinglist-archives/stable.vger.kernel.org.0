Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9199C52BAE6
	for <lists+stable@lfdr.de>; Wed, 18 May 2022 14:39:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236496AbiERM1d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 May 2022 08:27:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236486AbiERM1R (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 May 2022 08:27:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA1F2ABF55;
        Wed, 18 May 2022 05:27:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4176BB81F40;
        Wed, 18 May 2022 12:27:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A8E9C34115;
        Wed, 18 May 2022 12:27:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652876830;
        bh=CVclP0CVYd+Kst09m8hEBA7IByOo7/Fm5SO7C+br1ow=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fIexz4c6oJyzsH+PgPSNWPk0T2uPdJ5cTP9OXeWJa3SHbFZimE05TNzF1C0MvULr2
         w+VKZlkpUB/NliEtFwYR/4X4C1bzxscmSBGZcA4c+aQkTQ/uIMBFfcSSBXbbQ7+tPb
         m4fFgp5/XzKWLOqKk8vII4dblbgkRAiMc6nlmpkhxKVIpZ7B49IbRMXTGesEu9Jm+y
         /BOxLKTTbUK2iNBpIIgNSTp8tPMBRxbb3eeKkWjKwWjM8tVeciySvhSztFLF1WYDA6
         QhmHJk8cGIf367LWALSMosnb2FnKIg7V0pB4T2rjNCrLY+6aTs87oCtCAa43Jc+gPa
         Sk2ReFgNxwrUw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Maximilian Luz <luzmaximilian@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>, markgross@kernel.org,
        platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 5.17 12/23] platform/surface: gpe: Add support for Surface Pro 8
Date:   Wed, 18 May 2022 08:26:25 -0400
Message-Id: <20220518122641.342120-12-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220518122641.342120-1-sashal@kernel.org>
References: <20220518122641.342120-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maximilian Luz <luzmaximilian@gmail.com>

[ Upstream commit ed13d4ac57474d959c40fd05d8860e2b1607becb ]

The new Surface Pro 8 uses GPEs for lid events as well. Add an entry for
that so that the lid can be used to wake the device. Note that this is a
device with a keyboard type-cover, where this acts as the "lid".

Signed-off-by: Maximilian Luz <luzmaximilian@gmail.com>
Link: https://lore.kernel.org/r/20220429180049.1282447-1-luzmaximilian@gmail.com
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/surface/surface_gpe.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/platform/surface/surface_gpe.c b/drivers/platform/surface/surface_gpe.c
index c1775db29efb..ec66fde28e75 100644
--- a/drivers/platform/surface/surface_gpe.c
+++ b/drivers/platform/surface/surface_gpe.c
@@ -99,6 +99,14 @@ static const struct dmi_system_id dmi_lid_device_table[] = {
 		},
 		.driver_data = (void *)lid_device_props_l4D,
 	},
+	{
+		.ident = "Surface Pro 8",
+		.matches = {
+			DMI_EXACT_MATCH(DMI_SYS_VENDOR, "Microsoft Corporation"),
+			DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "Surface Pro 8"),
+		},
+		.driver_data = (void *)lid_device_props_l4B,
+	},
 	{
 		.ident = "Surface Book 1",
 		.matches = {
-- 
2.35.1


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FF74531B70
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:56:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241767AbiEWRob (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 13:44:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243711AbiEWRmZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 13:42:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10ABA5D198;
        Mon, 23 May 2022 10:34:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 22E69B81233;
        Mon, 23 May 2022 17:31:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59C28C385A9;
        Mon, 23 May 2022 17:30:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653327059;
        bh=CVclP0CVYd+Kst09m8hEBA7IByOo7/Fm5SO7C+br1ow=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JspTKfYA1DLtskWe1L1vtQLYZkOGz4uQP1SQKGyKqUbupu09pOgoAKORh3asj1WVN
         Bc5o+rw/jKvg5crtgwZirWS5Ji2m0NP6oWMGOfG2C6HT/WlpRXzOa6HUMZPHS/sHaw
         bj15D3oD1oDsGVE1cR2B1mievRqG9hIKtXflzQqo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maximilian Luz <luzmaximilian@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 144/158] platform/surface: gpe: Add support for Surface Pro 8
Date:   Mon, 23 May 2022 19:05:01 +0200
Message-Id: <20220523165854.135126878@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220523165830.581652127@linuxfoundation.org>
References: <20220523165830.581652127@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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




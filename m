Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05C5A6E6407
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:45:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231978AbjDRMpg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:45:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231987AbjDRMpc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:45:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99ACF14F4E
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:45:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 35A2A63382
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:45:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A017C433D2;
        Tue, 18 Apr 2023 12:45:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681821926;
        bh=MeGy0MOALBiuRe8CcWLS3lryePjtmMT+QnPF+LdrO28=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FKVUnn6nTrgW5oop7s/JKJ6KSWcsnmGi/gYzXr23p3LWKXfBRe6RXaVjmjoJUWp7z
         FVlqPDYY+2JU+L9EjOXluu6UHcSvxKhbdWccIwJl3jXq++2Db305ml32aOs5aPX7Ru
         ULNcpKYWBL3c9QiKP3MmihDpTQKDfAWf4tfL3wGU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Aymeric Wibo <obiwac@gmail.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 093/134] ACPI: resource: Add Medion S17413 to IRQ override quirk
Date:   Tue, 18 Apr 2023 14:22:29 +0200
Message-Id: <20230418120316.411800423@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120313.001025904@linuxfoundation.org>
References: <20230418120313.001025904@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aymeric Wibo <obiwac@gmail.com>

[ Upstream commit 2d0ab14634a26e54f8d6d231b47b7ef233e84599 ]

Add DMI info of the Medion S17413 (board M1xA) to the IRQ override
quirk table. This fixes the keyboard not working on these laptops.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=213031
Signed-off-by: Aymeric Wibo <obiwac@gmail.com>
[ rjw: Fixed up white space ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/resource.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/acpi/resource.c b/drivers/acpi/resource.c
index a222bda7e15b0..d08818baea88f 100644
--- a/drivers/acpi/resource.c
+++ b/drivers/acpi/resource.c
@@ -400,6 +400,13 @@ static const struct dmi_system_id medion_laptop[] = {
 			DMI_MATCH(DMI_BOARD_NAME, "M17T"),
 		},
 	},
+	{
+		.ident = "MEDION S17413",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "MEDION"),
+			DMI_MATCH(DMI_BOARD_NAME, "M1xA"),
+		},
+	},
 	{ }
 };
 
-- 
2.39.2




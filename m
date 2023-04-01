Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A73E66D2D49
	for <lists+stable@lfdr.de>; Sat,  1 Apr 2023 03:48:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233943AbjDABsg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 Mar 2023 21:48:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233949AbjDABsG (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 31 Mar 2023 21:48:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 603882780A;
        Fri, 31 Mar 2023 18:45:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 622A362D12;
        Sat,  1 Apr 2023 01:44:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23291C433A1;
        Sat,  1 Apr 2023 01:44:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680313456;
        bh=4ObIQEFT28XMyBb0BYjDdLUP28ymPeN1aWYQT7wGy+A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Kx8BHMyrhy1efUxXXHain335/BWSVej1/Ec0msG0c/eyaLtHWbOaIP9eFuzJVMuf/
         OLFI4SEzLFuCZ6rsDPxiNslUU+tuGIcSkKmvo8W07Fegtjwz23UtZV23uV3RJxXkhB
         UsEXFMbrbAW6Fsb4y7PdZAZEGLjanO7nyRyJLLGweBLwCDNz/a6kG36rYpOHlsY4iy
         SccwmwuBqrlroCvLPewyDb1sBu/ViWW/yplOzzapea/pXElDRJgZ/EW2erkiZwZkQM
         MCkuS3Hh+ONv0UExuBo8PZBMrlBx2X2APiYtsv8NBLETHI2s4t3LfmZY3nFtgV8dP6
         x0zXy+6hXK+BQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Aymeric Wibo <obiwac@gmail.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, rafael@kernel.org,
        linux-acpi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 11/11] ACPI: resource: Add Medion S17413 to IRQ override quirk
Date:   Fri, 31 Mar 2023 21:43:49 -0400
Message-Id: <20230401014350.3357107-11-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230401014350.3357107-1-sashal@kernel.org>
References: <20230401014350.3357107-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
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
index 3b9f894873365..803dc6afa6d69 100644
--- a/drivers/acpi/resource.c
+++ b/drivers/acpi/resource.c
@@ -396,6 +396,13 @@ static const struct dmi_system_id medion_laptop[] = {
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


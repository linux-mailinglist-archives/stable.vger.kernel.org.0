Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51D77594487
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 00:58:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243826AbiHOWUF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 18:20:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350789AbiHOWSd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 18:18:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40F5D6557E;
        Mon, 15 Aug 2022 12:41:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E85FEB80EA9;
        Mon, 15 Aug 2022 19:41:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39DB8C433C1;
        Mon, 15 Aug 2022 19:41:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660592497;
        bh=+kx/jLvczudwRcK6z8GXOx7aUu/65FgT7dznEfehYwY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rDHf75R5o2KeDjD2By42z6bncpxul2IbjyggYsaKznM7F8CbMNwwGIjj2YuNS2MIo
         MFZy8O9JmBHg9OlEGAKDIiFxOuSbCVx5r00+qkdkJGJ/FH6aI9UeKbKGTSCY4Lu0br
         SrKt5curViY5G2Jpz5cc8niqSjWIa+G3ybgKg0ug=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Michael=20Sch=C3=B6ne?= <michael.schoene@rhebo.com>,
        Paul Spooren <paul.spooren@rhebo.com>,
        "Matwey V. Kornilov" <matwey@sai.msu.ru>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0799/1095] platform/x86: pmc_atom: Match all Lex BayTrail boards with critclk_systems DMI table
Date:   Mon, 15 Aug 2022 20:03:18 +0200
Message-Id: <20220815180502.315854500@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit c9d959fc32a5f9312282817052d8986614f2dc08 ]

The critclk_systems[] DMI match table already contains 2 Lex BayTrail
boards and patches were just submitted to add 3 more entries for the
following models: 3I380NX, 3I380A, 3I380CW.

Looking at: https://www.lex.com.tw/products/embedded-ipc-board/
we can see that Lex BayTrail makes many embedded boards with
multiple ethernet boards and none of their products are battery
powered so we don't need to worry (too much) about power consumption
when suspended.

Add a new DMI match which simply matches all Lex BayTrail boards and drop
the 2 existing board specific quirks.

Fixes: 648e921888ad ("clk: x86: Stop marking clocks as CLK_IS_CRITICAL")
Reported-by: Michael Schöne <michael.schoene@rhebo.com>
Reported-by: Paul Spooren <paul.spooren@rhebo.com>
Reported-by: Matwey V. Kornilov <matwey@sai.msu.ru>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/pmc_atom.c | 19 +++++++------------
 1 file changed, 7 insertions(+), 12 deletions(-)

diff --git a/drivers/platform/x86/pmc_atom.c b/drivers/platform/x86/pmc_atom.c
index a40fae6edc84..f24ab24f2927 100644
--- a/drivers/platform/x86/pmc_atom.c
+++ b/drivers/platform/x86/pmc_atom.c
@@ -402,21 +402,16 @@ static const struct dmi_system_id critclk_systems[] = {
 		},
 	},
 	{
-		/* pmc_plt_clk0 - 3 are used for the 4 ethernet controllers */
-		.ident = "Lex 3I380D",
+		/*
+		 * Lex System / Lex Computech Co. makes a lot of Bay Trail
+		 * based embedded boards which often come with multiple
+		 * ethernet controllers using multiple pmc_plt_clks. See:
+		 * https://www.lex.com.tw/products/embedded-ipc-board/
+		 */
+		.ident = "Lex BayTrail",
 		.callback = dmi_callback,
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "Lex BayTrail"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "3I380D"),
-		},
-	},
-	{
-		/* pmc_plt_clk* - are used for ethernet controllers */
-		.ident = "Lex 2I385SW",
-		.callback = dmi_callback,
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Lex BayTrail"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "2I385SW"),
 		},
 	},
 	{
-- 
2.35.1




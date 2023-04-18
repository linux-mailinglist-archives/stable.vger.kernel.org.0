Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1286C6E64F3
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:53:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232233AbjDRMxs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:53:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232245AbjDRMxo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:53:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C332D118E9
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:53:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2BE4963470
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:53:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 402F8C433D2;
        Tue, 18 Apr 2023 12:53:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681822410;
        bh=MeGy0MOALBiuRe8CcWLS3lryePjtmMT+QnPF+LdrO28=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gtbeAjM53eL9vdtPz2PP3RAMxl4d9fRdhoVsSUn9bElmmEMZ7Qn3I12H5qoBJtFGz
         Mog7llBz1pDQ+ZcwsNcejWPl5kVSrdVj+f8sxEvCsnDHYst/cVt8QxLCNjA6yjN1ir
         84Etf0HXNsUnDjHuOVR68v/wr7hz68KxMr9HOFG8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Aymeric Wibo <obiwac@gmail.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 099/139] ACPI: resource: Add Medion S17413 to IRQ override quirk
Date:   Tue, 18 Apr 2023 14:22:44 +0200
Message-Id: <20230418120317.501407131@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120313.725598495@linuxfoundation.org>
References: <20230418120313.725598495@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
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




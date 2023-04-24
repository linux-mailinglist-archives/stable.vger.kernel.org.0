Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A92286D2D0D
	for <lists+stable@lfdr.de>; Sat,  1 Apr 2023 03:46:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233815AbjDABpm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 Mar 2023 21:45:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233748AbjDABpF (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 31 Mar 2023 21:45:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E284920C1B;
        Fri, 31 Mar 2023 18:43:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D4837B83314;
        Sat,  1 Apr 2023 01:43:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7A7BC433EF;
        Sat,  1 Apr 2023 01:43:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680313381;
        bh=+fMqBQJ3HNRVkOcsoALHG97fgpPp7DZScxjVejQUzaQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Kkz3GfqhGgLm/GAcTIxi+1YWQB7eeWl+1918XXvUC3H/wPnQX3a67q3iXmA/6f1k1
         L3cldUUd4ORUUFk7OH+b79vsFIzRkq4s1UuqXObqkIUdyMUmfJ8apFQ6arl5owYN3h
         jMDR/f2xx3UGFrYFoocKPYLNNFgIFOwiLxNXq/15l3aqeH4LDxlLI2Po3dSIUJDqam
         d0iLjpSuA3WBZ1qtaAJ/Q9ZF3QfvCx3nJyPQTUJX4TZYBUaV6JhKk7gj+Z1i4WdAaG
         AiO2qwpj8f6bxegC90T/z3TQ3yqR6A1LQDLom0wg948axRDKpvXMnLNXYHdJtIdSOw
         lQZIqjYQEGKCw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, rafael@kernel.org,
        linux-acpi@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 12/24] ACPI: video: Add backlight=native DMI quirk for Acer Aspire 3830TG
Date:   Fri, 31 Mar 2023 21:42:28 -0400
Message-Id: <20230401014242.3356780-12-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230401014242.3356780-1-sashal@kernel.org>
References: <20230401014242.3356780-1-sashal@kernel.org>
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

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 5e7a3bf65db57461d0f47955248fcadf37321a74 ]

The Acer Aspire 3830TG predates Windows 8, so it defaults to using
acpi_video# for backlight control, but this is non functional on
this model.

Add a DMI quirk to use the native backlight interface which does
work properly.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/video_detect.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/acpi/video_detect.c b/drivers/acpi/video_detect.c
index 7f0ed845cd6ad..d3a38e1971035 100644
--- a/drivers/acpi/video_detect.c
+++ b/drivers/acpi/video_detect.c
@@ -493,6 +493,14 @@ static const struct dmi_system_id video_detect_dmi_table[] = {
 		DMI_MATCH(DMI_PRODUCT_NAME, "Precision 7510"),
 		},
 	},
+	{
+	 .callback = video_detect_force_native,
+	 /* Acer Aspire 3830TG */
+	 .matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
+		DMI_MATCH(DMI_PRODUCT_NAME, "Aspire 3830TG"),
+		},
+	},
 	{
 	 .callback = video_detect_force_native,
 	 /* Acer Aspire 4810T */
-- 
2.39.2


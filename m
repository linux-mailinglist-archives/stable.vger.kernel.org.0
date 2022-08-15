Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2CBF5943A0
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 00:57:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345650AbiHOWeK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 18:34:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348784AbiHOWcS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 18:32:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BAE212E24D;
        Mon, 15 Aug 2022 12:49:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 459FF61231;
        Mon, 15 Aug 2022 19:49:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30652C433D6;
        Mon, 15 Aug 2022 19:49:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660592942;
        bh=oF4xWoSbIFPJ8tM34EAHPqzQikSWy54TF/PD7GuhNQU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hhbzdzLw5h/poR914wgW+bd0hcJPDTm5ISIUL4/EGqdgXH8P2hN3Cvi+XCXrVmA1I
         CwdNcDMGRcn/6wOM2dHiaxZHWIJhBZI5XcN2u7BSibWd6X+TICH2PtAPoCY0ZEA1W2
         gBYps6p7nA6+89cjMR3rN4FT28d2Ub0imlYNIhKQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        Ben Greening <bgreening@gmail.com>
Subject: [PATCH 5.19 0190/1157] ACPI: video: Use native backlight on Dell Inspiron N4010
Date:   Mon, 15 Aug 2022 19:52:26 +0200
Message-Id: <20220815180447.351486607@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
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

[ Upstream commit 03c440a26cba6cfa540d65924e9db86fcea362b2 ]

The Dell Inspiron N4010 does not have ACPI backlight control,
so acpi_video_get_backlight_type()'s heuristics return vendor as
the type to use.

But the vendor interface is broken, where as the native (intel_backlight)
works well, add a quirk to use native.

Link: https://lore.kernel.org/regressions/CALF=6jEe5G8+r1Wo0vvz4GjNQQhdkLT5p8uCHn6ZXhg4nsOWow@mail.gmail.com/
Reported-and-tested-by: Ben Greening <bgreening@gmail.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/video_detect.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/acpi/video_detect.c b/drivers/acpi/video_detect.c
index 6615f59ab7fd..5d7f38016a24 100644
--- a/drivers/acpi/video_detect.c
+++ b/drivers/acpi/video_detect.c
@@ -347,6 +347,14 @@ static const struct dmi_system_id video_detect_dmi_table[] = {
 		DMI_MATCH(DMI_PRODUCT_NAME, "MacBookPro12,1"),
 		},
 	},
+	{
+	 .callback = video_detect_force_native,
+	 /* Dell Inspiron N4010 */
+	 .matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+		DMI_MATCH(DMI_PRODUCT_NAME, "Inspiron N4010"),
+		},
+	},
 	{
 	 .callback = video_detect_force_native,
 	 /* Dell Vostro V131 */
-- 
2.35.1




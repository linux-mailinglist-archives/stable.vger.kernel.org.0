Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1707F6AF200
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:49:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233298AbjCGSte (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:49:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233309AbjCGStM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:49:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD79CA8E82
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:37:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3BC356153F
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:29:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3570CC4339B;
        Tue,  7 Mar 2023 18:29:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678213748;
        bh=AV1DgJ+RZhmUcdTX7iChUO8omw1DLAJzQVPfWeQFWK8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D/NN2vht1TMqNs46ppobLkJswC01IRU04uDpmb6/Ew0FNrmoc5yYzqrqwykxx9ZZs
         rUr+3XywNSzifvqI3+YumrQSfyHtuFFvUEwEaNyyzmGMt3ah9jVKITbCVOtckW/Z2x
         jC3MJdLirkUcQOPBbxVheCSz1SxpWd1mJ4JlfbiQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Hans de Goede <hdegoede@redhat.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 576/885] ACPI: video: Fix Lenovo Ideapad Z570 DMI match
Date:   Tue,  7 Mar 2023 17:58:30 +0100
Message-Id: <20230307170027.405517907@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 2d11eae42d52a131f06061015e49dc0f085c5bfc ]

Multiple Ideapad Z570 variants need acpi_backlight=native to force native
use on these pre Windows 8 machines since acpi_video backlight control
does not work here.

The original DMI quirk matches on a product_name of "102434U" but other
variants may have different product_name-s such as e.g. "1024D9U".

Move to checking product_version instead as is more or less standard for
Lenovo DMI quirks for similar reasons.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/video_detect.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/acpi/video_detect.c b/drivers/acpi/video_detect.c
index b48f85c3791e9..7f0ed845cd6ad 100644
--- a/drivers/acpi/video_detect.c
+++ b/drivers/acpi/video_detect.c
@@ -432,7 +432,7 @@ static const struct dmi_system_id video_detect_dmi_table[] = {
 	 /* Lenovo Ideapad Z570 */
 	 .matches = {
 		DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
-		DMI_MATCH(DMI_PRODUCT_NAME, "102434U"),
+		DMI_MATCH(DMI_PRODUCT_VERSION, "Ideapad Z570"),
 		},
 	},
 	{
-- 
2.39.2



